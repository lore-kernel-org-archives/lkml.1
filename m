Return-Path: <linux-kernel-owner+w=401wt.eu-S1751025AbXDMA54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751025AbXDMA54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 20:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbXDMA54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 20:57:56 -0400
Received: from smtp-out.google.com ([216.239.33.17]:15911 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbXDMA5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 20:57:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=W+9ME7+gsZ6CtbNHog4Le5+LuiCEcWPlJwiYUAFMEuR/G6LZlo/BSs4QrWAMeo1QP
	gPD6dY49WbTUzPLJI9FxA==
Message-ID: <b040c32a0704121757p728654cdte652c2a900e4c2d4@mail.gmail.com>
Date: Thu, 12 Apr 2007 17:57:45 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Jeff Moyer" <jmoyer@redhat.com>
Subject: Re: [patch] convert aio event reap to use atomic-op instead of spin_lock
Cc: "Zach Brown" <zach.brown@oracle.com>, akpm@linux-foundation.org,
       linux-aio@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <x49ejmp3igr.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070410235353.325A7346F64@localhost>
	 <20070411180038.GN28322@mami.zabbo.net>
	 <b040c32a0704111228t5065253en9249ff88db5b1384@mail.gmail.com>
	 <b040c32a0704120029u423bfd39pfa0479c3c678ebe2@mail.gmail.com>
	 <x49ejmp3igr.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/07, Jeff Moyer <jmoyer@redhat.com> wrote:
> I didn't see any response to Zach's request for code that actually
> tests out the shared ring buffer.  Do you have such code?

Yes, I do.  I was stress testing the code since last night.  After 20+
hours of stress run with fio and aio-stress, now I'm posting it with
confidence.

I modified libaio's io_getevents to take advantage of new user level
reap function. The feature is exported out via ring->compat_features.
btw, is compat_feature suppose to be a version number or a bit mask?
I think bitmask make more sense and more flexible.

(warning: some lines are extremely long in the patch and my email
client will probably mangle it badly).


diff -Nurp libaio-0.3.104/src/io_getevents.c
libaio-0.3.104-new/src/io_getevents.c
--- libaio-0.3.104/src/io_getevents.c	2003-06-18 12:58:21.000000000 -0700
+++ libaio-0.3.104-new/src/io_getevents.c	2007-04-12 17:35:06.000000000 -0700
@@ -21,10 +21,13 @@
 #include <stdlib.h>
 #include <time.h>
 #include "syscall.h"
+#include <asm/system.h>

 io_syscall5(int, __io_getevents_0_4, io_getevents, io_context_t, ctx,
long, min_nr, long, nr, struct io_event *, events, struct timespec *,
timeout)

 #define AIO_RING_MAGIC                  0xa10a10a1
+#define AIO_RING_BASE			1
+#define AIO_RING_USER_REAP		2

 /* Ben will hate me for this */
 struct aio_ring {
@@ -41,7 +44,11 @@ struct aio_ring {

 int io_getevents_0_4(io_context_t ctx, long min_nr, long nr, struct
io_event * events, struct timespec * timeout)
 {
+	long i = 0, ret;
+	unsigned head;
+	struct io_event *evt_base;
 	struct aio_ring *ring;
+
 	ring = (struct aio_ring*)ctx;
 	if (ring==NULL || ring->magic != AIO_RING_MAGIC)
 		goto do_syscall;
@@ -49,9 +56,35 @@ int io_getevents_0_4(io_context_t ctx, l
 		if (ring->head == ring->tail)
 			return 0;
 	}
-	
+
+	if (!(ring->compat_features & AIO_RING_USER_REAP))
+		goto do_syscall;
+
+	if (min_nr > nr || min_nr < 0 || nr < 0)
+		return -EINVAL;
+
+	evt_base = (struct io_event *) (ring + 1);
+	while (i < nr) {
+		head = ring->head;
+		if (head == ring->tail)
+			break;
+
+		*events = evt_base[head & (ring->nr - 1)];
+		if (head == cmpxchg(&ring->head, head, head + 1)) {
+			events++;
+			i++;
+		}
+	}
+
+	if (i >= min_nr)
+		return i;
+
 do_syscall:	
-	return __io_getevents_0_4(ctx, min_nr, nr, events, timeout);
+	ret = __io_getevents_0_4(ctx, min_nr - i, nr - i, events, timeout);
+	if (ret >= 0)
+		return i + ret;
+	else
+		return i ? i : ret;
 }

 DEFSYMVER(io_getevents_0_4, io_getevents, 0.4)
