Return-Path: <linux-kernel-owner+w=401wt.eu-S1760673AbZATBSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673AbZATBSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 20:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbZATBSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 20:18:08 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:46400 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbZATBSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 20:18:07 -0500
Message-ID: <49752649.3000508@hathawaymix.org>
Date: Mon, 19 Jan 2009 18:18:01 -0700
From: Shane Hathaway <shane@hathawaymix.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-XM-SPF: eid=;;;mid=;;;hst=mx02.mta.xmission.com;;;ip=166.70.244.130;;;frm=shane@hathawaymix.org;;;spf=none
X-XM-DomainKey: sender_domain=hathawaymix.org;;;sender=shane@hathawaymix.org;;;status=no signature
X-SA-Exim-Connect-IP: 166.70.244.130
X-SA-Exim-Mail-From: shane@hathawaymix.org
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;linux-kernel@vger.kernel.org
X-Spam-Relay-Country: 
X-Spam-Report: *  7.0 XM_URI_RBL URI's domain appears in surbl.xmission.com
	*      [URIs: lkml.org]
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0010]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: uml: sigprocmask fix
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just ran into the same issue described here:

http://lkml.org/lkml/2009/1/15/194

Like Americo Wang, my user mode linux compile failed when attempting to
link ".tmp_vmlinux".  However, his patch is probably wrong.  The problem
is that the name "sigprocmask" is getting renamed to
"kernel_sigprocmask" by a compiler directive in arch/um/Makefile, then
that name gets mangled into "sys_kernel_sigprocmask" by the
SYSCALL_DEFINE3(sigprocmask, ...) macro in kernel/signal.c.

So I added the following line to arch/um/sys-i386/sys_call_table.S:

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
before.

Shane

