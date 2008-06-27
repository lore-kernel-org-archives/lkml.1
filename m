Return-Path: <linux-kernel-owner+w=401wt.eu-S1764683AbYF0Xid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764683AbYF0Xid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 19:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761478AbYF0XiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 19:38:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:50066 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760525AbYF0XiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 19:38:18 -0400
From: Neil Brown <neilb@suse.de>
To: Andre Noll <maan@systemlinux.org>
Date: Sat, 28 Jun 2008 09:38:06 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18533.31198.932488.652568@notabene.brown>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 008 of 29] md: Close race in md_probe
In-Reply-To: message from Andre Noll on Friday June 27
References: <20080627164503.9671.patches@notabene>
	<1080627065010.10418@suse.de>
	<20080627122153.GE4981@skl-net.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday June 27, maan@systemlinux.org wrote:
> On 16:50, NeilBrown wrote:
> > 
> > There is a possible race in md_probe.  If two threads call md_probe
> > for the same device, then one could exit (having checked that
> > ->gendisk exists) before the other has called kobject_init_and_add,
> > thus returning an incomplete kobj which will cause problems when
> > we try to add children to it.
...
> 
> Even with this patch, md_probe() calls mddev_find() without holding
> the disks_mutex. Is this OK? If it isn't, something like the patch
> below might be necessary.

Thanks for looking at this and asking.

No, the below patch is not necessary.

mddev_find gets a reference on the mddev, so it cannot become stale.
md_probe does not return what it gets from mddev_find until getting
the disks_mutex lock and checking the contents, so it is sure to
return a good mddev.

Thanks,
NeilBrown



> 
> Andre
> ---
> 
> From: Andre Noll <maan@systemlinux.org>
> 
> Fix possible race in md_probe().
> 
> The current code calls mddev_find() without any locks held.  It might
> happen that mddev_find() succeeds but the returned mddev pointer
> becomes stale just before the disks_mutex is aquired.
> 
> So close the race by calling mddev_find() with the disks mutex held.
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 647395b..6cb8773 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3184,17 +3184,20 @@ static int mdp_major;
>  static struct kobject *md_probe(dev_t dev, int *part, void *data)
>  {
>  	static DEFINE_MUTEX(disks_mutex);
> -	mddev_t *mddev = mddev_find(dev);
> +	mddev_t *mddev;
>  	struct gendisk *disk;
>  	int partitioned = (MAJOR(dev) != MD_MAJOR);
>  	int shift = partitioned ? MdpMinorShift : 0;
>  	int unit = MINOR(dev) >> shift;
>  	int error;
>  
> -	if (!mddev)
> -		return NULL;
>  
>  	mutex_lock(&disks_mutex);
> +	mddev = mddev_find(dev);
> +	if (!mddev) {
> +		mutex_unlock(&disks_mutex);
> +		return NULL;
> +	}
>  	if (mddev->gendisk) {
>  		mutex_unlock(&disks_mutex);
>  		mddev_put(mddev);
> 
> -- 
> The only person who always got his work done by Friday was Robinson Crusoe
