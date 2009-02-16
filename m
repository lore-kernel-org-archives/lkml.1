Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbZBPJ7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbZBPJ7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 04:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbZBPJ7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 04:59:25 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:50802 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbZBPJ7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 04:59:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cSK3USeBLXCdUWt3wwAwbz5BBvRfvF4QJU4qEDsxsxQjLYuE5SgGrxEgcSjuFbQ2Ph
         iQ6meCEi4XYFOOs+QBdLkg0+aONYDg5Fk1+0XQ9FXCzpmmJpC445nkfhMKktalY2rsGU
         9qs1o9n+a54WMJmuI7KOtzcDpYhJRJ3VcHI34=
Message-ID: <499938F2.7050301@panasas.com>
Date: Mon, 16 Feb 2009 11:59:14 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 6/8] exofs: super_operations and file_system_type
References: <49902A9E.3070002@panasas.com> <1234185953-7901-1-git-send-email-bharrosh@panasas.com> <20090215172443.GB18115@ioremap.net>
In-Reply-To: <20090215172443.GB18115@ioremap.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> Hi.
> 

Hi

> On Mon, Feb 09, 2009 at 03:25:53PM +0200, Boaz Harrosh (bharrosh@panasas.com) wrote:
>> +		case Opt_to:
>> +			if (match_int(&args[0], &option))
>> +				return -EINVAL;
>> +			if (option <= 0) {
>> +				EXOFS_ERR("Timout must be > 0");
>> +				return -EINVAL;
>> +			}
>> +			opts->timeout = option * HZ;
> 
> Is it intentional to be a different timeouton systems with different HX
> but the same mount option?
> 

Does not "option * HZ" means that "option" is in seconds?
Any way I would not bother, it is an undocumented option for debugging only.

>> +static struct inode *exofs_alloc_inode(struct super_block *sb)
>> +{
>> +	struct exofs_i_info *oi;
>> +
>> +	oi = kmem_cache_alloc(exofs_inode_cachep, GFP_KERNEL);
> 
> I'm curious if this should be GFP_NOFS or not?
> 

Currently none of the OSD transports, (Shhhh ... including osd initiator
library), are not SWAP safe.

I will revisit all that, far in the future, when I will need SWAPyness?

>> +	if (!oi)
>> +		return NULL;
>> +
>> +	oi->vfs_inode.i_version = 1;
>> +	return &oi->vfs_inode;
>> +}
> 
>> +static void exofs_put_super(struct super_block *sb)
>> +{
>> +	int num_pend;
>> +	struct exofs_sb_info *sbi = sb->s_fs_info;
>> +
>> +	/* make sure there are no pending commands */
>> +	for (num_pend = atomic_read(&sbi->s_curr_pending); num_pend > 0;
>> +	     num_pend = atomic_read(&sbi->s_curr_pending)) {
> 
> This rises a question. Let's check exofs_new_inode() for example (it is
> a bad example, since inode can not be created when we already in the
> put_super() callback, but still there are others), it increments
> s_curr_pending way after inode was created, so is it possible that
> some in-flight callback is about to be executed and its subsequent
> s_curr_pending manipulation will not be detected by this loop?
> 
> Should s_curr_pending increment be audited all over the code to be
> increased before the potential postponing command starts (which is not
> the case in exofs_new_inode() above)?
> 

I have experimented with this a bit in the passed. And did not find any
problems. To the best of my understanding, I'm somehow protected by the VFS.
If the FS is busy ie. file handles open. It will refuse an unmount. Once all
handles are closed, it will remove visibility from the FS and only then
unmount. So the loop above will only wait for old commands. Actually I put
prints in there and I never ever got a count of pending commands.

It is hard to test because it is hard to find the time slot after all file
handles are close, but with heavy pending IO, and before the umount kicks
in.

Also note that I've decided to fsync on file close so I think most/all IO
should be finished by the time a file is closed.

>> +		wait_queue_head_t wq;
>> +		init_waitqueue_head(&wq);
>> +		wait_event_timeout(wq,
>> +				  (atomic_read(&sbi->s_curr_pending) == 0),
>> +				  msecs_to_jiffies(100));
>> +	}
>> +
>> +	osduld_put_device(sbi->s_dev);
>> +	kfree(sb->s_fs_info);
>> +	sb->s_fs_info = NULL;
>> +}
> 

Thanks, I appreciate your comments, they make me think

Boaz
