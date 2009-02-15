Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbZBORZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbZBORZO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 12:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbZBORY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 12:24:58 -0500
Received: from cs-studio.ru ([195.178.208.66]:50972 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbZBORY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 12:24:57 -0500
Date: Sun, 15 Feb 2009 20:24:43 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 6/8] exofs: super_operations and file_system_type
Message-ID: <20090215172443.GB18115@ioremap.net>
References: <49902A9E.3070002@panasas.com> <1234185953-7901-1-git-send-email-bharrosh@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234185953-7901-1-git-send-email-bharrosh@panasas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, Feb 09, 2009 at 03:25:53PM +0200, Boaz Harrosh (bharrosh@panasas.com) wrote:
> +static int parse_options(char *options, struct exofs_mountopt *opts)
> +{
> +	char *p;
> +	substring_t args[MAX_OPT_ARGS];
> +	int option;
> +	bool s_pid = false;
> +
> +	EXOFS_DBGMSG("parse_options %s\n", options);
> +	/* defaults */
> +	memset(opts, 0, sizeof(*opts));
> +	opts->timeout = BLK_DEFAULT_SG_TIMEOUT;
> +
> +	while ((p = strsep(&options, ",")) != NULL) {
> +		int token;
> +		char str[32];
> +
> +		if (!*p)
> +			continue;
> +
> +		token = match_token(p, tokens, args);
> +		switch (token) {
> +		case Opt_pid:
> +			if (0 == match_strlcpy(str, &args[0], sizeof(str)))
> +				return -EINVAL;
> +			opts->pid = simple_strtoull(str, NULL, 0);
> +			if (opts->pid < EXOFS_MIN_PID) {
> +				EXOFS_ERR("Partition ID must be >= %u",
> +					  EXOFS_MIN_PID);
> +				return -EINVAL;
> +			}
> +			s_pid = 1;
> +			break;
> +		case Opt_to:
> +			if (match_int(&args[0], &option))
> +				return -EINVAL;
> +			if (option <= 0) {
> +				EXOFS_ERR("Timout must be > 0");
> +				return -EINVAL;
> +			}
> +			opts->timeout = option * HZ;

Is it intentional to be a different timeouton systems with different HX
but the same mount option?

> +static struct inode *exofs_alloc_inode(struct super_block *sb)
> +{
> +	struct exofs_i_info *oi;
> +
> +	oi = kmem_cache_alloc(exofs_inode_cachep, GFP_KERNEL);

I'm curious if this should be GFP_NOFS or not?

> +	if (!oi)
> +		return NULL;
> +
> +	oi->vfs_inode.i_version = 1;
> +	return &oi->vfs_inode;
> +}

> +static void exofs_put_super(struct super_block *sb)
> +{
> +	int num_pend;
> +	struct exofs_sb_info *sbi = sb->s_fs_info;
> +
> +	/* make sure there are no pending commands */
> +	for (num_pend = atomic_read(&sbi->s_curr_pending); num_pend > 0;
> +	     num_pend = atomic_read(&sbi->s_curr_pending)) {

This rises a question. Let's check exofs_new_inode() for example (it is
a bad example, since inode can not be created when we already in the
put_super() callback, but still there are others), it increments
s_curr_pending way after inode was created, so is it possible that
some in-flight callback is about to be executed and its subsequent
s_curr_pending manipulation will not be detected by this loop?

Should s_curr_pending increment be audited all over the code to be
increased before the potential postponing command starts (which is not
the case in exofs_new_inode() above)?

> +		wait_queue_head_t wq;
> +		init_waitqueue_head(&wq);
> +		wait_event_timeout(wq,
> +				  (atomic_read(&sbi->s_curr_pending) == 0),
> +				  msecs_to_jiffies(100));
> +	}
> +
> +	osduld_put_device(sbi->s_dev);
> +	kfree(sb->s_fs_info);
> +	sb->s_fs_info = NULL;
> +}

-- 
	Evgeniy Polyakov
