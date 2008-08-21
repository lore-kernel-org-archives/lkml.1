Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbYHUIST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbYHUIST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 04:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbYHUISD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 04:18:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:58503 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758027AbYHUIR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 04:17:57 -0400
Subject: Re: VolanoMark regression with 2.6.27-rc1
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ray Lee <ray-lk@madrabbit.org>, adobriyan@gmail.com,
       Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Chris Friesen <cfriesen@nortel.com>
In-Reply-To: <200808211611.17889.nickpiggin@yahoo.com.au>
References: <1912217169.25608.228.camel@ymzhang>
	 <1219264236.8651.76.camel@twins> <1219265798.8651.84.camel@twins>
	 <200808211611.17889.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 10:17:35 +0200
Message-Id: <1219306655.8651.90.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-21 at 16:11 +1000, Nick Piggin wrote:
> On Thursday 21 August 2008 06:56, Peter Zijlstra wrote:
> > On Wed, 2008-08-20 at 22:30 +0200, Peter Zijlstra wrote:
> 
> > > works for the above example, but when I make it long long, so as to
> > > match the longest supported type, it goes boom again - for as of yet
> > > unknown reasons.
> >
> > Ok, people pointed out I got my promotion rules mixed up, I casted the
> > result of the division to signed, instead of ending up with a signed
> > division.
> >
> > #define avg(x, y) ({                            \
> >         typeof(x) _avg1 = (x);                  \
> >         typeof(y) _avg2 = (y);                  \
> >         (void) (&_avg1 == &_avg2);              \
> >         (typeof(x))(_avg1 + ((long long)_avg2 - _avg1)/2); })
> >
> > seems to work.
> 
> Right, I guess that will work, but unfortunately the code gen on 32-bit
> is a monstrosity. If you're going to cast to 64-bit anyway, we might as
> well then just do the normal add rather than playing the game to avoid
> overflow.
> 
> Secondly, this is operating on the fixed point scaled load numbers, so in
> the case of the scheduler I wouldn't worry too much about rounding... also
> in most integer operations, rounding down is less surprising than rounding
> up like the last code did.
> 
> I still don't know whether it is appropriate to put it into kernel.h
> (because of rounding, and variability when it comes to what type size will
> hold the sum of parameters), but for the scheduler, I would use this:
> 
> 	((unsigned long long)a + b) / 2;

Right - anyway the point is moot - as Yanmin says it still sucks rocks.

But since I couldn't let it rest :-)

---
Index: linux-2.6/include/linux/kernel.h
===================================================================
--- linux-2.6.orig/include/linux/kernel.h
+++ linux-2.6/include/linux/kernel.h
@@ -367,6 +367,45 @@ static inline char *pack_hex_byte(char *
 	(void) (&_max1 == &_max2);		\
 	_max1 > _max2 ? _max1 : _max2; })
 
+#define __avg_t(type, x, y) ({			\
+	typeof(x) __avg1 = (x);			\
+	typeof(y) __avg2 = (y);			\
+	__avg1 + ((type)(__avg2 - __avg1))/2; })
+
+extern void avg_unknown_size(void);
+
+#define __avg(x, y) ({				\
+	typeof(x) ret;				\
+	switch (sizeof(ret)) {			\
+	case 1:					\
+		ret = __avg_t(s8, x, y);	\
+		break;				\
+	case 2:					\
+		ret = __avg_t(s16, x, y);	\
+		break;				\
+	case 4:					\
+		ret = __avg_t(s32, x, y);	\
+		break;				\
+	case 8:					\
+		ret = __avg_t(s64, x, y);	\
+		break;				\
+	default:				\
+		avg_unknown_size();		\
+		break;				\
+	}					\
+	ret; })
+
+#define avg(x, y) ({				\
+	typeof(x) _avg1 = (x);			\
+	typeof(y) _avg2 = (y);			\
+	(void) (&_avg1 == &_avg2);		\
+	__avg(_avg1, _avg2); })
+
+#define avg_t(type, x, y) ({			\
+	type _avg1 = (x);			\
+	type _avg2 = (y);			\
+	__avg(_avg1, _avg2); })
+
 /**
  * clamp - return a value clamped to a given range with strict typechecking
  * @val: current value


