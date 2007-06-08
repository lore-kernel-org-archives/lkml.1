Return-Path: <linux-kernel-owner+w=401wt.eu-S939338AbXFHTXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939338AbXFHTXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbXFHTXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:23:09 -0400
Received: from mail-gw3.adaptec.com ([216.52.22.36]:52863 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbXFHTXH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:23:07 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [stable] [patch 37/54] SCSI: aacraid: Correctsaplatformsupport. (Was: [Bug 8469] Bad EIP value onpentium3SMPkernel-2.6.21.1)
Date: Fri, 8 Jun 2007 15:23:04 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01AB85A5@otce2k301.adaptec.com>
In-reply-to: <20070608184042.GK3723@sequoia.sous-sol.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [stable] [patch 37/54] SCSI: aacraid: Correctsaplatformsupport. (Was: [Bug 8469] Bad EIP value onpentium3SMPkernel-2.6.21.1)
Thread-Index: Acep/IfK6Mo2B+e5S4WqMTTf7X+6qgABbrbQ
From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
To: "Chris Wright" <chrisw@sous-sol.org>
Cc: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>,
       "James Bottomley" <James.Bottomley@steeleye.com>,
       "AACRAID" <aacraid@adaptec.com>, "Greg Kroah-Hartman" <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>, <stable@kernel.org>, <davej@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Poifect (for earlier kernels without the restart adapter function added)

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Chris Wright [mailto:chrisw@sous-sol.org] 
> Sent: Friday, June 08, 2007 2:41 PM
> To: Salyzyn, Mark
> Cc: Chris Wright; Stefan Lippers-Hollmann; James Bottomley; 
> AACRAID; Greg Kroah-Hartman; linux-kernel@vger.kernel.org; 
> stable@kernel.org; davej@redhat.com
> Subject: Re: [stable] [patch 37/54] SCSI: aacraid: 
> Correctsaplatformsupport. (Was: [Bug 8469] Bad EIP value 
> onpentium3SMPkernel-2.6.21.1)
> 
> 
> * Salyzyn, Mark (mark_salyzyn@adaptec.com) wrote:
> > Drop the setting of restart, drop the dummy restart handler in sa.c.
> 
> Yup, OK.  That's exactly the updated patch I included.  Here 
> it is again:
> 
> From: Salyzyn, Mark <mark_salyzyn@adaptec.com>
> Subject: SCSI: aacraid: Correct sa platform support. (Was: 
> [Bug 8469] Bad EIP value on pentium3 SMP kernel-2.6.21.1)
> 
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=8469
> 
> As discussed in the bugzilla outlined below, we have an sa based
> (Mustang) RAID adapter on the system, a Dell PERC2/QC. Affected
> controllers are HP NetRAID, Adaptec AAC-364, Dell PERC2/QC or Adaptec
> 5400S. This problem  coincides with the introduction of the 
> adapter_comm
> and adapter_deliver platform functions (Message [PATCH 1/4] aacraid:
> rework communication support code, January 23 2007, which initially
> migrated to 2.6.21)
> 
> The panic occurs with an uninitialized adapter_deliver 
> platform function
> pointer. The enclosed patch, unmodified as tested by Rainer, 
> solves the
> problem.
> 
> Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
> Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> [chrisw: backport to 2.6.21.4]
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> 
> ---
>  drivers/scsi/aacraid/aacraid.h |    1 +
>  drivers/scsi/aacraid/rx.c      |    2 +-
>  drivers/scsi/aacraid/sa.c      |    3 ++-
>  3 files changed, 4 insertions(+), 2 deletions(-)
> 
> --- linux-2.6.21.4.orig/drivers/scsi/aacraid/aacraid.h
> +++ linux-2.6.21.4/drivers/scsi/aacraid/aacraid.h
> @@ -1840,6 +1840,7 @@ struct aac_driver_ident* aac_get_driver_
>  int aac_get_adapter_info(struct aac_dev* dev);
>  int aac_send_shutdown(struct aac_dev *dev);
>  int aac_probe_container(struct aac_dev *dev, int cid);
> +int aac_rx_deliver_producer(struct fib * fib);
>  extern int numacb;
>  extern int acbsize;
>  extern char aac_driver_version[];
> --- linux-2.6.21.4.orig/drivers/scsi/aacraid/rx.c
> +++ linux-2.6.21.4/drivers/scsi/aacraid/rx.c
> @@ -378,7 +378,7 @@ static int aac_rx_check_health(struct aa
>   *
>   *	Will send a fib, returning 0 if successful.
>   */
> -static int aac_rx_deliver_producer(struct fib * fib)
> +int aac_rx_deliver_producer(struct fib * fib)
>  {
>  	struct aac_dev *dev = fib->dev;
>  	struct aac_queue *q = &dev->queues->queue[AdapNormCmdQueue];
> --- linux-2.6.21.4.orig/drivers/scsi/aacraid/sa.c
> +++ linux-2.6.21.4/drivers/scsi/aacraid/sa.c
> @@ -5,7 +5,7 @@
>   * based on the old aacraid driver that is..
>   * Adaptec aacraid device driver for Linux.
>   *
> - * Copyright (c) 2000 Adaptec, Inc. (aacraid@adaptec.com)
> + * Copyright (c) 2000-2007 Adaptec, Inc. (aacraid@adaptec.com)
>   *
>   * This program is free software; you can redistribute it 
> and/or modify
>   * it under the terms of the GNU General Public License as 
> published by
> @@ -368,6 +368,7 @@ int aac_sa_init(struct aac_dev *dev)
>  	dev->a_ops.adapter_sync_cmd = sa_sync_cmd;
>  	dev->a_ops.adapter_check_health = aac_sa_check_health;
>  	dev->a_ops.adapter_intr = aac_sa_intr;
> +	dev->a_ops.adapter_deliver = aac_rx_deliver_producer;
>  	dev->a_ops.adapter_ioremap = aac_sa_ioremap;
>  
>  	/*
> 
