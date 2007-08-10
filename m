Return-Path: <linux-kernel-owner+w=401wt.eu-S934074AbXHJKNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934074AbXHJKNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 06:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbXHJKNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 06:13:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50515 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757478AbXHJKNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 06:13:34 -0400
Date: Fri, 10 Aug 2007 11:13:03 +0100
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jarek Poplawski <jarkao2@o2.pl>, Thomas Gleixner <tglx@linutronix.de>,
       John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org,
       vignaud@xandmail.fr, marcin.slusarz@gmail.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-net@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.23-rc2: WARNING: at kernel/irq/resend.c:70
 check_irq_resend()
Message-ID: <20070810111303.04da45e1@oldman.hamilton.local>
In-Reply-To: <20070810093353.GA19777@elte.hu>
References: <18107.11431.838905.331157@stoffel.org>
	<20070809155445.GA5161@ff.dom.local>
	<1186733140.12828.45.camel@chaos>
	<20070810082346.GD1764@ff.dom.local>
	<20070810083050.GA4545@elte.hu>
	<20070810084924.GF1764@ff.dom.local>
	<20070810085611.GA11639@elte.hu>
	<20070810091231.GH1764@ff.dom.local>
	<20070810093353.GA19777@elte.hu>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 11:33:53 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jarek Poplawski <jarkao2@o2.pl> wrote:
> 
> > > > > +               }
> > > > >  #ifdef CONFIG_HARDIRQS_SW_RESEND
> > > 
> > > we used the hw-resend method unconditionally, right?
> > 
> > Right: unconditionally on a condition they are not edges...
> > 
> > But, since not resending at all seems to work so good in testing, I 
> > thought, _SW_RESEND could be considered as an unnecessarily 
> > complicated alternative.
> > 
> > Now, I'm a bit confused...
> 
> the idea is multi-pronged:
> 
>  - Primarily, we want to fix the regression. 2.6.20 worked, 2.6.21 
>    didnt, that has to be fixed, no matter what - end of story. But we've 
>    got a wide selection of patches for that purpose now, so what matters 
>    at this point is the secondary question:
> 
>  - we want to know _why exactly_ the hang happens. We now have a pretty 
>    good theory: hw-resend hangs the IO-APIC. (there is a delicate dance
>    between local APICs and IO-APICs for level-triggered irqs, and if we
>    interject via hw-resending via the local APIC, existing races, hw
>    bugs or weaknesses in our hw-resend implementation might be exposed)
> 
> and even though we now have a wide selection of patches we really want 
> to get to the bottom of the problem so that we can fix the bug that got 
> exposed: apparently hw resend doesnt always work with level-triggered 
> irqs.
> 
> Note that the hw-resend sequence can trigger _even without our original 
> patch that triggered the regression_, it's just much less likely to 
> happen, so this is a pre-existing IO-APIC/APIC code bug that could 
> trigger anytime, and which we want to see fixed.
> 
> To confirm this theory - does the debug-patch below fix the hang? If it 
> fixes the hang then the theory is confirmed and then the right solution 
> is to retrigger an IRQ for level-triggered irqs with the proper 
> trigger-type set.
> 


All this might explain some of the IRQ loss, I saw with sky2 on mac mini.
Basically, the device would act like it missed an IRQ. The chip and PCI registers
all said "device has asserted IRQ" but the IRQ handler never got called.

Then again, the problem might be completely different since this was with
PCI-E with either MSI or INTA mode.

The workaround was to perodically call the soft IRQ handler and that would
clear the IRQ, but it's not something I want to keep.
