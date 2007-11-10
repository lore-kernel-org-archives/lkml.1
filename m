Return-Path: <linux-kernel-owner+w=401wt.eu-S1759335AbXKJA4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335AbXKJA4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 19:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755724AbXKJA4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 19:56:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:28857 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793AbXKJA4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 19:56:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,397,1188802800"; 
   d="scan'208";a="267253532"
Date: Fri, 9 Nov 2007 16:52:47 -0800
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: SANGOI DINO LEONARDO <dino.leonardo.sangoi@allianz.it>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Brown, Len" <len.brown@intel.com>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.24-rc1 and 2.6.24.rc2 hangs while running udev on my laptop
Message-ID: <20071110005247.GA1898@linux-os.sc.intel.com>
References: <2C8305E0BE090E47A2BAD52A48AC911D17BCE242@exchange1.lloyd.com> <20071109020321.b26b293f.akpm@linux-foundation.org> <B5B0CFF685D7DF46A05CF1678CFB42ED20E0093D@orsmsx423.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B5B0CFF685D7DF46A05CF1678CFB42ED20E0093D@orsmsx423.amr.corp.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 10:10:43AM -0800, Pallipadi, Venkatesh wrote:
>  
> 
> >-----Original Message-----
> >From: Andrew Morton [mailto:akpm@linux-foundation.org] 
> >Sent: Friday, November 09, 2007 2:03 AM
> >To: SANGOI DINO LEONARDO
> >Cc: linux-kernel@vger.kernel.org; Rafael J. Wysocki; Brown, 
> >Len; Pallipadi, Venkatesh; linux-acpi@vger.kernel.org
> >Subject: Re: 2.6.24-rc1 and 2.6.24.rc2 hangs while running 
> >udev on my laptop
> >
> >
> >(cc's added)
> >
> >On Fri, 9 Nov 2007 09:47:02 +0100  SANGOI DINO LEONARDO 
> ><dino.leonardo.sangoi@allianz.it> wrote:
> >
> >> Hi,
> >>  
> >> My laptop (an HP nx6125) doesn't boot with kernels 2.6.24-rc1 and
> >> 2.6.24.rc2. 
> >> It works fine with 2.6.23 and older.
> >> 
> >> I seen this bug first while running fedora rawhide, so you 
> >can find hardware
> >> 
> >> info and boot logs at 
> >https://bugzilla.redhat.com/show_bug.cgi?id=312201.
> >> 
> >> I did a git bisect, and got this:
> >> 
> >> $ git bisect bad
> >> 4f86d3a8e297205780cca027e974fd5f81064780 is first bad commit
> >> commit 4f86d3a8e297205780cca027e974fd5f81064780
> >> Author: Len Brown <len.brown@intel.com>
> >> Date:   Wed Oct 3 18:58:00 2007 -0400
> >> 
> >>     cpuidle: consolidate 2.6.22 cpuidle branch into one patch
> >> [SNIP full commit log]
> >> 
> <snip>
> > --------
> >> 
> >> Config is taken from Fedora kernel. CONFIG_CPU_IDLE is set 
> >to y (tell me if
> >> full config is needed).
> >> 
> >> If I use 'nolapic' parameter, kernel 2.6.24-rc1 boots fine. 
> >> Setting CONFIG_CPU_IDLE=n also gives me a working kernel.
> >> 
> >> Ask me if more info is needed (please CC me).
> >> 
> >> Thanks,
> >> 
> >> Dino
> 
> 

Dino,

Can you try the patch below over rc2 and see whether it fixes the problem.
Looking at the code, it should fix the problem. If it does not, can you send
me the output of acpidump from your system. That will help to look further
into this. You can get acpidump from latest pmtools package here.
www.kernel.org/pub/linux/kernel/people/lenb/acpi/utils/

Thanks,
Venki


Test patch for the bug report at
https://bugzilla.redhat.com/show_bug.cgi?id=312201

Signed-off-by: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.24-rc/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6.24-rc.orig/drivers/acpi/processor_idle.c
+++ linux-2.6.24-rc/drivers/acpi/processor_idle.c
@@ -1502,23 +1502,28 @@ static int acpi_idle_enter_bm(struct cpu
 	} else {
 		acpi_idle_update_bm_rld(pr, cx);
 
-		spin_lock(&c3_lock);
-		c3_cpu_count++;
-		/* Disable bus master arbitration when all CPUs are in C3 */
-		if (c3_cpu_count == num_online_cpus())
-			acpi_set_register(ACPI_BITREG_ARB_DISABLE, 1);
-		spin_unlock(&c3_lock);
+		if (pr->flags.bm_check && pr->flags.bm_control) {
+			spin_lock(&c3_lock);
+			c3_cpu_count++;
+			/* Disable bus master arbitration when all CPUs are in C3 */
+			if (c3_cpu_count == num_online_cpus())
+				acpi_set_register(ACPI_BITREG_ARB_DISABLE, 1);
+			spin_unlock(&c3_lock);
+		} else if (!pr->flags.bm_check) {
+			ACPI_FLUSH_CPU_CACHE();
+		}
 
 		t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 		acpi_idle_do_entry(cx);
 		t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 
-		spin_lock(&c3_lock);
 		/* Re-enable bus master arbitration */
-		if (c3_cpu_count == num_online_cpus())
+		if (pr->flags.bm_check && pr->flags.bm_control) {
+			spin_lock(&c3_lock);
 			acpi_set_register(ACPI_BITREG_ARB_DISABLE, 0);
-		c3_cpu_count--;
-		spin_unlock(&c3_lock);
+			c3_cpu_count--;
+			spin_unlock(&c3_lock);
+		}
 	}
 
 #if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86_TSC)
