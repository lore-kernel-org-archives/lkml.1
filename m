Return-Path: <linux-kernel-owner+w=401wt.eu-S1760463AbYDPV5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760463AbYDPV5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 17:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbYDPV52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 17:57:28 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48860 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529AbYDPV51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 17:57:27 -0400
From: Hollis Blanchard <hollisb@us.ibm.com>
Organization: IBM Linux Technology Center
To: Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH] add virtio disk geometry feature
Date: Wed, 16 Apr 2008 16:57:24 -0500
User-Agent: KMail/1.9.9
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ryan Harper <ryanh@us.ibm.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm-devel@lists.sourceforge.net
References: <1208372197-20815-1-git-send-email-ryanh@us.ibm.com> <200804170715.55041.rusty@rustcorp.com.au> <4806706E.10701@us.ibm.com>
In-Reply-To: <4806706E.10701@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Message-Id: <200804161657.24454.hollisb@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m3GLlREB013889

On Wednesday 16 April 2008 16:32:30 Anthony Liguori wrote:> > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c> > --- a/drivers/block/virtio_blk.c> > +++ b/drivers/block/virtio_blk.c> > @@ -157,10 +157,25 @@ static int virtblk_ioctl(struct inode *i> >  /* We provide getgeo only to please some old bootloader/partitioning tools */> >  static int virtblk_getgeo(struct block_device *bd, struct hd_geometry *geo)> >  {> > -     /* some standard values, similar to sd */> > -     geo->heads = 1 << 6;> > -     geo->sectors = 1 << 5;> > -     geo->cylinders = get_capacity(bd->bd_disk) >> 11;> > +     struct virtio_blk *vblk = bd->bd_disk->private_data;> > +     struct virtio_blk_geometry vgeo;> > +     int err;> > +> > +     /* see if the host passed in geometry config */> > +     err = virtio_config_val(vblk->vdev, VIRTIO_BLK_F_GEOMETRY,> > +                             offsetof(struct virtio_blk_config, geometry),> > +                             &vgeo);> > +> > +     if (!err) {> > +             geo->heads = vgeo.heads;> > +             geo->sectors = vgeo.sectors;> > +             geo->cylinders = vgeo.cylinders;> > +     } else {> > +             /* some standard values, similar to sd */> > +             geo->heads = 1 << 6;> > +             geo->sectors = 1 << 5;> > +             geo->cylinders = get_capacity(bd->bd_disk) >> 11;> > +     }> >       return 0;> >  }> >   > > You're probably breaking PPC since the values in the config space are in > little endian format.  virtio_config_val does automagic endianness > conversion if the size is 2, 4, or 8.  In this case, the structure size > is 4 so the endianness conversion will do the wrong thing.
Good catch; byte-swapping an entire structure is a terrible terrible idea.
> Magic endianness conversion based on read size is looking pretty evil to > me... Perhaps we need explicit *_val[8,16,32,64]?
Implicit byteswapping based on access size is the standard way of implementing accessors.
In this case, reading each structure member individually will do the right implicit swapping, rather than trying to load the whole thing as a single access.
-- Hollis BlanchardIBM Linux Technology Center���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
