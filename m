Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbYKXPPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbYKXPPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 10:15:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbYKXPPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 10:15:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:23848 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbYKXPPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 10:15:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,659,1220252400"; 
   d="scan'208";a="466755279"
Date: Mon, 24 Nov 2008 18:02:08 -0500
From: "Youquan,Song" <youquan.song@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, venkatesh.pallipadi@intel.com,
       len.brown@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]  ACPI: Check _PSS invalidation when BIOS report _PSS with  all 0x80000000
Message-ID: <20081124230208.GA21491@youquan-linux.bj.intel.com>
References: <3606.172.16.183.72.1227236916.squirrel@linux.intel.com> <20081121150839.58dbedfa.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121150839.58dbedfa.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 03:08:39PM -0800, Andrew Morton wrote:
> On Thu, 20 Nov 2008 19:08:36 -0800 (PST)
> youquan_song@linux.intel.com wrote:
> 
> > Subject: Check _PSS invalidation when BIOS report _PSS with 0x80000000
> > 
> > When cpu frequencey scaling disable,some BIOS report _PSS with all
> > 0x80000000.
> > If kernel treat this case as valid, the kernel will boot crash when load
> > cpufreq govenors.
> > 
> > So in order to cover more buggy BIOSs, the patch just check _PSS core
> > frequencey invalidtion.
> > 
> 
> It's unclear how many machines this will affect, and what the effects
> of not having the patch are upon those machines.  That is useful
> information for people who are deciding whcih kernel versions this
> patch should be merged into.

I meet 2 machines that if the P-states is disabled in BIOS, the kernel
will boot crash at loading cpufreq_userspace governor because kernel
consider that P-states validate. I know there are some other machines
also exist this bug.

> 
> Do you think this fix is needed in 2.6.28?  2.6.27.x?  2.6.26.x?  etc?
> 

I know that the bug exists in kernel as old as 2.6.18 and also exits on
2.6.28, 2.6.27 etc. 

> > 
> > --- linux-2.6-tip-orignal/drivers/acpi/processor_perflib.c	2008-11-20
> > 12:25:05.000000000 -0500
> > +++ linux-2.6-tip/drivers/acpi/processor_perflib.c	2008-11-20
> > 12:23:57.000000000 -0500
> 
> Your email client is wordwrapping the text, btw.
> 
> > @@ -50,6 +50,7 @@
> >  #define ACPI_PROCESSOR_CLASS		"processor"
> >  #define ACPI_PROCESSOR_FILE_PERFORMANCE	"performance"
> >  #define _COMPONENT		ACPI_PROCESSOR_COMPONENT
> > +#define ACPI_PROCESSOR_PSS_INVALID	0x80000000
> >  ACPI_MODULE_NAME("processor_perflib");
> > 
> >  static DEFINE_MUTEX(performance_mutex);
> > @@ -324,6 +325,14 @@
> >  			kfree(pr->performance->states);
> >  			goto end;
> >  		}
> > +
> > +		if (px->core_frequency == ACPI_PROCESSOR_PSS_INVALID) {
> > +			printk(KERN_ERR PREFIX
> > +				    "P-states disabled in the BIOS\n");
> > +			result = -EFAULT;
> > +			kfree(pr->performance->states);
> > +			goto end;
> > +		}
> >  	}
> > 
> >        end:
> 
> 
