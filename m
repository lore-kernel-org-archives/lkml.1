Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbXGHTps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbXGHTps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 15:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbXGHTpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 15:45:40 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:13069 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbXGHTpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 15:45:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=GiuurqREgIgD/U0NfHtsAjVwsWKrxmE2krd4Oi0jIAu21LD4PYrxNH46gi9yuctTcp7srAAZezne+CnIgGjyRz3Np19UtXmk2yfhmjISUYW/Z+ABjkZ156SLyXHFscphcqm6PQoTi5Q6AM4JS8qPOEW0JAX+MPrzF8c0Lq03aHw=
Date: Sun, 8 Jul 2007 21:45:35 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Yoann Padioleau <padator@wanadoo.fr>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] some kmalloc/memset ->kzalloc (tree wide)
Message-ID: <20070708194535.GA14745@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878x9ta320.fsf@wanadoo.fr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yoann Padioleau <padator@wanadoo.fr> ha scritto:
> 
> Transform some calls to kmalloc/memset to a single kzalloc (or kcalloc).
[...]
> diff --git a/arch/alpha/kernel/module.c b/arch/alpha/kernel/module.c
> index bd03dc9..026ba9a 100644
> --- a/arch/alpha/kernel/module.c
> +++ b/arch/alpha/kernel/module.c
> @@ -119,8 +119,7 @@ module_frob_arch_sections(Elf64_Ehdr *hd
> 	}
> 
> 	nsyms = symtab->sh_size / sizeof(Elf64_Sym);
> -	chains = kmalloc(nsyms * sizeof(struct got_entry), GFP_KERNEL);
> -	memset(chains, 0, nsyms * sizeof(struct got_entry));
> +	chains = kcalloc(nsyms, sizeof(struct got_entry), GFP_KERNEL);
> 
> 	got->sh_size = 0;
> 	got->sh_addralign = 8;

Unrelated to the conversion, but here Alpha module loader is
dereferencing 'chains' without checking the outcome of the kmalloc().

