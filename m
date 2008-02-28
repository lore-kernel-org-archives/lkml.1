Return-Path: <linux-kernel-owner+w=401wt.eu-S1764788AbYB1VMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764788AbYB1VMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 16:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761405AbYB1VMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 16:12:36 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:6430 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760950AbYB1VMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 16:12:34 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alexander van Heukelum <heukelum@fastmail.fm>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Mark McLoughlin <markmc@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080228132822.GA25278@mailshack.com>
References: <20080224174605.GA21661@mailshack.com>
	 <47C22568.1010405@zytor.com>
	 <1203958478.20033.1239002461@webmail.messagingengine.com>
	 <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com>
	 <20080228131341.GA25213@mailshack.com>
	 <20080228132822.GA25278@mailshack.com>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 21:12:11 +0000
Message-Id: <1204233131.28798.12.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [RFC] use realmode code to reserve end-of-conventional-memory
	to 1MB
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 14:28 +0100, Alexander van Heukelum wrote:
> Instead of using early reservations inside the kernel code,
> we could use the realmode code to modify the e820 memmap.
> This patch shows what that would look like. I have not looked
> at the case where the BIOS does not provide an e820 memmap
> yet. Probably a full solution would need to create a fake
> e820 memmap in that case.

An e820 is already faked up in machine_specific_memory_setup() if one
doesn't already exist.

> Comments?

This won't work for Xen since the real-mode code never runs there. I
think it could be fixed in xen_memory_setup() though if native goes down
this route.

Ian.

> 
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> 
> diff --git a/arch/x86/boot/memory.c b/arch/x86/boot/memory.c
> index e77d89f..522920a 100644
> --- a/arch/x86/boot/memory.c
> +++ b/arch/x86/boot/memory.c
> @@ -23,6 +23,7 @@ static int detect_memory_e820(void)
>  	int count = 0;
>  	u32 next = 0;
>  	u32 size, id;
> +	u32 lowmem, ebda_addr;
>  	u8 err;
>  	struct e820entry *desc = boot_params.e820_map;
>  
> @@ -50,13 +51,51 @@ static int detect_memory_e820(void)
>  		   just return failure. */
>  		if (id != SMAP) {
>  			count = 0;
> -			break;
> +			goto out;
>  		}
>  
>  		count++;
>  		desc++;
> -	} while (next && count < E820MAX);
> -
> +	} while (next && count < (E820MAX - 1));
> +
> +	/* Some BIOSes do not reserve the EBDA/XBDA area correctly in.
> +	   The e820-map. Find out where the EBDA resides by looking at
> +	   the BIOS data area and reserve the EBDA and the following
> +	   legacy adapter area explicitly. */
> +#define BIOS_EBDA_SEGMENT 0x40E
> +#define BIOS_LOWMEM_KILOBYTES 0x413
> +
> +	/* end of low (conventional) memory */
> +	set_fs(0);
> +	lowmem = rdfs16(BIOS_LOWMEM_KILOBYTES);
> +	lowmem <<= 10;
> +
> +	/* start of EBDA area */
> +	ebda_addr = rdfs16(BIOS_EBDA_SEGMENT);
> +	ebda_addr <<= 4;
> +
> +	/* Fixup: bios puts an EBDA in the top 64K segment */
> +	/* of conventional memory, but does not adjust lowmem. */
> +	if ((lowmem - ebda_addr) <= 0x10000)
> +		lowmem = ebda_addr;
> +
> +	/* Fixup: bios does not report an EBDA at all. */
> +	/* Some old Dells seem to need 4k anyhow (bugzilla 2990) */
> +	if ((ebda_addr == 0) && (lowmem >= 0x9f000))
> +		lowmem = 0x9f000;
> +
> +	/* Paranoia: should never happen, but... */
> +	if (lowmem >= 0x100000)
> +		lowmem = 0xa0000;
> +
> +	/* reserve all memory between lowmem and the 1MB mark */
> +	desc->addr = lowmem;
> +	desc->size = 0x100000 - lowmem;
> +	desc->type = E820_RESERVED;
> +	count++;
> +	desc++;
> +
> +out:
>  	return boot_params.e820_entries = count;
>  }
>  
> 
> 
-- 
Ian Campbell

Nasrudin walked into a teahouse and declaimed, "The moon is more useful
than the sun."
	"Why?", he was asked.
	"Because at night we need the light more."

