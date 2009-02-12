Return-Path: <linux-kernel-owner+w=401wt.eu-S1758763AbZBLKic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763AbZBLKic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 05:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757469AbZBLKiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 05:38:06 -0500
Received: from gate.crashing.org ([63.228.1.57]:58701 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756739AbZBLKiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 05:38:05 -0500
Subject: Re: [PATCH 3/5]: drm: radeon: Fix ring_rptr accesses.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090212.021537.223279165.davem@davemloft.net>
References: <20090212.021537.223279165.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 21:37:54 +1100
Message-Id: <1234435074.29851.57.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 02:15 -0800, David Miller wrote:
> The memory behind ring_rptr can either be in ioremapped memory
> or a vmalloc() normal kernel memory buffer.
> 
> However, the code unconditionally uses DRM_{READ,WRITE}32() (and thus
> readl() and writel()) to access it.
> 
> Basically, if RADEON_IS_AGP then it's ioremap()'d memory else it's
> vmalloc'd memory.
> 
> Adjust all of the ring_rptr access code as needed.
> 
> While we're here, kill the 'scratch' pointer in drm_radeon_private.
> It's only used in the one place where it is initialized.

Similar comment about potential swapper setting when accessing the RPTR
via the framebuffer. David (Airlied), what's the current status with
that stuff ? I know you work on cleaning that shit up in kms, right now,
we'll hit the non-surface region whose setting will pretty much depend
on the fb bit depth setting...

Cheers,
Ben.

> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  drivers/gpu/drm/radeon/radeon_cp.c    |   70 +++++++++++++++++++++++++++------
>  drivers/gpu/drm/radeon/radeon_drv.h   |   17 ++++----
>  drivers/gpu/drm/radeon/radeon_state.c |    6 +-
>  3 files changed, 70 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/gpu/drm/radeon/radeon_cp.c b/drivers/gpu/drm/radeon/radeon_cp.c
> index ae4ffa1..9053755 100644
> --- a/drivers/gpu/drm/radeon/radeon_cp.c
> +++ b/drivers/gpu/drm/radeon/radeon_cp.c
> @@ -43,6 +43,52 @@
>  static int radeon_do_cleanup_cp(struct drm_device * dev);
>  static void radeon_do_cp_start(drm_radeon_private_t * dev_priv);
>  
> +static u32 radeon_read_ring_rptr(drm_radeon_private_t *dev_priv, u32 off)
> +{
> +	u32 val;
> +
> +	if (dev_priv->flags & RADEON_IS_AGP) {
> +		val = DRM_READ32(dev_priv->ring_rptr, off);
> +	} else {
> +		val = *(((volatile u32 *)
> +			 dev_priv->ring_rptr->handle) +
> +			(off / sizeof(u32)));
> +		val = le32_to_cpu(val);
> +	}
> +	return val;
> +}
> +
> +u32 radeon_get_ring_head(drm_radeon_private_t *dev_priv)
> +{
> +	if (dev_priv->writeback_works)
> +		return radeon_read_ring_rptr(dev_priv, 0);
> +	else
> +		return RADEON_READ(RADEON_CP_RB_RPTR);
> +}
> +
> +static void radeon_write_ring_rptr(drm_radeon_private_t *dev_priv, u32 off, u32 val)
> +{
> +	if (dev_priv->flags & RADEON_IS_AGP)
> +		DRM_WRITE32(dev_priv->ring_rptr, off, val);
> +	else
> +		*(((volatile u32 *) dev_priv->ring_rptr->handle) +
> +		  (off / sizeof(u32))) = cpu_to_le32(val);
> +}
> +
> +void radeon_set_ring_head(drm_radeon_private_t *dev_priv, u32 val)
> +{
> +	radeon_write_ring_rptr(dev_priv, 0, val);
> +}
> +
> +u32 radeon_get_scratch(drm_radeon_private_t *dev_priv, int index)
> +{
> +	if (dev_priv->writeback_works)
> +		return radeon_read_ring_rptr(dev_priv,
> +					     RADEON_SCRATCHOFF(index));
> +	else
> +		return RADEON_READ(RADEON_SCRATCH_REG0 + 4*index);
> +}
> +
>  static u32 R500_READ_MCIND(drm_radeon_private_t *dev_priv, int addr)
>  {
>  	u32 ret;
> @@ -647,10 +693,6 @@ static void radeon_cp_init_ring_buffer(struct drm_device * dev,
>  	RADEON_WRITE(RADEON_SCRATCH_ADDR, RADEON_READ(RADEON_CP_RB_RPTR_ADDR)
>  		     + RADEON_SCRATCH_REG_OFFSET);
>  
> -	dev_priv->scratch = ((__volatile__ u32 *)
> -			     dev_priv->ring_rptr->handle +
> -			     (RADEON_SCRATCH_REG_OFFSET / sizeof(u32)));
> -
>  	RADEON_WRITE(RADEON_SCRATCH_UMSK, 0x7);
>  
>  	/* Turn on bus mastering */
> @@ -668,13 +710,13 @@ static void radeon_cp_init_ring_buffer(struct drm_device * dev,
>  		RADEON_WRITE(RADEON_BUS_CNTL, tmp);
>  	} /* PCIE cards appears to not need this */
>  
> -	dev_priv->scratch[0] = 0;
> +	radeon_write_ring_rptr(dev_priv, RADEON_SCRATCHOFF(0), 0);
>  	RADEON_WRITE(RADEON_LAST_FRAME_REG, 0);
>  
> -	dev_priv->scratch[1] = 0;
> +	radeon_write_ring_rptr(dev_priv, RADEON_SCRATCHOFF(1), 0);
>  	RADEON_WRITE(RADEON_LAST_DISPATCH_REG, 0);
>  
> -	dev_priv->scratch[2] = 0;
> +	radeon_write_ring_rptr(dev_priv, RADEON_SCRATCHOFF(2), 0);
>  	RADEON_WRITE(RADEON_LAST_CLEAR_REG, 0);
>  
>  	radeon_do_wait_for_idle(dev_priv);
> @@ -698,12 +740,15 @@ static void radeon_test_writeback(drm_radeon_private_t * dev_priv)
>  	/* Writeback doesn't seem to work everywhere, test it here and possibly
>  	 * enable it if it appears to work
>  	 */
> -	DRM_WRITE32(dev_priv->ring_rptr, RADEON_SCRATCHOFF(1), 0);
> +	radeon_write_ring_rptr(dev_priv, RADEON_SCRATCHOFF(1), 0);
> +
>  	RADEON_WRITE(RADEON_SCRATCH_REG1, 0xdeadbeef);
>  
>  	for (tmp = 0; tmp < dev_priv->usec_timeout; tmp++) {
> -		if (DRM_READ32(dev_priv->ring_rptr, RADEON_SCRATCHOFF(1)) ==
> -		    0xdeadbeef)
> +		u32 val;
> +
> +		val = radeon_read_ring_rptr(dev_priv, RADEON_SCRATCHOFF(1));
> +		if (val == 0xdeadbeef)
>  			break;
>  		DRM_UDELAY(1);
>  	}
> @@ -1540,7 +1585,7 @@ struct drm_buf *radeon_freelist_get(struct drm_device * dev)
>  	start = dev_priv->last_buf;
>  
>  	for (t = 0; t < dev_priv->usec_timeout; t++) {
> -		u32 done_age = GET_SCRATCH(1);
> +		u32 done_age = GET_SCRATCH(dev_priv, 1);
>  		DRM_DEBUG("done_age = %d\n", done_age);
>  		for (i = start; i < dma->buf_count; i++) {
>  			buf = dma->buflist[i];
> @@ -1574,8 +1619,9 @@ struct drm_buf *radeon_freelist_get(struct drm_device * dev)
>  	struct drm_buf *buf;
>  	int i, t;
>  	int start;
> -	u32 done_age = DRM_READ32(dev_priv->ring_rptr, RADEON_SCRATCHOFF(1));
> +	u32 done_age;
>  
> +	done_age = radeon_read_ring_rptr(dev_priv, RADEON_SCRATCHOFF(1));
>  	if (++dev_priv->last_buf >= dma->buf_count)
>  		dev_priv->last_buf = 0;
>  
> diff --git a/drivers/gpu/drm/radeon/radeon_drv.h b/drivers/gpu/drm/radeon/radeon_drv.h
> index c608e22..a253cf0 100644
> --- a/drivers/gpu/drm/radeon/radeon_drv.h
> +++ b/drivers/gpu/drm/radeon/radeon_drv.h
> @@ -160,10 +160,6 @@ enum radeon_chip_flags {
>  	RADEON_IS_IGPGART = 0x01000000UL,
>  };
>  
> -#define GET_RING_HEAD(dev_priv)	(dev_priv->writeback_works ? \
> -        DRM_READ32(  (dev_priv)->ring_rptr, 0 ) : RADEON_READ(RADEON_CP_RB_RPTR))
> -#define SET_RING_HEAD(dev_priv,val)	DRM_WRITE32( (dev_priv)->ring_rptr, 0, (val) )
> -
>  typedef struct drm_radeon_freelist {
>  	unsigned int age;
>  	struct drm_buf *buf;
> @@ -248,7 +244,6 @@ typedef struct drm_radeon_private {
>  	drm_radeon_freelist_t *head;
>  	drm_radeon_freelist_t *tail;
>  	int last_buf;
> -	volatile u32 *scratch;
>  	int writeback_works;
>  
>  	int usec_timeout;
> @@ -338,6 +333,12 @@ extern int radeon_no_wb;
>  extern struct drm_ioctl_desc radeon_ioctls[];
>  extern int radeon_max_ioctl;
>  
> +extern u32 radeon_get_ring_head(drm_radeon_private_t *dev_priv);
> +extern void radeon_set_ring_head(drm_radeon_private_t *dev_priv, u32 val);
> +
> +#define GET_RING_HEAD(dev_priv)	radeon_get_ring_head(dev_priv)
> +#define SET_RING_HEAD(dev_priv, val) radeon_set_ring_head(dev_priv, val)
> +
>  /* Check whether the given hardware address is inside the framebuffer or the
>   * GART area.
>   */
> @@ -639,9 +640,9 @@ extern int r300_do_cp_cmdbuf(struct drm_device *dev,
>  
>  #define RADEON_SCRATCHOFF( x )		(RADEON_SCRATCH_REG_OFFSET + 4*(x))
>  
> -#define GET_SCRATCH( x )	(dev_priv->writeback_works			\
> -				? DRM_READ32( dev_priv->ring_rptr, RADEON_SCRATCHOFF(x) ) \
> -				: RADEON_READ( RADEON_SCRATCH_REG0 + 4*(x) ) )
> +extern u32 radeon_get_scratch(drm_radeon_private_t *dev_priv, int index);
> +
> +#define GET_SCRATCH(dev_priv, x) radeon_get_scratch(dev_priv, x)
>  
>  #define RADEON_GEN_INT_CNTL		0x0040
>  #	define RADEON_CRTC_VBLANK_MASK		(1 << 0)
> diff --git a/drivers/gpu/drm/radeon/radeon_state.c b/drivers/gpu/drm/radeon/radeon_state.c
> index ef940a0..03fea43 100644
> --- a/drivers/gpu/drm/radeon/radeon_state.c
> +++ b/drivers/gpu/drm/radeon/radeon_state.c
> @@ -3010,14 +3010,14 @@ static int radeon_cp_getparam(struct drm_device *dev, void *data, struct drm_fil
>  		break;
>  	case RADEON_PARAM_LAST_FRAME:
>  		dev_priv->stats.last_frame_reads++;
> -		value = GET_SCRATCH(0);
> +		value = GET_SCRATCH(dev_priv, 0);
>  		break;
>  	case RADEON_PARAM_LAST_DISPATCH:
> -		value = GET_SCRATCH(1);
> +		value = GET_SCRATCH(dev_priv, 1);
>  		break;
>  	case RADEON_PARAM_LAST_CLEAR:
>  		dev_priv->stats.last_clear_reads++;
> -		value = GET_SCRATCH(2);
> +		value = GET_SCRATCH(dev_priv, 2);
>  		break;
>  	case RADEON_PARAM_IRQ_NR:
>  		value = drm_dev_to_irq(dev);

