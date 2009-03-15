Return-Path: <linux-kernel-owner+w=401wt.eu-S1756594AbZCOSNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbZCOSNU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 14:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755972AbZCOSMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 14:12:46 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:27409 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754921AbZCOSMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 14:12:43 -0400
Message-ID: <49BD449C.8090301@panasas.com>
Date: Sun, 15 Mar 2009 20:10:36 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 5/8] exofs: dir_inode and directory operations
References: <49902A9E.3070002@panasas.com> <1234185853-7873-1-git-send-email-bharrosh@panasas.com> <20090215170840.GA18115@ioremap.net> <4999328B.8000705@panasas.com>
In-Reply-To: <4999328B.8000705@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Mar 2009 18:11:35.0094 (UTC) FILETIME=[79ED3D60:01C9A599]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> Evgeniy Polyakov wrote:
>> Hi.
>>
>> On Mon, Feb 09, 2009 at 03:24:13PM +0200, Boaz Harrosh (bharrosh@panasas.com) wrote:
>>
<snip>
> <snip>
>>> +
>>> +	atomic_inc(&inode->i_count);
>>> +
>>> +	ret = exofs_async_op(or, create_done, inode, oi->i_cred);
>>> +	if (ret) {
>>> +		atomic_dec(&inode->i_count);
>> igrab()/iput()?
>>
> 
> Thanks, makes much more sense. Sorry leftovers from 2.6.10
> 

It's the same at ext2. I looked at the igrab()/iput() code it does some extra
locks which I'm afraid of at this stage. I'll postpone this to the next (next)
merge window, after I ran with it for a while.

>>> +		osd_end_request(or);
>>> +		return ERR_PTR(-EIO);
>>> +	}
>>> +	atomic_inc(&sbi->s_curr_pending);
>>> +
>>> +	return inode;
>>> +}
>>> +static int exofs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
>>> +{
>>> +	struct inode *inode;
>>> +	int err = -EMLINK;
>>> +
>>> +	if (dir->i_nlink >= EXOFS_LINK_MAX)
>>> +		goto out;
>>> +
>>> +	inode_inc_link_count(dir);
>>> +
>>> +	inode = exofs_new_inode(dir, S_IFDIR | mode);
>>> +	err = PTR_ERR(inode);
>>> +	if (IS_ERR(inode))
>>> +		goto out_dir;
>>> +
>>> +	inode->i_op = &exofs_dir_inode_operations;
>>> +	inode->i_fop = &exofs_dir_operations;
>>> +	inode->i_mapping->a_ops = &exofs_aops;
>>> +
>>> +	inode_inc_link_count(inode);
>>> +
>>> +	err = exofs_make_empty(inode, dir);
>>> +	if (err)
>>> +		goto out_fail;
>>> +
>>> +	err = exofs_add_link(dentry, inode);
>>> +	if (err)
>>> +		goto out_fail;
>>> +
>>> +	d_instantiate(dentry, inode);
>>> +out:
>>> +	return err;
>>> +
>>> +out_fail:
>>> +	inode_dec_link_count(inode);
>>> +	inode_dec_link_count(inode);
>> Why two decrements, will it be ok after exofs_make_empty() fail when it
>> was incremented only once?
>>
> 
> That's hard to say, I'll investigate it some more.
> Thanks
> 

I've put some prints and current code is correct. inode->i_nlink (the target
of inode_dec_link_count()) is 1 after exofs_new_inode() and 2 after
inode_inc_link_count() (Just before exofs_make_empty()). Very confusing, but
exofs_add_link() does not touch inode->i_nlink.

I will be posting a new set tomorrow

Thanks
Boaz

