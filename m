Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbYFSDD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbYFSDD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 23:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYFSDDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 23:03:22 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:16615 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbYFSDDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 23:03:21 -0400
To: Cliff Wickman <cpw@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: reboot-notify additions
From: Andi Kleen <andi@firstfloor.org>
References: <E1K95kd-00081i-B6@eag09.americas.sgi.com>
Date: Thu, 19 Jun 2008 05:02:19 +0200
In-Reply-To: <E1K95kd-00081i-B6@eag09.americas.sgi.com> (Cliff Wickman's message of "Wed, 18 Jun 2008 17:03:35 -0500")
Message-ID: <87mylib004.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 Jun 2008 02:55:04.0594 (UTC) FILETIME=[DFEA1720:01C8D1B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cliff Wickman <cpw@sgi.com> writes:

> From: Cliff Wickman <cpw@sgi.com>
>
> X86 reboot-notify additions.

Doesn't seem x86 specific to me.

> @@ -1068,6 +1071,8 @@ void crash_kexec(struct pt_regs *regs)
>  	if (!locked) {
>  		if (kexec_crash_image) {
>  			struct pt_regs fixed_regs;
> +			blocking_notifier_call_chain(&reboot_notifier_list,
> +				SYS_INSANE, NULL);

But you don't really want to block during a crash, do you?

>  			crash_setup_regs(&fixed_regs, regs);
>  			crash_save_vmcoreinfo();
>  			machine_crash_shutdown(&fixed_regs);
> Index: linux/kernel/sys.c
> ===================================================================
> --- linux.orig/kernel/sys.c
> +++ linux/kernel/sys.c
> @@ -270,6 +270,7 @@ out_unlock:
>   */
>  void emergency_restart(void)
>  {
> +	blocking_notifier_call_chain(&reboot_notifier_list, SYS_INSANE, NULL);

Here neither.

In fact taking any locks here is dangerous because if you crash holding
such a lock the system will deadlock on panic.

-Andi
