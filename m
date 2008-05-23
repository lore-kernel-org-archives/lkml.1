Return-Path: <linux-kernel-owner+w=401wt.eu-S1759584AbYEWVNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584AbYEWVNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 17:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbYEWVNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 17:13:31 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:39222 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754AbYEWVNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 17:13:30 -0400
Message-ID: <4837339F.9060407@freescale.com>
Date: Fri, 23 May 2008 16:14:07 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: Trent Piepho <tpiepho@freescale.com>, David Miller <davem@davemloft.net>,
       linuxppc-dev@ozlabs.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: MMIO and gcc re-ordering (Was: [PATCH] [POWERPC] Improve	(in|out)_beXX()
 asm code)
References: <4833524C.3040207@freescale.com>	 <20080520.153947.84346222.davem@davemloft.net>	 <4833542E.3040608@freescale.com>	 <20080520.155326.195407196.davem@davemloft.net>	 <1211516683.8297.271.camel@pasglop>	 <Pine.LNX.4.64.0805221553400.8205@t2.domain.actdsltmp>	 <1211546197.8297.308.camel@pasglop> <1211547016.8297.310.camel@pasglop>
In-Reply-To: <1211547016.8297.310.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Fri, 2008-05-23 at 08:36 -0400, Benjamin Herrenschmidt wrote:
>>         - mandate some kind of dma_sync_for_device/cpu on consistent memory.
>> Almost no driver do that currently tho. They only do that for non
>> consistent memory mapped with dma_map_*.
>>
>>         - mandate the use of wmb,rmb,mb barriers for use between memory
>> accesses and MMIOs for ordering them. (ie. fix drivers that don't do
>> it). Advantage for powerpc is that I can remove (after some auditing of
>> course) the added heavy barriers in the MMIO accessors themselves.
> 
> Note that the above is my preferred approach, and a lot of drivers
> happen to already do this.

As Trent pointed out, if you change to eieio in the accessors, that'd 
require drivers to also use mmiowb() before spin_unlock(), which fewer 
drivers currently do.

>>         - stick a full memory clobber in all MMIO (and PIO) accessors on all
>> archs.

I like this, combined with introducing raw variants of the non-PCI 
accessors (in_be32 and such).  It's slower and safe by default (i.e. no 
auditing drivers), but performance-critical paths can be optimized to 
use raw accessors combined with explicit barriers.

-Scott
