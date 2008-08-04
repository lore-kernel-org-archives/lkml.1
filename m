Return-Path: <linux-kernel-owner+w=401wt.eu-S1762518AbYHDUHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762518AbYHDUHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760054AbYHDUHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:07:08 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:38302 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759589AbYHDUHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:07:06 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=x8iekeYzKkdUhB-W9DwA:9 a=J4UFAtDpc6c1rwIzyQEA:7 a=5Kq4wEXyGCwUDm759KimPvfnbBYA:4 a=ZCnnSLshPu8A:10 a=lN1hEWcJ4VIA:10
Message-ID: <48976168.3020804@shaw.ca>
Date: Mon, 04 Aug 2008 14:07:04 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: Re: Kernel Summit request for Discussion of future of ATA (libata)
 and IDE
References: <fa.OGeO7gZvBG4obEzRbVltjSebgTQ@ifi.uio.no> <fa.KtvYE2B2yrJqUleolhtMPN9ljAQ@ifi.uio.no> <fa.AqEKTvguYFAzDFHy/We/8MpOqmo@ifi.uio.no>
In-Reply-To: <fa.AqEKTvguYFAzDFHy/We/8MpOqmo@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> * There are still corner case in libata core - PIO is dead slow
>> compared to drivers/ide/,
> 
> There are two there - libata keeps IRQs blocked for longer in PIO mode as
> well which is a factor for realtime that needs looking at, as well as
> using 16bit not 32bit I/O for most devices (which is trivial to fix). The
> IRQ masking stuff is more complex and old IDE handles it far better for
> PIO on non shared IRQ interfaces. That is actually probably the most
> complicated thing to address of the stuff you'd want to do if you were
> going to kill off old IDE.

I was looking into the 32-bit PIO issue a bit yesterday. It looks like 
some of the VLB libata drivers are doing this internally already, so it 
shouldn't be hard to do this in the core. Only question is how we know 
generically if the controller can do it or not? It looks like in old 
IDE, a few controllers explicitly disable it, but it appears that it 
doesn't default to on for any controller, so it's possible there are 
others on which it doesn't work. Presumably anything on an actual 16-bit 
bus (ISA, LPC, etc.) wouldn't like it, to start with.

There's also the matter of the identify bit to indicate whether the 
drive supports 32-bit transfers, which was reallocated to trusted 
computing in ATA-8 so any drive matching that standard will indicate not 
supported. I couldn't track down where that bit was actually defined in 
the first place, all the way back to ATA-1 it seems to be indicated as 
reserved. Actually, I'm not sure why the drive cares in the first place, 
it would seem like a pure host controller issue..
