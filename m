Return-Path: <linux-kernel-owner+w=401wt.eu-S1752644AbYL3Qlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbYL3Qlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 11:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYL3Qll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 11:41:41 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:35882 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbYL3Qlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 11:41:40 -0500
Message-ID: <495A4F35.2080603@oracle.com>
Date: Tue, 30 Dec 2008 08:41:25 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Karen Xie <kxie@chelsio.com>
CC: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-next@vger.kernel.org,
       sfr@canb.auug.org.au
Subject: Re: [PATCH 1/1] cxgb3i - remove use of skb->sp
References: <200812300543.mBU5hPcb020725@localhost.localdomain>
In-Reply-To: <200812300543.mBU5hPcb020725@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.495A4F39.0304:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karen Xie wrote:
> [PATCH 1/1] cxgb3i - remove use of skb->sp
> 
> From: Karen Xie <kxie@chelsio.com>
> 
> The cxgb3i was using skb->sp pointer for some internal book-keeping which is not related to the secure path. Changed it to use skb->cb[] instead.
> 
> Signed-off-by: Karen Xie <kxie@chelsio.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> ---
> 
>  drivers/scsi/cxgb3i/cxgb3i_offload.c |    8 ++++----
>  drivers/scsi/cxgb3i/cxgb3i_offload.h |    6 +++---
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
> index 5f16081..a865f1f 100644
> --- a/drivers/scsi/cxgb3i/cxgb3i_offload.c
> +++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
> @@ -496,7 +496,7 @@ static inline void reset_wr_list(struct s3_conn *c3cn)
>  static inline void enqueue_wr(struct s3_conn *c3cn,
>  			      struct sk_buff *skb)
>  {
> -	skb->sp = NULL;
> +	skb_wr_data(skb) = NULL;
>  
>  	/*
>  	 * We want to take an extra reference since both us and the driver
> @@ -509,7 +509,7 @@ static inline void enqueue_wr(struct s3_conn *c3cn,
>  	if (!c3cn->wr_pending_head)
>  		c3cn->wr_pending_head = skb;
>  	else
> -		c3cn->wr_pending_tail->sp = (void *)skb;
> +		skb_wr_data(skb) = skb;
>  	c3cn->wr_pending_tail = skb;
>  }
>  
> @@ -529,8 +529,8 @@ static inline struct sk_buff *dequeue_wr(struct s3_conn *c3cn)
>  
>  	if (likely(skb)) {
>  		/* Don't bother clearing the tail */
> -		c3cn->wr_pending_head = (struct sk_buff *)skb->sp;
> -		skb->sp = NULL;
> +		c3cn->wr_pending_head = skb_wr_data(skb);
> +		skb_wr_data(skb) = NULL;
>  	}
>  	return skb;
>  }
> diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.h b/drivers/scsi/cxgb3i/cxgb3i_offload.h
> index 5b93d62..d231569 100644
> --- a/drivers/scsi/cxgb3i/cxgb3i_offload.h
> +++ b/drivers/scsi/cxgb3i/cxgb3i_offload.h
> @@ -180,7 +180,7 @@ void cxgb3i_c3cn_release(struct s3_conn *);
>   * @seq:	tcp sequence number
>   * @ddigest:	pdu data digest
>   * @pdulen:	recovered pdu length
> - * @ulp_data:	scratch area for ULP
> + * @wr_data:	scratch area for tx wr
>   */
>  struct cxgb3_skb_cb {
>  	__u8 flags;
> @@ -188,7 +188,7 @@ struct cxgb3_skb_cb {
>  	__u32 seq;
>  	__u32 ddigest;
>  	__u32 pdulen;
> -	__u8 ulp_data[16];
> +	struct sk_buff *wr_data;
>  };
>  
>  #define CXGB3_SKB_CB(skb)	((struct cxgb3_skb_cb *)&((skb)->cb[0]))
> @@ -196,7 +196,7 @@ struct cxgb3_skb_cb {
>  #define skb_ulp_mode(skb)	(CXGB3_SKB_CB(skb)->ulp_mode)
>  #define skb_ulp_ddigest(skb)	(CXGB3_SKB_CB(skb)->ddigest)
>  #define skb_ulp_pdulen(skb)	(CXGB3_SKB_CB(skb)->pdulen)
> -#define skb_ulp_data(skb)	(CXGB3_SKB_CB(skb)->ulp_data)
> +#define skb_wr_data(skb)	(CXGB3_SKB_CB(skb)->wr_data)
>  
>  enum c3cb_flags {
>  	C3CB_FLAG_NEED_HDR = 1 << 0,	/* packet needs a TX_DATA_WR header */


-- 
~Randy
