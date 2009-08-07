Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbZHGGzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbZHGGzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 02:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756686AbZHGGzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 02:55:23 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:51198 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756672AbZHGGzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 02:55:20 -0400
Date: Fri, 7 Aug 2009 08:51:08 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: "Daniel K." <dk@uw.no>
Cc: benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] arch/powerpc: Add kmalloc NULL tests
In-Reply-To: <4A7BCAF1.5070605@uw.no>
Message-ID: <Pine.LNX.4.64.0908070850380.20445@pc-004.diku.dk>
References: <Pine.LNX.4.64.0908062203380.19100@ask.diku.dk> <4A7BCAF1.5070605@uw.no>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Aug 2009, Daniel K. wrote:

> Julia Lawall wrote:
> > --- a/arch/powerpc/sysdev/fsl_rio.c
> > +++ b/arch/powerpc/sysdev/fsl_rio.c
> > @@ -1057,6 +1057,10 @@ int fsl_rio_setup(struct of_device *dev)
> >     law_start, law_size);
> >  
> > 	ops = kmalloc(sizeof(struct rio_ops), GFP_KERNEL);
> > +	if (!ops) {
> > +		rc = -ENOMEM;
> > +		goto err_ops;
> > +	}
> >   ops->lcread = fsl_local_config_read;
> >   ops->lcwrite = fsl_local_config_write;
> >   ops->cread = fsl_rio_config_read;
> > @@ -1064,6 +1068,10 @@ int fsl_rio_setup(struct of_device *dev)
> >   ops->dsend = fsl_rio_doorbell_send;
> >  
> > 	port = kzalloc(sizeof(struct rio_mport), GFP_KERNEL);
> > +	if (!port) {
> > +		rc = -ENOMEM;
> > +		goto err_port;
> > +	}
> >   port->id = 0;
> >   port->index = 0;
> >  
> > @@ -1071,7 +1079,7 @@ int fsl_rio_setup(struct of_device *dev)
> >   if (!priv) {
> >    printk(KERN_ERR "Can't alloc memory for 'priv'\n");
> >    rc = -ENOMEM;
> > -		goto err;
> > +		goto err_priv;
> >   }
> >  
> >   INIT_LIST_HEAD(&port->dbells);
> > @@ -1169,13 +1177,15 @@ int fsl_rio_setup(struct of_device *dev)
> >  
> >  	return 0;
> > err:
> > -	if (priv)
> > -		iounmap(priv->regs_win);
> > -	kfree(ops);
> > +	iounmap(priv->regs_win);
> > +err_priv:
> > 	kfree(priv);
> > +err_port:
> > 	kfree(port);
> > +err_ops:
> > +	kfree(ops);
> >   return rc;
> 
> There seems to be a goto-off-by-one error here.
> 
> If xxxx = kxalloc() fails, you goto err_xxxx, and do a kfree(xxxx) where xxxx
> is
> already proven to be NULL.
> 
> Is there a reason for this that eludes me?

No, I messed up...  I will fix it.

julia


> I'd expect that last hunk to look something like
> 
> @@ -1169,13 +1177,15 @@ int fsl_rio_setup(struct of_device *dev)
> 
> 	return 0;
> err:
> -	if (priv)
> -		iounmap(priv->regs_win);
> -	kfree(ops);
> +	iounmap(priv->regs_win);
> 	kfree(priv);
> +err_priv:
> 	kfree(port);
> +err_port:
> +	kfree(ops);
> +err_ops:
> 	return rc;
> }
> 
> 
> Daniel K.
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
