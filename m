Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbYL0JUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbYL0JUL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 04:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbYL0JT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 04:19:58 -0500
Received: from proxy1.bredband.net ([195.54.101.71]:53458 "EHLO
	proxy1.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbYL0JT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 04:19:57 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Agg+AEuCVUnVQJ+/PGdsb2JhbACBbJF2AQEBATUBqSdYjxiGRA
Message-ID: <4955F338.4020509@zappa.cx>
Date: Sat, 27 Dec 2008 10:19:52 +0100
From: Andreas Sundstrom <sunkan@zappa.cx>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28 ext4, xen and lvm volume becomes ro after snapshot
References: <4954BAAB.9090108@zappa.cx> <20081226140721.GN9871@mit.edu> <4954FB62.4090306@zappa.cx> <20081226182145.GP9871@mit.edu> <495526F6.9040704@zappa.cx> <20081226193307.GA2138@mit.edu> <495553EB.6030604@zappa.cx> <20081227030632.GA3539@mit.edu>
In-Reply-To: <20081227030632.GA3539@mit.edu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Fri, Dec 26, 2008 at 11:00:11PM +0100, Andreas Sundstrom wrote:
>> But I enabled debugfs and did
>> "echo 3 > /sys/kernel/debug/jbd2/jbd2-debug" and reproduced the problem
>> by taking a snapshot while the system was live.
>> I hope this had the same effect as your proposed change.
> 
> Thanks, that was helpful.  Can you try applying this patch, and let me
> know whether the printk triggers?

No problem

> 
> What I'm guessing is going on is that on a native kernel, we get the
> ENOTSUPP error immediately when we call submit_bh().  However, with
> the Xen kernel, we aren't getting the error right away; we're either
> getting ENOTSUPP later on, when we call wait_on_buffer().  For ext3,
> this doesn't matter, since we call sync_dirty_buffer() which calls
> submit_bh() and wait_on_buffer() synchronously.  But ext4 doesn't use
> sync_dirty_buffer(), instead calling submit_bh() and wait_on_buffer()
> separately.
> 
> This patch should be able to confirm whether or not this supposition
> is correct.
> 
> 						- Ted
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index bd1fad0..630196d 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -174,9 +174,16 @@ static int journal_wait_on_commit_record(struct buffer_head *bh)
>  
>  	clear_buffer_dirty(bh);
>  	wait_on_buffer(bh);
> +	if (buffer_eopnotsupp(bh)) {
> +		printk("jbd2: journal_wait_on_commit_record: eopnotsupp\n");
> +		ret = sync_dirty_buffer(bh);
> +		printk("jbd2: sync_dirty_buffer returned %d\n", ret);
> +	}
>  
> -	if (unlikely(!buffer_uptodate(bh)))
> +	if (unlikely(!buffer_uptodate(bh))) {
> +		printk("jbd2: journal_wait_on_commit_record: not uptodate\n");
>  		ret = -EIO;
> +	}
>  	put_bh(bh);            /* One for getblk() */
>  	jbd2_journal_put_journal_head(bh2jh(bh));
>  

[   44.546636] blkfront: xvda1: write barrier op failed

[   44.546666] blkfront: xvda1: barriers disabled

[   44.546686] end_request: I/O error, dev xvda1, sector 5256

[   44.546710] end_request: I/O error, dev xvda1, sector 5256

[   44.548228] jbd2: journal_wait_on_commit_record: eopnotsupp

[   44.548251] jbd2: sync_dirty_buffer returned 0

[   44.548270] jbd2: journal_wait_on_commit_record: not uptodate

[   44.548293] Aborting journal on device xvda1:8.

More output here http://pastebin.com/m3694a25b
