Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbYGYSgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbYGYSgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 14:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbYGYSfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 14:35:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:2708 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbYGYSfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 14:35:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ce5BHyRO4JgqEuz4GUXdBIrUBiKF87HsL+/BGMM58+d1f797QQHmv36GbWKMDrctME
         G8NJz1KAnK9vrdDgkOBJC8HkqPVK4trKh4nlwAUnRktr4Sc9QeMwCotnLpiDwGyYkcSN
         Sqi2XBQR/bkBOlqHdHn4mlRojtn74+CVVr2W4=
Date: Fri, 25 Jul 2008 20:36:22 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Ingo Oeser <netdev@axxeo.de>
Cc: David Miller <davem@davemloft.net>, peterz@infradead.org,
       Larry.Finger@lwfinger.net, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, mingo@redhat.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
	__netif_schedule+0x2c/0x98()
Message-ID: <20080725183622.GA3107@ami.dom.local>
References: <1216806614.7257.152.camel@twins> <1216810696.7257.175.camel@twins> <20080723.131441.200166513.davem@davemloft.net> <200807251904.37302.netdev@axxeo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807251904.37302.netdev@axxeo.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 07:04:36PM +0200, Ingo Oeser wrote:
...
> I'm sure as hell, I miss sth. but can't it be done by this pseudo-code:

...And I really doubt it can't be done like this.

Jarek P.

> 
> netif_tx_lock(device)
> {
> 	mutex_lock(device->queue_entry_mutex);
> 	foreach_queue_entries(queue, device->queues)
> 	{
> 		spin_lock(queue->tx_lock);
> 		set_noop_tx_handler(queue);
> 		spin_unlock(queue->tx_lock);
> 	}
> 	mutex_unlock(device->queue_entry_mutex);
> }
> 
> netif_tx_unlock(device)
> {
> 	mutex_lock(device->queue_entry_mutex);
> 	foreach_queue_entries(queue, device->queues)
> 	{
> 		spin_lock(queue->tx_lock);
> 		set_useful_tx_handler(queue);
> 		spin_unlock(queue->tx_lock);
> 	}
> 	mutex_unlock(device->queue_entry_mutex);
> }
> 
> Then protect use of the queues by queue->tx_lock in transmit path.
> The first setup of the queue doesn't need to be protected, since no-one
> knows the device. The final cleanup of the device doesn't need to be
> protected either, because netif_tx_lock() and netif_tx_unlock() should
> not be called after entering the final cleanup.
> 
> Some VM locking works this way...
> 
> 
> Best Regards
> 
> Ingo Oeser
