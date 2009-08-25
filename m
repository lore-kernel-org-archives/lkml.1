Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbZHYFjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbZHYFjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 01:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbZHYFjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 01:39:41 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:34141 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbZHYFjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 01:39:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=Eh8y2kWUzvVkvQH0AE4YSay2MfWFcqO80ojyyuAaZP0TJUWkF9A6BBigaPdQ/DA3sq
         h9V7UsdgnJu3UHZnNIepHXHc7Em8baD6gIgpj6fMioZEyv20NaEPVQgJoK3ENenPozbT
         PkCLAjzbfQ7GJ1ZFNJSFBzyHUDdFNLMgWoV2o=
Date: Tue, 25 Aug 2009 14:39:12 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Hiroaki Wakabayashi <primulaelatior@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Ying Han <yinghan@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [PATCH] mm: make munlock fast when mlock is canceled by sigkill
Message-Id: <20090825143912.48b63131.minchan.kim@barrios-desktop>
In-Reply-To: <82e12e5f0908242146uad0f314hcbb02fcc999a1d32@mail.gmail.com>
References: <82e12e5f0908220954p7019fb3dg15f9b99bb7e55a8c@mail.gmail.com>
	<28c262360908231844o3df95b14v15b2d4424465f033@mail.gmail.com>
	<20090824105139.c2ab8403.kamezawa.hiroyu@jp.fujitsu.com>
	<2f11576a0908232113w71676aatf22eb6d431501fd0@mail.gmail.com>
	<82e12e5f0908242146uad0f314hcbb02fcc999a1d32@mail.gmail.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Aug 2009 13:46:19 +0900
Hiroaki Wakabayashi <primulaelatior@gmail.com> wrote:

> Thank you for reviews.
> 
> >>> > @@ -254,6 +254,7 @@ static inline void
> >>> > mminit_validate_memmodel_limits(unsigned long *start_pfn,
> >>> >  #define GUP_FLAGS_FORCE                  0x2
> >>> >  #define GUP_FLAGS_IGNORE_VMA_PERMISSIONS 0x4
> >>> >  #define GUP_FLAGS_IGNORE_SIGKILL         0x8
> >>> > +#define GUP_FLAGS_ALLOW_NULL             0x10
> >>> >
> >>>
> >>> I am worried about adding new flag whenever we need it.
> >>> But I think this case makes sense to me.
> >>> In addition, I guess ZERO page can also use this flag.
> >>>
> >>> Kame. What do you think about it?
> >>>
> >> I do welcome this !
> >> Then, I don't have to take care of mlock/munlock in ZERO_PAGE patch.
> >>
> >> And without this patch, munlock() does copy-on-write just for unpinning memory.
> >> So, this patch shows some right direction, I think.
> >>
> >> One concern is flag name, ALLOW_NULL sounds not very good.
> >>
> >>  GUP_FLAGS_NOFAULT ?
> >>
> >> I wonder we can remove a hack of FOLL_ANON for core-dump by this flag, too.
> >
> > Yeah, GUP_FLAGS_NOFAULT is better.
> 
> Me too.
> I will change this flag name.
> 
> > Plus, this patch change __get_user_pages() return value meaning IOW.
> > after this patch, it can return following value,
> >
> >  return value: 3
> >  pages[0]: hoge-page
> >  pages[1]: null
> >  pages[2]: fuga-page
> >
> > but, it can be
> >
> >  return value: 2
> >  pages[0]: hoge-page
> >  pages[1]: fuga-page
> >
> > no?
> 
> I did misunderstand mean of get_user_pages()'s return value.
> 
> When I try to change __get_user_pages(), I got problem.
> If remove NULLs from pages,
> __mlock_vma_pages_range() cannot know how long __get_user_pages() readed.
> So, I have to get the virtual address of the page from vma and page.
> Because __mlock_vma_pages_range() have to call
> __get_user_pages() many times with different `start' argument.
> 
> I try to use page_address_in_vma(), but it failed.
> (page_address_in_vma() returned -EFAULT)
> I cannot find way to solve this problem.
> Are there good ideas?
> Please give me some ideas.


Could you satisfy your needs with this ?

--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -217,6 +217,11 @@ static long __mlock_vma_pages_range(struct vm_area_struct *vma,
 
                lru_add_drain();        /* push cached pages to LRU */
 
+               /*
+                * here we assume that get_user_pages() has given us
+                * a list of virtually contiguous pages.
+                */
+               addr += PAGE_SIZE * ret; /* for next get_user_pages() */
                for (i = 0; i < ret; i++) {
                        struct page *page = pages[i];
 
@@ -234,12 +239,6 @@ static long __mlock_vma_pages_range(struct vm_area_struct *vma,
                        }
                        unlock_page(page);
                        put_page(page);         /* ref from get_user_pages() */
-
-                       /*
-                        * here we assume that get_user_pages() has given us
-                        * a list of virtually contiguous pages.
-                        */
-                       addr += PAGE_SIZE;      /* for next get_user_pages() */
                        nr_pages--;
                }
                ret = 0;

> 
> Thanks.
> --
> Hiroaki Wakabayashi


-- 
Kind regards,
Minchan Kim
