Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbZEYJ2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbZEYJ2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 05:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbZEYJ2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 05:28:08 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:41930 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbZEYJ2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 05:28:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=R1xfqUvWPUobIajpXF/1nQEXRA65RLZ39e0TNO7DJIQDXZRwbCVOaO4hnul/U80nZi
         ruan+pm3bd7dqUArlwV12MRUI51WaH6FW7NyaEOQut5TDrm6HpX5Sc6UsKtrsjPZpu6b
         64kAst6Ua+nuZrjcJLjvVUnSeUOJe0wZAvClc=
Message-ID: <4A1A64A1.2050409@panasas.com>
Date: Mon, 25 May 2009 12:28:01 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 03/13] scsi: unify allocation of scsi command and sense
 buffer
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com> <1243236668-3398-6-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1243236668-3398-6-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2009 10:30 AM, Jens Axboe wrote:
> Fold the sense buffer into the command, thereby eliminating a slab
> allocation and free per command.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

Jens Hi.

I'm "TO:" this to Tomo.

This is the way it used to be for a long time. It was only recently changed by
Tomo because of a bug on none-cache-coherent arches that need to dma-access the
sense_buffer and also on the other hand change scsi_cmnd members by CPU.

In my opinion all you need is an __aligned(SMP_CACHE_BYTES) declaration at
sense_buffer[] and let there be a hole at the end before the array. But Tomo
did not like that, so he separated the two.

Ideally there should be a MACRO that is defined to WORD_SIZE on cache-coherent
ARCHs and to SMP_CACHE_BYTES on none-cache-coherent systems and use that size
at the __align() attribute. (So only stupid ARCHES get hurt)

(see below)
> ---
>  drivers/scsi/scsi.c      |   44 ++++++++++----------------------------------
>  include/scsi/scsi_cmnd.h |   12 ++++++------
>  2 files changed, 16 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 166417a..6a993af 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -133,7 +133,6 @@ EXPORT_SYMBOL(scsi_device_type);
>  
>  struct scsi_host_cmd_pool {
>  	struct kmem_cache	*cmd_slab;
> -	struct kmem_cache	*sense_slab;
>  	unsigned int		users;
>  	char			*cmd_name;
>  	char			*sense_name;
> @@ -167,20 +166,9 @@ static DEFINE_MUTEX(host_cmd_pool_mutex);
>  static struct scsi_cmnd *
>  scsi_pool_alloc_command(struct scsi_host_cmd_pool *pool, gfp_t gfp_mask)
>  {
> -	struct scsi_cmnd *cmd;
> -
> -	cmd = kmem_cache_zalloc(pool->cmd_slab, gfp_mask | pool->gfp_mask);
> -	if (!cmd)
> -		return NULL;
> +	gfp_t gfp = gfp_mask | pool->gfp_mask;
>  
> -	cmd->sense_buffer = kmem_cache_alloc(pool->sense_slab,
> -					     gfp_mask | pool->gfp_mask);
> -	if (!cmd->sense_buffer) {
> -		kmem_cache_free(pool->cmd_slab, cmd);
> -		return NULL;
> -	}
> -
> -	return cmd;
> +	return kmem_cache_zalloc(pool->cmd_slab, gfp);
>  }
>  
>  /**
> @@ -198,7 +186,6 @@ scsi_pool_free_command(struct scsi_host_cmd_pool *pool,
>  	if (cmd->prot_sdb)
>  		kmem_cache_free(scsi_sdb_cache, cmd->prot_sdb);
>  
> -	kmem_cache_free(pool->sense_slab, cmd->sense_buffer);
>  	kmem_cache_free(pool->cmd_slab, cmd);
>  }
>  
> @@ -242,7 +229,6 @@ scsi_host_alloc_command(struct Scsi_Host *shost, gfp_t gfp_mask)
>  struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
>  {
>  	struct scsi_cmnd *cmd;
> -	unsigned char *buf;
>  
>  	cmd = scsi_host_alloc_command(shost, gfp_mask);
>  
> @@ -257,11 +243,8 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
>  		}
>  		spin_unlock_irqrestore(&shost->free_list_lock, flags);
>  
> -		if (cmd) {
> -			buf = cmd->sense_buffer;
> +		if (cmd)
>  			memset(cmd, 0, sizeof(*cmd));
> -			cmd->sense_buffer = buf;
> -		}
>  	}
>  
>  	return cmd;
> @@ -361,19 +344,13 @@ static struct scsi_host_cmd_pool *scsi_get_host_cmd_pool(gfp_t gfp_mask)
>  	pool = (gfp_mask & __GFP_DMA) ? &scsi_cmd_dma_pool :
>  		&scsi_cmd_pool;
>  	if (!pool->users) {
> -		pool->cmd_slab = kmem_cache_create(pool->cmd_name,
> -						   sizeof(struct scsi_cmnd), 0,
> -						   pool->slab_flags, NULL);
> -		if (!pool->cmd_slab)
> -			goto fail;
> +		unsigned int slab_size;
>  
> -		pool->sense_slab = kmem_cache_create(pool->sense_name,
> -						     SCSI_SENSE_BUFFERSIZE, 0,
> -						     pool->slab_flags, NULL);
> -		if (!pool->sense_slab) {
> -			kmem_cache_destroy(pool->cmd_slab);
> +		slab_size = sizeof(struct scsi_cmnd) + SCSI_SENSE_BUFFERSIZE;

You might as well just define sense array as unsigned char sense_buffer[SCSI_SENSE_BUFFERSIZE]
and save the manual calculation.

> +		pool->cmd_slab = kmem_cache_create(pool->cmd_name, slab_size,
> +						   0, pool->slab_flags, NULL);
> +		if (!pool->cmd_slab)
>  			goto fail;
> -		}
>  	}
>  
>  	pool->users++;
> @@ -397,10 +374,9 @@ static void scsi_put_host_cmd_pool(gfp_t gfp_mask)
>  	 */
>  	BUG_ON(pool->users == 0);
>  
> -	if (!--pool->users) {
> +	if (!--pool->users)
>  		kmem_cache_destroy(pool->cmd_slab);
> -		kmem_cache_destroy(pool->sense_slab);
> -	}
> +
>  	mutex_unlock(&host_cmd_pool_mutex);
>  }
>  
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 43b50d3..649ad36 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -102,12 +102,6 @@ struct scsi_cmnd {
>  	struct request *request;	/* The command we are
>  				   	   working on */
>  
> -#define SCSI_SENSE_BUFFERSIZE 	96
> -	unsigned char *sense_buffer;
> -				/* obtained by REQUEST SENSE when
> -				 * CHECK CONDITION is received on original
> -				 * command (auto-sense) */
> -
>  	/* Low-level done function - can be used by low-level driver to point
>  	 *        to completion function.  Not used by mid/upper level code. */
>  	void (*scsi_done) (struct scsi_cmnd *);
> @@ -129,6 +123,12 @@ struct scsi_cmnd {
>  	int result;		/* Status code from lower level driver */
>  
>  	unsigned char tag;	/* SCSI-II queued command tag */
> +
> +#define SCSI_SENSE_BUFFERSIZE 	96
> +	unsigned char sense_buffer[0];

+	unsigned char sense_buffer[BUFFERSIZE]; __aligned(CACHE_COHERENT_BYTES)

> +				/* obtained by REQUEST SENSE when
> +				 * CHECK CONDITION is received on original
> +				 * command (auto-sense) */
>  };
>  
>  extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);

Thanks
Boaz
