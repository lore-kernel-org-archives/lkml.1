Return-Path: <linux-kernel-owner+w=401wt.eu-S1754364AbYIVV4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbYIVV4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 17:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbYIVV42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 17:56:28 -0400
Received: from isilmar.linta.de ([213.133.102.198]:45887 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753056AbYIVV41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 17:56:27 -0400
Date: Mon, 22 Sep 2008 23:56:17 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH] pcmcia: Fix broken abuse of dev->driver_data
Message-ID: <20080922215617.GA13057@comet.dominikbrodowski.net>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>, torvalds@osdl.org,
	linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
References: <20080922155814.2bdad40f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922155814.2bdad40f@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

(CC: linux-pcmcia added)

Many thanks for finding this bug.

On Mon, Sep 22, 2008 at 03:58:14PM +0100, Alan Cox wrote:
> PCMCIA abuses dev->private_data in the probe methods. Unfortunately it
> continues to abuse it after calling drv->probe() which leads to crashes and
> other nasties (such as bogus probes of multifunction devices) giving errors like

Well, PCMCIA drivers have (struct pcmcia_device *) p_dev->priv available and
use this regularly, so using dev->private_data never has been supported.
Nonetheless, let's add support for using dev->private_data also for PCMCIA
devices and remove p_dev->priv eventually.

> As its close to the final release just move the hack so it works out,
> hopefully someone will be sufficiently embarrassed to produce a nice rework
> for 2.6.28.

Could you remove this from the changelog entry, please?


> @@ -426,6 +426,18 @@ static int pcmcia_device_probe(struct device * dev)
>  	p_dev = to_pcmcia_dev(dev);
>  	p_drv = to_pcmcia_drv(dev->driver);
>  	s = p_dev->socket;
> +	

trailing whitespace

> +	/* The PCMCIA code passes the match data in via dev->driver_data
> +	 * which is an ugly hack. Once the driver probe is called it may
> +	 * and often will overwrite the match data so we must save it first 

trailing whitespace

>  	if (did && (did->match_flags & PCMCIA_DEV_ID_MATCH_DEVICE_NO) &&
>  	    (p_dev->socket->device_count == 1) && (p_dev->device_no ==
> 0)) pcmcia_add_device_later(p_dev->socket, 0);

uh?

>  
> - put_module:
> +put_module:
>  	if (ret)
>  		module_put(p_drv->owner);
> - put_dev:
> +put_dev:

unrelated -- please do not change it this time.

Best and thanks again,

	Dominik
