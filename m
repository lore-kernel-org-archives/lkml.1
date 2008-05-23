Return-Path: <linux-kernel-owner+w=401wt.eu-S1757791AbYEWUUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbYEWUUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 16:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbYEWUUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 16:20:40 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53946 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbYEWUUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 16:20:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sharyathi Nagesh <sharyath@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, fastboot@lists.osdl.org, akpm@osdl.org,
       maneesh@in.ltcfwd.linux.ibm.com, mohan@in.ibm.com, sachinp@in.ibm.com,
       mohd.omar@in.ibm.com, IndhuDurai@in.ibm.com,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <4836AC3C.3090005@in.ibm.com>
Date: Fri, 23 May 2008 13:14:42 -0700
In-Reply-To: <4836AC3C.3090005@in.ibm.com> (Sharyathi Nagesh's message of
	"Fri, 23 May 2008 17:06:28 +0530")
Message-ID: <m1ve144w25.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Sharyathi Nagesh <sharyath@in.ibm.com>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0039]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: correction to compat_sys_kexec_load
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sharyathi Nagesh <sharyath@in.ibm.com> writes:

> Hi
>   While testing with kexec tool, I observed some problems. When application
> (kexec) is 32 bit and kernel is 64 bit I observed that loading crash kernel
> works without any issues but unloading crash kernel fails.
> --------------------------------------------------------
> running strace over 'kexec -u -p'
> show the problem to be with sys_kexec_load() call
>
> sys_kexec_load(0, 0, 0, 0x1, 0)         = -1 EINVAL (Invalid argument)
> write(2, "kexec_load (0 segments) failed: "..., 49
> kexec_load (0 segments) failed: Invalid argument
> ) = 4

Yes.  This is a bug.  Although not in the kernel implementation.

> --------------------------------------------------------
>
> This is patch to fix the problem, I think kernel code had a typo where in:
> if((flags & KEXEC_ARCH_MASK) == KEXEC_ARCH) was used instead of
> if((flags & KEXEC_ARCH_MASK) != KEXEC_ARCH)

Nope.  We do the latter check after we have fixed up the arguments
and call sys_kexec_load.  The check really is meant to filter out
KEXEC_ARCH_DEFAULT.


> This patch takes care of that, I have tested the patch it worked fine for
> me. Please review the patch and let me know of your views. This patch is based
> on linux-2.6.26-rc3.

That patch as it exists is actively bad.  It removes the check for a really
nasty gotcha if someone passes in KEXEC_ARCH_DEFAULT in 32bit mode.  Code
expecting a 32bit handoff and getting a 64bit handoff will explode in fun
ways.  You happened to test the one corner case where this does not matter.

What we need to do is fix /sbin/kexec to pass in the correct
architecture of the kernel for unload as it does for load.

Eric
