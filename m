Return-Path: <linux-kernel-owner+w=401wt.eu-S1753738AbZJEQL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbZJEQL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 12:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbZJEQL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 12:11:57 -0400
Received: from kroah.org ([198.145.64.141]:41396 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbZJEQL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 12:11:56 -0400
Date: Mon, 5 Oct 2009 09:08:40 -0700
From: Greg KH <greg@kroah.com>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [079/136] [CPUFREQ] Fix NULL ptr regression in
 powernow-k8
Message-ID: <20091005160839.GA13626@kroah.com>
References: <20091002011548.335611824@mini.kroah.org>
 <20091002012418.981922186@mini.kroah.org>
 <200910031219.08574.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200910031219.08574.herton@mandriva.com.br>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03, 2009 at 12:19:08PM -0300, Herton Ronaldo Krzesinski wrote:
> Em Qui 01 Out 2009, às 22:17:07, Greg KH escreveu:
> > 2.6.31-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > From: Kurt Roeckx <kurt@roeckx.be>
> > 
> > commit f0adb134d8dc9993a9998dc50845ec4f6ff4fadc upstream.
> > 
> > Fixes bugzilla #13780
> > 
> > From: Kurt Roeckx <kurt@roeckx.be>
> > Signed-off-by: Dave Jones <davej@redhat.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > ---
> >  arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   15 ++++++++-------
> >  1 file changed, 8 insertions(+), 7 deletions(-)
> > 
> > --- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> > +++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> > @@ -605,9 +605,10 @@ static int check_pst_table(struct powern
> >  	return 0;
> >  }
> >  
> > -static void invalidate_entry(struct powernow_k8_data *data, unsigned int entry)
> > +static void invalidate_entry(struct cpufreq_frequency_table *powernow_table,
> > +		unsigned int entry)
> >  {
> > -	data->powernow_table[entry].frequency = CPUFREQ_ENTRY_INVALID;
> > +	powernow_table[entry].frequency = CPUFREQ_ENTRY_INVALID;
> >  }
> >  
> >  static void print_basics(struct powernow_k8_data *data)
> > @@ -914,13 +915,13 @@ static int fill_powernow_table_pstate(st
> >  					"bad value %d.\n", i, index);
> >  			printk(KERN_ERR PFX "Please report to BIOS "
> >  					"manufacturer\n");
> > -			invalidate_entry(data, i);
> > +			invalidate_entry(powernow_table, i);
> >  			continue;
> >  		}
> >  		rdmsr(MSR_PSTATE_DEF_BASE + index, lo, hi);
> >  		if (!(hi & HW_PSTATE_VALID_MASK)) {
> >  			dprintk("invalid pstate %d, ignoring\n", index);
> > -			invalidate_entry(data, i);
> > +			invalidate_entry(powernow_table, i);
> >  			continue;
> >  		}
> >  
> > @@ -970,7 +971,7 @@ static int fill_powernow_table_fidvid(st
> >  		/* verify frequency is OK */
> >  		if ((freq > (MAX_FREQ * 1000)) || (freq < (MIN_FREQ * 1000))) {
> >  			dprintk("invalid freq %u kHz, ignoring\n", freq);
> > -			invalidate_entry(data, i);
> > +			invalidate_entry(powernow_table, i);
> >  			continue;
> >  		}
> >  
> > @@ -978,7 +979,7 @@ static int fill_powernow_table_fidvid(st
> >  		 * BIOSs are using "off" to indicate invalid */
> >  		if (vid == VID_OFF) {
> >  			dprintk("invalid vid %u, ignoring\n", vid);
> > -			invalidate_entry(data, i);
> > +			invalidate_entry(powernow_table, i);
> >  			continue;
> >  		}
> >  
> > @@ -1009,7 +1010,7 @@ static int fill_powernow_table_fidvid(st
> >  				(unsigned int)
> >  				(data->acpi_data.states[i].core_frequency
> >  				 * 1000));
> > -			invalidate_entry(data, i);
> > +			invalidate_entry(powernow_table, i);
> >  			continue;
> >  		}
> >  	}
> > 
> 
> With this applied I get following warning:
> arch/x86/kernel/cpu/cpufreq/powernow-k8.c:1001: warning: passing argument 1 of 'invalidate_entry' from incompatible pointer type
> 
> There is a missing data->powernow_table change, following diff on top fixes it:
> 
> diff -p -up linux-2.6.31/arch/x86/kernel/cpu/cpufreq/powernow-k8.c.orig linux-2.6.31/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> --- linux-2.6.31/arch/x86/kernel/cpu/cpufreq/powernow-k8.c.orig	2009-10-03 12:06:38.000000000 -0300
> +++ linux-2.6.31/arch/x86/kernel/cpu/cpufreq/powernow-k8.c	2009-10-03 12:08:34.000000000 -0300
> @@ -998,7 +998,7 @@ static int fill_powernow_table_fidvid(st
>  
>  				dprintk("double low frequency table entry, "
>  						"ignoring it.\n");
> -				invalidate_entry(data, i);
> +				invalidate_entry(powernow_table, i);
>  				continue;
>  			} else
>  				cntlofreq = i;
> 

Thanks, I've merged this into the original patch.  For some reason my
build isn't letting me build this file so I didn't see the warning.

thanks again,

greg k-h
