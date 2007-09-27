Return-Path: <linux-kernel-owner+w=401wt.eu-S1760367AbXI0XeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760367AbXI0XeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 19:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760169AbXI0XeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 19:34:10 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:40008 "EHLO
	outbound1-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760028AbXI0XeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 19:34:08 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Date: Thu, 27 Sep 2007 17:34:08 -0600
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: jkeating@redhat.com, "Joerg Pommnitz" <pommnitz@yahoo.com>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <ak@suse.de>
Subject: Re: More E820 brokenness
Message-ID: <20070927233408.GD4755@cosmic.amd.com>
References: <46FC2BFD.6070200@zytor.com>
 <20070927223336.GB4755@cosmic.amd.com> <46FC32FE.9070302@zytor.com>
 <20070927231552.GC4755@cosmic.amd.com> <46FC3C5A.2010902@zytor.com>
MIME-Version: 1.0
In-Reply-To: <46FC3C5A.2010902@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 27 Sep 2007 23:33:38.0656 (UTC)
 FILETIME=[D4AA8E00:01C8015E]
X-WSS-ID: 6AE2E2692ZC503912-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/09/07 16:27 -0700, H. Peter Anvin wrote:
> Jordan Crouse wrote:
> > On 27/09/07 15:47 -0700, H. Peter Anvin wrote:
> >> Jordan Crouse wrote:
> >>> Breaks on the Geode - original behavior.
> >>>
> >>> I think that having boot_prams.e820_entries != 0 makes the kernel
> >>> assume the e820 data is correct.
> >>>
> >> Okay, now I'm utterly baffled how 2.6.22 ever worked on this Geode,
> >> because this, to the best of my reading, mimics the 2.6.22 behavior
> >> exactly.  DID IT REALLY, and/or did you make any kind of configuration
> >> changes?
> > 
> > I copied in a 2.6.22 kernel to see that it really did work, and it did.
> > But here's the crazy part - I did a dmesg, and it looks like it
> > *is* using e820 data, and it looks complete (I see the entire map - 
> > including the ACPI and reserved blocks way up high).
> > 
> > So apparently it was the 2.6.22 code that was buggy, but reading it,
> > I don't immediately see how. 
> > 
> 
> Oh bugger, looks like this one might be genuinely my fault after all.
> The ID check in the new code is buggy.
> 
> Can you please test this revised patch out (against current -git)?

> 	-hpa
> 
> 
> 

> diff --git a/arch/i386/boot/memory.c b/arch/i386/boot/memory.c
> index bccaa1c..84939b7 100644
> --- a/arch/i386/boot/memory.c
> +++ b/arch/i386/boot/memory.c
> @@ -34,17 +34,7 @@ static int detect_memory_e820(void)
>  		      "=m" (*desc)
>  		    : "D" (desc), "a" (0xe820));
>  
> -		/* Some BIOSes stop returning SMAP in the middle of
> -		   the search loop.  We don't know exactly how the BIOS
> -		   screwed up the map at that point, we might have a
> -		   partial map, the full map, or complete garbage, so
> -		   just return failure. */
> -		if (id != SMAP) {
> -			count = 0;
> -			break;
> -		}
> -
> -		if (err)
> +		if (id != SMAP || err)
>  			break;
>  
>  		count++;


That looks the same as the previous patch you sent?

Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.


