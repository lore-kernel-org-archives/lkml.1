Return-Path: <linux-kernel-owner+w=401wt.eu-S1757785AbYAFNUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785AbYAFNUG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 08:20:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbYAFNTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 08:19:55 -0500
Received: from lazybastard.de ([212.112.238.170]:34650 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbYAFNTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 08:19:54 -0500
Date: Sun, 6 Jan 2008 14:13:43 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org, peterz@infradead.org,
       mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block2mtd lockdep_init_map warning
Message-ID: <20080106131343.GA3120@lazybastard.org>
References: <200801060717.m067HW6c030422@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801060717.m067HW6c030422@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe it is not obvious that I maintain this driver and would like to be
kept on Cc:.  Will send a patch to fix that shortly.

On Sun, 6 January 2008 02:17:32 -0500, Erez Zadok wrote:
> 
> Hi David,
> 
> I've reported before a lockdep warning when block2mtd is modloaded, and a
> device is initialized, as in
> 
> 	modprobe block2mtd block2mtd=/dev/loop0
> 
> A typical warning looks like this:
> 
> BUG: key f88565c0 not in .data!
> WARNING: at kernel/lockdep.c:2331 lockdep_init_map()
> Pid: 1823, comm: modprobe Not tainted 2.6.24-rc6-unionfs2 #135
>  [<c02038c0>] show_trace_log_lvl+0x1a/0x2f
>  [<c02042bb>] show_trace+0x12/0x14
>  [<c0204a01>] dump_stack+0x6c/0x72
>  [<c022edf0>] lockdep_init_map+0x94/0x374
>  [<c022e79d>] debug_mutex_init+0x2c/0x3c
>  [<c0229bb0>] __mutex_init+0x38/0x40
>  [<f885520d>] 0xf885520d
>  [<c0226816>] parse_args+0x121/0x1fb
>  [<c0237aaf>] sys_init_module+0x10e8/0x1576
>  [<c0202836>] sysenter_past_esp+0x5f/0xa5
>  =======================
> 
> This is a long-standing problem I've seen in several of the latest stable
> kernels.  Once lockdep turns itself off, there's no easy way to turn it back
> on short of a reboot.
> 
> I looked more closely at the mtd code.  I believe the problem is that
> lockdep doesn't like a mutex_init to be called from a module_init code path,
> possibly because the module's symbols aren't all initialized yet.  (This
> could arguably be considered a limitation of lockdep.)
> 
> So I tried to defer the call to module_init until it's absolutely needed.  I
> couldn't find a clean way to do that via the struct mtd_info ops (there's no
> suitable ->init op), so instead I used an int to mark whether the mutex is
> initialized or not.  Below is a patch.  It works, but it's not as clean as
> it should be: a better way would be to probably add an mtd_info ->init op or
> so.
> 
> At least with this patch, lockdep doesn't complain any longer, so I can run
> a clean set of regression tests w/ unionfs on top of jffs2 and other file
> systems.
> 
> In lieu of a better fix, is this patch acceptable?

Not for me.  I don't mind if you keep such a hack until a proper
solution if found in your private tree.  But it is a horrible solution
to a problem introduced elsewhere.

Ingo, Peter, does either of you actually care about this problem?  In
the last round when I debugged this problem there was a notable lack of
reaction from either of you.

> block2mtd: defer mutex initialization to avoid a lockdep warning
> 
> Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
> 
> diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
> index be4b994..2c6d3e7 100644
> --- a/drivers/mtd/devices/block2mtd.c
> +++ b/drivers/mtd/devices/block2mtd.c
> @@ -32,6 +32,7 @@ struct block2mtd_dev {
>  	struct list_head list;
>  	struct block_device *blkdev;
>  	struct mtd_info mtd;
> +	int mutex_initialized;
>  	struct mutex write_mutex;
>  };
>  
> @@ -85,6 +86,11 @@ static int block2mtd_erase(struct mtd_info *mtd, struct erase_info *instr)
>  	size_t len = instr->len;
>  	int err;
>  
> +	if (!dev->mutex_initialized) {
> +		mutex_init(&dev->write_mutex);
> +		dev->mutex_initialized = 1;
> +	}
> +
>  	instr->state = MTD_ERASING;
>  	mutex_lock(&dev->write_mutex);
>  	err = _block2mtd_erase(dev, from, len);
> @@ -194,6 +200,11 @@ static int block2mtd_write(struct mtd_info *mtd, loff_t to, size_t len,
>  	struct block2mtd_dev *dev = mtd->priv;
>  	int err;
>  
> +	if (!dev->mutex_initialized) {
> +		mutex_init(&dev->write_mutex);
> +		dev->mutex_initialized = 1;
> +	}
> +
>  	if (!len)
>  		return 0;
>  	if (to >= mtd->size)
> @@ -275,8 +286,6 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
>  		goto devinit_err;
>  	}
>  
> -	mutex_init(&dev->write_mutex);
> -
>  	/* Setup the MTD structure */
>  	/* make the name contain the block device in */
>  	dev->mtd.name = kmalloc(sizeof("block2mtd: ") + strlen(devname),
> 
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/

Jörn

-- 
Joern's library part 13:
http://www.chip-architect.com/
