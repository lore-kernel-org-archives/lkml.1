Return-Path: <linux-kernel-owner+w=401wt.eu-S1753714AbZGXSAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbZGXSAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 14:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbZGXSAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 14:00:48 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:55863 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbZGXSAr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 14:00:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fGWfSWWjyl9g2Wcd6EDBo9XBl76gxVmHlL68C2jYdzSjYBw7nigjS0zfY3RtMsDWZT
         3JhNevN8LRK0mHM+0WL4D04IvWQUd3xbaa6Hz+q/iGcPjPjmKN0Mba+Q4i1tHFAnKMQr
         2T5ZhysZEvbaywgjcbKMeAuIo/35gkplze81c=
MIME-Version: 1.0
In-Reply-To: <20090724083926.GA6372@cr0.nay.redhat.com>
References: <4A693122.6060503@gmail.com>
	 <20090724083926.GA6372@cr0.nay.redhat.com>
Date: Fri, 24 Jul 2009 11:00:46 -0700
Message-ID: <7928e7bd0907241100n5bcef0d8nff0e769f19070ebb@mail.gmail.com>
Subject: Re: [PATCH 1/1] pagemap clear_refs: modify to specify anon or mapped 
	vma clearing
From: Moussa Ba <moussa.a.ba@gmail.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       adobriyan@gmail.com, mpm@selenic.com, mel@csn.ul.ie, yinghan@google.com,
       npiggin@suse.de, jaredeh@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 1:39 AM, Amerigo Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Thu, Jul 23, 2009 at 08:57:22PM -0700, Moussa A. Ba wrote:
> >
> > Signed-off-by: Jared E. Hulbert <jaredeh@gmail.com>
> > Signed-off-by: Moussa Ba <moussa.a.ba@gmail.com>
> > --- a/fs/proc/task_mmu.c      2009-07-21 14:30:01.000000000 -0700
> > +++ b/fs/proc/task_mmu.c      2009-07-21 14:32:56.000000000 -0700
> > @@ -461,6 +461,33 @@
> >       cond_resched();
> >       return 0;
> >  }
> > +static void walk_vma_area(struct mm_walk *this_walk, struct
> > vm_area_struct *vma,
> > +                                             int type)
> > +{
> > +     switch (type) {
> > +             /* Clear Anon VMAs only */
> > +     case 1:
> > +             if (!is_vm_hugetlb_page(vma) && !vma->vm_file)
> > +                     walk_page_range(vma->vm_start,
> > +                                     vma->vm_end,
> > +                                     this_walk);
> > +             break;
> > +             /* Clear Mapped VMAs only */
> > +     case 2:
> > +             if (!is_vm_hugetlb_page(vma) && vma->vm_file)
> > +                     walk_page_range(vma->vm_start,
> > +                                     vma->vm_end,
> > +                                     this_walk);
> > +             break;
> > +             /* Clear All VMAs */
> > +     default:
> > +             if (!is_vm_hugetlb_page(vma))
> > +                     walk_page_range(vma->vm_start,
> > +                                     vma->vm_end,
> > +                                     this_walk);
> > +             break;
> > +     }
> > +}
> >
>
>
> First, can you make these plain numbers as macros or enum types?
>
> Second, I believe the above code can be simiplified, how about below?


>
> {
>    if (!is_vm_hugetlb_page(vma)) {
>        if (type == 1 && vma->vm_file)
>             return;
>        if (type == 2 && !vma->vm_file)
>             return;
>        walk_page_range(vma->vm_start, vma->end, this_walk);
>    }
> }
>


It would indeed work, it can probably be written as:

{
	if (is_vm_hugetlb_page(vma))
    	    return;
       	if (type == 2 && vma->vm_file)
	    return;
	if (type == 3 && !vma->vm_file)
	    return;
	walk_page_range(vma->vm_start, vma->vm_end, this_walk);

}

The change in numbers also addresses Matt's concern that writing a 1 is the
default behavior where all vmas are cleared, hence it is better to not break
that and make the selective clearing options 2 and 3. There is no
documentation for clear_refs beyond a 1 liner that states "Clears page
referenced bits shown in smaps output".  I will also update the Documentation
and add it to the patch.




>
>
> >  static ssize_t clear_refs_write(struct file *file, const char __user *
> > buf,
> >                               size_t count, loff_t * ppos)
> > @@ -469,13 +496,15 @@
> >       char buffer[PROC_NUMBUF], *end;
> >       struct mm_struct *mm;
> >       struct vm_area_struct *vma;
> > +     int type;
> >
> >       memset(buffer, 0, sizeof(buffer));
> >       if (count > sizeof(buffer) - 1)
> >               count = sizeof(buffer) - 1;
> >       if (copy_from_user(buffer, buf, count))
> >               return -EFAULT;
> > -     if (!simple_strtol(buffer, &end, 0))
> > +     type = simple_strtol(buffer, &end, 0);
> > +     if (!type)
> >               return -EINVAL;
> >       if (*end == '\n')
> >               end++;
> > @@ -491,9 +520,7 @@
> >               down_read(&mm->mmap_sem);
> >               for (vma = mm->mmap; vma; vma = vma->vm_next) {
> >                       clear_refs_walk.private = vma;
> > -                     if (!is_vm_hugetlb_page(vma))
> > -                             walk_page_range(vma->vm_start, vma->vm_end,
> > -                                             &clear_refs_walk);
> > +                     walk_vma_area(&clear_refs_walk, vma, type);
> >               }
> >               flush_tlb_mm(mm);
> >               up_read(&mm->mmap_sem);
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
