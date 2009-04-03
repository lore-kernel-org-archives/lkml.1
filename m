Return-Path: <linux-kernel-owner+w=401wt.eu-S934928AbZDCRlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934928AbZDCRlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757569AbZDCRlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:41:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55447 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756578AbZDCRlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:41:07 -0400
Date: Fri, 3 Apr 2009 19:39:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: 2.6.29 git, resume from ram broken on thinkpad
Message-ID: <20090403173955.GD6295@elte.hu>
References: <200904011155.20751.a.miskiewicz@gmail.com> <200904030222.57469.a.miskiewicz@gmail.com> <20090403003523.GK18394@sequoia.sous-sol.org> <200904030847.19674.a.miskiewicz@gmail.com> <20090403173631.GA27148@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403173631.GA27148@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Wright <chrisw@sous-sol.org> wrote:

> * Arkadiusz Miskiewicz (a.miskiewicz@gmail.com) wrote:
> > On Friday 03 of April 2009, Chris Wright wrote:
> > > * Arkadiusz Miskiewicz (a.miskiewicz@gmail.com) wrote:
> > > > What about 9ea09af3bd3090e8349ca2899ca2011bd94cda85 ?
> > > >
> > > > stop_machine: introduce stop_machine_create/destroy.
> > >
> > > That is later fixed in a0e280e0f33f6c859a235fb69a875ed8f3420388.
> > >
> > > Can you please verify if 2.6.29 works for you? 
> > 
> > I think that the guilty part is 
> > CONFIG_CC_STACKPROTECTOR_ALL=y
> > CONFIG_CC_STACKPROTECTOR=y
> 
> Indeed, I think you're right.  In fact...this should fix it:

Note that i had to do a manual merge of the patch (it had 3 separate 
patch corruptions) - the non-damaged version i applied is the one 
below.

	Ingo

--------------->
>From 1f23b77e09be10edb30eb03c1b03879083e3cc72 Mon Sep 17 00:00:00 2001
From: Joseph Cihula <joseph.cihula@intel.com>
Date: Mon, 30 Mar 2009 14:03:01 -0700
Subject: [PATCH] x86: disable stack-protector for __restore_processor_state()

The __restore_processor_state() fn restores %gs on resume from S3.  As
such, it cannot be protected by the stack-protector guard since %gs will
not be correct on function entry.

There are only a few other fns in this file and it should not negatively
impact kernel security that they will also have the stack-protector
guard removed (and so it's not worth moving them to another file).

Without this change, S3 resume on a kernel built with
CONFIG_CC_STACKPROTECTOR_ALL=y will fail.

Signed-off-by: Joseph Cihula <joseph.cihula@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Tejun Heo <tj@kernel.org>
LKML-Reference: <49D13385.5060900@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/power/Makefile |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/power/Makefile b/arch/x86/power/Makefile
index 9ff4d5b..58b32db 100644
--- a/arch/x86/power/Makefile
+++ b/arch/x86/power/Makefile
@@ -1,2 +1,7 @@
+# __restore_processor_state() restores %gs after S3 resume and so should not
+# itself be stack-protected
+nostackp := $(call cc-option, -fno-stack-protector)
+CFLAGS_cpu_$(BITS).o	:= $(nostackp)
+
 obj-$(CONFIG_PM_SLEEP)		+= cpu_$(BITS).o
 obj-$(CONFIG_HIBERNATION)	+= hibernate_$(BITS).o hibernate_asm_$(BITS).o
