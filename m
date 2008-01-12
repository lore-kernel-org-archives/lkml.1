Return-Path: <linux-kernel-owner+w=401wt.eu-S1763490AbYALMSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763490AbYALMSI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 07:18:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761684AbYALMRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 07:17:55 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:48366 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761564AbYALMRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 07:17:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QpmodYqas9wJNNFFrHYRYCpkXseveLmOnHcs3TsJvFrtm3eqGsG6LQGmsjBAoldBDAvPB/vT5Nxe8xMCoctyq9QmS9789y6DRzjcv4UYWKDgGAT1/6qxXdpfAsaIEp/XeIHyWlC4mB/U/q5ZsVZFkw5V1lFMr7PaaqHhotuSVPA=
Message-ID: <4df4ef0c0801120417g762e15b2r767a07cabb89319f@mail.gmail.com>
Date: Sat, 12 Jan 2008 15:17:54 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/2][RFC][BUG] msync: updating ctime and mtime at syncing
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com
In-Reply-To: <1200130565.7999.8.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1200006638.19293.42.camel@codedot>
	 <1200012249.20379.2.camel@codedot> <1200130565.7999.8.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/12, Peter Zijlstra <a.p.zijlstra@chello.nl>:
>
> On Fri, 2008-01-11 at 03:44 +0300, Anton Salikhmetov wrote:
>
> > +/*
> > + * Update the ctime and mtime stamps after checking if they are to be updated.
> > + */
> > +void mapped_file_update_time(struct file *file)
> > +{
> > +     if (test_and_clear_bit(AS_MCTIME, &file->f_mapping->flags)) {
> > +             get_file(file);
> > +             file_update_time(file);
> > +             fput(file);
> > +     }
> > +}
> > +
>
> I don't think you need the get/put file stuff here, because
>
> > @@ -87,6 +87,8 @@ long do_fsync(struct file *file, int datasync)
> >               goto out;
> >       }
> >
> > +     mapped_file_update_time(file);
> > +
> >       ret = filemap_fdatawrite(mapping);
> >
> >       /*
>
> at this call-site we already hold an extra reference on the file, and
>
> > @@ -74,14 +79,17 @@ asmlinkage long sys_msync(unsigned long start, size_t len, int flags)
> >                       break;
> >               }
> >               file = vma->vm_file;
> > -             if ((flags & MS_SYNC) && file && (vma->vm_flags & VM_SHARED)) {
> > -                     get_file(file);
> > -                     up_read(&mm->mmap_sem);
> > -                     error = do_fsync(file, 0);
> > -                     fput(file);
> > -                     if (error)
> > -                             return error;
> > -                     down_read(&mm->mmap_sem);
> > +             if (file && (vma->vm_flags & VM_SHARED)) {
> > +                     mapped_file_update_time(file);
> > +                     if (flags & MS_SYNC) {
> > +                             get_file(file);
> > +                             up_read(&mm->mmap_sem);
> > +                             error = do_fsync(file, 0);
> > +                             fput(file);
> > +                             if (error)
> > +                                     return error;
> > +                             down_read(&mm->mmap_sem);
> > +                     }
> >               }
> >
> >               start = vma->vm_end;
>
> here we hold the mmap_sem so the vma reference on the file can't go
> away.

These get_file() and fput() calls were in the sys_msync() function form before
all my changes. I did not add them here.

>
>
