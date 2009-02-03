Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbZBCWHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbZBCWHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 17:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbZBCWHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 17:07:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52755 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbZBCWHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 17:07:18 -0500
Message-ID: <4988C00A.2040904@redhat.com>
Date: Tue, 03 Feb 2009 16:07:06 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       t-sato@yk.jp.nec.com
Subject: Re: [PATCH V4] Allow SysRq emergency thaw to thaw frozen filesystems
References: <496EB639.6090800@redhat.com>	<4970E087.8020308@redhat.com>	<4970E4FB.7040407@redhat.com>	<20090130134009.02d4a576.akpm@linux-foundation.org>	<498779D6.7010304@redhat.com> <20090203140135.fe8360f6.akpm@linux-foundation.org>
In-Reply-To: <20090203140135.fe8360f6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 02 Feb 2009 16:55:18 -0600
> Eric Sandeen <sandeen@redhat.com> wrote:
> 
>> (this version fixes a couple small issues raised by Randy Dunlap)
>> (and adds sb_lock locking I forgot, as akpm pointed out)
>> (Randy's CONFIG_BLOCK fix should still apply over this)
> 
> <converts it to a delta so I can see what you did>

Sorry, didn't know if you want deltas on top of old patches or new
respun patches.  Guess now I know :)

> --- a/fs/buffer.c~allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-v4
> +++ a/fs/buffer.c
> @@ -263,11 +263,13 @@ void do_thaw_all(unsigned long unused)
>  	struct super_block *sb;
>  	char b[BDEVNAME_SIZE];
>  
> +	spin_lock(&sb_lock);
>  	list_for_each_entry(sb, &super_blocks, s_list) {
>  		while (sb->s_bdev && !thaw_bdev(sb->s_bdev, sb))
>  			printk(KERN_WARNING "Emergency Thaw on %s\n",
>  			       bdevname(sb->s_bdev, b));
>  	}
> +	spin_unlock(&sb_lock);
>  	printk(KERN_WARNING "Emergency Thaw complete\n");
>  }
>  
> _
> 
> 
> Can't call thaw_bdev() under spinlock.

Oh, sigh, I've come full circle to what I started with that didn't work,
didn't I.

> If we're going to do this, I think it will need the whole
> sb_lock/s_count/s_umount song-n-dance.
> 
> It's a pretty common operation.  What you want is, I think, identical
> to sync_supers(), only with one line changed.
> 
> so we could do
> 
> void apply_to_all_supers(void (fn)(struct super_block *))
> {
> 	struct super_block *sb;
> 
> 	spin_lock(&sb_lock);
> restart:
> 	list_for_each_entry(sb, &super_blocks, s_list) {
> 		if (sb->s_dirt) {
> 			sb->s_count++;
> 			spin_unlock(&sb_lock);
> 			down_read(&sb->s_umount);
> 			(*fn)(sb);
> 			up_read(&sb->s_umount);
> 			spin_lock(&sb_lock);
> 			if (__put_super_and_need_restart(sb))
> 				goto restart;
> 		}
> 	}
> 	spin_unlock(&sb_lock);
> 
> }
> 
> That isn't quite sufficient to use for get_super(), but I think it
> could be made so.
> 
> Ditto user_get_super().
> 
> Ditto do_emergency_remount()
> 
> But that's a separate little project for someone.  For the purposes of
> this patch I guess you could do yet another copy-n-paste.

Ok, thanks.  Sorry for dragging this out through 5 revisions :(

-Eric