> diff --git a/drivers/char/rio/riotable.c b/drivers/char/rio/riotable.c
> index 7e98835..991119c 100644
> --- a/drivers/char/rio/riotable.c
> +++ b/drivers/char/rio/riotable.c
> @@ -863,8 +863,7 @@ int RIOReMapPorts(struct rio_info *p, st
> 		if (PortP->TxRingBuffer)
> 			memset(PortP->TxRingBuffer, 0, p->RIOBufferSize);
> 		else if (p->RIOBufferSize) {
> -			PortP->TxRingBuffer = kmalloc(p->RIOBufferSize, GFP_KERNEL);
> -			memset(PortP->TxRingBuffer, 0, p->RIOBufferSize);
> +			PortP->TxRingBuffer = kzalloc(p->RIOBufferSize, GFP_KERNEL);
> 		}
> 		PortP->TxBufferOut = 0;
> 		PortP->TxBufferIn = 0;

Same here.

> diff --git a/drivers/char/synclinkmp.c b/drivers/char/synclinkmp.c
> index ef93d05..e2847bd 100644
> --- a/drivers/char/synclinkmp.c
> +++ b/drivers/char/synclinkmp.c
> @@ -3794,14 +3794,13 @@ static SLMP_INFO *alloc_dev(int adapter_
> {
> 	SLMP_INFO *info;
> 
> -	info = kmalloc(sizeof(SLMP_INFO),
> +	info = kzalloc(sizeof(SLMP_INFO),
> 		 GFP_KERNEL);

Funny indentation :)

> diff --git a/drivers/macintosh/smu.c b/drivers/macintosh/smu.c
> index f8e1a13..d409f67 100644
> --- a/drivers/macintosh/smu.c
> +++ b/drivers/macintosh/smu.c
> @@ -1053,10 +1053,9 @@ static int smu_open(struct inode *inode,
> 	struct smu_private *pp;
> 	unsigned long flags;
> 
> -	pp = kmalloc(sizeof(struct smu_private), GFP_KERNEL);
> +	pp = kzalloc(sizeof(struct smu_private), GFP_KERNEL);
> 	if (pp == 0)
> 		return -ENOMEM;

s/0/NULL/

> -	memset(pp, 0, sizeof(struct smu_private));
> 	spin_lock_init(&pp->lock);
> 	pp->mode = smu_file_commands;
> 	init_waitqueue_head(&pp->wait);

> diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
> index 3d0354e..5452da1 100644
> --- a/drivers/macintosh/therm_windtunnel.c
> +++ b/drivers/macintosh/therm_windtunnel.c
> @@ -431,9 +431,8 @@ do_probe( struct i2c_adapter *adapter, i
> 				     | I2C_FUNC_SMBUS_WRITE_BYTE) )
> 		return 0;
> 
> -	if( !(cl=kmalloc(sizeof(*cl), GFP_KERNEL)) )
> +	if( !(cl=kzalloc(sizeof(*cl), GFP_KERNEL)) )
> 		return -ENOMEM;
> -	memset( cl, 0, sizeof(struct i2c_client) );

This - following the common style - should be:

cl = kzalloc(sizeof(*cl), GFP_KERNEL);
if (!cl)
        return -ENOMEM;

> diff --git a/drivers/media/dvb/cinergyT2/cinergyT2.c b/drivers/media/dvb/cinergyT2/cinergyT2.c
> index b40af48..cff3468 100644
> --- a/drivers/media/dvb/cinergyT2/cinergyT2.c
> +++ b/drivers/media/dvb/cinergyT2/cinergyT2.c
> @@ -905,12 +905,11 @@ static int cinergyt2_probe (struct usb_i
> 	struct cinergyt2 *cinergyt2;
> 	int err;
> 
> -	if (!(cinergyt2 = kmalloc (sizeof(struct cinergyt2), GFP_KERNEL))) {
> +	if (!(cinergyt2 = kzalloc (sizeof(struct cinergyt2), GFP_KERNEL))) {
> 		dprintk(1, "out of memory?!?\n");
> 		return -ENOMEM;
> 	}

Ditto.

> diff --git a/drivers/media/video/planb.c b/drivers/media/video/planb.c
> index 1455a8f..4ab1af7 100644
> --- a/drivers/media/video/planb.c
> +++ b/drivers/media/video/planb.c
> @@ -353,9 +353,8 @@ static int planb_prepare_open(struct pla
> 		* PLANB_DUMMY)*sizeof(struct dbdma_cmd)
> 		+(PLANB_MAXLINES*((PLANB_MAXPIXELS+7)& ~7))/8
> 		+MAX_GBUFFERS*sizeof(unsigned int);
> -	if ((pb->priv_space = kmalloc (size, GFP_KERNEL)) == 0)
> +	if ((pb->priv_space = kzalloc (size, GFP_KERNEL)) == 0)
> 		return -ENOMEM;

Ditto.

> -	memset ((void *) pb->priv_space, 0, size);
> 	pb->overlay_last1 = pb->ch1_cmd = (volatile struct dbdma_cmd *)
> 						DBDMA_ALIGN (pb->priv_space);
> 	pb->overlay_last2 = pb->ch2_cmd = pb->ch1_cmd + pb->tab_size;
> diff --git a/drivers/media/video/usbvideo/vicam.c b/drivers/media/video/usbvideo/vicam.c
> index 982b115..40ee5e5 100644
> --- a/drivers/media/video/usbvideo/vicam.c
> +++ b/drivers/media/video/usbvideo/vicam.c
> @@ -1305,13 +1305,12 @@ vicam_probe( struct usb_interface *intf,
> 	}
> 
> 	if ((cam =
> -	     kmalloc(sizeof (struct vicam_camera), GFP_KERNEL)) == NULL) {
> +	     kzalloc(sizeof (struct vicam_camera), GFP_KERNEL)) == NULL) {

Ditto, plus this one is ugly :)

> diff --git a/drivers/media/video/zr364xx.c b/drivers/media/video/zr364xx.c
> index b5d3364..ae50a22 100644
> --- a/drivers/media/video/zr364xx.c
> +++ b/drivers/media/video/zr364xx.c
> @@ -800,11 +800,10 @@ static int zr364xx_probe(struct usb_inte
> 	     udev->descriptor.idProduct);
> 
> 	if ((cam =
> -	     kmalloc(sizeof(struct zr364xx_camera), GFP_KERNEL)) == NULL) {
> +	     kzalloc(sizeof(struct zr364xx_camera), GFP_KERNEL)) == NULL) {

Ditto.

> diff --git a/drivers/net/bsd_comp.c b/drivers/net/bsd_comp.c
> index 7845eaf..202d4a4 100644
> --- a/drivers/net/bsd_comp.c
> +++ b/drivers/net/bsd_comp.c
> @@ -395,14 +395,13 @@ static void *bsd_alloc (unsigned char *o
>  * Allocate the main control structure for this instance.
>  */
>     maxmaxcode = MAXCODE(bits);
> -    db         = kmalloc(sizeof (struct bsd_db),
> +    db         = kzalloc(sizeof (struct bsd_db),
> 					    GFP_KERNEL);

Identation?

> diff --git a/drivers/net/pcmcia/ibmtr_cs.c b/drivers/net/pcmcia/ibmtr_cs.c
> index 4ecb8ca..64d5dcd 100644
> --- a/drivers/net/pcmcia/ibmtr_cs.c
> +++ b/drivers/net/pcmcia/ibmtr_cs.c
> @@ -146,9 +146,8 @@ static int __devinit ibmtr_attach(struct
>     DEBUG(0, "ibmtr_attach()\n");
> 
>     /* Create new token-ring device */
> -    info = kmalloc(sizeof(*info), GFP_KERNEL); 
> +    info = kzalloc(sizeof(*info), GFP_KERNEL); 
>     if (!info) return -ENOMEM;

Fix the return statement while you are at it.

> diff --git a/drivers/net/ppp_async.c b/drivers/net/ppp_async.c
> index caabbc4..27f5b90 100644
> --- a/drivers/net/ppp_async.c
> +++ b/drivers/net/ppp_async.c
> @@ -159,12 +159,11 @@ ppp_asynctty_open(struct tty_struct *tty
> 	int err;
> 
> 	err = -ENOMEM;
> -	ap = kmalloc(sizeof(*ap), GFP_KERNEL);
> +	ap = kzalloc(sizeof(*ap), GFP_KERNEL);
> 	if (ap == 0)
> 		goto out;

NULL, not 0.

> diff --git a/drivers/net/ppp_deflate.c b/drivers/net/ppp_deflate.c
> index 72c8d66..eb98b66 100644
> --- a/drivers/net/ppp_deflate.c
> +++ b/drivers/net/ppp_deflate.c
> @@ -121,12 +121,11 @@ static void *z_comp_alloc(unsigned char 
> 	if (w_size < DEFLATE_MIN_SIZE || w_size > DEFLATE_MAX_SIZE)
> 		return NULL;
> 
> -	state = kmalloc(sizeof(*state),
> +	state = kzalloc(sizeof(*state),
> 						     GFP_KERNEL);

Style

> diff --git a/drivers/net/ppp_synctty.c b/drivers/net/ppp_synctty.c
> index 5918fab..ce64032 100644
> --- a/drivers/net/ppp_synctty.c
> +++ b/drivers/net/ppp_synctty.c
> @@ -207,13 +207,12 @@ ppp_sync_open(struct tty_struct *tty)
> 	struct syncppp *ap;
> 	int err;
> 
> -	ap = kmalloc(sizeof(*ap), GFP_KERNEL);
> +	ap = kzalloc(sizeof(*ap), GFP_KERNEL);
> 	err = -ENOMEM;
> 	if (ap == 0)
> 		goto out;

NULL

> diff --git a/drivers/nubus/nubus.c b/drivers/nubus/nubus.c
> index 3a0a3a7..e503c9c 100644
> --- a/drivers/nubus/nubus.c
> +++ b/drivers/nubus/nubus.c
> @@ -466,9 +466,8 @@ static struct nubus_dev* __init
> 		       parent->base, dir.base);
> 
> 	/* Actually we should probably panic if this fails */
> -	if ((dev = kmalloc(sizeof(*dev), GFP_ATOMIC)) == NULL)
> +	if ((dev = kzalloc(sizeof(*dev), GFP_ATOMIC)) == NULL)
> 		return NULL;	
> -	memset(dev, 0, sizeof(*dev));

Split maybe?

> 	dev->resid = parent->type;
> 	dev->directory = dir.base;
> 	dev->board = board;
> @@ -800,9 +799,8 @@ static struct nubus_board* __init nubus_
> 	nubus_rewind(&rp, FORMAT_BLOCK_SIZE, bytelanes);
> 
> 	/* Actually we should probably panic if this fails */
> -	if ((board = kmalloc(sizeof(*board), GFP_ATOMIC)) == NULL)
> +	if ((board = kzalloc(sizeof(*board), GFP_ATOMIC)) == NULL)
> 		return NULL;	
> -	memset(board, 0, sizeof(*board));

Same here.

> diff --git a/drivers/pci/pcie/aer/aerdrv.c b/drivers/pci/pcie/aer/aerdrv.c
> index db6ad8e..c344ebf 100644
> --- a/drivers/pci/pcie/aer/aerdrv.c
> +++ b/drivers/pci/pcie/aer/aerdrv.c
> @@ -148,11 +148,10 @@ static struct aer_rpc* aer_alloc_rpc(str
> {
> 	struct aer_rpc *rpc;
> 
> -	if (!(rpc = kmalloc(sizeof(struct aer_rpc),
> +	if (!(rpc = kzalloc(sizeof(struct aer_rpc),
> 		GFP_KERNEL)))
> 		return NULL;

Ditto, plus the indentation looks strange.

> diff --git a/drivers/s390/char/tape_34xx.c b/drivers/s390/char/tape_34xx.c
> index e765875..80e7a53 100644
> --- a/drivers/s390/char/tape_34xx.c
> +++ b/drivers/s390/char/tape_34xx.c
> @@ -131,10 +131,9 @@ tape_34xx_schedule_work(struct tape_devi
> {
> 	struct tape_34xx_work *p;
> 
> -	if ((p = kmalloc(sizeof(*p), GFP_ATOMIC)) == NULL)
> +	if ((p = kzalloc(sizeof(*p), GFP_ATOMIC)) == NULL)
> 		return -ENOMEM;

Two lines.

> --- a/drivers/s390/net/claw.c
> +++ b/drivers/s390/net/claw.c
> @@ -317,8 +317,8 @@ #endif
> 		CLAW_DBF_TEXT_(2,setup,"probex%d",-ENOMEM);
> 		return -ENOMEM;
> 	}
> -	privptr->p_mtc_envelope= kmalloc( MAX_ENVELOPE_SIZE, GFP_KERNEL);
> -	privptr->p_env = kmalloc(sizeof(struct claw_env), GFP_KERNEL);
> +	privptr->p_mtc_envelope= kzalloc( MAX_ENVELOPE_SIZE, GFP_KERNEL);
> +	privptr->p_env = kzalloc(sizeof(struct claw_env), GFP_KERNEL);
>         if ((privptr->p_mtc_envelope==NULL) || (privptr->p_env==NULL)) {
>                 probe_error(cgdev);
> 		put_device(&cgdev->dev);

On the error path this driver may leak the memory allocated by the first
kmalloc (in case only the second fails).

> diff --git a/drivers/scsi/pcmcia/aha152x_stub.c b/drivers/scsi/pcmcia/aha152x_stub.c
> index 370802d..2dd0dc9 100644
> --- a/drivers/scsi/pcmcia/aha152x_stub.c
> +++ b/drivers/scsi/pcmcia/aha152x_stub.c
> @@ -106,9 +106,8 @@ static int aha152x_probe(struct pcmcia_d
>     DEBUG(0, "aha152x_attach()\n");
> 
>     /* Create new SCSI device */
> -    info = kmalloc(sizeof(*info), GFP_KERNEL);
> +    info = kzalloc(sizeof(*info), GFP_KERNEL);
>     if (!info) return -ENOMEM;

Style

> -    memset(info, 0, sizeof(*info));
>     info->p_dev = link;
>     link->priv = info;
> 
> diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
> index c6f8c6e..445cfbb 100644
> --- a/drivers/scsi/pcmcia/nsp_cs.c
> +++ b/drivers/scsi/pcmcia/nsp_cs.c
> @@ -1602,9 +1602,8 @@ static int nsp_cs_probe(struct pcmcia_de
> 	nsp_dbg(NSP_DEBUG_INIT, "in");
> 
> 	/* Create new SCSI device */
> -	info = kmalloc(sizeof(*info), GFP_KERNEL);
> +	info = kzalloc(sizeof(*info), GFP_KERNEL);
> 	if (info == NULL) { return -ENOMEM; }

Style


Luca
-- 
Il coraggio non mi manca.
E` la paura che mi frega...
