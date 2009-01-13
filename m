Return-Path: <linux-kernel-owner+w=401wt.eu-S1755082AbZAMALO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbZAMALO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 19:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZAMAKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 19:10:54 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50508
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751735AbZAMAKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 19:10:53 -0500
Date: Mon, 12 Jan 2009 16:10:54 -0800 (PST)
Message-Id: <20090112.161054.180487472.davem@davemloft.net>
To: mike@marineau.org
Cc: oliver@hartkopp.net, jaswinder@infradead.org, jgarzik@redhat.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, mchan@broadcom.com
Subject: Re: [PATCH -net-next 3/4] firmware: convert tg3 driver to
 request_firmware()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090107230624.GA6894@porter.dyn.128.marineau.org>
References: <20090105.160112.119906029.davem@davemloft.net>
	<20090107031724.GA6118@porter.dyn.128.marineau.org>
	<20090107230624.GA6894@porter.dyn.128.marineau.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Marineau <mike@marineau.org>
Date: Wed, 7 Jan 2009 18:06:25 -0500

> -static void rfc2863_policy(struct net_device *dev)
> -{
> -	unsigned char operstate = default_operstate(dev);
> -
> -	if (operstate == dev->operstate)
> -		return;
> -
> -	write_lock_bh(&dev_base_lock);
> -
> -	switch(dev->link_mode) {
> -	case IF_LINK_MODE_DORMANT:
> -		if (operstate == IF_OPER_UP)
> -			operstate = IF_OPER_DORMANT;
> -		break;
> -
> -	case IF_LINK_MODE_DEFAULT:
> -	default:
> -		break;
> -	}
> -
> -	dev->operstate = operstate;
> -
> -	write_unlock_bh(&dev_base_lock);
> +	if (dev->link_mode == IF_LINK_MODE_DORMANT && netif_oper_up(dev))
> +		netif_userspace_dormant_on(dev);
> +	else
> +		netif_userspace_dormant_off(dev);
>  }

Michael, this doesn't work.

The whole point of taking the dev_base_lock is to freeze the state of
->link_mode, so that we can make a decision atomically based upon it's
value and without that value changing in the middle of the decision.


