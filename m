Return-Path: <linux-kernel-owner+w=401wt.eu-S1755135AbYG2Bid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbYG2Bid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 21:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbYG2BiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 21:38:22 -0400
Received: from smtp.knology.net ([24.214.63.101]:45825 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbYG2BiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 21:38:21 -0400
Subject: Re: [PATCH] typhoon: use request_firmware
From: David Dillow <dave@thedillows.org>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, becker@scyld.com,
       davidpmclean@yahoo.com, Jeff Garzik <jeff@garzik.org>,
       netdev <netdev@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1217253260.17632.6.camel@jaswinder.satnam>
References: <1217170232.3537.6.camel@jaswinder.satnam>
	 <1217209400.22789.47.camel@obelisk.thedillows.org>
	 <1217215009.2970.7.camel@jaswinder.satnam>
	 <1217248585.22789.58.camel@obelisk.thedillows.org>
	 <1217253260.17632.6.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 21:38:18 -0400
Message-Id: <1217295498.28682.16.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-28 at 19:24 +0530, Jaswinder Singh wrote:
> Here is patch for typhoon.c :

It's getting better, as it's not obviously broken now.

> +MODULE_FIRMWARE("3com/typhoon.bin");

Minor nit, but perhaps #define the name, so you don't have to keep this
and the string in typhoon_init_firmware() in sync.

> @@ -307,6 +308,9 @@ struct typhoon {
>  	/* unused stuff (future use) */
>  	int			capabilities;
>  	struct transmit_ring 	txHiRing;
> +
> +	/* firmware */
> +	u8			*tp_fw_image;
>  };

Now you keep one copy per NIC, which doubles the memory usage. Just use
static struct firmware *typhoon_fw;

> +static int typhoon_init_firmware(struct typhoon *tp)
> +{
> +	const struct firmware *fw;
> +	const char fw_name[] = "3com/typhoon.bin";

If you use the #define and the global static, you can get rid of the
above. Just use the define in place of fw_name below:

> +	err = request_firmware(&fw, fw_name, &tp->pdev->dev);
> +	if (err) {
> +		printk(KERN_ERR "%s: Failed to load firmware \"%s\"\n",
> +		       tp->name, fw_name);
> +		return err;
> +	}
> +	tp->tp_fw_image = vmalloc(fw->size);
> +	if (!tp->tp_fw_image) {
> +		err = -ENOMEM;
> +		printk(KERN_ERR "%s: \"%s\" Failed %d\n",
> +		       tp->name, fw_name, err);
> +		goto out;
> +	}

Then you can get rid of the double allocation and memcpy. Just put the
call to release_firmware() in typhoon_cleanup().

> @@ -2102,6 +2132,10 @@ typhoon_open(struct net_device *dev)
>  	if(err < 0)
>  		goto out_sleep;
>  
> +	err = typhoon_init_firmware(tp);
> +	if (err)
> +		goto out_irq;
> +

This should move to either typhoon_init() or typhoon_init_one(). Putting
it in typhoon_init() means we waste memory when the module is loaded if
there is no typhoon NIC; putting it in typhoon_init_one() means it needs
protection from threaded probing, should that ever be put back in. Given
that most modern distros don't do probing by blinding loading modules,
typhoon_init() seems a safe bet.

> @@ -2155,6 +2189,9 @@ typhoon_close(struct net_device *dev)

> +	if (tp->tp_fw_image)
> +		vfree(tp->tp_fw_image);
> +

This goes away and is replaced by a release_firmware() in
typhoon_cleanup() if you do the above.

Dave

