Return-Path: <linux-kernel-owner+w=401wt.eu-S1765726AbZAOOkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765726AbZAOOkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 09:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756988AbZAOOk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 09:40:29 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:54552 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003AbZAOOk2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 09:40:28 -0500
Message-ID: <496F4AD4.9080201@cosmosbay.com>
Date: Thu, 15 Jan 2009 15:40:20 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Pekka Pietikainen <pp@ee.oulu.fi>
CC: =?UTF-8?B?TWloYWkgRG9uyJt1?= <mihai.dontu@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: b44 - swapper: page allocation failure
References: <20090115111537.GA994@gondor.apana.org.au> <200901151527.43646.mihai.dontu@gmail.com> <20090115134055.GA15551@ee.oulu.fi>
In-Reply-To: <20090115134055.GA15551@ee.oulu.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 15 Jan 2009 15:40:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Pietikainen a écrit :
> On Thu, Jan 15, 2009 at 03:27:43PM +0200, Mihai Donțu wrote:
>>>> A friend of mine just booted 2.6.28 and when someone else tried to send
>>>> something to him over ssh (scp), the transfer failed and the following
>>>> appeared in dmesg:
>>> You missed the all important order line before the stack trace.
>> Right, sorry for that. Here it is:
>> swapper: page allocation failure. order:0, mode:0x21
>>> If it's order 0, then you're just out of memory, if it's greater
>>> than order 0, then either you're using jumbo frames or b44 is
>>> broken.
>> It is order zero, but he's not out of memory. He has just booted 2.6.28 (no X, 
>> no thing), has 3GB of RAM and 2GB of swap.
> b44 uses GFP_DMA bounce buffers in some situations (x86_64 with > 1GB of
> memory would do the trick I think, as does x86 with 4:4 memory split),
> and that's a very limited resource (Memory < 16MB ). 
> 
> Lovely hardware feature requiring nasty workarounds
> (the chip can't do DMA for addresses > 1GB).
> 
> Maybe something else sucks up GFP_DMA memory with 2.6.28?

Normal tcp queues (in this case, since a single scp is enough
to trigger the bug)

If a rx buffer was allocated using GFP_DMA, then b44_rx()
should copy it to a new skb, (like done by copybreak algo),
regardless of frame size, to not consume DMA memory in protocol
queues.

Better be slow (because of extra copy) then risking exhausting DMA zone

easy way to test would be to redefine RX_COPY_THRESHOLD to 16000


