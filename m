Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600Ab0A0QwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab0A0QwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 11:52:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755502Ab0A0QwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 11:52:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754286Ab0A0QwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 11:52:02 -0500
Date: Wed, 27 Jan 2010 08:50:49 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Jarek Poplawski <jarkao2@gmail.com>, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, flyboy@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>, Don Fry <pcnet32@verizon.net>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Matt Carlson <mcarlson@broadcom.com>
Subject: Re: Hang: 2.6.32.4 sky2/DMAR (was [PATCH] sky2: Fix WARNING: at
 lib/dma-debug.c:902 check_sync)
Message-ID: <20100127085049.5b5048e9@nehalam>
In-Reply-To: <4B605D1B.60402@majjas.com>
References: <20100120094103.GA6225@ff.dom.local>
	<4B58B217.8030001@majjas.com>
	<20100121204133.GB3085@del.dom.local>
	<4B59E7EB.3050605@majjas.com>
	<20100122215304.GA3105@del.dom.local>
	<4B5A2362.6000306@majjas.com>
	<20100122230605.GB3105@del.dom.local>
	<4B5A33D8.90501@majjas.com>
	<20100122234656.GC3105@del.dom.local>
	<4B5A39BD.8020305@majjas.com>
	<20100123232133.GA3487@del.dom.local>
	<4B605D1B.60402@majjas.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010 10:34:51 -0500
Michael Breuer <mbreuer@majjas.com> wrote:

> On 01/23/2010 06:21 PM, Jarek Poplawski wrote:
> > On Fri, Jan 22, 2010 at 06:50:21PM -0500, Michael Breuer wrote:
> >      
> >> When the packets were dropped, there was a different sequence in the
> >> log - DISCOVER/OFFER repeated. The "normal" is that the sequence
> >> appeared correct and complete - DISCOVER/OFFER/REQUEST/ACK - or
> >> INFORM/ACK (vs. INFORM repeatedly sans ACK) as the case may be.
> >>        
> > Anyway, I'd be intersted if the switch matters here.
> >
> > Plus one more test: could you try to load sky2 with the parameter:
> > "copybreak=1" (the rest as in any recent test, which gave you dmar
> > errors; any switch).
> >
> > Thanks,
> > Jarek P.
> >      
> Ok - now up 80+ hours with copybreak=1. I'm going to redo w/o copybreak 
> to confirm that I haven't inadvertently fixed something. However, given 
> that it might be copybreak-related, I looked at sky2.c again and I'm 
> wondering about the copybreak max size in sky2_rx_start:
> 
>    size = roundup(sky2->netdev->mtu + ETH_HLEN + VLAN_HLEN, 8);
> 
>          /* Stopping point for hardware truncation */
>          thresh = (size - 8) / sizeof(u32);
> 
>          sky2->rx_nfrags = size >> PAGE_SHIFT;
>          BUG_ON(sky2->rx_nfrags > ARRAY_SIZE(re->frag_addr));
> 
>          /* Compute residue after pages */
>          size -= sky2->rx_nfrags << PAGE_SHIFT;
> 
>          /* Optimize to handle small packets and headers */
>          if (size < copybreak)
>                  size = copybreak;
>          if (size < ETH_HLEN)
>                  size = ETH_HLEN;
> 
> 
> Why would increasing size to copybreak be valid here?
> 
> Guessing a bit as I'm not sure about rx_nfrags, but if I read this 
> correctly, if size is ever less than copybreak it's because there isn't 
> enough space left for anything larger. If so, wouldn't increasing size 
> potentially corrupt something? I'd further guess that the resulting 
> condition manifests sooner (or at least with a more visible effect) when 
> using DMAR.
> 
> In any event, why "copybreak" as the minimum buffer size? I'd suggest 
> that if it isn't possible to allocate at least MTU + overhead that 
> sky2_rx_start ought to be delayed until there is room.

This code is where driver decides how much data will be received in skb
data area and the remaining data spills over into skb frags.
Copybreak is the threshold so that packets less than size are copied
to a new skb.  The code doing the copying there assumes the data is
totally contained in the skb (not in frags). The size increase there
is to make sure that assumption is always true.  I suppose you
could do something perverse like setting copybreak really huge 
and confuse driver, but that is a user error.


