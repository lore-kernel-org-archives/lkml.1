Return-Path: <linux-kernel-owner+w=401wt.eu-S935782AbYD1PPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935782AbYD1PPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935386AbYD1PO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:14:27 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:54839 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935560AbYD1POZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:14:25 -0400
Date: Mon, 28 Apr 2008 16:14:11 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Michael Abbott <michael@araneidae.co.uk>
Cc: linux-net@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DM9000: Restore MII physical polling timer.
Message-ID: <20080428151411.GF16284@fluff.org.uk>
References: <20080424095217.P51356@saturn.araneidae.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424095217.P51356@saturn.araneidae.co.uk>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 10:12:59AM +0000, Michael Abbott wrote:
> From: Michael Abbott <michael.abbott@diamond.ac.uk>
>
> DM9000: Restore MII physical polling timer.
>
> In commit fcfa81aa3e8d885356139122fcb281487b983468 the timer for polling the
> MII physical layer was removed because of conflicts with newly added mutexes.
> Unfortunately a side effect of this change is that the corresponding ethernet
> layer is permanently reported as down: there is no other way to read the link
> status.
>
> This commit restores the timer, but uses the default work queue for polling.

I've already submitted a similar patch to netdev@vger.kernel.org

> Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
> ---
>  drivers/net/dm9000.c |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
>
> This patch is against 2.6.25, and has been tested with the Colibri PXA270 
> board (patch follows separately).
>
> diff --git a/drivers/net/dm9000.c b/drivers/net/dm9000.c
> index d63cc93..9ad9499 100644
> --- a/drivers/net/dm9000.c
> +++ b/drivers/net/dm9000.c
> @@ -43,6 +43,7 @@
>  /* Board/System/Debug information/definition ---------------- */
>
>  #define DM9000_PHY		0x40	/* PHY address 0x01 */
> +#define DM9000_TIMER_WUT	(HZ*2)	/* timer wakeup time : 2 second */
>
>  #define CARDNAME "dm9000"
>  #define PFX CARDNAME ": "
> @@ -117,6 +118,8 @@ typedef struct board_info {
>
>  	struct mutex	 addr_lock;	/* phy and eeprom access lock */
>
> +	struct delayed_work timer;	/* Interface status timer. */
> +
>  	spinlock_t lock;
>
>  	struct mii_if_info mii;
> @@ -144,6 +147,7 @@ static int dm9000_start_xmit(struct sk_buff *, struct net_device *);
>  static int dm9000_stop(struct net_device *);
>  static int dm9000_ioctl(struct net_device *dev, struct ifreq *req, int cmd);
>
> +static void dm9000_timer(struct work_struct * work);
>  static void dm9000_init_dm9000(struct net_device *);
>
>  static irqreturn_t dm9000_interrupt(int, void *);
> @@ -762,6 +766,10 @@ dm9000_open(struct net_device *dev)
>  	mii_check_media(&db->mii, netif_msg_link(db), 1);
>  	netif_start_queue(dev);
>
> +	/* Start the media status timer running. */
> +	INIT_DELAYED_WORK(&db->timer, dm9000_timer);
> +	schedule_delayed_work(&db->timer, DM9000_TIMER_WUT);
> +
>  	return 0;
>  }
>
> @@ -876,6 +884,9 @@ dm9000_stop(struct net_device *ndev)
>  {
>  	board_info_t *db = (board_info_t *) ndev->priv;
>
> +	/* Delete the timer and make sure it's not running right now! */
> +	cancel_delayed_work_sync(&db->timer);
> +
>  	if (netif_msg_ifdown(db))
>  		dev_dbg(db->dev, "shutting down %s\n", ndev->name);
>
> @@ -965,6 +976,16 @@ dm9000_interrupt(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
>
> +
> +/* Two second timer to poll the media status -- the DM9000 doesn't provide a
> + * status interrupt, so this has to be polled. */
> +static void dm9000_timer(struct work_struct * work)
> +{
> +	board_info_t *db = container_of(work, board_info_t, timer);
> +	mii_check_media(&db->mii, netif_msg_link(db), 0);
> +	schedule_delayed_work(&db->timer, DM9000_TIMER_WUT);
> +}
> +
>  struct dm9000_rxhdr {
>  	u8	RxPktReady;
>  	u8	RxStatus;
> -- 
> 1.5.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
