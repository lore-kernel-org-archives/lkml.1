Return-Path: <linux-kernel-owner+w=401wt.eu-S1765323AbYCDQv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765323AbYCDQv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYCDQvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:51:18 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:40777 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751980AbYCDQvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:51:17 -0500
Message-Id: <1204649476.5048.1240509149@webmail.messagingengine.com>
X-Sasl-Enc: fxSkemAwQjZfcJil95bznigC/pkc1jV3yswgB+sELIPs 1204649476
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Mark McLoughlin" <markmc@redhat.com>,
       "Alexander van Heukelum" <heukelum@mailshack.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Ian Campbell" <ijc@hellion.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, "Andi Kleen" <ak@suse.de>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "LKML" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <47C22568.1010405@zytor.com>
   <1203958478.20033.1239002461@webmail.messagingengine.com>
   <20080225170134.GA15839@elte.hu>
   <20080225180750.GA31054@mailshack.com>
   <20080228131341.GA25213@mailshack.com>
   <1204232996.28798.8.camel@cthulhu.hellion.org.uk>
   <20080229114943.GA1909@mailshack.com> <1204305247.2037.2.camel@muff>
   <1204310323.24514.1239870063@webmail.messagingengine.com>
   <1204322819.6299.1.camel@muff> <20080301160911.GA13271@mailshack.com>
   <1204631082.16613.7.camel@muff> <47CD6858.9070603@goop.org>
Subject: Re: [PATCH] reserve end-of-conventional-memory to 1MB on 32-bit v2
In-Reply-To: <47CD6858.9070603@goop.org>
Date: Tue, 04 Mar 2008 17:51:16 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 04 Mar 2008 07:18:48 -0800, "Jeremy Fitzhardinge"
<jeremy@goop.org> said:
> Mark McLoughlin wrote:
> > This is a bit magic, is it worth splitting it out as something like
> > is_paravirt_environment() ?
> >   
> 
> Yes, is_paravirt() already exists for this purpose.

Hi,

If it exists, it is well-hidden. A grep for is_paravirt on the testing
tree turns up nothing. Did you get the name right?

> The code looking at the boot params will only work if we actually booted 
> via the paravirt Linux boot protocol, which Xen doesn't at present.

I chose to code it exactly this way, because it is what is used in
head_32.S to choose how to start the kernel. Or is this code not
executed at all?

[excerpt form head_32.S]
        cmpw $0x207, pa(boot_params + BP_version)
        jb default_entry

        /* Paravirt-compatible boot parameters.  Look to see what
        architecture
                we're booting under. */
        movl pa(boot_params + BP_hardware_subarch), %eax
        cmpl $num_subarch_entries, %eax
        jae bad_subarch

        movl pa(subarch_entries)(,%eax,4), %eax
        subl $__PAGE_OFFSET, %eax
        jmp *%eax
[and]
subarch_entries:
        .long default_entry             /* normal x86/PC */
        .long lguest_entry              /* lguest hypervisor */
        .long xen_entry                 /* Xen hypervisor */
num_subarch_entries = (. - subarch_entries) / 4
[end]

If this is indeed not executed, is there a way to detect whether
we can expect the environment to behave like a normal pc in terms
of magic addresses, bios areas, isa reserved address space and so
on?

Greetings,
    Alexander
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - mmm... Fastmail...

