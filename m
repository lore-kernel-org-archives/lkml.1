Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbZBDJ76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbZBDJ76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 04:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbZBDJ7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 04:59:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52766 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbZBDJ7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 04:59:48 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/7] CPUFREQ: powernow-k8: Only print error message once, not per core.
Date: Wed, 4 Feb 2009 10:59:43 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.13-HEAD_20090130075504_71baee03-default; KDE/4.1.3; x86_64; ; )
Cc: davej@codemonkey.org.uk, mark.langsdorf@amd.com, cpufreq@vger.kernel.org,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org
References: <1233679606-1971-1-git-send-email-trenn@suse.de> <1233679606-1971-7-git-send-email-trenn@suse.de> <20090203210947.49fc5933.akpm@linux-foundation.org>
In-Reply-To: <20090203210947.49fc5933.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041059.44897.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009 06:09:47 Andrew Morton wrote:
> On Tue,  3 Feb 2009 17:46:45 +0100 Thomas Renninger <trenn@suse.de> wrote:
> > This is the typical message you get if you plug in a CPU
> > which is newer than your BIOS. It's annoying seeing this
> > message for each core.
> >
> > Signed-off-by: Thomas Renninger <trenn@suse.de>
> > ---
> >  arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   12 ++++++------
> >  1 files changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> > b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c index 9accffb..9e312c5 100644
> > --- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> > +++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> > @@ -743,7 +743,7 @@ static int find_psb_table(struct powernow_k8_data
> > *data) * BIOS and Kernel Developer's Guide, which is available on
> >  	 * www.amd.com
> >  	 */
> > -	printk(KERN_ERR PFX "BIOS error - no PSB or ACPI _PSS objects\n");
> > +	printk(KERN_ERR FW_BUG PFX "No PSB or ACPI _PSS objects\n");
> >  	return -ENODEV;
> >  }
> >
> > @@ -1154,11 +1154,11 @@ static int __cpuinit powernowk8_cpu_init(struct
> > cpufreq_policy *pol) * an UP version, and is deprecated by AMD.
> >  		 */
> >  		if (num_online_cpus() != 1) {
> > -			printk(KERN_ERR FW_BUG PFX "Your BIOS does not provide"
> > -			       " ACPI _PSS objects in a way that Linux "
> > -			       "understands. Please report this to the Linux "
> > -			       "ACPI maintainers and complain to your BIOS "
> > -			       "vendor.\n");
> > +			WARN_ONCE(1, KERN_ERR FW_BUG PFX "Your BIOS does not "
> > +				  "provide ACPI _PSS objects in a way that "
> > +				  "Linux understands. Please report this to "
> > +				  "the Linux ACPI maintainers and complain to "
> > +				  "your BIOS vendor.\n");
> >  			goto err_out;
> >  		}
> >  		if (pol->cpu != 0) {
>
> WARN_ONCE will also spew a stack backtrace, which seems inappropriate here.
Yes. I saw WARN_ONCE(1, KERN_INFO..), which should be a KERN_ERR then
(if you get a backtrace you do not want to have the message suppressed?)
and thus thought it's a simple printk.
>
> There was talk of writing a simple ONCE() macro for this sort of thing:
>
> 	if (ONCE())
> 		printk(...)
Yep, that would be nice here.

> but it never happened.
I added a static int print_once; hack now.

Thanks,

   Thomas
