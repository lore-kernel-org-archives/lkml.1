Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbZABI3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbZABI3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 03:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbZABI3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 03:29:09 -0500
Received: from proxy3.bredband.net ([195.54.101.73]:57397 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbZABI3I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 03:29:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al9HAKNeXUlR4F8bPGdsb2JhbACBbJIGAQEBATUBtWqFcg
Message-ID: <20090102092902.6p7echfdgkos40ss@zappa.cx>
Date: Fri, 02 Jan 2009 09:29:02 +0100
From: Andreas Sundstrom <sunkan@zappa.cx>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28 ext4, xen and lvm volume becomes ro after snapshot
References: <4954BAAB.9090108@zappa.cx> <20081226140721.GN9871@mit.edu>
	<4954FB62.4090306@zappa.cx> <20081226182145.GP9871@mit.edu>
	<495526F6.9040704@zappa.cx> <20081226193307.GA2138@mit.edu>
	<495553EB.6030604@zappa.cx> <20081227030632.GA3539@mit.edu>
	<4955F338.4020509@zappa.cx> <20090102031110.GF17821@mit.edu>
In-Reply-To: <20090102031110.GF17821@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Theodore Tso <tytso@mit.edu>:

> Can you try this patch?  This should (hopefully!) allow you to mount
> ext4 in a Xen guest without needing to explicitly disable barriers.
> If it works, it's what I plan to push to Linus.
>
>          	     	       	      	      	 - Ted
>
> jbd2: Add barrier not supported test to journal_wait_on_commit_record
>
> Xen doesn't report that barriers are not supported until buffer I/O is
> reported as completed, instead of when the buffer I/O is submitted.
> Add a check and a fallback codepath to journal_wait_on_commit_record()
> to detect this case, so that attempts to mount ext4 filesystems on
> LVM/devicemapper devices on Xen guests don't blow up with an "Aborting
> journal on device XXX"; "Remounting filesystem read-only" error.
>
> Thanks to Andreas Sundstrom for reporting this issue.
>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index bd1fad0..4b87547 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -25,6 +25,7 @@
>  #include <linux/crc32.h>
>  #include <linux/writeback.h>
>  #include <linux/backing-dev.h>
> +#include <linux/bio.h>
>
>  /*
>   * Default IO end handler for temporary BJ_IO buffer_heads.
> @@ -168,12 +169,34 @@ static int   
> journal_submit_commit_record(journal_t *journal,
>   * This function along with journal_submit_commit_record
>   * allows to write the commit record asynchronously.
>   */
> -static int journal_wait_on_commit_record(struct buffer_head *bh)
> +static int journal_wait_on_commit_record(journal_t *journal,
> +					 struct buffer_head *bh)
>  {
>  	int ret = 0;
>
> +retry:
>  	clear_buffer_dirty(bh);
>  	wait_on_buffer(bh);
> +	if (buffer_eopnotsupp(bh) && (journal->j_flags & JBD2_BARRIER)) {
> +		printk(KERN_WARNING
> +		       "JBD2: wait_on_commit_record: sync failed on %s - "
> +		       "disabling barriers\n", journal->j_devname);
> +		spin_lock(&journal->j_state_lock);
> +		journal->j_flags &= ~JBD2_BARRIER;
> +		spin_unlock(&journal->j_state_lock);
> +
> +		lock_buffer(bh);
> +		clear_buffer_dirty(bh);
> +		set_buffer_uptodate(bh);
> +		bh->b_end_io = journal_end_buffer_io_sync;
> +
> +		ret = submit_bh(WRITE_SYNC, bh);
> +		if (ret) {
> +			unlock_buffer(bh);
> +			return ret;
> +		}
> +		goto retry;
> +	}
>
>  	if (unlikely(!buffer_uptodate(bh)))
>  		ret = -EIO;
> @@ -802,7 +825,7 @@ wait_for_iobuf:
>  			__jbd2_journal_abort_hard(journal);
>  	}
>  	if (!err && !is_journal_aborted(journal))
> -		err = journal_wait_on_commit_record(cbh);
> +		err = journal_wait_on_commit_record(journal, cbh);
>
>  	if (err)
>  		jbd2_journal_abort(journal, err);
>

Well, the patch didn't work when I did "patch -i ext4.patch -p1" but I  
did it manually and the code compiles and works fine.
Here are the ext4 related kernel messages:

[    0.147721] EXT4-fs warning (device xvda1): ext4_fill_super:  
extents feature not enabled on this filesystem, use tune2fs.
[    0.148744] EXT4-fs: barriers enabled
[    0.158109] kjournald2 starting.  Commit interval 5 seconds
[    0.158131] EXT4-fs: delayed allocation enabled
[    0.158224] EXT4-fs: mballoc enabled
[    0.158235] EXT4-fs: mounted filesystem with ordered data mode.
[    0.158262] VFS: Mounted root (ext4 filesystem) readonly.
[    3.403818] EXT4 FS on xvda1, internal journal on xvda1:8
[    7.800623] blkfront: xvda1: write barrier op failed
[    7.800640] blkfront: xvda1: barriers disabled
[    7.800651] end_request: I/O error, dev xvda1, sector 4384
[    7.800664] end_request: I/O error, dev xvda1, sector 4384
[    7.800690] JBD2: wait_on_commit_record: sync failed on xvda1:8 -  
disabling barriers

# cat /proc/mounts |grep ext4
/dev/root / ext4 rw,noatime,barrier=1,noextents,data=ordered 0 0

/Andreas
