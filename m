Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbYGJUMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbYGJUMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 16:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYGJUMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 16:12:01 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:37989 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbYGJUMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 16:12:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       jbarnes@virtuousgeek.org, steiner@sgi.com, linux-kernel@vger.kernel.org
References: <20080710181634.764954000@linux-os.sc.intel.com>
Date: Thu, 10 Jul 2008 13:05:50 -0700
In-Reply-To: <20080710181634.764954000@linux-os.sc.intel.com> (Suresh Siddha's
	message of "Thu, 10 Jul 2008 11:16:34 -0700")
Message-ID: <m1prplv71d.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Suresh Siddha <suresh.b.siddha@intel.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0013]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and x2apic support
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


At a quick skim nothing looks really bad, nothing looks really bad,
but you are dealing in an area of code that could be made much nicer
and if we are going to support a noticeably different style of irq
management we need to get in some of those pending cleanups so the
code does not fall down under it's own wait.

Suresh Siddha <suresh.b.siddha@intel.com> writes:

> irq migration in the presence of interrupt-remapping is done from the
> process-context as opposed to interrupt-context. Interrupt-remapping
> infrastrucutre allows us to do this migration in a simple fashion (atleast for
> edge triggered interrupts).

Unless I have misread things this irq migration remains racy, as I did not
see any instructions that would guarantee that in flight irqs were flushed
to the cpus local apics before we cleaned up the destination.

You are sizing an array as NR_IRQS this is something there should be sufficient
existing infrastructure to avoid.  Arrays sized by NR_IRQS is a significant
problem both for scaling the system up and down so ultimately we need to kill
this.  For now we should not introduce any new arrays.

A lot of your code is generic, and some of it is for just x86_64.  Since the
cpus are capable of running in 32bit mode.  We really need to implement x86_32
and x86_64 support in the same code base.  Which I believe means factoring out
pieces of io_apic_N.c into things such as msi.c that can be shared between the
two architectures.

Eric

