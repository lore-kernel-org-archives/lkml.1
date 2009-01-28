Return-Path: <linux-kernel-owner+w=401wt.eu-S1752223AbZA1Sso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbZA1Sso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 13:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbZA1Ssf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 13:48:35 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:60263 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZA1Ssf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 13:48:35 -0500
Subject: Re: [PATCH v3] timer: implement lockdep deadlock detection
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1233140081.3936.21.camel@johannes.local>
References: <1233010786.4344.1.camel@johannes.local>
	 <20090126230721.GA6556@elte.hu> <1233046009.4012.3.camel@johannes.local>
	 <20090127132759.GI23121@elte.hu>  <20090127134128.GA24965@elte.hu>
	 <1233079597.4755.2.camel@johannes.local> <1233081027.10992.21.camel@laptop>
	 <1233082650.4455.9.camel@johannes.local> <1233130815.10992.39.camel@laptop>
	 <1233136487.4151.5.camel@johannes.local> <1233137581.10992.44.camel@laptop>
	 <1233140081.3936.21.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 19:06:57 +0100
Message-Id: <1233166017.4811.9.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-28 at 11:59 +0100, Johannes Berg wrote:

> > > I actually got "trying to register non-static key" on my powerpc64
> > > machine. Is there a possibility that functions are not static??
> > 
> > Hmm, weird, afaict static_obj() includes both text and data, for the
> > core kernel as well as modules.
> 
> Yeah, I'd think it should. I'll run it by the powerpc list when I get it
> again, it only seems to happen very rarely.

It's actually a generic bug.

delayed work structs are initialised like this:

#define __DELAYED_WORK_INITIALIZER(n, f) {                      \
        .work = __WORK_INITIALIZER((n).work, (f)),              \
        .timer = TIMER_INITIALIZER(NULL, 0, 0),                 \
        }

#define DECLARE_DELAYED_WORK(n, f)                              \
        struct delayed_work n = __DELAYED_WORK_INITIALIZER(n, f)


Note the NULL function, which I used for the key of timers. Thus, the
key is NULL, and the name is "NULL".

Now, this means that my code for the run timer:

				struct lockdep_map lockdep_map =
					timer->lockdep_map;

will actually have lockdep_map here with a NULL key. Once it gets into

			lock_map_acquire(&lockdep_map);

it'll try to register &lockdep_map as the key.

Interestingly, that doesn't seem to be a problem on x86_64, which would
appear to be a bug, the stack certainly isn't a static location.

The patch below fixes it by using the file/lineno of the static
definition as both the name and the key -- using it as the name means
you have a good chance of finding it if something goes wrong, and using
it as the key means we have a good key for it. The patch looks horrible
though. Any better ideas? If not, I think we should roll this into the
original patch.

johannes
---
 include/linux/timer.h |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

--- wireless-testing.orig/include/linux/timer.h	2009-01-28 18:55:03.270071595 +0100
+++ wireless-testing/include/linux/timer.h	2009-01-28 19:00:41.326947619 +0100
@@ -32,23 +32,35 @@ extern struct tvec_base boot_tvec_bases;
 /*
  * NB: because we have to copy the lockdep_map, setting _key
  * here is required, otherwise it could get initialised to the
- * copy of the lockdep_map! We use the function pointer as the
- * lockdep key here.
+ * copy of the lockdep_map! We use the pointer to and the string
+ * "<file>:<line>" as the key resp. the name of the lockdep_map.
  */
-#define __TIMER_LOCKDEP_MAP_INITIALIZER(fn, name)		\
-	.lockdep_map = STATIC_LOCKDEP_MAP_INIT(name, fn),
+#define __TIMER_LOCKDEP_MAP_INITIALIZER(name, key)			\
+	.lockdep_map = STATIC_LOCKDEP_MAP_INIT(name, key),
 #else
-#define __TIMER_LOCKDEP_MAP_INITIALIZER(fn, name)
+#define __TIMER_LOCKDEP_MAP_INITIALIZER(name, key)
 #endif
 
-#define TIMER_INITIALIZER(_function, _expires, _data) {			\
+#define ____TIMER_INITIALIZER(_function, _expires, _data, _name, _key) {\
 		.entry = { .prev = TIMER_ENTRY_STATIC },		\
 		.function = (_function),				\
 		.expires = (_expires),					\
 		.data = (_data),					\
 		.base = &boot_tvec_bases,				\
-		__TIMER_LOCKDEP_MAP_INITIALIZER((_function), #_function)\
+		__TIMER_LOCKDEP_MAP_INITIALIZER((_name), (_key))	\
 	}
+/*
+ * All the indirection here is required to build the
+ * "<file>:<line>" string and the pointer to it.
+ */
+#define ___TIMER_INITIALIZER(_fn, _exp, _dat, _kn)			\
+	____TIMER_INITIALIZER(_fn, _exp, _dat, (_kn), &(_kn))
+#define __TIMER_INITIALIZER(_fn, _exp, _dat, _f, _c, _l)		\
+	___TIMER_INITIALIZER(_fn, _exp, _dat, _f # _c # _l)
+#define _TIMER_INITIALIZER(_fn, _exp, _dat, _f, _l)			\
+	__TIMER_INITIALIZER(_fn, _exp, _dat, _f, :, _l)
+#define TIMER_INITIALIZER(_function, _expires, _data)			\
+	_TIMER_INITIALIZER(_function, _expires, _data, __FILE__, __LINE__)
 
 #define DEFINE_TIMER(_name, _function, _expires, _data)		\
 	struct timer_list _name =				\


