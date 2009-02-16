Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbZBPJca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbZBPJca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 04:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbZBPJcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 04:32:20 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:57585 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbZBPJcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 04:32:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=F0McQ/y5qq7k5WlfjVhDiWbcqdPjxAQ9fNP64T6tisfTI2UGtqqAOJDlvsAxyN6e1K
         83EdmPE2T2uR0uFjSf1a1ipS1W2F2/zFGdhfUuIpcmY2CmmVAyCCgTempGr7ZWk4w6/5
         sxCiwZ7IxEm4FleK/YdP0A/ldOKz9C1AY+8Fc=
Message-ID: <4999328B.8000705@panasas.com>
Date: Mon, 16 Feb 2009 11:31:55 +0200
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
Subject: Re: [PATCH 5/8] exofs: dir_inode and directory operations
References: <49902A9E.3070002@panasas.com> <1234185853-7873-1-git-send-email-bharrosh@panasas.com> <20090215170840.GA18115@ioremap.net>
In-Reply-To: <20090215170840.GA18115@ioremap.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> Hi.
> 
> On Mon, Feb 09, 2009 at 03:24:13PM +0200, Boaz Harrosh (bharrosh@panasas.com) wrote:
> 
>> +void exofs_set_link(struct inode *dir, struct exofs_dir_entry *de,
>> +			struct page *page, struct inode *inode)
>> +{
>> +	loff_t pos = page_offset(page) +
>> +			(char *) de - (char *) page_address(page);
>> +	unsigned len = le16_to_cpu(de->rec_len);
>> +	int err;
>> +
>> +	lock_page(page);
>> +	err = exofs_write_begin(NULL, page->mapping, pos, len,
>> +				AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
>> +	BUG_ON(err);
> 
> How unfriendly :)
> simple_write_begin() may fail if there is no memory or appropriate
> cgroup does not allow to charge more memory.
> 

You are right on the money. I'll go and revisit all the BUGs and BUG_ONs
Thanks good catch.

>> +		unlock_page(page);
>> +		exofs_put_page(page);
>> +	}
>> +	BUG();
>> +	return -EINVAL;
>> +
> 
> So it will crash the system if directory entry does not contain any
> data? What was wrong with -EINVAL?
> 

Yes, thanks, will fix

> Also, dir_pages(), readpage_done() and similar functions scream for less
> generic names, and at least dir_pages() is already implemented in another
> 5 filesystems.
> 

I will fix that too. I thought I changed all these, I must have missed
a few.

We are so used to filesystems been loadable modules we never try to compile
a few in-kernel.

>> +int exofs_delete_entry(struct exofs_dir_entry *dir, struct page *page)
>> +{
>> +	struct address_space *mapping = page->mapping;
>> +	struct inode *inode = mapping->host;
>> +	struct exofs_sb_info *sbi = inode->i_sb->s_fs_info;
>> +	char *kaddr = page_address(page);
>> +	unsigned from = ((char *)dir - kaddr) & ~(exofs_chunk_size(inode)-1);
>> +	unsigned to = ((char *)dir - kaddr) + le16_to_cpu(dir->rec_len);
>> +	loff_t pos;
>> +	struct exofs_dir_entry *pde = NULL;
>> +	struct exofs_dir_entry *de = (struct exofs_dir_entry *) (kaddr + from);
>> +	int err;
>> +
>> +	while ((char *)de < (char *)dir) {
> 
> They have the same type, why is it needed to cast them to char pointer?
> 

Will fix, thanks

>> +		if (de->rec_len == 0) {
>> +			EXOFS_ERR("ERROR: exofs_delete_entry:"
>> +				"zero-length directory entry");
>> +			err = -EIO;
>> +			goto out;
>> +		}
>> +		pde = de;
>> +		de = exofs_next_entry(de);
>> +	}
>> +	if (pde)
>> +		from = (char *)pde - (char *)page_address(page);
>> +	pos = page_offset(page) + from;
>> +	lock_page(page);
>> +	err = exofs_write_begin(NULL, page->mapping, pos, to - from, 0,
>> +							&page, NULL);
>> +	BUG_ON(err);
> 
> Ugh, in the exofs_make_empty() it is handled without so visible
> pain.
> 

Yep, will fix

>> +	if (pde)
>> +		pde->rec_len = cpu_to_le16(to - from);
>> +	dir->inode_no = 0;
>> +	err = exofs_commit_chunk(page, pos, to - from);
>> +	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
>> +	mark_inode_dirty(inode);
>> +	sbi->s_numfiles--;
>> +out:
>> +	exofs_put_page(page);
>> +	return err;
>> +}

<snip>
>> +
>> +	atomic_inc(&inode->i_count);
>> +
>> +	ret = exofs_async_op(or, create_done, inode, oi->i_cred);
>> +	if (ret) {
>> +		atomic_dec(&inode->i_count);
> 
> igrab()/iput()?
> 

Thanks, makes much more sense. Sorry leftovers from 2.6.10

>> +		osd_end_request(or);
>> +		return ERR_PTR(-EIO);
>> +	}
>> +	atomic_inc(&sbi->s_curr_pending);
>> +
>> +	return inode;
>> +}
> 
>> +static int exofs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
>> +{
>> +	struct inode *inode;
>> +	int err = -EMLINK;
>> +
>> +	if (dir->i_nlink >= EXOFS_LINK_MAX)
>> +		goto out;
>> +
>> +	inode_inc_link_count(dir);
>> +
>> +	inode = exofs_new_inode(dir, S_IFDIR | mode);
>> +	err = PTR_ERR(inode);
>> +	if (IS_ERR(inode))
>> +		goto out_dir;
>> +
>> +	inode->i_op = &exofs_dir_inode_operations;
>> +	inode->i_fop = &exofs_dir_operations;
>> +	inode->i_mapping->a_ops = &exofs_aops;
>> +
>> +	inode_inc_link_count(inode);
>> +
>> +	err = exofs_make_empty(inode, dir);
>> +	if (err)
>> +		goto out_fail;
>> +
>> +	err = exofs_add_link(dentry, inode);
>> +	if (err)
>> +		goto out_fail;
>> +
>> +	d_instantiate(dentry, inode);
>> +out:
>> +	return err;
>> +
>> +out_fail:
>> +	inode_dec_link_count(inode);
>> +	inode_dec_link_count(inode);
> 
> Why two decrements, will it be ok after exofs_make_empty() fail when it
> was incremented only once?
> 

That's hard to say, I'll investigate it some more.
Thanks

>> +	iput(inode);
>> +out_dir:
>> +	inode_dec_link_count(dir);
>> +	goto out;
>> +}
> 

Most valuable input, thank you for taking the time to review.

Boaz
