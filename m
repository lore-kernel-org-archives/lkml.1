Return-Path: <linux-kernel-owner+w=401wt.eu-S934262AbYETWWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934262AbYETWWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761333AbYETWWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:22:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:17010 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760251AbYETWWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:22:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MMkmrVMSB0IXMUe2h2sVgRqAB+08ilcYVMCYmEbdoFJHEh1qo+eDylAXmEtuJLMaLzDIHqMj1sS5By0xyPM0JFZG1ikVGnxyCtZy0H1NcMxwvd1mjETp/cyEfW4F+hnipuUW+hIy919vyS/10F4KokLMGPJGm/RqVLmgbTFCIu4=
Message-ID: <7b9198260805201522u43befee7m5d1b02e030e1c993@mail.gmail.com>
Date: Tue, 20 May 2008 23:22:06 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: [RFC PATCH] Introduce filesystem type tracking
Cc: "Christoph Hellwig" <hch@infradead.org>,
       "Al Viro" <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080520220029.GR2638@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1211196126-7442-1-git-send-email-tspink@gmail.com>
	 <7b9198260805200606u6ebc2681o8af7a8eebc1cb96@mail.gmail.com>
	 <20080520134306.GA28946@ZenIV.linux.org.uk>
	 <20080520135732.GA30349@infradead.org>
	 <7b9198260805200818v687fc495nb7db5ffd6c8b6ba1@mail.gmail.com>
	 <20080520153456.GN2638@parisc-linux.org>
	 <7b9198260805200836q6b9ad5f0x3b42c8f6c933fa21@mail.gmail.com>
	 <7b9198260805201408q6089a600g458dcab80b87951a@mail.gmail.com>
	 <20080520220029.GR2638@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/20 Matthew Wilcox <matthew@wil.cx>:
> On Tue, May 20, 2008 at 10:08:04PM +0100, Tom Spink wrote:
>> I've taken some more time to go over the locking semantics.  I wrote a
>> quick toy filesystem to simulate delays, blocking, memory allocation,
>> etc in the init and exit routines - and with an appropriately large
>> amount of printk's everywhere, I saw a quite a few interleavings.
>>
>> I *think* I may have got it right, but please, let me know what you
>> think!  The only thing that I think may be wrong with this patch is
>> the
>> spin_lock/unlock at the end of sget, where the superblock is
>> list_add_tailed into the super_blocks list.  I believe this opens the
>> possibility for the same superblock being list_add_tailed twice... can
>> anyone else see this code-path, and is it a problem?
>
> Hi Tom,

Hi Matthew,

> I spotted one definite bug; on failure, you leave the superblock on
> the super_blocks list.

I spotted this while I was coding, and I was careful not to let it get
added to the list...  If the ->init routine fails, the superblock
hasn't even been added to the list yet.  The patch moves this line:

list_add_tail(&s->s_list, &super_blocks);

Down to after the ->init call.

> Your locking may well be correct, but it has the hallmarks of being "a bit
> tricky" and a bit tricky means potentially buggy.  How about doing the
> nesting the other way round, ie take the mutex first, then the spinlock?

Thanks for the suggestion!

> The code needs a bit of tweaking because you don't want to put the
> superblock on any list where it can be found until it's fully
> initialised.  This may not be quite right:
>
>> +     mutex_lock(&type->fs_supers_lock);
>>       spin_lock(&sb_lock);
>>       /* should be initialized for __put_super_and_need_restart() */
>>       list_del_init(&sb->s_list);
>>       list_del(&sb->s_instances);
>>       spin_unlock(&sb_lock);
>> +
>> +     if (list_empty(&type->fs_supers) && type->exit)
>> +             type->exit();
>> +     mutex_unlock(&type->fs_supers_lock);
>> +
>>       up_write(&sb->s_umount);
>>  }
>>

I'll definitely give it a go.

> sget is a little more complex ... the fs_supers_lock would need to be
> dropped in a lot more places than I've shown here:
>
> @@ -365,11 +372,31 @@ retry:
>  retry:
> +       mutex_lock(&type->fs_supers_lock);
>        spin_lock(&sb_lock);
>
>                destroy_super(s);
>                return ERR_PTR(err);
>        }
>        s->s_type = type;
>        strlcpy(s->s_id, type->name, sizeof(s->s_id));
> +       if (list_empty(&type->fs_supers) && type->init) {
> +               spin_unlock(&sb_lock);
> +               err = type->init();
> +               if (err) {
> +                       mutex_unlock(&type->fs_supers_lock);
> +                       destroy_super(s);
> +                       return ERR_PTR(err);
> +               }
> +               spin_lock(&sb_lock);
> +       }
>        list_add_tail(&s->s_list, &super_blocks);
>        list_add(&s->s_instances, &type->fs_supers);
>        spin_unlock(&sb_lock);
> +       mutex_unlock(&type->fs_supers_lock);
>        get_filesystem(type);
>        return s;
> }

I had something similar earlier, but I thought it started to look
slightly messy when I discovered that dropping the spinlock would lead
to a racey ->init... but I hadn't thought of putting the mutex outside
the spinlock; the mutex protecting ->init and ->exit (I was getting
caught up in trying not to go to sleep inside a spinlock)

Thanks!
-- 
Tom Spink
