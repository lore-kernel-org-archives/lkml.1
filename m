Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZDWGKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZDWGKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 02:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbZDWGJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 02:09:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49358 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117AbZDWGJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 02:09:57 -0400
Date: Thu, 23 Apr 2009 08:09:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/hpet: prevent boot hang when hpet=force used on
	old ICH
Message-ID: <20090423060936.GA1917@elte.hu>
References: <alpine.LFD.2.00.0904222223200.21119@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904222223200.21119@localhost.localdomain>
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


* Len Brown <lenb@kernel.org> wrote:

> From: Len Brown <len.brown@intel.com>
> 
> Linux tells ICH4 users that they can (manually) invoke
> "hpet=force" to enable the undocumented HPET.
> The HPET becomes available for both clocksource and clockevents.
> 
> But as of ff69f2bba67bd45514923aaedbf40fe351787c59
> (acpi: fix of pmtimer overflow that make Cx states time incorrect)
> the hpet may be used for idle accounting, and
> hpet=force on an ICH4 box hangs boot.
> 
> It turns out that reading the HPET timer immediately
> after return from C3 hangs.
> 
> Well, the reason we enable the HPET on these systems
> is primarily for clockevents -- the HPET has a longer
> maximum timer duration than the PIT.  HPET as a clocksource
> is less interesting.
> 
> So for "hpet=force" on old ICH, allow HPET clockevents,
> but do not allow HPET as a clocksource.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=13087
> 
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
> Ingo/Peter/Thomas,
> This regression was filed against ACPI, but the fix is under x86.
> I'd wait for Venki's ack on anything related to HPET,
> and I can send via your tree or yours, just let me know.

Looks good, thanks!

There's two minor details which you or Venki might want to fix when 
this is resubmitted with Venki's ack:

> +	if (hpet_is_forced_old_ich()) {
> +		printk(KERN_WARNING "hpet: hpet=force on old ICH enables clockevents,"
> +				" but not clocksource.\n");
> +		return -ENODEV;

that should be in a single line, to make git grep work when someone 
greps for a line out of a syslog:

	git grep "hpet: hpet=force on old ICH enables clockevents, but not clocksource."

( The string can be shortened to fit nicely in a line, and/or 
  defined separately or checkpatch can be ignored. )

> +++ b/arch/x86/kernel/quirks.c
> @@ -253,6 +253,10 @@ static void old_ich_force_enable_hpet(struct pci_dev *dev)
>  	dev_printk(KERN_DEBUG, &dev->dev, "Failed to force enable HPET\n");
>  }
>  
> +int hpet_is_forced_old_ich() {
> +	return (force_hpet_resume_type == OLD_ICH_FORCE_HPET_RESUME);
> +}

the function needs a proper prototype and the curly brace should 
start on the next line i guess.

Thanks,

	Ingo
