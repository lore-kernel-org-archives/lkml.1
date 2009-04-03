Return-Path: <linux-kernel-owner+w=401wt.eu-S935242AbZDCRht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935242AbZDCRht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbZDCRhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:37:40 -0400
Received: from sous-sol.org ([216.99.217.87]:48758 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751251AbZDCRhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:37:39 -0400
Date: Fri, 3 Apr 2009 10:36:31 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: Chris Wright <chrisw@sous-sol.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: 2.6.29 git, resume from ram broken on thinkpad
Message-ID: <20090403173631.GA27148@sequoia.sous-sol.org>
References: <200904011155.20751.a.miskiewicz@gmail.com> <200904030222.57469.a.miskiewicz@gmail.com> <20090403003523.GK18394@sequoia.sous-sol.org> <200904030847.19674.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904030847.19674.a.miskiewicz@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arkadiusz Miskiewicz (a.miskiewicz@gmail.com) wrote:
> On Friday 03 of April 2009, Chris Wright wrote:
> > * Arkadiusz Miskiewicz (a.miskiewicz@gmail.com) wrote:
> > > What about 9ea09af3bd3090e8349ca2899ca2011bd94cda85 ?
> > >
> > > stop_machine: introduce stop_machine_create/destroy.
> >
> > That is later fixed in a0e280e0f33f6c859a235fb69a875ed8f3420388.
> >
> > Can you please verify if 2.6.29 works for you? 
> 
> I think that the guilty part is 
> CONFIG_CC_STACKPROTECTOR_ALL=y
> CONFIG_CC_STACKPROTECTOR=y

Indeed, I think you're right.  In fact...this should fix it:

From:  Joseph Cihula <joseph.cihula@intel.com>

The __restore_processor_state() fn restores %gs on resume from S3.  As
such, it cannot be protected by the stack-protector guard since %gs will
not be correct on function entry.

There are only a few other fns in this file and it should not negatively
impact kernel security that they will also have the stack-protector
guard removed (and so it's not worth moving them to another file).

Without this change, S3 resume on a kernel built with
CONFIG_CC_STACKPROTECTOR_ALL=y will fail.

Signed-off-by:  Joseph Cihula <joseph.cihula@intel.com>

--- ../linux.trees.git/arch/x86/power/Makefile	2009-03-29 
12:12:13.000000000 -0700
+++ arch/x86/power/Makefile	2009-03-30 12:21:19.000000000 -0700
@@ -1,2 +1,7 @@
+# __restore_processor_state() restores %gs after S3 resume and so 
should not
+# itself be stack-protected
+nostackp := $(call cc-option, -fno-stack-protector)
+CFLAGS_cpu_$(BITS).o	:= $(nostackp)
+
obj-$(CONFIG_PM_SLEEP)		+= cpu_$(BITS).o
obj-$(CONFIG_HIBERNATION)	+= hibernate_$(BITS).o hibernate_asm_$(BITS).o



