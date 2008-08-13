Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbYHMKpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbYHMKpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 06:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYHMKos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 06:44:48 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:17875 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbYHMKor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 06:44:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tYnDuJpr4jF/cTCMyPbSV1Zr2Y+oeHEy9j4JqoAqTn0lOVKMpUmRpI8zCY78/Iy0PX
         UI0j0Fxecqs8F4EvkXnFo+DUBc62W2XYa1/gQzFIjGncgdXaYELIiDRyJs93WEYqg3H3
         GU/9sJ3xi0WqRpadlRC+mDXg1bJu0U0N88K9s=
Message-ID: <19f34abd0808130344h65e793eare83c0f41cb1cfb8a@mail.gmail.com>
Date: Wed, 13 Aug 2008 12:44:46 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [RFC][PATCH] netconsole: avoid deadlock on printk from driver code
Cc: adobriyan@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com
In-Reply-To: <20080813.032946.114949936.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080813095324.GA15055@ben.ifi.uio.no>
	 <20080813095942.GA9145@martell.zuzino.mipt.ru>
	 <20080813.032946.114949936.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 12:29 PM, David Miller <davem@davemloft.net> wrote:
> From: Alexey Dobriyan <adobriyan@gmail.com>
> Date: Wed, 13 Aug 2008 13:59:43 +0400
>> > The least invasive fix is to detect that we're trying to re-enter the
>> > driver code. We provide a netdev_busy() function which can be used to
>> > determine whether a deadlock can occur if we try to transmit another
>> > packet.
>> >
>> > Note that this may lead to lost messages if the driver is active on
>> > another CPU while we try to use the same device for netconsole.
>>
>> This sucks.
>
> It's also the wrong fix.
>
> As a quicker and more palatable solution, print your link status
> message in some kind of deferred context where you can have the
> lock not held or similar.

This is true, but it is very fragile. It fixes only one case (exactly
the case that I saw), while there may be many more of the same nature.

For your proposed fix to work in all cases, _all_ printks coming from
rtl8139_tx_interrupt() must be printed in a different context. That
includes, but is not necessarily limited to, these obvious cases:

        DPRINTK ("%s: Abnormal interrupt, status %8.8x.\n",
                 dev->name, status);

    printk(KERN_DEBUG "%s: Transmit error, Tx status %8.8x.\n",

                printk (KERN_ERR "%s: PCI Bus error %4.4x.\n",
                        dev->name, pci_cmd_status);

                printk (KERN_ERR "%s: Out-of-sync dirty pointer, %ld
vs. %ld.\n",

There must also be no BUG()s, WARN()s, other debugging facilities
(spinlock debugging, lockdep, irqtrace, etc.) triggering which may
call printk() inside the protected section. Can we really ensure this?
For all drivers supporting netconsole?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
