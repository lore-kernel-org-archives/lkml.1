Return-Path: <linux-kernel-owner+w=401wt.eu-S934176AbYETWAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934176AbYETWAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757635AbYETWAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:00:32 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:53244 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbYETWAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:00:31 -0400
Date: Tue, 20 May 2008 16:00:29 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Tom Spink <tspink@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] Introduce filesystem type tracking
Message-ID: <20080520220029.GR2638@parisc-linux.org>
References: <1211196126-7442-1-git-send-email-tspink@gmail.com> <7b9198260805200606u6ebc2681o8af7a8eebc1cb96@mail.gmail.com> <20080520134306.GA28946@ZenIV.linux.org.uk> <20080520135732.GA30349@infradead.org> <7b9198260805200818v687fc495nb7db5ffd6c8b6ba1@mail.gmail.com> <20080520153456.GN2638@parisc-linux.org> <7b9198260805200836q6b9ad5f0x3b42c8f6c933fa21@mail.gmail.com> <7b9198260805201408q6089a600g458dcab80b87951a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b9198260805201408q6089a600g458dcab80b87951a@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 10:08:04PM +0100, Tom Spink wrote:
> I've taken some more time to go over the locking semantics.  I wrote a
> quick toy filesystem to simulate delays, blocking, memory allocation,
> etc in the init and exit routines - and with an appropriately large
> amount of printk's everywhere, I saw a quite a few interleavings.
> 
> I *think* I may have got it right, but please, let me know what you
> think!  The only thing that I think may be wrong with this patch is
> the
> spin_lock/unlock at the end of sget, where the superblock is
> list_add_tailed into the super_blocks list.  I believe this opens the
> possibility for the same superblock being list_add_tailed twice... can
> anyone else see this code-path, and is it a problem?

Hi Tom,

I spotted one definite bug; on failure, you leave the superblock on
the super_blocks list.

Your locking may well be correct, but it has the hallmarks of being "a bit
tricky" and a bit tricky means potentially buggy.  How about doing the
nesting the other way round, ie take the mutex first, then the spinlock?

The code needs a bit of tweaking because you don't want to put the
superblock on any list where it can be found until it's fully
initialised.  This may not be quite right:

> +	mutex_lock(&type->fs_supers_lock);
>  	spin_lock(&sb_lock);
>  	/* should be initialized for __put_super_and_need_restart() */
>  	list_del_init(&sb->s_list);
>	list_del(&sb->s_instances);
>  	spin_unlock(&sb_lock);
> +
> +	if (list_empty(&type->fs_supers) && type->exit)
> +		type->exit();
> +	mutex_unlock(&type->fs_supers_lock);
> +	
>  	up_write(&sb->s_umount);
>  }
> 

sget is a little more complex ... the fs_supers_lock would need to be
dropped in a lot more places than I've shown here:

@@ -365,11 +372,31 @@ retry:
 retry:
+	mutex_lock(&type->fs_supers_lock);
 	spin_lock(&sb_lock);
	
 		destroy_super(s);
 		return ERR_PTR(err);
 	}
 	s->s_type = type;
 	strlcpy(s->s_id, type->name, sizeof(s->s_id));
+	if (list_empty(&type->fs_supers) && type->init) {
+		spin_unlock(&sb_lock);
+		err = type->init();
+		if (err) {
+			mutex_unlock(&type->fs_supers_lock);
+			destroy_super(s);
+			return ERR_PTR(err);
+		}
+		spin_lock(&sb_lock);
+	}
 	list_add_tail(&s->s_list, &super_blocks);
 	list_add(&s->s_instances, &type->fs_supers);
 	spin_unlock(&sb_lock);
+	mutex_unlock(&type->fs_supers_lock);
 	get_filesystem(type);
 	return s;
}

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
