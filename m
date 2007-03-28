Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbXC1Hf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbXC1Hf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 03:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbXC1Hf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 03:35:28 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:15680 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbXC1Hf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 03:35:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Jynhiy1BiQMtLsI0e89SdCt3m2sjl0aOkm+EDX5YBk8vFmNtLYO4cNHobDjhuT7IZL98TNqK3HucKxMxc9OE37CJIH5+kriR07f5hrt73/VYrZ8tyc7VOB47SjxsdKbk5ab6xiFobyi7dBvIuIvCAmiGCnEHiWY7zy+Yt3DEpFc=
Message-ID: <ca992f110703280035p7d113f43ob87ffcf40c7c6f90@mail.gmail.com>
Date: Wed, 28 Mar 2007 16:35:25 +0900
From: "junjie cai" <junjiec@gmail.com>
To: "Xin Zhao" <uszhaoxin@gmail.com>
Subject: Re: Linux page cache issue?
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <4ae3c140703272345y3b3cb3cexf4c4b63e0035d5b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4ae3c140703272345y3b3cb3cexf4c4b63e0035d5b9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

generic_forget_inode() don't call trancate_inode_pages() if FS is still active
see the 10449 line below:

1040 static void generic_forget_inode(struct inode *inode)
1041 {
1042         struct super_block *sb = inode->i_sb;
1043
1044         if (!hlist_unhashed(&inode->i_hash)) {
1045                 if (!(inode->i_state & (I_DIRTY|I_LOCK)))
1046                         list_move(&inode->i_list, &inode_unused);
1047                 inodes_stat.nr_unused++;
1048                 spin_unlock(&inode_lock);
1049                 if (!sb || (sb->s_flags & MS_ACTIVE))
1050                         return;
1051                 write_inode_now(inode, 1);
1052                 spin_lock(&inode_lock);
1053                 inodes_stat.nr_unused--;
1054                 hlist_del_init(&inode->i_hash);
1055         }
1056         list_del_init(&inode->i_list);
1057         list_del_init(&inode->i_sb_list);
1058         inode->i_state|=I_FREEING;
1059         inodes_stat.nr_inodes--;
1060         spin_unlock(&inode_lock);
1061         if (inode->i_data.nrpages)
1062                 truncate_inode_pages(&inode->i_data, 0);
1063         clear_inode(inode);
1064         destroy_inode(inode);
1065


On 3/28/07, Xin Zhao <uszhaoxin@gmail.com> wrote:
> Hi,
>
> If a Linux process opens and reads a file A, then it closes the file.
> Will Linux keep the file A's data in cache for a while in case another
> process opens and reads the same in a short time? I think that is what
> I heard before.
>
> But after I digged into the kernel code, I am confused.
>
> When a process closes the file A, iput() will be called, which in turn
> calls the follows two functions:
> iput_final()->generic_drop_inode()
>
> But from the following calling chain, we can see that file close will
> eventually lead to evict and free all cached pages. Actually in
> truncate_complete_page(), the pages will be freed.  This seems to
> imply that Linux has to re-read the same data from disk even if
> another process B read the same file right after process A closes the
> file. That does not make sense to me.
>
> /***calling chain ***/
> generic_delete_inode/generic_forget_inode()->
> truncate_inode_pages()->truncate_inode_pages_range()->
> truncate_complete_page()->remove_from_page_cache()->
> __remove_from_page_cache()->radix_tree_delete()
>
> Am I missing something? Can someone please provide some advise?
>
> Thanks a lot
> -x
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
