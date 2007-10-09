Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbXJIPup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbXJIPup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 11:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbXJIPuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 11:50:37 -0400
Received: from barikada.upol.cz ([158.194.242.200]:45434 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbXJIPug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 11:50:36 -0400
To: "Joerg Roedel" <joerg.roedel@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Christoph Egger" <Christoph.Egger@amd.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i386: mce cleanup part1: functional change
In-Reply-To: <11919341961530-git-send-email-joerg.roedel@amd.com>
References: <11919341961890-git-send-email-joerg.roedel@amd.com> <11919341961530-git-send-email-joerg.roedel@amd.com>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Tue, 9 Oct 2007 18:04:48 +0200
Message-Id: <E1IfHZg-0003dp-FA@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Tue,  9 Oct 2007 14:49:55 +0200

[]
> @@ -33,9 +33,20 @@ void fastcall (*machine_check_vector)(struct pt_regs *, long error_code) = unexp
>  /* This has to be run for each processor */
>  void mcheck_init(struct cpuinfo_x86 *c)
>  {
> +	uint32_t mca, mce;
> +
>  	if (mce_disabled==1)
>  		return;
>  
> +	mca = cpu_has(c, X86_FEATURE_MCA);
> +	mce = cpu_has(c, X86_FEATURE_MCE);
> +
> +	if (!mca || !mce) {
> +		printk(KERN_INFO "CPU%i: No machine check support available\n",
> +			smp_processor_id());
> +		return;
> +	}
> +

cpu_has() returns int,
but would it be better to have something like

  	if (!mce_disabled &&
	    !(c->x86_capability & (X86_FEATURE_MCA | X86_FEATURE_MCE)) {
		printk(KERN_INFO "CPU%i: No machine check support available\n",
			smp_processor_id());
		return;
	} else
		return;
?
____
