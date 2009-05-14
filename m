Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbZENJNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbZENJNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 05:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbZENJMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 05:12:55 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44013 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbZENJMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 05:12:54 -0400
From: Subrata Modak <subrata@linux.vnet.ibm.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Date: Thu, 14 May 2009 14:42:47 +0530
Message-Id: <20090514091247.32082.38639.sendpatchset@subratamodak.linux.ibm.com>
Subject: Re:[PATCH] Fix Warnining in arch/x86/kernel/signal.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hiroshi-san,

On Thu, 2009-05-14 at 09:24 +0900, Hiroshi Shimamoto wrote:
H. Peter Anvin wrote:
> > Ingo Molnar wrote:
> >>>>>  
> >>>>>         if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
> >>>>>                 goto badframe;
> >>>>> -       if (__get_user(set.sig[0], &frame->sc.oldmask) || (_NSIG_WORDS > 1
> >>>>> -               && __copy_from_user(&set.sig[1], &frame->extramask,
> >>>>> -                                   sizeof(frame->extramask))))
> >>>>> +
> >>>>> +        if ( (__copy_from_user(&set.sig[1], &frame->extramask,
> >>>>> +                sizeof(frame->extramask)) && _NSIG_WORDS > 1) || 
> >>>>> +                __get_user(set.sig[0], &frame->sc.oldmask))
> >>>>>                 goto badframe;
> >>>> I'm not sure why this eliminates that warning.
> >>>> set.sig[0] may not be initialized too, if __copy_from_user() failed.
> >>> True, but only when either or both of __copy_from_user() and
> >>> (_NSIG_WORDS > 1) fails. But in all instances set.sig[1] gets
> >>> initialized.
> >>>
> >>>> I don't have enough time to look at this right now, sorry.
> >>>>
> >>>> Another question, __copy_from_user() will be called even if
> >>>> _NSIG_WORDS is less than 2, perhaps it never occurs.
> >>>> I think, to check _NSIG_WORDS > 1 before calling __copy_from_user()
> >>>> is better.
> >>> Fine. Let Ingo/Thomas/Peter decide whether they would like this fix or
> >>> drop it.
> >> If you get the Acked-by from Hiroshi-san it looks good to me. He 
> >> modified this code last.
> >>
> > 
> > This seriously looks wrong to me.  If _NSIG_WORDS == 1, then calling
> > __copy_from_user here is a serious error.
> 
> Right. If _NSIG_WORDS is 1, sigset_t set has only sig[0], writing to
> set.sig[1] means stack corruption.
> 
> Subrata, could you try like this?
> if ((_NSIG_WORDS > 1 && __copy_from_user(&set.sig[1], ...) ||
>       __get_user(set.sig[0], ...))
> 
> 

How about now ? Thanks for pointing that out. My mistake ;-)

Signed-off-by: Subrata Modak <subrata@linux.vnet.ibm.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
Cc: H. Peter Anvin <hpa@zytor.com>,
Cc: Ingo Molnar <mingo@elte.hu>,
Cc: x86@kernel.org,
Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>,
Cc: Andi Kleen <andi@firstfloor.org>,
Cc: Andi Kleen <ak@linux.intel.com>,
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
Cc: Thomas Gleixner <tglx@linutronix.de>,
Cc: Ingo Molnar <mingo@redhat.com>
Subject: Re:[PATCH] Fix Warnining in arch/x86/kernel/signal.c
---

--- a/arch/x86/kernel/signal.c	2009-05-14 11:27:15.000000000 +0530
+++ b/arch/x86/kernel/signal.c	2009-05-14 14:36:24.000000000 +0530
@@ -576,9 +576,9 @@ unsigned long sys_sigreturn(struct pt_re
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
-	if (__get_user(set.sig[0], &frame->sc.oldmask) || (_NSIG_WORDS > 1
-		&& __copy_from_user(&set.sig[1], &frame->extramask,
-				    sizeof(frame->extramask))))
+	if ((_NSIG_WORDS > 1 && __copy_from_user(&set.sig[1],
+		&frame->extramask, sizeof(frame->extramask))) ||
+		__get_user(set.sig[0], &frame->sc.oldmask))
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);

---
Regards--
Subrata

> I wonder whether gcc really complains about the case of
> __get_user(set.sig[0], ...) failure.
> Why, the case which sig[0] initialized and sig[1] uninitialized is NG
> and the case which sig[0] uninitialized and sig[1] initialized is OK.
> 
> Thanks,
> Hiroshi
