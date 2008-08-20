Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbYHTU6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbYHTU6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 16:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbYHTU6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 16:58:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41134
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751442AbYHTU6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 16:58:33 -0400
Date: Wed, 20 Aug 2008 13:58:32 -0700 (PDT)
Message-Id: <20080820.135832.93663823.davem@davemloft.net>
To: penberg@cs.helsinki.fi
Cc: vegard.nossum@gmail.com, vegardno@ifi.uio.no, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com, adobriyan@gmail.com
Subject: Re: [RFC][PATCH] netconsole: avoid deadlock on printk from driver
 code
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0808202051550.3501@melkki.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0808141643200.3164@sbz-30.cs.Helsinki.FI>
	<20080814.151502.251134900.davem@davemloft.net>
	<Pine.LNX.4.64.0808202051550.3501@melkki.cs.Helsinki.FI>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka J Enberg <penberg@cs.helsinki.fi>
Date: Wed, 20 Aug 2008 20:54:01 +0300 (EEST)

> @@ -1721,7 +1723,8 @@ static int rtl8139_start_xmit (struct sk
>  		return 0;
>  	}
>  
> -	spin_lock_irqsave(&tp->lock, flags);
> +	local_irq_save(flags);
> +	netif_tx_lock(dev);
>  	RTL_W32_F (TxStatus0 + (entry * sizeof (u32)),
>  		   tp->tx_flag | max(len, (unsigned int)ETH_ZLEN));

The generic networking takes the TX lock for you, you don't
need to take it explicitly here.

You also cannot depend upon IRQ disabled locking, the generic
TX lock is only softirq safe, not hard IRQ safe.

This means you have to move TX descriptor reclaim into a
soft IRQ context, such as NAPI ->poll().
