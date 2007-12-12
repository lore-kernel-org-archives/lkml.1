Return-Path: <linux-kernel-owner+w=401wt.eu-S1758123AbXLLFsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbXLLFsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 00:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757425AbXLLFsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 00:48:32 -0500
Received: from ro-out-1112.google.com ([72.14.202.183]:49237 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198AbXLLFsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 00:48:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pDz0tqwUiFsfXAVXSt8EVTxCaIZyyzyjqfG+pWztMZh/DzE2XSjO+GLnWQQU6ProqsOLP6H6QQttYqoL0z3NhEdpRpV4o4sc3IcmuLn+O+tIdBb46V/elCoft1HfJochUHHeMybMaWmrEm8WqanFHTWtY6Xx15ovCzPCHzJ+UIg=
Message-ID: <b25c3fa70712112148u59baea4dl67a6939df4292917@mail.gmail.com>
Date: Wed, 12 Dec 2007 14:48:27 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: [PATCH 6/7] [NETDEV]: tehuti Fix possible causing oops of net_rx_action
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       baum@tehutinetworks.net, andy@greyhouse.net
In-Reply-To: <20071211213939.122de1db@freepuppy.rosehill>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <002901c83c73$b089b6e0$9c94fea9@jason>
	 <20071211213939.122de1db@freepuppy.rosehill>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2007/12/12, Stephen Hemminger <shemminger@linux-foundation.org>:
> On Wed, 12 Dec 2007 13:01:27 +0900
> "Joonwoo Park" <joonwpark81@gmail.com> wrote:
>
> > [NETDEV]: tehuti Fix possible causing oops of net_rx_action
> >
> > Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
> > ---
> >  drivers/net/tehuti.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/net/tehuti.c b/drivers/net/tehuti.c
> > index 21230c9..955e749 100644
> > --- a/drivers/net/tehuti.c
> > +++ b/drivers/net/tehuti.c
> > @@ -305,6 +305,8 @@ static int bdx_poll(struct napi_struct *napi, int budget)
> >
> >               netif_rx_complete(dev, napi);
> >               bdx_enable_interrupts(priv);
> > +             if (unlikely(work_done == napi->weight))
> > +                     return work_done - 1;
> >       }
> >       return work_done;
> >  }
>
> A better fix would be not going over budget in the first place.
>
> --
> Stephen Hemminger <shemminger@linux-foundation.org>
>

Stephen,
This is code of bd_poll().
Do you mean remove napi_stop stuff?

static int bdx_poll(struct napi_struct *napi, int budget)
{
...
        work_done = bdx_rx_receive(priv, &priv->rxd_fifo0, budget);
        if ((work_done < budget) ||
            (priv->napi_stop++ >= 30)) {
                DBG("rx poll is done. backing to isr-driven\n");

                /* from time to time we exit to let NAPI layer release
                 * device lock and allow waiting tasks (eg rmmod) to advance) */
                priv->napi_stop = 0;

                netif_rx_complete(dev, napi);
                bdx_enable_interrupts(priv);
                if (unlikely(work_done == napi->weight))
                        return work_done - 1;
        }
        return work_done;
}

Thanks,
Joonwoo
