Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbYKSTKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbYKSTKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 14:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbYKSTKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 14:10:30 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:28933 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbYKSTK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 14:10:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=s8bkSFHzMns7FyXzhwxQdcEMWUvPVCcpamSxoTA1klZJzRODviktolNRvlqS1jUwmB
         FkZ0mPmvC8R2yS916n50aPojL3WAX8iURnI9qXsn9vDWbwFAbwzLB6uk7p9Z5NKWb/Qr
         VuKNhUrWs9lKSU7TmR/r4IYmv9CQM4eQjJw+Y=
Message-ID: <cfd18e0f0811191110t792cc9a4i5869bee0fb3d759c@mail.gmail.com>
Date: Wed, 19 Nov 2008 14:10:26 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch] Fix type errors in inotify interfaces
Cc: lkml <linux-kernel@vger.kernel.org>, "Robert Love" <rlove@google.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Ulrich Drepper" <drepper@redhat.com>, john@johnmccutchan.com
In-Reply-To: <20081119000342.05b2de85.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4923230D.8090301@gmail.com>
	 <20081119000342.05b2de85.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Would be nice to see an Aacked-by from Robert or John on this patch.)

On Wed, Nov 19, 2008 at 3:03 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 18 Nov 2008 15:18:21 -0500 Michael Kerrisk <mtk.manpages@googlemail.com> wrote:
>
>> Andrew,
>>
>> Vegard reminded me of an issue with the inotify interface
>> that I raised quite a while ago, offlist, with Robert; Robert
>> acknowledged that things should be fixed, but then neither of
>> us actually did anything :-{.
>>
>> The problems lie in the types used for some inotify interfaces, both
>> at the kernel level and at the glibc level.  This mail addresses the
>> kernel problem.  I will follow up with some suggestions for glibc
>> changes.
>>
>> For the sys_inotify_rm_watch() interface, the type of the 'wd' argument
>> is currently 'u32', it should be '__s32' .  That is Robert's suggestion,
>> and is consistent with the other declarations of watch descriptors in
>> the kernel source, in particular, the inotify_event structure in
>> include/linux/inotify.h:
>>
>> struct inotify_event {
>>         __s32           wd;             /* watch descriptor */
>>         __u32           mask;           /* watch mask */
>>         __u32           cookie;         /* cookie to synchronize two events */
>>         __u32           len;            /* length (including nulls) of name */
>>         char            name[0];        /* stub for possible name */
>> };
>>
>> The patch below makes the changes needed for inotify_rm_watch().
>>
>> Thanks
>>
>> Michael
>>
>>
>> diff --git a/fs/inotify_user.c b/fs/inotify_user.c
>> index d367e9b..a71f764 100644
>> --- a/fs/inotify_user.c
>> +++ b/fs/inotify_user.c
>> @@ -704,7 +704,7 @@ fput_and_out:
>>       return ret;
>>  }
>>
>> -asmlinkage long sys_inotify_rm_watch(int fd, u32 wd)
>> +asmlinkage long sys_inotify_rm_watch(int fd, __s32 wd)
>>  {
>>       struct file *filp;
>>       struct inotify_device *dev;
>> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
>> index d6ff145..36983a5 100644
>> --- a/include/linux/syscalls.h
>> +++ b/include/linux/syscalls.h
>> @@ -550,7 +550,7 @@ asmlinkage long sys_inotify_init(void);
>>  asmlinkage long sys_inotify_init1(int flags);
>>  asmlinkage long sys_inotify_add_watch(int fd, const char __user *path,
>>                                       u32 mask);
>> -asmlinkage long sys_inotify_rm_watch(int fd, u32 wd);
>> +asmlinkage long sys_inotify_rm_watch(int fd, __s32 wd);
>>
>>  asmlinkage long sys_spu_run(int fd, __u32 __user *unpc,
>>                                __u32 __user *ustatus);
>

Yes -- there is no sane reason for a negative watch descriptor to
inotify_rm_watch(); this change is mainly about consistency.  (The
glibc change is probably more important.)

> otoh, the system call via which one _obtains_ watch descriptors most
> certainly wants to return -ve nunmbers, to signify errors.
>
> All too hard.  I think I'll stop thinking about it and merge the patch ;)

Thanks.

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
