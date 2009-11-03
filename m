Return-Path: <linux-kernel-owner+w=401wt.eu-S1750973AbZKCKBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750973AbZKCKBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 05:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbZKCKBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 05:01:47 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:46389 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZKCKBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 05:01:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sGJz9sP/D+knfjGLTJYHVENveb7+Bhj7TGaw+O0fhw9bqC4VU1JxbEQuXPffYGfTPw
         gmR/bBcPBQ3HppAztQ/3j0XfdcgaiVsg1CTBpd6ocKX/z2NklHTkWUs3n4C23D12b+Eb
         bJ/agnTxr0Rjz9lzq5ThX5LDGOtYPNiZjIdR0=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0911022157360.26157@cobra.newdream.net>
References: <Pine.LNX.4.64.0910302253100.1867@cobra.newdream.net>
	 <87bpjorn6g.fsf@openvz.org>
	 <Pine.LNX.4.64.0911022157360.26157@cobra.newdream.net>
Date: Tue, 3 Nov 2009 13:01:49 +0300
Message-ID: <c18d6aa20911030201s2d1b7eb7q8897a3943bd04fbb@mail.gmail.com>
Subject: Re: ext3/jbd oops in journal_start
From: Dmitry Monakhov <rjevskiy@gmail.com>
To: Sage Weil <sage@newdream.net>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/3 Sage Weil <sage@newdream.net>:
> On Sat, 31 Oct 2009, Dmitry Monakhov wrote:
>
>> Sage Weil <sage@newdream.net> writes:
>>
>> > Hi,
>> >
>> > I'm consistently seeing ext3 oops on a fresh ~60 GB fs on 2.6.32-rc3 (and
>> > 2.6.31).  data=writeback or data=ordered.  It's not the hardware or
>> > drive... I have 8 boxes (each with slightly different hardware) that crash
>> > identically.
>> Strange, 2.6.31 with ext3 is quite popular configuration...
>> Can you please post exact test-case.
>> >
>> > The oops is at fs/jbd/transaction.c, journal_start():
>> >
>> >             J_ASSERT(handle->h_transaction->t_journal == journal);
>> *handle = journal_current_handle()
>>
>> IMHO it's looks like you have entered here with current->journal_info != NULL
>>
>> , but journal_info contains unexpected data
>> This may happens in two cases:
>> 1) calling jbd code from other filesystem.
>> 2) Some fs forget to zero current->journal_info on exit from vfs
>> According to call trace we have got second case. Do you use some
>> unusual/experimental fs?
>
> Yep, it was #2.  It turns out btrfs s setting current->journal_info
> (for no reason that I can see?), and with the transaction ioctl a
> transaction can span multiple calls.
Whait a minute. Thats ioctl totally wrong! How it can prevent from problems?
issues:
1) If we are using this thechnic to preserving atomic behaviour, but
process dies unexpectedly in the midle of complex
operation which  must be done attomically. Then we call trans_end
which result in committing some internal file state.

2) What happens when second process try to touch file with opened
transaction? what behavuour expected from fsync?
process 1                                    process 2
1 fd = open("./file)                         open("./file")
2 ioctl_start_trans
3 write(fd, "a", 1)                           write(fd,"b", 1)
4                                                 fsync
5
What data do you expect after state (4), and after state (5)
>
> Chris, is it ok to just remove the journal_info bits?  Nothing in fs/btrfs
> even looks at it.  I'm not sure what the point of only conditionally
> setting/clearly journal_info would be either, unless it's for debugging or
> something?
>
> Thanks-
> sage
>
> ---
> From: Sage Weil <sage@newdream.net>
> Date: Mon, 2 Nov 2009 14:21:29 -0800
> Subject: [PATCH] Btrfs: don't set current->journal_info
>
> Btrfs doesn't use current->journal_info for anything, so don't set it.
> We currently cause a NULL dereference in jbd if a process starts a btrfs
> user transaction and then touches another mounted fs that uses jbd, since
> current->journal_info is only supposed to be set for the duration of a
> single call into the fs.

NAK The root of bad thing is ioctl patch.
If you really want to design external(from kernel point of view)
atomic interface then you have to use another
locking mechanism not transaction. Some thing like lock_flag. And it
must be stored on inode in order to provide
mutal exclusion for concurent task. Otherwise this mechanism is useless.
This patch just hide problem under a carpet. Actually setting
current->journal_info
is a good way to catch  fs to fs switching.
>
> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
>  fs/btrfs/transaction.c |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index bca82a4..c6dbbb8 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -186,9 +186,6 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
>        h->alloc_exclude_start = 0;
>        h->delayed_ref_updates = 0;
>
> -       if (!current->journal_info)
> -               current->journal_info = h;
> -
>        root->fs_info->running_transaction->use_count++;
>        record_root_in_trans(h, root);
>        mutex_unlock(&root->fs_info->trans_mutex);
> @@ -321,8 +318,6 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
>        put_transaction(cur_trans);
>        mutex_unlock(&info->trans_mutex);
>
> -       if (current->journal_info == trans)
> -               current->journal_info = NULL;
>        memset(trans, 0, sizeof(*trans));
>        kmem_cache_free(btrfs_trans_handle_cachep, trans);
>
> @@ -1105,9 +1100,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>
>        mutex_unlock(&root->fs_info->trans_mutex);
>
> -       if (current->journal_info == trans)
> -               current->journal_info = NULL;
> -
>        kmem_cache_free(btrfs_trans_handle_cachep, trans);
>        return ret;
>  }
> --
> 1.5.6.5
>
>
