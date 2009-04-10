Return-Path: <linux-kernel-owner+w=401wt.eu-S1763476AbZDJN4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763476AbZDJN4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 09:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbZDJN4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 09:56:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:42672 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbZDJN4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 09:56:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sDAFlvqs5PONs/D3D/wvhil/Pl9++o6tS6mSnt9srLKeFjXX2T109+KFjL5NiZcb/u
         69m524aLxcf8gZk1EOThobuGChAQa0rkB0+085FYfUYWGgF9C3pfMBhR2KaWwQU7EBYb
         pxWOu6SbVnqJjmzI2vaU64SeTsIjMuMwe3LAQ=
Date: Fri, 10 Apr 2009 17:56:06 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [RFC -tip] x86: do_IRQ - send APIC EOI for x86-32 on irq
	without handler v3
Message-ID: <20090410135606.GA8204@lenovo>
References: <20090409181802.GC7558@lenovo> <20090410122750.GR21506@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410122750.GR21506@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Fri, Apr 10, 2009 at 02:27:50PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
| 
| > Ingo, I've checked the sources and as far as I see
| > we could NOP'ify apic->write indeed but I have
| > an internal feeling that this will bring us more problem
| > in future (for example it could be the following scenario:
| > some screwed APIC would require cleaning of LVT's or
| > IRR after resume regardless if it was initialized
| > or not at all). Mostly I mean that the idea of making
| > apic->write NOP'ified is quite elegant indeed but
| > cut off the subset of apic operations (we need
| > apic->read anyway) somehow bothering me from inside :)
| 
| it's as if assigned a special type of 'dummy apic' struct apic. It 
| wont cause problems down the line: we use the new APIC driver 
| infrastructure to abstract out quirks.

Well, it's not that new actually :-)

| 
| one small detail:
| 
| > +/* Ack APIC irq if it's enabled only */
| > +static inline void ack_APIC_irq_safe(void)
| > +{
| > +#ifdef CONFIG_X86_LOCAL_APIC
| > +	if (cpu_has_apic)
| > +		ack_APIC_irq();
| > +#endif
| 
| we dont need the cpu_has_apic check there, do we? In the 
| !cpu_has_apic the ->write method should be a dummy.

Yes. In case you're talking about it'll not be needed
(we will find earlier whether cpu_has_apic or not).

| 
| > -#ifdef CONFIG_X86_64
| > -		if (!disable_apic)
| > -			ack_APIC_irq();
| > -#endif
| > -
| > +		ack_APIC_irq_safe();
| 
| Please keep the ack_APIC_irq() name - it is inherently safe to call 
| it if we always give it a meaningful ->write method.
| 
| 	Ingo
| 

Ok, I think we eventually try to NOP'ify apic->write method
so this patch is plainly not needed (thanks for comments!).

Will back with new patch.

        Cyrill
