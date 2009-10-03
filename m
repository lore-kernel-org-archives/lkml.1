Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbZJCPUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbZJCPUw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 11:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbZJCPUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 11:20:51 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:58891 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbZJCPUv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 11:20:51 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Organization: Mandriva
To: Greg KH <gregkh@suse.de>
Subject: Re: [079/136] [CPUFREQ] Fix NULL ptr regression in powernow-k8
Date: Sat, 3 Oct 2009 12:19:08 -0300
User-Agent: KMail/1.12.1 (Linux/2.6.31.1-desktop-1mnb; KDE/4.3.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dave Jones <davej@redhat.com>
References: <20091002011548.335611824@mini.kroah.org> <20091002012418.981922186@mini.kroah.org>
In-Reply-To: <20091002012418.981922186@mini.kroah.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <200910031219.08574.herton@mandriva.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Qui 01 Out 2009, às 22:17:07, Greg KH escreveu:
> 2.6.31-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: Kurt Roeckx <kurt@roeckx.be>
> 
> commit f0adb134d8dc9993a9998dc50845ec4f6ff4fadc upstream.
> 
> Fixes bugzilla #13780
> 
> From: Kurt Roeckx <kurt@roeckx.be>
> Signed-off-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> --- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> +++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> @@ -605,9 +605,10 @@ static int check_pst_table(struct powern
>  	return 0;
>  }
>  
> -static void invalidate_entry(struct powernow_k8_data *data, unsigned int entry)
> +static void invalidate_entry(struct cpufreq_frequency_table *powernow_table,
> +		unsigned int entry)
>  {
> -	data->powernow_table[entry].frequency = CPUFREQ_ENTRY_INVALID;
> +	powernow_table[entry].frequency = CPUFREQ_ENTRY_INVALID;
>  }
>  
>  static void print_basics(struct powernow_k8_data *data)
> @@ -914,13 +915,13 @@ static int fill_powernow_table_pstate(st
>  					"bad value %d.\n", i, index);
>  			printk(KERN_ERR PFX "Please report to BIOS "
>  					"manufacturer\n");
> -			invalidate_entry(data, i);
> +			invalidate_entry(powernow_table, i);
>  			continue;
>  		}
>  		rdmsr(MSR_PSTATE_DEF_BASE + index, lo, hi);
>  		if (!(hi & HW_PSTATE_VALID_MASK)) {
>  			dprintk("invalid pstate %d, ignoring\n", index);
> -			invalidate_entry(data, i);
> +			invalidate_entry(powernow_table, i);
>  			continue;
>  		}
>  
> @@ -970,7 +971,7 @@ static int fill_powernow_table_fidvid(st
>  		/* verify frequency is OK */
>  		if ((freq > (MAX_FREQ * 1000)) || (freq < (MIN_FREQ * 1000))) {
>  			dprintk("invalid freq %u kHz, ignoring\n", freq);
> -			invalidate_entry(data, i);
> +			invalidate_entry(powernow_table, i);
>  			continue;
>  		}
>  
> @@ -978,7 +979,7 @@ static int fill_powernow_table_fidvid(st
>  		 * BIOSs are using "off" to indicate invalid */
>  		if (vid == VID_OFF) {
>  			dprintk("invalid vid %u, ignoring\n", vid);
> -			invalidate_entry(data, i);
> +			invalidate_entry(powernow_table, i);
>  			continue;
>  		}
>  
> @@ -1009,7 +1010,7 @@ static int fill_powernow_table_fidvid(st
>  				(unsigned int)
>  				(data->acpi_data.states[i].core_frequency
>  				 * 1000));
> -			invalidate_entry(data, i);
> +			invalidate_entry(powernow_table, i);
>  			continue;
>  		}
>  	}
> 

With this applied I get following warning:
arch/x86/kernel/cpu/cpufreq/powernow-k8.c:1001: warning: passing argument 1 of 'invalidate_entry' from incompatible pointer type

There is a missing data->powernow_table change, following diff on top fixes it:

diff -p -up linux-2.6.31/arch/x86/kernel/cpu/cpufreq/powernow-k8.c.orig linux-2.6.31/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
--- linux-2.6.31/arch/x86/kernel/cpu/cpufreq/powernow-k8.c.orig	2009-10-03 12:06:38.000000000 -0300
+++ linux-2.6.31/arch/x86/kernel/cpu/cpufreq/powernow-k8.c	2009-10-03 12:08:34.000000000 -0300
@@ -998,7 +998,7 @@ static int fill_powernow_table_fidvid(st
 
 				dprintk("double low frequency table entry, "
 						"ignoring it.\n");
-				invalidate_entry(data, i);
+				invalidate_entry(powernow_table, i);
 				continue;
 			} else
 				cntlofreq = i;


-- 
[]'s
Herton
