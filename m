Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbYLIQ07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbYLIQ07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 11:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYLIQ0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 11:26:51 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:37945 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbYLIQ0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 11:26:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Ojh9aXBjLSbB0QSyJwO/sl4Mf9fNmeHkZBIkdljV3Z385j0wKi1D+OP9il/7TJMs+X
         dwOmJ5V2u5R9YkPtKSxpdyNPeDl115B5Zb5fER/7VwwYnBuBO53Rl3wbi8Jbzp0lcjjU
         NQEKqz62jNooUAxwY5/fvKAESPXuRWObCnytA=
Message-ID: <e9e943910812090820h3cc63b5dtb767a8a11ee2bad2@mail.gmail.com>
Date: Tue, 9 Dec 2008 16:20:43 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "Boaz Harrosh" <bharrosh@panasas.com>
Subject: Re: Checking link targets are NULL-terminated
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <493E8F31.3040806@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081205144810.GA25585@dastardly.home.dghda.com>
	 <493E8F31.3040806@panasas.com>
X-Google-Sender-Auth: 25ebb92a8e75a542
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boaz, thanks for your review and comments...

2008/12/9 Boaz Harrosh <bharrosh@panasas.com>:
>> diff --git a/fs/ext2/symlink.c b/fs/ext2/symlink.c
>> index 4e2426e..9b01af2 100644
>> --- a/fs/ext2/symlink.c
>> +++ b/fs/ext2/symlink.c
>> @@ -24,8 +24,14 @@
>>  static void *ext2_follow_link(struct dentry *dentry, struct nameidata *nd)
>>  {
>>       struct ext2_inode_info *ei = EXT2_I(dentry->d_inode);
>> -     nd_set_link(nd, (char *)ei->i_data);
>> -     return NULL;
>> +     void *err = NULL;
>> +
>> +     if (memchr(ei->i_data, 0, sizeof(ei->i_data)) == NULL)
>> +             err = ERR_PTR(-ENAMETOOLONG);
>> +     else
>> +             nd_set_link(nd, (char *)ei->i_data);
>> +
>> +     return err;
>>  }
>
> Here (Like below) Just zero the very last byte in the buffer.
> The first time this buffer was strcpy to, it was including the null terminated
> string. then written to inode on disk. When read, at most it could be,
> is as space allocated at inode (including null). If intentionally damaged, the symlink
> will be corrupted but Kernel is safe.

I considered this approach. Filesystems that allocate buffers for the
name (e.g. XFS) already tend to unconditionally NULL-terminate it, so
this is a non-issue for them. However others (including ext2) do not
allocate a buffer, instead pointing to the in-memory data representing
the on-disk data. If we NULL-terminate in those cases the in-memory
and on-disk data would differ. If the kernel writes out the data for
some other reason (say after updating atime) then we may
unintentionally modify the link target. That may not be a serious
problem in practice, but it doesn't feel right.

However, if the FS maintainers don't have a problem with it, it will
certainly be cleaner and easier to implement than scanning. Opinions?

[snip]

> I hit this problem too, while developing a filesystem that was based
> on ext2. The reason that it works is because the remainder of a page is always
> Zero'ed out on writes. Then when read, you receive back your zero terminated link.
> (Which means that if you have a symlink exactly 4k it will BUG but I guess
> that is not possible).

It is not possible for an uncorrupted symlink :)

> The solution is to use the i_size information for the string length, and zero
> terminate at i_size + 1.
>
> The way I fixed it is that I Zero out the last page's remainder on read and not
> on write like ext2 and other do it. (A symlink is less then 4k, right?)

Right. If PATH_MAX is larger than PAGE_SIZE no doubt all sorts of
things would start going horribly wrong.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
