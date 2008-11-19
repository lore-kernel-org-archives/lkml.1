Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbYKSK4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbYKSK4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 05:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYKSK4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 05:56:11 -0500
Received: from www.tglx.de ([62.245.132.106]:56409 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbYKSK4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 05:56:10 -0500
Message-ID: <4923F08A.3020702@linutronix.de>
Date: Wed, 19 Nov 2008 11:55:06 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
CC: Bryan Wu <cooloney@kernel.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Robin Getz <rgetz@blackfin.uclinux.org>,
       "Frysinger, Michael" <Michael.Frysinger@analog.com>
Subject: Re: [PATCH] USB/ISP1760: Fix for unaligned exceptions
References: <1227000131-19145-1-git-send-email-cooloney@kernel.org> <49229E64.2010907@linutronix.de> <8A42379416420646B9BFAC9682273B6D06966B66@limkexm3.ad.analog.com> <20081119091853.GA26629@www.tglx.de> <8A42379416420646B9BFAC9682273B6D069B15C2@limkexm3.ad.analog.com>
In-Reply-To: <8A42379416420646B9BFAC9682273B6D069B15C2@limkexm3.ad.analog.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hennerich, Michael wrote:
> I know the issue is originated in either RTL8150 set_registers or
> get_registers. We get some unaligned address from the stack to the
> ISP1760 priv_read/wite_copy.
> 
> The RTL8150 driver does something like this:
> 
> 	u8 data[3], tmp;
> 
> 	data[0] = phy;
> 	data[1] = data[2] = 0;
> 	tmp = indx | PHY_READ | PHY_GO;
> 	i = 0;
> 
> 	set_registers(dev, PHYADD, sizeof(data), data);

ach. So that's wrong anyway. There are arches which can't DMA stack 
memory. So fixing this properly does not fix just your arch.

>>> I wonder if it's only us (NOMMU) seeing these odd aligned buffers?
>> Not sure. The only problem I have with this patch is that you might
>> cover bugs in drivers and you don't notice it anymore since you choose
>> "voluntary" the slow path.
> 
> Well here I disagree, but I agree with the fact that there are buggy
> drivers.
> 
> Since most processors running Linux do have unaligned access handling,
> this issue goes unnoticed for all of them. Believe me the penalty taken
> by any Processor doing this automatically and unnoticed is typically
> much higher than using get/put_unaligned.
Okay. A packed struct with a u8 followed by u16 which is required by the 
spec can't be fixed. unaligned helper is the only solution. I agree here. 
Allocating memory on the stack for a dma transfer is wrong.
On PowerPC and X86 get_unaligned() does not behave any different than a 
normal dereference. So I doubt that there is a performance improvement.

> I'm tiered fixing all unaligned issues in drivers. It's a hassle getting
> them merged, since most people don't care. Having a workaround in a
> single place, the hcd driver is much easier.

Having a fixup in the exception handler like sparc does is probably little 
slower than the fixup here. On the other hand you would not have to fix 
unaligned access anymore.

>>> -Michael

Sebastian
