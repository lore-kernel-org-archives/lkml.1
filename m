Return-Path: <linux-kernel-owner+w=401wt.eu-S1761686AbZATCB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761686AbZATCB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 21:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757612AbZATCBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 21:01:16 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:41765 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756348AbZATCBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 21:01:15 -0500
Message-ID: <49753063.8040007@hathawaymix.org>
Date: Mon, 19 Jan 2009 19:01:07 -0700
From: Shane Hathaway <shane@hathawaymix.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: Daolong Wang <ahlongxp@gmail.com>
CC: Jeff Dike <jdike@addtoit.com>, Rob Landley <rob@landley.net>,
       user-mode-linux-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Am?rico Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
References: <20090115194033.GA10926@hack.private>	 <20090116124158.4364e269.akpm@linux-foundation.org>	 <200901170328.15178.rob@landley.net>	 <dc84318c0901172223p57872a8cr227d940b1c0a908a@mail.gmail.com>	 <20090119152104.GC6432@c2.user-mode-linux.org> <dc84318c0901191746g31d51c23g65da89190dc8bfd2@mail.gmail.com>
In-Reply-To: <dc84318c0901191746g31d51c23g65da89190dc8bfd2@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-XM-SPF: eid=;;;mid=;;;hst=mx03.mta.xmission.com;;;ip=166.70.244.130;;;frm=shane@hathawaymix.org;;;spf=none
X-XM-DomainKey: sender_domain=hathawaymix.org;;;sender=shane@hathawaymix.org;;;status=no signature
X-SA-Exim-Connect-IP: 166.70.244.130
X-SA-Exim-Mail-From: shane@hathawaymix.org
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Daolong Wang <ahlongxp@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0023]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [uml-devel] [Patch] uml: fix a link error
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx03.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daolong Wang wrote:
> On Mon, Jan 19, 2009 at 11:21 PM, Jeff Dike <jdike@addtoit.com> wrote:
>> On Sun, Jan 18, 2009 at 02:23:46PM +0800, Daolong Wang wrote:
>>> I can confirm this link error.
>> In what environment?  I see no problems here.

I can also confirm this link error.  The problem occurs when compiling
either 2.6.28.1 or 2.6.27.12; I didn't try anything earlier.  The patch
suggested at this beginning of this thread did solve the link problem
and the resulting kernel ran for several hours.  However, I think the
patch is still probably incorrect.

I'm going to repost what I said in another message I sent today, this
time with a wider audience:

The problem is that the name "sigprocmask" is getting renamed to
"kernel_sigprocmask" by a compiler directive in arch/um/Makefile, then
that name gets mangled into "sys_kernel_sigprocmask" by the
SYSCALL_DEFINE3(sigprocmask, ...) macro in kernel/signal.c.

So, instead of the patch suggested earlier, I added the following line
to arch/um/sys-i386/sys_call_table.S:

#define sys_sigprocmask sys_kernel_sigprocmask

This made it compile and link correctly.  Look at the symbols generated
by the compile of signal.c to see what I mean:

# nm kernel/signal.o | grep sigprocmask
0000008f r __kstrtab_kernel_sigprocmask
00000040 r __ksymtab_kernel_sigprocmask
00001ea6 T kernel_sigprocmask
00002d67 T sys_kernel_sigprocmask
00001faf T sys_rt_sigprocmask

Unfortunately, it's a mystery to me that others haven't run into this
before.  My host environment is RHEL 4 inside some kind of chroot.

Shane

