Return-Path: <linux-kernel-owner+w=401wt.eu-S932664AbXDAGUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbXDAGUt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 02:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932697AbXDAGUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 02:20:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:38538 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932664AbXDAGUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 02:20:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EMzhLRGSgC+t2FsHEeRVmToWXEGThk+zcWUeGBzfFWqtCzvIQdh7AI2/eOzwycmrZPw/EdVklqR6imvKsG0W9MxyJVtzPJ0H96uxFiBug8lQ+ePUq9fRRLQCQuuY7dA9hyQIZh9NjMrGvCb1zxoBtEKYTkkTuC1bPbqD6+WDhnc=
Message-ID: <2375c9f90703312320m3e895bbap735c2d49da9d5ff9@mail.gmail.com>
Date: Sun, 1 Apr 2007 14:20:46 +0800
From: "Cong WANG" <xiyou.wangcong@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: [-mm3 patch]Warning fix: check the return value of kobject_add etc.
In-Reply-To: <20070331223136.6019d98f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2375c9f90703301930k4963168u4ba4dbc4c43ce2ee@mail.gmail.com>
	 <20070331223136.6019d98f.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/4/1, Andrew Morton <akpm@linux-foundation.org>:
> On Sat, 31 Mar 2007 10:30:31 +0800 "Cong WANG" <xiyou.wangcong@gmail.com> wrote:
>
> > Since kobject_add, sysfs_create_link and sysfs_create_file are marked
> > as '__must_check', so we must always check their return values, or gcc
> > will give us warnings.
> >
> > Signed-off-by: Cong WANG <xiyou.wangcong@gmail.com>
> >
> > ---
> > --- fs/partitions/check.c.orig        2007-03-30 21:35:45.000000000 +0800
> > +++ fs/partitions/check.c     2007-03-30 21:49:53.000000000 +0800
> > @@ -385,10 +385,16 @@ void add_partition(struct gendisk *disk,
> >       p->kobj.parent = &disk->kobj;
> >       p->kobj.ktype = &ktype_part;
> >       kobject_init(&p->kobj);
> > -     kobject_add(&p->kobj);
> > +     if (kobject_add(&p->kobj)) {
> > +             kfree(p);
> > +             return;
> > +     }
> >       if (!disk->part_uevent_suppress)
> >               kobject_uevent(&p->kobj, KOBJ_ADD);
> > -     sysfs_create_link(&p->kobj, &block_subsys.kset.kobj, "subsystem");
> > +     if (sysfs_create_link(&p->kobj, &block_subsys.kset.kobj, "subsystem")) {
> > +             kfree(p);
> > +             return;
> > +     }
> >       if (flags & ADDPART_FLAG_WHOLEDISK) {
> >               static struct attribute addpartattr = {
> >                       .name = "whole_disk",
> > @@ -396,7 +402,10 @@ void add_partition(struct gendisk *disk,
> >                       .owner = THIS_MODULE,
> >               };
> >
> > -             sysfs_create_file(&p->kobj, &addpartattr);
> > +             if (sysfs_create_file(&p->kobj, &addpartattr)) {
> > +                     kfree(p);
> > +                     return;
> > +             }
> >       }
> >       partition_sysfs_add_subdir(p);
> >       disk->part[part-1] = p;
>
> Well yes, but the point here it to fix kernel bugs, not to just make the
> warnings go away.
>
> The bugs here are that the effects of the kobject_add() and the
> sysfs_create_link() are not undone on the error path.

Thanks for your point.

>
> Also, please always prepare patches in `patch -p1' form, as per
> http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt, thanks.
>
>

Sorry. I am confused with this. Does that mean I should make patches
_upon_ the root kernel source directory or first make a copy of the
original source code and then diff against the two dirs? But I was
told that "patches should be based _in_ the root kernel source
directory" and when only one file was modified just to diff it with
the original single file. (See Documentation/SubmittingPatches.)

Can you help out? And should I remake this patch? Thanks again!
