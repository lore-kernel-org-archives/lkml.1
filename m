Return-Path: <linux-kernel-owner+w=401wt.eu-S1764376AbZE0TPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764376AbZE0TPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759442AbZE0TPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:15:24 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57096 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757202AbZE0TPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:15:23 -0400
Date: Wed, 27 May 2009 21:15:24 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v8
Message-ID: <20090527191524.GS11363@kernel.dk>
References: <1243417312-7444-1-git-send-email-jens.axboe@oracle.com> <20090527144754.GD10842@mit.edu> <20090527175353.GE10842@mit.edu> <20090527175830.GF10842@mit.edu> <20090527181402.GP11363@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527181402.GP11363@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27 2009, Jens Axboe wrote:
> On Wed, May 27 2009, Theodore Tso wrote:
> > On Wed, May 27, 2009 at 01:53:53PM -0400, Theodore Tso wrote:
> > > On Wed, May 27, 2009 at 10:47:54AM -0400, Theodore Tso wrote:
> > > > 
> > > > I'll retry the test with your stock writeback-v8 git branch w/o any
> > > > ext4 patches planned the next mere window mainline to see if I get the
> > > > same soft lockup, but I thought I should give you an early heads up.
> > > 
> > > Confirmed.  I had to run fsstress twice, but I was able to trigger a
> > > soft hangup with just the per-bdi v8 patches using ext4.
> > 
> > As you requested, here's the .config file which I used.  This was on a
> > Lenovo S10 (N270 Atom dual-core CPU, 1.5 gigs of memory, 5400 rpm hdd).
> 
> If you have time, can you rerun with this little patch? It moves the
> super sync to a separate thread. Thanks!
> 
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index f71588c..8b30f29 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -218,10 +218,14 @@ static __init int bdi_class_init(void)
>  }
>  postcore_initcall(bdi_class_init);
>  
> +static int bdi_sync_supers(void *unused);
> +
>  static int __init default_bdi_init(void)
>  {
>  	int err;
>  
> +	kthread_run(bdi_sync_supers, NULL, "bdi-super");
> +
>  	err = bdi_init(&default_backing_dev_info);
>  	if (!err)
>  		bdi_register(&default_backing_dev_info, NULL, "default");
> @@ -412,6 +416,20 @@ static void bdi_flush_io(struct backing_dev_info *bdi)
>  	generic_sync_bdi_inodes(NULL, &wbc);
>  }
>  
> +static int bdi_sync_supers(void *unused)
> +{
> +	while (!kthread_should_stop()) {
> +		schedule_timeout(dirty_expire_interval * 10);

Woops, that should be

                schedule_timeout(msecs_to_jiffies(dirty_expire_interval * 10));

of course, otherwise we sync quite a lot :-)

-- 
Jens Axboe

