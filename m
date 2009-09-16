Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbZIPIUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbZIPIUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 04:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbZIPIUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 04:20:32 -0400
Received: from mail-qy0-f192.google.com ([209.85.221.192]:40893 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbZIPIU3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 04:20:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SaGfeoSjp7bAYaUhIBH+FkOz9hkQ0b1Y/VduQAqPJW0PZ/T2ZDPjE+SJZUuXivKKFq
         m2KpUnkmPu4QC72gE5IVDiMuxdkyD4P3VA5YaSoZ3+nVNZQuLQA3k+5ZTNQz5swAGtut
         nDWPhV72GyOnxkqwdT2fjw9/idRbhDzPvvp2M=
MIME-Version: 1.0
In-Reply-To: <20090916142956.9998ba71.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090914032901.GA16189@localhost>
	 <20090915165852.032d164f.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090916142956.9998ba71.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 16 Sep 2009 16:20:32 +0800
Message-ID: <2375c9f90909160120u151b0449x2eac665080a3ae82@mail.gmail.com>
Subject: Re: [RFC][PATCH][bugfix] more checks for negative f_pos handling (Was 
	Re: Question: how to handle too big f_pos
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, viro@zeniv.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       oleg@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 1:29 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> The problem:
>> I'm writing a patch against /dev/kmem...I found a problem.
>>
>> /dev/kmem (and /proc/<pid>/mem) puts virtual addres to f->f_pos.
>>
>> but f->f_pos is always negative and rw_verify_ara() returns -EINVAL always.
>
> Changed CC: List.
>
> This is a trial to consider how to fix negative f_pos problem shown in above.
>
> Hmm, even after this patch, x86's vsyscall area is not readable.
> ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0  [vsyscall]
> But maybe no problems. (now, it cannot be read, anyway.)
>
> I tested /dev/kmem on x86-64 and this works fine. I added a fix for
> /proc/<pid>/mem because I know ia64's hugetlbe area is not readable
> via /proc/<pid>/mem. (But I'm not sure other 64bit arch has this
> kind of problems in /proc/<pid>/mem)
>
> ==
> From: KAMEZAWA Hiruyoki <kamezawa.hiroyu@jp.fujitsu.com>
>
> Modifying rw_verify_area()'s negative f_pos check.
>
> Now, rw_verify_area() has this check
>   if (unlikely((pos < 0) || (loff_t) (pos + count) < 0))
>                return -EINVAL
>
> And access to special files as /dev/mem,kmem, /proc/<pid>/mem
> returns unexpected -EINVAL.
> (For example, ia64 maps hugetlb at 0x8000000000000000- region)
>
> This patch tries to make range check more precise by using
> llseek ops defined per special files.
>
> Signed-off-by: KAMEZAWA Hiruyoki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  fs/proc/base.c  |   22 +++++++++++++++++-----
>  fs/read_write.c |   39 +++++++++++++++++++++++++++++++++++++--
>  2 files changed, 54 insertions(+), 7 deletions(-)
>
> Index: mmotm-2.6.31-Sep14/fs/read_write.c
> ===================================================================
> --- mmotm-2.6.31-Sep14.orig/fs/read_write.c
> +++ mmotm-2.6.31-Sep14/fs/read_write.c
> @@ -205,6 +205,37 @@ bad:
>  }
>  #endif
>
> +static int
> +__verify_negative_pos_range(struct file *file, loff_t pos, size_t count)
> +{
> +       unsigned long long upos, end;
> +       loff_t ret;
> +
> +       /* disallow overflow */
> +       upos = (unsigned long long)pos;
> +       end = upos + count;
> +       if (end < pos)
> +               return -EOVERFLOW;
> +       /*
> +        * Sanity check...subsystem has to provide llseek for handle big pos.
> +        * Subsystem's llseek should verify f_pos's value comaparing with its
> +        * max file size.
> +        * Note1: generic file ops' llseek cannot handle negative pos.
> +        * Note2: should we take care of pos == -EINVAL ?
> +        * Note3: we check flags and ops here for avoiding taking locks in.
> +        * default_lseek.
> +        */
> +       ret = -EINVAL;
> +       if ((file->f_mode & FMODE_LSEEK) &&
> +           (file->f_op && file->f_op->llseek)) {
> +               ret = vfs_llseek(file, 0, SEEK_CUR);
> +               if (ret == pos)
> +                       return 0;
> +       }
> +
> +       return (int)ret;
> +}
> +
>  /*
>  * rw_verify_area doesn't like huge counts. We limit
>  * them to something that fits in "int" so that others
> @@ -222,8 +253,12 @@ int rw_verify_area(int read_write, struc
>        if (unlikely((ssize_t) count < 0))
>                return retval;
>        pos = *ppos;
> -       if (unlikely((pos < 0) || (loff_t) (pos + count) < 0))
> -               return retval;
> +       if (unlikely((pos < 0) || (loff_t) (pos + count) < 0)) {
> +               /* some files requires special care */
> +               retval = __verify_negative_pos_range(file, pos, count);
> +               if (retval)
> +                       return retval;
> +       }
>
>        if (unlikely(inode->i_flock && mandatory_lock(inode))) {
>                retval = locks_mandatory_area(
> Index: mmotm-2.6.31-Sep14/fs/proc/base.c
> ===================================================================
> --- mmotm-2.6.31-Sep14.orig/fs/proc/base.c
> +++ mmotm-2.6.31-Sep14/fs/proc/base.c
> @@ -903,18 +903,30 @@ out_no_task:
>
>  loff_t mem_lseek(struct file *file, loff_t offset, int orig)
>  {
> +       struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
> +       unsigned long long new_offset = -EINVAL;


Why not make 'new_offset' as loff_t? This can make your code easier.

> +
> +       if (!task) /* lseek's spec doesn't allow -ESRCH but... */


No worry, we have many ESRCH for proc files.

> +               return -ESRCH;
> +
>        switch (orig) {
>        case 0:
> -               file->f_pos = offset;
> +               new_offset = offset;
>                break;
>        case 1:
> -               file->f_pos += offset;
> +               new_offset = (unsigned long long)f->f_pos + offset;
>                break;
>        default:
> -               return -EINVAL;
> +               new_offset = -EINVAL;
> +               break;
>        }
> -       force_successful_syscall_return();
> -       return file->f_pos;
> +       if (new_offset < (unsigned long long)TASK_SIZE_OF(task)) {


Hmm, why this check?

> +               file->f_pos = (loff_t)new_offset;
> +               force_successful_syscall_return();
> +       } else
> +               new_offset = -EINVAL;
> +       put_task_struct(task);
> +       return (loff_t)new_offset;
>  }
>
>  static const struct file_operations proc_mem_operations = {

Thanks.
