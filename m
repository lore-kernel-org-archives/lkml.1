Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbYBUNqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbYBUNqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 08:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbYBUNqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 08:46:20 -0500
Received: from mail2.neteffect.com ([204.57.75.68]:9964 "EHLO
	mail2.neteffect.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbYBUNqT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 08:46:19 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [ofa-general] [PATCH 2.6 6/8] RDMA/nes: Fix rdma connectionestablishment on big-endian platforms
Date: Thu, 21 Feb 2008 07:46:19 -0600
Message-ID: <5E701717F2B2ED4EA60F87C8AA57B7CC07950006@venom2>
In-Reply-To: <200802211429.m1LETfLj005153@velma.neteffect.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [ofa-general] [PATCH 2.6 6/8] RDMA/nes: Fix rdma connectionestablishment on big-endian platforms
Thread-Index: Ach0jpvnlF1XoZ3LQ/iZDdXcEq5yUwAARdOA
From: "Glenn Streiff" <gstreiff@NetEffect.com>
To: <rdreier@cisco.com>
Cc: <linux-kernel@vger.kernel.org>, <general@lists.openfabrics.org>,
       "Faisal Latif" <flatif@NetEffect.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You'll notice I have two "6/8" patches.  This is the
bogus one.  No one told me this job required ability to count.

Glenn

> -----Original Message-----
> From: general-bounces@lists.openfabrics.org
> [mailto:general-bounces@lists.openfabrics.org]On Behalf Of
> gstreiff@neteffect.com
> Sent: Thursday, February 21, 2008 8:30 AM
> To: rdreier@cisco.com
> Cc: linux-kernel@vger.kernel.org; 
> general@lists.openfabrics.org; Faisal
> Latif
> Subject: [ofa-general] [PATCH 2.6 6/8] RDMA/nes: Fix rdma
> connectionestablishment on big-endian platforms
> 
> 
> From: Faisal Latif <flatif@neteffect.com>
> 
> With commit ef19454bd437b2ba, behavior of crc32c changes on
> big-endian platforms.
> 
> Our algorithm expects previous behavior otherwise we have
> rdma connection establishment failure on big-endian platforms
> like ppc64.  Applying cpu_to_le32() to value returned by
> crc32c() to get previous behavior.
> 
> Signed-off-by: Faisal Latif <flatif@neteffect.com>
> Signed-off-by: Glenn Streiff <gstreiff@neteffect.com>
> 
> ---
>  drivers/infiniband/hw/nes/nes.h    |   14 ++++++++++++++
>  drivers/infiniband/hw/nes/nes_cm.c |    5 +++--
>  2 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/nes/nes.h 
> b/drivers/infiniband/hw/nes/nes.h
> index fd57e8a..b0d3c52 100644
> --- a/drivers/infiniband/hw/nes/nes.h
> +++ b/drivers/infiniband/hw/nes/nes.h
> @@ -285,6 +285,20 @@ struct nes_device {
>  };
>  
>  
> +static inline u32 get_crc_value(struct nes_v4_quad* nes_quad)
> +{
> +	u32 crc_value;
> +	crc_value = crc32c(~0, (void *)nes_quad, sizeof (struct 
> nes_v4_quad));
> +
> +	/*
> +	* With commit ef19454bd437b2ba, behavior of crc32c changes on
> +	* big-endian platforms.  Our algorithm expects previous behavior
> +	* otherwise we have rdma connection establishment issue 
> on ppc64.
> +	*/
> +	crc_value = cpu_to_le32(crc_value);
> +	return crc_value;
> +}
> +
>  static inline void
>  set_wqe_64bit_value(__le32 *wqe_words, u32 index, u64 value)
>  {
> diff --git a/drivers/infiniband/hw/nes/nes_cm.c 
> b/drivers/infiniband/hw/nes/nes_cm.c
> index 6c298aa..1f042d1 100644
> --- a/drivers/infiniband/hw/nes/nes_cm.c
> +++ b/drivers/infiniband/hw/nes/nes_cm.c
> @@ -2320,6 +2320,7 @@ int nes_accept(struct iw_cm_id *cm_id, 
> struct iw_cm_conn_param *conn_param)
>  	struct iw_cm_event cm_event;
>  	struct nes_hw_qp_wqe *wqe;
>  	struct nes_v4_quad nes_quad;
> +	u32 crc_value;
>  	int ret;
>  
>  	ibqp = nes_get_qp(cm_id->device, conn_param->qpn);
> @@ -2436,8 +2437,8 @@ int nes_accept(struct iw_cm_id *cm_id, 
> struct iw_cm_conn_param *conn_param)
>  	nes_quad.TcpPorts[1]   = cm_id->local_addr.sin_port;
>  
>  	/* Produce hash key */
> -	nesqp->hte_index = cpu_to_be32(
> -			crc32c(~0, (void *)&nes_quad, 
> sizeof(nes_quad)) ^ 0xffffffff);
> +	crc_value = get_crc_value(&nes_quad);
> +	nesqp->hte_index = cpu_to_be32(crc_value ^ 0xffffffff);
>  	nes_debug(NES_DBG_CM, "HTE Index = 0x%08X, CRC = 0x%08X\n",
>  			nesqp->hte_index, nesqp->hte_index & 
> adapter->hte_index_mask);
>  
> _______________________________________________
> general mailing list
> general@lists.openfabrics.org
> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general
> 
> To unsubscribe, please visit 
http://openib.org/mailman/listinfo/openib-general
