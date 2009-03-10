Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbZCJSQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbZCJSQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 14:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbZCJSQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 14:16:07 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:10128 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbZCJSQG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 14:16:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Xui2svX65WV2wWzSywBFb0WkmlUVuCW4vz5Rjn13POT+cbbBK4r8QsDvvH6/TV4Gdt
         Qf0sNPKM1+F9OzvwNElYFTyKoznQlj0jUpha/NtLgMyos7mGIsP3Pz5b+41ucFQKKWVY
         PBJkALia2Bc3YwLiW+UqujZi9ciDq0pKgl+E0=
MIME-Version: 1.0
In-Reply-To: <49B62FF2.7020607@gmail.com>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com>
	 <1236661850-8237-2-git-send-email-stoyboyker@gmail.com>
	 <49B62FF2.7020607@gmail.com>
Date: Tue, 10 Mar 2009 13:16:02 -0500
Message-ID: <6d291e080903101116i32f13c33nf272e4adafc32477@mail.gmail.com>
Subject: Re: [PATCH 01/25] [btrfs] BUG to BUG_ON changes
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: davidjonx@gmail.com
Cc: linux-kernel@vger.kernel.org, chris.mason@oracle.com,
       linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 4:16 AM, David John <davidjonx@gmail.com> wrote:
> Stoyan Gaydarov wrote:
>> Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
>> ---
>>  fs/btrfs/ctree.c            |    3 +--
>>  fs/btrfs/extent-tree.c      |    3 +--
>>  fs/btrfs/free-space-cache.c |    3 +--
>>  fs/btrfs/tree-log.c         |    3 +--
>>  4 files changed, 4 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>> index 37f31b5..2c590b0 100644
>> --- a/fs/btrfs/ctree.c
>> +++ b/fs/btrfs/ctree.c
>> @@ -2174,8 +2174,7 @@ static int insert_ptr(struct btrfs_trans_handle *trans, struct btrfs_root
>>       BUG_ON(!path->nodes[level]);
>>       lower = path->nodes[level];
>>       nritems = btrfs_header_nritems(lower);
>> -     if (slot > nritems)
>> -             BUG();
>> +     BUG_ON(slot > nritems);
>>       if (nritems == BTRFS_NODEPTRS_PER_BLOCK(root))
>>               BUG();
>
> ^ You seem to have missed one.

Actually that one was left on purpose because BUG_ON calls are not to
have any side effects and I do not know enough about btrfs to know
what BTRFS_NODEPTRS_PER_BLOCK does so it was left as is.

>
>>       if (slot != nritems) {
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 9abf81f..0314ab6 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -672,8 +672,7 @@ static noinline int insert_extents(struct btrfs_trans_handle *trans,
>>                                             keys+i, data_size+i, total-i);
>>               BUG_ON(ret < 0);
>>
>> -             if (last && ret > 1)
>> -                     BUG();
>> +             BUG_ON(last && ret > 1);
>>
>>               leaf = path->nodes[0];
>>               for (c = 0; c < ret; c++) {
>> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
>> index d1e5f0e..b0c7661 100644
>> --- a/fs/btrfs/free-space-cache.c
>> +++ b/fs/btrfs/free-space-cache.c
>> @@ -267,8 +267,7 @@ static int __btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
>>  out:
>>       if (ret) {
>>               printk(KERN_ERR "btrfs: unable to add free space :%d\n", ret);
>> -             if (ret == -EEXIST)
>> -                     BUG();
>> +             BUG_ON(ret == -EEXIST);
>>       }
>>
>>       kfree(alloc_info);
>> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
>> index 9c462fb..2c892f6 100644
>> --- a/fs/btrfs/tree-log.c
>> +++ b/fs/btrfs/tree-log.c
>> @@ -1150,8 +1150,7 @@ insert:
>>       ret = insert_one_name(trans, root, path, key->objectid, key->offset,
>>                             name, name_len, log_type, &log_key);
>>
>> -     if (ret && ret != -ENOENT)
>> -             BUG();
>> +     BUG_ON(ret && ret != -ENOENT);
>>       goto out;
>>  }
>>
>
>

-- 

-Stoyan
