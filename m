Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbXGGNEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbXGGNEW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 09:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbXGGNEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 09:04:13 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48139 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753590AbXGGNEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 09:04:11 -0400
X-Sasl-enc: yOVmFC4BioJY5/H0YjgZj64tkKDdKG9AFhml/iQokXQF 1183813399
Message-ID: <468F901B.2000000@imap.cc>
Date: Sat, 07 Jul 2007 15:07:39 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Yoann Padioleau <padator@wanadoo.fr>
CC: kernel-janitors@lists.osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] some kmalloc/memset ->kzalloc (tree wide)
References: <878x9ta320.fsf@wanadoo.fr>
In-Reply-To: <878x9ta320.fsf@wanadoo.fr>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6EA288C1055F12242277B9A6"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6EA288C1055F12242277B9A6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 06.07.2007 18:51 schrieb Yoann Padioleau:
> @@
> expression E1,E2,E3;
> @@
>=20
> - kzalloc(E1 * E2,E3)
> + kcalloc(E1,E2,E3)

This misses the semantic distinction between the first and second
arguments of kcalloc(). The first argument is supposed to be the
number of elements to allocate and the second their size. As a
consequence, the following hunks in your pathc are wrong:

> diff --git a/arch/arm/mach-iop13xx/pci.c b/arch/arm/mach-iop13xx/pci.c
> index 9d63d7f..b84955f 100644
> --- a/arch/arm/mach-iop13xx/pci.c
> +++ b/arch/arm/mach-iop13xx/pci.c
> @@ -1002,11 +1002,10 @@ int iop13xx_pci_setup(int nr, struct pci
>  	if (nr > 1)
>  		return 0;
> =20
> -	res =3D kmalloc(sizeof(struct resource) * 2, GFP_KERNEL);
> +	res =3D kcalloc(sizeof(struct resource), 2, GFP_KERNEL);
>  	if (!res)
>  		panic("PCI: unable to alloc resources");
> =20
> -	memset(res, 0, sizeof(struct resource) * 2);
> =20
>  	/* 'nr' assumptions:
>  	 * ATUX is always 0

> diff --git a/drivers/char/drm/via_dmablit.c b/drivers/char/drm/via_dmab=
lit.c
> index 2881a06..f246109 100644
> --- a/drivers/char/drm/via_dmablit.c
> +++ b/drivers/char/drm/via_dmablit.c
> @@ -273,10 +273,9 @@ via_alloc_desc_pages(drm_via_sg_info_t *
>  	vsg->num_desc_pages =3D (vsg->num_desc + vsg->descriptors_per_page - =
1) /=20
>  		vsg->descriptors_per_page;
> =20
> -	if (NULL =3D=3D  (vsg->desc_pages =3D kmalloc(sizeof(void *) * vsg->n=
um_desc_pages, GFP_KERNEL)))=20
> +	if (NULL =3D=3D  (vsg->desc_pages =3D kcalloc(sizeof(void *), vsg->nu=
m_desc_pages, GFP_KERNEL)))=20
>  		return DRM_ERR(ENOMEM);
>  =09
> -	memset(vsg->desc_pages, 0, sizeof(void *) * vsg->num_desc_pages);
>  	vsg->state =3D dr_via_desc_pages_alloc;
>  	for (i=3D0; i<vsg->num_desc_pages; ++i) {
>  		if (NULL =3D=3D (vsg->desc_pages[i] =3D=20

> diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
> index 42ba1c0..d383455 100644
> --- a/drivers/net/forcedeth.c
> +++ b/drivers/net/forcedeth.c
> @@ -4995,12 +4995,10 @@ static int __devinit nv_probe(struct pci
>  			goto out_unmap;
>  		np->tx_ring.ex =3D &np->rx_ring.ex[np->rx_ring_size];
>  	}
> -	np->rx_skb =3D kmalloc(sizeof(struct nv_skb_map) * np->rx_ring_size, =
GFP_KERNEL);
> -	np->tx_skb =3D kmalloc(sizeof(struct nv_skb_map) * np->tx_ring_size, =
GFP_KERNEL);
> +	np->rx_skb =3D kcalloc(sizeof(struct nv_skb_map), np->rx_ring_size, G=
FP_KERNEL);
> +	np->tx_skb =3D kcalloc(sizeof(struct nv_skb_map), np->tx_ring_size, G=
FP_KERNEL);
>  	if (!np->rx_skb || !np->tx_skb)
>  		goto out_freering;
> -	memset(np->rx_skb, 0, sizeof(struct nv_skb_map) * np->rx_ring_size);
> -	memset(np->tx_skb, 0, sizeof(struct nv_skb_map) * np->tx_ring_size);
> =20
>  	dev->open =3D nv_open;
>  	dev->stop =3D nv_close;

> diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
> index 9ef49ce..89a06b3 100644
> --- a/drivers/net/wan/cosa.c
> +++ b/drivers/net/wan/cosa.c
> @@ -572,13 +572,11 @@ #endif
>  	sprintf(cosa->name, "cosa%d", cosa->num);
> =20
>  	/* Initialize the per-channel data */
> -	cosa->chan =3D kmalloc(sizeof(struct channel_data)*cosa->nchannels,
> -			     GFP_KERNEL);
> +	cosa->chan =3D kcalloc(sizeof(struct channel_data), cosa->nchannels, =
GFP_KERNEL);
>  	if (!cosa->chan) {
>  	        err =3D -ENOMEM;
>  		goto err_out3;
>  	}
> -	memset(cosa->chan, 0, sizeof(struct channel_data)*cosa->nchannels);
>  	for (i=3D0; i<cosa->nchannels; i++) {
>  		cosa->chan[i].cosa =3D cosa;
>  		cosa->chan[i].num =3D i;

> diff --git a/drivers/net/wan/cycx_main.c b/drivers/net/wan/cycx_main.c
> index 6e5f1c8..8b6f22c 100644
> --- a/drivers/net/wan/cycx_main.c
> +++ b/drivers/net/wan/cycx_main.c
> @@ -113,12 +113,10 @@ static int __init cycx_init(void)
>  	/* Verify number of cards and allocate adapter data space */
>  	cycx_ncards =3D min_t(int, cycx_ncards, CYCX_MAX_CARDS);
>  	cycx_ncards =3D max_t(int, cycx_ncards, 1);
> -	cycx_card_array =3D kmalloc(sizeof(struct cycx_device) * cycx_ncards,=

> -				  GFP_KERNEL);
> +	cycx_card_array =3D kcalloc(sizeof(struct cycx_device), cycx_ncards, =
GFP_KERNEL);
>  	if (!cycx_card_array)
>  		goto out;
> =20
> -	memset(cycx_card_array, 0, sizeof(struct cycx_device) * cycx_ncards);=

> =20
>  	/* Register adapters with WAN router */
>  	for (cnt =3D 0; cnt < cycx_ncards; ++cnt) {

> diff --git a/drivers/net/wan/x25_asy.c b/drivers/net/wan/x25_asy.c
> index 1c9edd9..5bceb2c 100644
> --- a/drivers/net/wan/x25_asy.c
> +++ b/drivers/net/wan/x25_asy.c
> @@ -786,14 +786,12 @@ static int __init init_x25_asy(void)
>  	printk(KERN_INFO "X.25 async: version 0.00 ALPHA "
>  			"(dynamic channels, max=3D%d).\n", x25_asy_maxdev );
> =20
> -	x25_asy_devs =3D kmalloc(sizeof(struct net_device *)*x25_asy_maxdev, =

> -			       GFP_KERNEL);
> +	x25_asy_devs =3D kcalloc(sizeof(struct net_device*), x25_asy_maxdev, =
GFP_KERNEL);
>  	if (!x25_asy_devs) {
>  		printk(KERN_WARNING "X25 async: Can't allocate x25_asy_ctrls[] "
>  				"array! Uaargh! (-> No X.25 available)\n");
>  		return -ENOMEM;
>  	}
> -	memset(x25_asy_devs, 0, sizeof(struct net_device *)*x25_asy_maxdev); =

> =20
>  	return tty_register_ldisc(N_X25, &x25_ldisc);
>  }

> diff --git a/drivers/sbus/char/vfc_dev.c b/drivers/sbus/char/vfc_dev.c
> index 6afc7e5..4b5918b 100644
> --- a/drivers/sbus/char/vfc_dev.c
> +++ b/drivers/sbus/char/vfc_dev.c
> @@ -656,12 +656,9 @@ static int vfc_probe(void)
>  	if (!cards)
>  		return -ENODEV;
> =20
> -	vfc_dev_lst =3D kmalloc(sizeof(struct vfc_dev *) *
> -						 (cards+1),
> -						 GFP_KERNEL);
> +	vfc_dev_lst =3D kcalloc(sizeof(struct vfc_dev*), (cards+1), GFP_KERNE=
L);
>  	if (vfc_dev_lst =3D=3D NULL)
>  		return -ENOMEM;
> -	memset(vfc_dev_lst, 0, sizeof(struct vfc_dev *) * (cards + 1));
>  	vfc_dev_lst[cards] =3D NULL;
> =20
>  	ret =3D register_chrdev(VFC_MAJOR, vfcstr, &vfc_fops);

> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index eb766c3..09b0e5c 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -1160,13 +1160,12 @@ static int twa_initialize_device_extensi
>  	}
> =20
>  	/* Allocate event info space */
> -	tw_dev->event_queue[0] =3D kmalloc(sizeof(TW_Event) * TW_Q_LENGTH, GF=
P_KERNEL);
> +	tw_dev->event_queue[0] =3D kcalloc(sizeof(TW_Event), TW_Q_LENGTH, GFP=
_KERNEL);
>  	if (!tw_dev->event_queue[0]) {
>  		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x18, "Event info memory allocati=
on failed");
>  		goto out;
>  	}
> =20
> -	memset(tw_dev->event_queue[0], 0, sizeof(TW_Event) * TW_Q_LENGTH);
> =20
>  	for (i =3D 0; i < TW_Q_LENGTH; i++) {
>  		tw_dev->event_queue[i] =3D (TW_Event *)((unsigned char *)tw_dev->eve=
nt_queue[0] + (i * sizeof(TW_Event)));

> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachb=
a.c
> index 8dcfe4e..81e27ed 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -312,11 +312,9 @@ int aac_get_containers(struct aac_dev *d
> =20
>  	if (maximum_num_containers < MAXIMUM_NUM_CONTAINERS)
>  		maximum_num_containers =3D MAXIMUM_NUM_CONTAINERS;
> -	fsa_dev_ptr =3D  kmalloc(sizeof(*fsa_dev_ptr) * maximum_num_container=
s,
> -			GFP_KERNEL);
> +	fsa_dev_ptr =3D  kcalloc(sizeof(*fsa_dev_ptr), maximum_num_containers=
, GFP_KERNEL);
>  	if (!fsa_dev_ptr)
>  		return -ENOMEM;
> -	memset(fsa_dev_ptr, 0, sizeof(*fsa_dev_ptr) * maximum_num_containers)=
;
> =20
>  	dev->fsa_dev =3D fsa_dev_ptr;
>  	dev->maximum_num_containers =3D maximum_num_containers;

> diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megar=
aid/megaraid_mbox.c
> index 04d0b69..8cfa5cd 100644
> --- a/drivers/scsi/megaraid/megaraid_mbox.c
> +++ b/drivers/scsi/megaraid/megaraid_mbox.c
> @@ -1050,8 +1048,7 @@ megaraid_alloc_cmd_packets(adapter_t *ad
>  	 * since the calling routine does not yet know the number of availabl=
e
>  	 * commands.
>  	 */
> -	adapter->kscb_list =3D kmalloc(sizeof(scb_t) * MBOX_MAX_SCSI_CMDS,
> -			GFP_KERNEL);
> +	adapter->kscb_list =3D kcalloc(sizeof(scb_t), MBOX_MAX_SCSI_CMDS, GFP=
_KERNEL);
> =20
>  	if (adapter->kscb_list =3D=3D NULL) {
>  		con_log(CL_ANN, (KERN_WARNING
> @@ -1059,7 +1056,6 @@ megaraid_alloc_cmd_packets(adapter_t *ad
>  			__LINE__));
>  		goto out_free_ibuf;
>  	}
> -	memset(adapter->kscb_list, 0, sizeof(scb_t) * MBOX_MAX_SCSI_CMDS);
> =20
>  	// memory allocation for our command packets
>  	if (megaraid_mbox_setup_dma_pools(adapter) !=3D 0) {
> @@ -3572,8 +3568,7 @@ megaraid_cmm_register(adapter_t *adapter
>  	int		i;
> =20
>  	// Allocate memory for the base list of scb for management module.
> -	adapter->uscb_list =3D kmalloc(sizeof(scb_t) * MBOX_MAX_USER_CMDS,
> -			GFP_KERNEL);
> +	adapter->uscb_list =3D kcalloc(sizeof(scb_t), MBOX_MAX_USER_CMDS, GFP=
_KERNEL);
> =20
>  	if (adapter->uscb_list =3D=3D NULL) {
>  		con_log(CL_ANN, (KERN_WARNING
> @@ -3581,7 +3576,6 @@ megaraid_cmm_register(adapter_t *adapter
>  			__LINE__));
>  		return -1;
>  	}
> -	memset(adapter->uscb_list, 0, sizeof(scb_t) * MBOX_MAX_USER_CMDS);
> =20
> =20
>  	// Initialize the synchronization parameters for resources for

> diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megara=
id/megaraid_sas.c
> index e2cf12e..d2bec2b 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.c
> +++ b/drivers/scsi/megaraid/megaraid_sas.c
> @@ -1714,15 +1714,13 @@ static int megasas_alloc_cmds(struct meg
>  	 * Allocate the dynamic array first and then allocate individual
>  	 * commands.
>  	 */
> -	instance->cmd_list =3D kmalloc(sizeof(struct megasas_cmd *) * max_cmd=
,
> -				     GFP_KERNEL);
> +	instance->cmd_list =3D kcalloc(sizeof(struct megasas_cmd*), max_cmd, =
GFP_KERNEL);
> =20
>  	if (!instance->cmd_list) {
>  		printk(KERN_DEBUG "megasas: out of memory\n");
>  		return -ENOMEM;
>  	}
> =20
> -	memset(instance->cmd_list, 0, sizeof(struct megasas_cmd *) * max_cmd)=
;
> =20
>  	for (i =3D 0; i < max_cmd; i++) {
>  		instance->cmd_list[i] =3D kmalloc(sizeof(struct megasas_cmd),

> diff --git a/drivers/video/au1200fb.c b/drivers/video/au1200fb.c
> index dbf4ec3..311e323 100644
> --- a/drivers/video/au1200fb.c
> +++ b/drivers/video/au1200fb.c
> @@ -1589,11 +1589,10 @@ static int au1200fb_init_fbinfo(struct a
>  		return -EFAULT;
>  	}
> =20
> -	fbi->pseudo_palette =3D kmalloc(sizeof(u32) * 16, GFP_KERNEL);
> +	fbi->pseudo_palette =3D kcalloc(sizeof(u32), 16, GFP_KERNEL);
>  	if (!fbi->pseudo_palette) {
>  		return -ENOMEM;
>  	}
> -	memset(fbi->pseudo_palette, 0, sizeof(u32) * 16);
> =20
>  	if (fb_alloc_cmap(&fbi->cmap, AU1200_LCD_NBR_PALETTE_ENTRIES, 0) < 0)=
 {
>  		print_err("Fail to allocate colormap (%d entries)",

> diff --git a/drivers/video/savage/savagefb_driver.c b/drivers/video/sav=
age/savagefb_driver.c
> index 3d7507a..b855f4a 100644
> --- a/drivers/video/savage/savagefb_driver.c
> +++ b/drivers/video/savage/savagefb_driver.c
> @@ -2174,11 +2174,10 @@ static int __devinit savage_init_fb_info
> =20
>  #if defined(CONFIG_FB_SAVAGE_ACCEL)
>  	/* FIFO size + padding for commands */
> -	info->pixmap.addr =3D kmalloc(8*1024, GFP_KERNEL);
> +	info->pixmap.addr =3D kcalloc(8, 1024, GFP_KERNEL);
> =20
>  	err =3D -ENOMEM;
>  	if (info->pixmap.addr) {
> -		memset(info->pixmap.addr, 0, 8*1024);
>  		info->pixmap.size =3D 8*1024;
>  		info->pixmap.scan_align =3D 4;
>  		info->pixmap.buf_align =3D 4;

HTH

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Please excuse my bad English/German/French/Greek/Cantonese/Klingon/...


--------------enig6EA288C1055F12242277B9A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGj5AjMdB4Whm86/kRAnUrAJ9u71fWLI12MacI9CVhsCsx6HNasACfQmft
RNcpSOAFb6b62qkyZX+boGg=
=v8Nu
-----END PGP SIGNATURE-----

--------------enig6EA288C1055F12242277B9A6--
