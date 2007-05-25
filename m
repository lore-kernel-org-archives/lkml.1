Return-Path: <linux-kernel-owner+w=401wt.eu-S1763553AbXEYQ0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763553AbXEYQ0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 12:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761212AbXEYQ0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 12:26:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:64076 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbXEYQ0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 12:26:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [patch 5/7] ps3: Disk Storage Driver
Date: Fri, 25 May 2007 18:26:25 +0200
User-Agent: KMail/1.9.6
Cc: Geert.Uytterhoeven@sonycom.com, linux-kernel@vger.kernel.org
References: <20070525083607.784351000@sonycom.com> <20070525083632.575306000@sonycom.com>
In-Reply-To: <20070525083632.575306000@sonycom.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705251826.25572.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/SbcYuDTCRR2THKjQ6mLAeu+SW85xD+gVy8RX
 76gRbytVCMKk6Nhg1wGYuewQ2+Hp72TNQMQMCsQZunzqF52su2
 cHLnypO7uwK23I7F+/S3w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 May 2007, Geert.Uytterhoeven@sonycom.com wrote:
> +static void ps3disk_scatter_gather(struct ps3_storage_device *dev,
> +				   struct request *req, int gather)
> +{
> +	unsigned int sectors = 0, offset = 0;
> +	struct bio *bio;
> +	sector_t sector;
> +	struct bio_vec *bvec;
> +	unsigned int i = 0, j;
> +	size_t size;
> +	void *buf;
> +
> +	rq_for_each_bio(bio, req) {
> +		sector = bio->bi_sector;
> +		dev_dbg(&dev->sbd.core,
> +			"%s:%u: bio %u: %u segs %u sectors from %lu\n",
> +			__func__, __LINE__, i, bio_segments(bio),
> +			bio_sectors(bio), sector);
> +		bio_for_each_segment(bvec, bio, j) {
> +			size = bio_cur_sectors(bio)*KERNEL_SECTOR_SIZE;
> +			buf = __bio_kmap_atomic(bio, j, KM_USER0);
> +			if (gather)
> +				memcpy(dev->bounce_buf+offset, buf, size);
> +			else
> +				memcpy(buf, dev->bounce_buf+offset, size);
> +			offset += size;
> +			__bio_kunmap_atomic(bio, KM_USER0);
> +		}
> +		sectors += bio_sectors(bio);
> +		i++;
> +	}
> +}

So the hypervison uses guest-real addresses here? I would have expected
it to use the kernel page tables, which lets you use vmap() to do
scatter-gather.

> +static int ps3disk_thread(void *data)
> +{
> +	struct ps3_storage_device *dev = data;
> +	struct ps3disk_private *priv = ps3disk_priv(dev);
> +	request_queue_t *q = priv->queue;
> +	struct request *req;
> +
> +	dev_dbg(&dev->sbd.core, "%s thread init\n", __func__);
> +
> +	current->flags |= PF_NOFREEZE;
> +
> +	while (!kthread_should_stop()) {
> +		spin_lock_irq(&priv->lock);
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		req = elv_next_request(q);
> +		if (!req) {
> +			spin_unlock_irq(&priv->lock);
> +			schedule();
> +			continue;
> +		}
> +		if (!blk_fs_request(req)) {
> +			blk_dump_rq_flags(req, DEVICE_NAME " bad request");
> +			end_request(req, 0);
> +			spin_unlock_irq(&priv->lock);
> +			continue;
> +		}
> +		spin_unlock_irq(&priv->lock);
> +		ps3disk_handle_request_sg(dev, req);
> +	}
> +
> +	dev_dbg(&dev->sbd.core, "%s thread exit\n", __func__);
> +	return 0;
> +}

I don't really understand what the kthread is needed for. You probably
thought about multiple options and ended up with this, but having
a comment in front of it might be helpful.

	Arnd <><
