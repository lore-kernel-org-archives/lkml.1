Return-Path: <linux-kernel-owner+w=401wt.eu-S1760780AbZDARH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760780AbZDARH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 13:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755831AbZDARHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 13:07:10 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:24978 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753791AbZDARHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 13:07:08 -0400
Message-ID: <49D39EBF.50905@panasas.com>
Date: Wed, 01 Apr 2009 20:05:03 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 17/17] blk-map/bio: remove superflous @q from blk_rq_map_{user|kern}*()
References: <1238593472-30360-1-git-send-email-tj@kernel.org> <1238593472-30360-18-git-send-email-tj@kernel.org>
In-Reply-To: <1238593472-30360-18-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2009 17:07:04.0449 (UTC) FILETIME=[47DD6F10:01C9B2EC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2009 04:44 PM, Tejun Heo wrote:
> Impact: API cleanup
> 
> All initialized requests must and are guaranteed to have rq->q set.
> Taking both @q and @rq parameters doesn't improve anything.  It only
> adds pathological corner case where @q != !@rq->q.  Kill the
> superflous @q parameter from blk_rq_map_{user|kern}*().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Thank god, great stuff

> ---
>  block/blk-map.c                            |   27 +++++++++++----------------
>  block/bsg.c                                |    5 ++---
>  block/scsi_ioctl.c                         |    6 +++---
>  drivers/block/pktcdvd.c                    |    2 +-
>  drivers/cdrom/cdrom.c                      |    2 +-
>  drivers/scsi/device_handler/scsi_dh_alua.c |    2 +-
>  drivers/scsi/device_handler/scsi_dh_emc.c  |    2 +-
>  drivers/scsi/device_handler/scsi_dh_rdac.c |    2 +-
>  drivers/scsi/scsi_lib.c                    |    7 +++----
>  drivers/scsi/scsi_tgt_lib.c                |    3 +--
>  drivers/scsi/sg.c                          |    6 +++---
>  drivers/scsi/st.c                          |    3 +--
>  include/linux/blkdev.h                     |   15 +++++++--------
>  13 files changed, 36 insertions(+), 46 deletions(-)
> 
> diff --git a/block/blk-map.c b/block/blk-map.c
> index f60f439..885d359 100644
> --- a/block/blk-map.c
> +++ b/block/blk-map.c
> @@ -10,7 +10,6 @@
>  
>  /**
>   * blk_rq_map_user_iov - map user data to a request, for REQ_TYPE_BLOCK_PC usage
> - * @q:		request queue where request should be inserted
>   * @rq:		request to map data to
>   * @md:		pointer to the rq_map_data holding pages (if necessary)
>   * @iov:	pointer to the iovec
> @@ -30,10 +29,10 @@
>   *    original bio must be passed back in to blk_rq_unmap_user() for proper
>   *    unmapping.
>   */
> -int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
> -			struct rq_map_data *md, struct iovec *iov, int count,
> -			gfp_t gfp)
> +int blk_rq_map_user_iov(struct request *rq, struct rq_map_data *md,
> +			struct iovec *iov, int count, gfp_t gfp)
>  {
> +	struct request_queue *q = rq->q;
>  	struct bio *bio = ERR_PTR(-EINVAL);
>  	int rw = rq_data_dir(rq);
>  
> @@ -66,7 +65,6 @@ EXPORT_SYMBOL(blk_rq_map_user_iov);
>  
>  /**
>   * blk_rq_map_user - map user data to a request, for REQ_TYPE_BLOCK_PC usage
> - * @q:		request queue where request should be inserted
>   * @rq:		request structure to fill
>   * @md:		pointer to the rq_map_data holding pages (if necessary)
>   * @ubuf:	the user buffer
> @@ -86,16 +84,15 @@ EXPORT_SYMBOL(blk_rq_map_user_iov);
>   *    original bio must be passed back in to blk_rq_unmap_user() for proper
>   *    unmapping.
>   */
> -int blk_rq_map_user(struct request_queue *q, struct request *rq,
> -		    struct rq_map_data *md, void __user *ubuf,
> -		    unsigned long len, gfp_t gfp)
> +int blk_rq_map_user(struct request *rq, struct rq_map_data *md,
> +		    void __user *ubuf, unsigned long len, gfp_t gfp)
>  {
>  	struct iovec iov;
>  
>  	iov.iov_base = ubuf;
>  	iov.iov_len = len;
>  
> -	return blk_rq_map_user_iov(q, rq, md, &iov, 1, gfp);
> +	return blk_rq_map_user_iov(rq, md, &iov, 1, gfp);
>  }
>  EXPORT_SYMBOL(blk_rq_map_user);
>  
> @@ -128,7 +125,6 @@ EXPORT_SYMBOL(blk_rq_unmap_user);
>  
>  /**
>   * blk_rq_map_kern_sg - map kernel data to a request, for REQ_TYPE_BLOCK_PC
> - * @q:		request queue where request should be inserted
>   * @rq:		request to fill
>   * @sgl:	area to map
>   * @nents:	number of elements in @sgl
> @@ -138,9 +134,10 @@ EXPORT_SYMBOL(blk_rq_unmap_user);
>   *    Data will be mapped directly if possible. Otherwise a bounce
>   *    buffer is used.
>   */
> -int blk_rq_map_kern_sg(struct request_queue *q, struct request *rq,
> -		       struct scatterlist *sgl, int nents, gfp_t gfp)
> +int blk_rq_map_kern_sg(struct request *rq, struct scatterlist *sgl, int nents,
> +		       gfp_t gfp)
>  {
> +	struct request_queue *q = rq->q;
>  	int rw = rq_data_dir(rq);
>  	struct bio *bio;
>  
> @@ -165,7 +162,6 @@ EXPORT_SYMBOL(blk_rq_map_kern_sg);
>  
>  /**
>   * blk_rq_map_kern - map kernel data to a request, for REQ_TYPE_BLOCK_PC usage
> - * @q:		request queue where request should be inserted
>   * @rq:		request to fill
>   * @kbuf:	the kernel buffer
>   * @len:	length of user data
> @@ -175,13 +171,12 @@ EXPORT_SYMBOL(blk_rq_map_kern_sg);
>   *    Data will be mapped directly if possible. Otherwise a bounce
>   *    buffer is used.
>   */
> -int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
> -		    unsigned int len, gfp_t gfp)
> +int blk_rq_map_kern(struct request *rq, void *kbuf, unsigned int len, gfp_t gfp)
>  {
>  	struct scatterlist sg;
>  
>  	sg_init_one(&sg, kbuf, len);
>  
> -	return blk_rq_map_kern_sg(q, rq, &sg, 1, gfp);
> +	return blk_rq_map_kern_sg(rq, &sg, 1, gfp);
>  }
>  EXPORT_SYMBOL(blk_rq_map_kern);
> diff --git a/block/bsg.c b/block/bsg.c
> index 206060e..69c222a 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -283,7 +283,7 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
>  		next_rq->cmd_type = rq->cmd_type;
>  
>  		dxferp = (void*)(unsigned long)hdr->din_xferp;
> -		ret =  blk_rq_map_user(q, next_rq, NULL, dxferp,
> +		ret =  blk_rq_map_user(next_rq, NULL, dxferp,
>  				       hdr->din_xfer_len, GFP_KERNEL);
>  		if (ret)
>  			goto out;
> @@ -299,8 +299,7 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
>  		dxfer_len = 0;
>  
>  	if (dxfer_len) {
> -		ret = blk_rq_map_user(q, rq, NULL, dxferp, dxfer_len,
> -				      GFP_KERNEL);
> +		ret = blk_rq_map_user(rq, NULL, dxferp, dxfer_len, GFP_KERNEL);
>  		if (ret)
>  			goto out;
>  	}
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index fd538f8..a98e4ec 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -306,11 +306,11 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
>  		hdr->iovec_count = iov_shorten(iov, hdr->iovec_count,
>  					       hdr->dxfer_len);
>  
> -		ret = blk_rq_map_user_iov(q, rq, NULL, iov, hdr->iovec_count,
> +		ret = blk_rq_map_user_iov(rq, NULL, iov, hdr->iovec_count,
>  					  GFP_KERNEL);
>  		kfree(iov);
>  	} else if (hdr->dxfer_len)
> -		ret = blk_rq_map_user(q, rq, NULL, hdr->dxferp, hdr->dxfer_len,
> +		ret = blk_rq_map_user(rq, NULL, hdr->dxferp, hdr->dxfer_len,
>  				      GFP_KERNEL);
>  
>  	if (ret)
> @@ -449,7 +449,7 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
>  		break;
>  	}
>  
> -	if (bytes && blk_rq_map_kern(q, rq, buffer, bytes, __GFP_WAIT)) {
> +	if (bytes && blk_rq_map_kern(rq, buffer, bytes, __GFP_WAIT)) {
>  		err = DRIVER_ERROR << 24;
>  		goto out;
>  	}
> diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
> index dc7a8c3..a4e5e9b 100644
> --- a/drivers/block/pktcdvd.c
> +++ b/drivers/block/pktcdvd.c
> @@ -771,7 +771,7 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
>  			     WRITE : READ, __GFP_WAIT);
>  
>  	if (cgc->buflen) {
> -		if (blk_rq_map_kern(q, rq, cgc->buffer, cgc->buflen, __GFP_WAIT))
> +		if (blk_rq_map_kern(rq, cgc->buffer, cgc->buflen, __GFP_WAIT))
>  			goto out;
>  	}
>  
> diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
> index cceace6..ef67aec 100644
> --- a/drivers/cdrom/cdrom.c
> +++ b/drivers/cdrom/cdrom.c
> @@ -2112,7 +2112,7 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
>  			break;
>  		}
>  
> -		ret = blk_rq_map_user(q, rq, NULL, ubuf, len, GFP_KERNEL);
> +		ret = blk_rq_map_user(rq, NULL, ubuf, len, GFP_KERNEL);
>  		if (ret) {
>  			blk_put_request(rq);
>  			break;
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index e356b43..f3cb900 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -101,7 +101,7 @@ static struct request *get_alua_req(struct scsi_device *sdev,
>  		return NULL;
>  	}
>  
> -	if (buflen && blk_rq_map_kern(q, rq, buffer, buflen, GFP_NOIO)) {
> +	if (buflen && blk_rq_map_kern(rq, buffer, buflen, GFP_NOIO)) {
>  		blk_put_request(rq);
>  		sdev_printk(KERN_INFO, sdev,
>  			    "%s: blk_rq_map_kern failed\n", __func__);
> diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
> index 0e572d2..dbbd56d 100644
> --- a/drivers/scsi/device_handler/scsi_dh_emc.c
> +++ b/drivers/scsi/device_handler/scsi_dh_emc.c
> @@ -308,7 +308,7 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
>  	rq->timeout = CLARIION_TIMEOUT;
>  	rq->retries = CLARIION_RETRIES;
>  
> -	if (blk_rq_map_kern(rq->q, rq, buffer, len, GFP_NOIO)) {
> +	if (blk_rq_map_kern(rq, buffer, len, GFP_NOIO)) {
>  		blk_put_request(rq);
>  		return NULL;
>  	}
> diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
> index 5366476..f50b33a 100644
> --- a/drivers/scsi/device_handler/scsi_dh_rdac.c
> +++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
> @@ -219,7 +219,7 @@ static struct request *get_rdac_req(struct scsi_device *sdev,
>  		return NULL;
>  	}
>  
> -	if (buflen && blk_rq_map_kern(q, rq, buffer, buflen, GFP_NOIO)) {
> +	if (buflen && blk_rq_map_kern(rq, buffer, buflen, GFP_NOIO)) {
>  		blk_put_request(rq);
>  		sdev_printk(KERN_INFO, sdev,
>  				"get_rdac_req: blk_rq_map_kern failed.\n");
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 3fa5589..66c3d0b 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -216,8 +216,7 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
>  
>  	req = blk_get_request(sdev->request_queue, write, __GFP_WAIT);
>  
> -	if (bufflen &&	blk_rq_map_kern(sdev->request_queue, req,
> -					buffer, bufflen, __GFP_WAIT))
> +	if (bufflen && blk_rq_map_kern(req, buffer, bufflen, __GFP_WAIT))
>  		goto out;
>  
>  	req->cmd_len = COMMAND_SIZE(cmd[0]);
> @@ -332,9 +331,9 @@ int scsi_execute_async(struct scsi_device *sdev, const unsigned char *cmd,
>  	req->cmd_flags |= REQ_QUIET;
>  
>  	if (use_sg)
> -		err = blk_rq_map_kern_sg(req->q, req, buffer, use_sg, gfp);
> +		err = blk_rq_map_kern_sg(req, buffer, use_sg, gfp);
>  	else if (bufflen)
> -		err = blk_rq_map_kern(req->q, req, buffer, bufflen, gfp);
> +		err = blk_rq_map_kern(req, buffer, bufflen, gfp);
>  
>  	if (err)
>  		goto free_req;
> diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
> index 48ba413..55beba4 100644
> --- a/drivers/scsi/scsi_tgt_lib.c
> +++ b/drivers/scsi/scsi_tgt_lib.c
> @@ -357,12 +357,11 @@ static int scsi_tgt_transfer_response(struct scsi_cmnd *cmd)
>  static int scsi_map_user_pages(struct scsi_tgt_cmd *tcmd, struct scsi_cmnd *cmd,
>  			       unsigned long uaddr, unsigned int len, int rw)
>  {
> -	struct request_queue *q = cmd->request->q;
>  	struct request *rq = cmd->request;
>  	int err;
>  
>  	dprintk("%lx %u\n", uaddr, len);
> -	err = blk_rq_map_user(q, rq, NULL, (void *)uaddr, len, GFP_KERNEL);
> +	err = blk_rq_map_user(rq, NULL, (void *)uaddr, len, GFP_KERNEL);
>  	if (err) {
>  		/*
>  		 * TODO: need to fixup sg_tablesize, max_segment_size,
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 5fcf436..a769041 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1672,11 +1672,11 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
>  	}
>  
>  	if (iov_count)
> -		res = blk_rq_map_user_iov(q, rq, md, hp->dxferp, iov_count,
> +		res = blk_rq_map_user_iov(rq, md, hp->dxferp, iov_count,
>  					  GFP_ATOMIC);
>  	else
> -		res = blk_rq_map_user(q, rq, md, hp->dxferp,
> -				      hp->dxfer_len, GFP_ATOMIC);
> +		res = blk_rq_map_user(rq, md, hp->dxferp, hp->dxfer_len,
> +				      GFP_ATOMIC);
>  
>  	if (!res) {
>  		srp->bio = rq->bio;
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index c6f19ee..c4615bb 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -492,8 +492,7 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
>  	mdata->null_mapped = 1;
>  
>  	if (bufflen) {
> -		err = blk_rq_map_user(req->q, req, mdata, NULL, bufflen,
> -				      GFP_KERNEL);
> +		err = blk_rq_map_user(req, mdata, NULL, bufflen, GFP_KERNEL);
>  		if (err) {
>  			blk_put_request(req);
>  			return DRIVER_ERROR << 24;
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 6876466..ff0ad9e 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -770,15 +770,14 @@ extern void __blk_stop_queue(struct request_queue *q);
>  extern void __blk_run_queue(struct request_queue *);
>  extern void blk_run_queue(struct request_queue *);
>  extern void blk_start_queueing(struct request_queue *);
> -extern int blk_rq_map_user(struct request_queue *, struct request *,
> -			   struct rq_map_data *, void __user *, unsigned long,
> -			   gfp_t);
> +extern int blk_rq_map_user(struct request *rq, struct rq_map_data *md,
> +			   void __user *ubuf, unsigned long len, gfp_t gfp);
>  extern int blk_rq_unmap_user(struct bio *);
> -extern int blk_rq_map_kern(struct request_queue *, struct request *, void *, unsigned int, gfp_t);
> -extern int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
> -			       struct rq_map_data *md, struct iovec *iov,
> -			       int count, gfp_t gfp);
> -extern int blk_rq_map_kern_sg(struct request_queue *q, struct request *rq,
> +extern int blk_rq_map_kern(struct request *rq, void *kbuf, unsigned int len,
> +			   gfp_t gfp);
> +extern int blk_rq_map_user_iov(struct request *rq, struct rq_map_data *md,
> +			       struct iovec *iov, int count, gfp_t gfp);
> +extern int blk_rq_map_kern_sg(struct request *rq,
>  			      struct scatterlist *sgl, int nents, gfp_t gfp);
>  extern int blk_execute_rq(struct request_queue *, struct gendisk *,
>  			  struct request *, int);

