Return-Path: <linux-kernel-owner+w=401wt.eu-S1751302AbZHXCXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbZHXCXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 22:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbZHXCXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 22:23:20 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:46203 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbZHXCXT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 22:23:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Cc5a5bnr4u5arBoCPM5ljfJQ4B1tUaG2oISfqno3VkSHPKEjOnicfDQDTuBDy0QwPx
         iib6y4YyoSPUwRzsPXfLUTAQV/f108l7zb9xvflxLpqzQEzIPWTWSqMdlwRSmm/k1d5T
         ozJ2pWoPTUG1+oT+0DfV9euQlxvnijbJXi8MY=
MIME-Version: 1.0
In-Reply-To: <20090824105139.c2ab8403.kamezawa.hiroyu@jp.fujitsu.com>
References: <82e12e5f0908220954p7019fb3dg15f9b99bb7e55a8c@mail.gmail.com>
	 <28c262360908231844o3df95b14v15b2d4424465f033@mail.gmail.com>
	 <20090824105139.c2ab8403.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 24 Aug 2009 11:23:21 +0900
Message-ID: <28c262360908231923q354281a6yca3b43019af3c40e@mail.gmail.com>
Subject: Re: [PATCH] mm: make munlock fast when mlock is canceled by sigkill
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hiroaki Wakabayashi <primulaelatior@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Ying Han <yinghan@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 10:51 AM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Mon, 24 Aug 2009 10:44:41 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> On Sun, Aug 23, 2009 at 1:54 AM, Hiroaki
>> Wakabayashi<primulaelatior@gmail.com> wrote:
>> > From 27b2fde0222c59049026e7d0bdc4a2a68d0720f5 Mon Sep 17 00:00:00 2001
>> > From: Hiroaki Wakabayashi <primulaelatior@gmail.com>
>> > Date: Sat, 22 Aug 2009 19:14:53 +0900
>> > Subject: [PATCH] mm: make munlock fast when mlock is canceled by sigkill
>> >
>> > This patch is for making commit 4779280d1e (mm: make get_user_pages()
>> > interruptible) complete.
>> >
>> > At first, munlock() assumes that all pages in vma are pinned,
>> >
>> > Now, by the commit, mlock() can be interrupted by SIGKILL, etc  So, part of
>> > pages are not pinned.
>> > If SIGKILL, In exit() path, munlock is called for unlocking pinned pages
>> > in vma.
>> >
>> > But, there, get_user_pages(write) is used for munlock(). Then, pages are
>> > allocated via page-fault for exsiting process !!! This is problem at canceling
>> > big mlock.
>> > This patch tries to avoid allocating new pages at munlock().
>> >
>> >   mlock( big area )
>> >        <===== sig kill
>> >   do_exit()
>> >    ->mmput()
>> >       -> do_munlock()
>> >         -> get_user_pages()
>> >               <allocate *never used* memory>
>> >       ->.....freeing allocated memory.
>> >
>> > * Test program
>> > % cat run.sh
>> > #!/bin/sh
>> >
>> > ./mlock_test 2000000000 &
>> > sleep 2
>> > kill -9 $!
>> > wait
>> >
>> > % cat mlock_test.c
>> > #include <stdio.h>
>> > #include <stdlib.h>
>> > #include <string.h>
>> > #include <sys/mman.h>
>> > #include <sys/types.h>
>> > #include <sys/stat.h>
>> > #include <fcntl.h>
>> > #include <errno.h>
>> > #include <time.h>
>> > #include <unistd.h>
>> > #include <sys/time.h>
>> >
>> > int main(int argc, char **argv)
>> > {
>> >        size_t length = 50 * 1024 * 1024;
>> >        void *addr;
>> >        time_t timer;
>> >
>> >        if (argc >= 2)
>> >                length = strtoul(argv[1], NULL, 10);
>> >        printf("PID = %d\n", getpid());
>> >        addr = mmap(NULL, length, PROT_READ | PROT_WRITE,
>> >                                MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>> >        if (addr == MAP_FAILED) {
>> >                fprintf(stderr, "mmap failed: %s, length=%lu\n",
>> >                                strerror(errno), length);
>> >                exit(EXIT_FAILURE);
>> >        }
>> >        printf("try mlock length=%lu\n", length);
>> >        timer = time(NULL);
>> >        if (mlock(addr, length) < 0) {
>> >                fprintf(stderr, "mlock failed: %s, time=%lu[sec]\n",
>> >                                strerror(errno), time(NULL) - timer);
>> >                exit(EXIT_FAILURE);
>> >        }
>> >        printf("mlock succeed, time=%lu[sec]\n\n", time(NULL) - timer);
>> >        printf("try munlock length=%lu\n", length);
>> >        timer = time(NULL);
>> >        if (munlock(addr, length) < 0) {
>> >                fprintf(stderr, "munlock failed: %s, time=%lu[sec]\n",
>> >                                strerror(errno), time(NULL)-timer);
>> >                exit(EXIT_FAILURE);
>> >        }
>> >        printf("munlock succeed, time=%lu[sec]\n\n", time(NULL) - timer);
>> >        if (munmap(addr, length) < 0) {
>> >                fprintf(stderr, "munmap failed: %s\n", strerror(errno));
>> >                exit(EXIT_FAILURE);
>> >        }
>> >        return 0;
>> > }
>> >
>> > * Executed Result
>> > -- Original executed result
>> > % time ./run.sh
>> >
>> > PID = 2678
>> > try mlock length=2000000000
>> > ./run.sh: line 6:  2678 Killed                  ./mlock_test 2000000000
>> > ./run.sh  0.00s user 2.59s system 13% cpu 18.781 total
>> > %
>> >
>> > -- After applied this patch
>> > % time ./run.sh
>> >
>> > PID = 2512
>> > try mlock length=2000000000
>> > ./run.sh: line 6:  2512 Killed                  ./mlock_test 2000000000
>> > ./run.sh  0.00s user 1.15s system 45% cpu 2.507 total
>> > %
>> >
>> > Signed-off-by: Hiroaki Wakabayashi <primulaelatior@gmail.com>
>> > ---
>> >  mm/internal.h |    1 +
>> >  mm/memory.c   |    9 +++++++--
>> >  mm/mlock.c    |   35 +++++++++++++++++++----------------
>> >  3 files changed, 27 insertions(+), 18 deletions(-)
>> >
>> > diff --git a/mm/internal.h b/mm/internal.h
>> > index f290c4d..4ab5b24 100644
>> > --- a/mm/internal.h
>> > +++ b/mm/internal.h
>> > @@ -254,6 +254,7 @@ static inline void
>> > mminit_validate_memmodel_limits(unsigned long *start_pfn,
>> >  #define GUP_FLAGS_FORCE                  0x2
>> >  #define GUP_FLAGS_IGNORE_VMA_PERMISSIONS 0x4
>> >  #define GUP_FLAGS_IGNORE_SIGKILL         0x8
>> > +#define GUP_FLAGS_ALLOW_NULL             0x10
>> >
>>
>> I am worried about adding new flag whenever we need it.
>> But I think this case makes sense to me.
>> In addition, I guess ZERO page can also use this flag.
>>
>> Kame. What do you think about it?
>>
> I do welcome this !
> Then, I don't have to take care of mlock/munlock in ZERO_PAGE patch.
>
> And without this patch, munlock() does copy-on-write just for unpinning memory.
> So, this patch shows some right direction, I think.
>
> One concern is flag name, ALLOW_NULL sounds not very good.
>
>  GUP_FLAGS_NOFAULT ?
>
> I wonder we can remove a hack of FOLL_ANON for core-dump by this flag, too.

That's a good point.
It can remove little cache footprint and
unnecessary calls[flush_xxx_page in GUP].

-- 
Kind regards,
Minchan Kim
