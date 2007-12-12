Return-Path: <linux-kernel-owner+w=401wt.eu-S1757629AbXLLPSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629AbXLLPSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbXLLPSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:18:36 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60561
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752042AbXLLPSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:18:35 -0500
Date: Wed, 12 Dec 2007 07:18:32 -0800 (PST)
Message-Id: <20071212.071832.07747779.davem@davemloft.net>
To: joonwpark81@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       baum@tehutinetworks.net, andy@greyhouse.net
Subject: Re: [PATCH 6/7] [NETDEV]: tehuti Fix possible causing oops of
 net_rx_action
From: David Miller <davem@davemloft.net>
In-Reply-To: <002901c83c73$b089b6e0$9c94fea9@jason>
References: <002901c83c73$b089b6e0$9c94fea9@jason>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Joonwoo Park" <joonwpark81@gmail.com>
Date: Wed, 12 Dec 2007 13:01:27 +0900

> @@ -305,6 +305,8 @@ static int bdx_poll(struct napi_struct *napi, int budget)
>  
>  		netif_rx_complete(dev, napi);
>  		bdx_enable_interrupts(priv);
> +		if (unlikely(work_done == napi->weight))
> +			return work_done - 1;
>  	}
>  	return work_done;
>  }

Any time your trying to make a caller "happy" by adjusting
a return value forcefully, it's a hack.

And I stated this in another reply about this issue.

Please do not fix the problem this way.

The correct way to fix this is, if we did process a full
"weight" or work, we should not netif_rx_complete() and
we should not re-enable chip interrupts.

Instead we should return the true "work_done" value and
allow the caller to thus poll us one more time.
