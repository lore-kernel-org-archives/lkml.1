Return-Path: <linux-kernel-owner+w=401wt.eu-S1754937AbXLLWTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbXLLWTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 17:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbXLLWS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 17:18:56 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:37355 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbXLLWS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 17:18:56 -0500
Message-ID: <47605E4B.6050904@davidnewall.com>
Date: Thu, 13 Dec 2007 08:48:51 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Rene Herman <rene.herman@keyaccess.nl>, Paul Rolland <rol@as2917.net>,
       "H. Peter Anvin" <hpa@zytor.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       "David P. Reed" <dpreed@reed.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com>	<p733auekcly.fsf@bingen.suse.de>	<20071207160439.71b7f46a@the-village.bc.nu>	<20071209125458.GB4381@ucw.cz>	<20071209165908.GA15910@one.firstfloor.org>	<20071209212513.GC24284@elf.ucw.cz>	<475CBDD7.5050602@keyaccess.nl>	<m3bq8y23de.fsf@maximus.localdomain>	<475DE37F.20706@davidnewall.com>	<475DE6F4.80702@zytor.com>	<475DEB23.1000304@davidnewall.com>	<20071211084059.3d03e11d@tux.DEF.witbe.net>	<475E5D4B.8020101@keyaccess.nl>	<475E7DC2.4060509@davidnewall.com>	<475E8D91.20201@keyaccess.nl>	<475E95A3.3070801@davidnewall.com> <20071211142552.2ae6ea9a@the-village.bc.nu>
In-Reply-To: <20071211142552.2ae6ea9a@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> without need.  Not surprising since it has such a vague specific 
>> meaning.  One could say, Linux on i386 is liberally sprinkled with 
>>     
>
> "vague specific" ? sorry don't follow you.
>   

The _p variants are a universal fixture, defined as ending with a pause, 
but without specifying the duration.  (The duration is architecture 
specific, mostly zero.)  It really isn't a form that should be used in 
generic code.

>> I really prefer accurate code, but I'm also pragmatic and realise that 
>> it's far too much work to fix this any time soon.  But if it were to be 
>> fixed, then perhaps _p would take an additional parameter, measured in 
>> cycles of delay.
>>     
>
> measured in what, against what, for which bus.
>
> inb_p/outb_p are really only meaningful for ISA/LPC bus devices. In those
> cases it is precisely defined. Its use for PCI devices is a bit suspect
> and as a general rule probably wrong.

Yes, it's now clear that all of this is so.  Regrettably, it's used in 
dozens of drivers, most having nothing to do with an ISA/LPC bus.

If it really is specific to the ISA architecture, then it should only be 
used in architecture specific code.

I think the solution is to remove it.  Replace all _p calls with the 
non-_p variant, and add an explicit udelay.  Udelay can initially be set 
conservatively until it's been properly calibrated, allowing it to be 
used during early boot.  The good news is that it's only used in a few 
dozen drivers, so that actually might be doable.  And then, who knows, 
maybe Microsoft might have to scratch their corporate heads, trying to 
find out how to compete with a suddenly much faster Linux! :-p
