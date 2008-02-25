Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbYBYQyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbYBYQyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 11:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbYBYQyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 11:54:40 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:32933 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754963AbYBYQyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 11:54:40 -0500
Message-Id: <1203958478.20033.1239002461@webmail.messagingengine.com>
X-Sasl-Enc: hNpsP5i+VVs4Al4peHc+iAlDcbGswtZ25hlAI1TIoz+S 1203958478
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "H. Peter Anvin" <hpa@zytor.com>, "Andi Kleen" <ak@suse.de>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Alexander van Heukelum" <heukelum@mailshack.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080224174605.GA21661@mailshack.com> <47C22568.1010405@zytor.com>
Subject: Re: [PATCH] Fix alignment of early reservation for EBDA
In-Reply-To: <47C22568.1010405@zytor.com>
Date: Mon, 25 Feb 2008 17:54:38 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008 18:18:16 -0800, "H. Peter Anvin" <hpa@zytor.com>
said:
> Alexander van Heukelum wrote:
> > early res: 3 [9f000-9ffff] EBDA
> > 
> > Is it really necessary to force the allocation to a page boundary?
> 
> It is, but that rounding gets done in reserve_bootmem() anyway, so there 
> is no need for the arch-specific code to do it.
> 
> The 32-bit EBDA code hard-codes a size of 4K, which is probably equally 
> wrong; my gut feel is that the right thing to do is to reserve from the 
> EBDA up to the 640K mark (some BIOSes use an area like that for SMM 
> stuff), possibly with some sanity checking.

Then, how about reserving everything from the end of conventional memory
up to the 1Mb mark? Like this:

/*
 * The BIOS places the EBDA/XBDA at the top of conventional
 * memory, and usually decreases the reported amount of
 * conventional memory (int 0x12) too.
 */
static __init void reserve_ebda(void)
{
        unsigned int lowmem, ebda_addr;

        /* end of low (conventional) memory */
        lowmem = *(unsigned short *)__va(BIOS_LOWMEM_KILOBYTES);
        lowmem <<= 10;

        /* start of EBDA area */
        ebda_addr = *(unsigned short *)__va(BIOS_EBDA_SEGMENT);
        ebda_addr <<= 4;

        /* Fixup: bios puts an EBDA in the top 64K segment */
        /* of conventional memory, but does not adjust lowmem. */
        if ((lowmem - ebda_addr) <= 0x10000)
                lowmem = ebda_addr;

        /* Fixup: bios does not report an EBDA at all. */
        /* Some old Dells seem to need 4k anyhow (bugzilla 2990) */
        if ((ebda_addr == 0) && (lowmem >= 0x9f000))
                lowmem = 0x9f000;

        /* Paranoia: should never happen, but... */
        if (lowmem >= 0x100000)
                lowmem = 0xa0000;

        /* reserve all memory between lowmem and the 1MB mark */
        reserve_early(lowmem, 0x100000, "BIOS reserved");
}

Greetings,
    Alexander
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Choose from over 50 domains or use your own

