Return-Path: <linux-kernel-owner+w=401wt.eu-S1752845AbYLLTGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbYLLTGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 14:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbYLLTGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 14:06:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56728 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYLLTGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 14:06:03 -0500
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: re-enable MCE on secondary CPUS after suspend/resume
From: Andi Kleen <andi@firstfloor.org>
References: <20081212180650.GS19144@alberich.amd.com>
	<20081212181021.GU19144@alberich.amd.com>
Date: Fri, 12 Dec 2008 20:06:21 +0100
In-Reply-To: <20081212181021.GU19144@alberich.amd.com> (Andreas Herrmann's message of "Fri, 12 Dec 2008 19:10:21 +0100")
Message-ID: <873agtnrgy.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Herrmann <andreas.herrmann3@amd.com> writes:

> Impact: fix suspend/resume bug with MCE
>
> After suspend/resume MCx_CTL registers of secondary CPUs are cleared.
> (At least that's what I've observed on several systems.)
> Linux currently only re-initializes MCE on the boot CPU - see mce_resume().
> Thus after suspend/resume we end up with a system where MCE is active
> on the boot CPU but switched off on all other CPUs.
>
> By calling mce_init() whenever a CPU comes online this problem is
> solved.

Can you double check that please?

Suspend/resume are supposted to hotunplug all CPUs except the BP and
then re-online them on resume (with "disable_nonboot_cpus()) . The
re-online initializes MCEs in the standard CPU bootup path.

A good way is to stick a WARN_ON(num_online_cpus() > 1) into
mce_suspend(). I had that here for some time and didn't see
it trigger.

I got a couple of suspend bug fixes in my mce improvement tree, see:

http://git.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-x86.git;a=history;f=arch/x86/kernel/cpu/mcheck/mce_64.c;h=9512a7eab4e7b03a584f5bb647bd242bd4c003dc;hb=x86/mce

During review it was decided to all defer it to .29 though.

-Andi

-- 
ak@linux.intel.com
