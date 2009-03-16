Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZCPDYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZCPDYe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 23:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbZCPDYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 23:24:24 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60536 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbZCPDYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 23:24:24 -0400
Date: Mon, 16 Mar 2009 12:22:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Gene Heskett <gene.heskett@gmail.com>,
       David Newall <davidn@davidnewall.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: I just got got another Oops
Message-Id: <20090316122255.48006430.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090316115509.40ea13da.kamezawa.hiroyu@jp.fujitsu.com>
References: <200903120133.11583.gene.heskett@gmail.com>
	<49B8C98D.3020309@davidnewall.com>
	<200903121431.49437.gene.heskett@gmail.com>
	<20090316115509.40ea13da.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009 11:55:09 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Thu, 12 Mar 2009 14:31:49 -0400
> Gene Heskett <gene.heskett@gmail.com> wrote:
> 
> > Mar 12 14:15:02 coyote kernel: [ 2656.832669]
> > Mar 12 14:15:02 coyote kernel: [ 2656.832672] Pid: 18877, comm: kmail Not tainted (2.6.29-rc7 #5) System Product Name
> > Mar 12 14:15:02 coyote kernel: [ 2656.832675] EIP: 0060:[<c046520b>] EFLAGS: 00210202 CPU: 0
> > Mar 12 14:15:02 coyote kernel: [ 2656.832678] EIP is at get_page_from_freelist+0x24b/0x4c0
> > Mar 12 14:15:02 coyote kernel: [ 2656.832680] EAX: ffffffff EBX: 80004000 ECX: 00000001 EDX: 00000002
> > Mar 12 14:15:02 coyote kernel: [ 2656.832682] ESI: c28fc260 EDI: 00000000 EBP: f2168d5c ESP: f2168cfc
> > Mar 12 14:15:02 coyote kernel: [ 2656.832684]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > Mar 12 14:15:02 coyote kernel: [ 2656.832686] Process kmail (pid: 18877, ti=f2168000 task=f22018b0 task.ti=f2168000)
> > Mar 12 14:15:02 coyote kernel: [ 2656.832688] Stack:
> > Mar 12 14:15:02 coyote kernel: [ 2656.832689]  00000002 00000044 c28fc060 00000000 f1463ca4 c0744b80 c06d6480 00000002
> > Mar 12 14:15:02 coyote kernel: [ 2656.832693]  00000000 00000000 001201d2 00000002 00200246 00000001 c06d6900 00000100
> > Mar 12 14:15:02 coyote kernel: [ 2656.832698]  00000000 80000000 c06d7484 c06d6480 c06d6480 c06d6480 f22018b0 00000129
> 
> Added linux-mm to CC:
> 
> 22a9:	8b 1e         mov    (%esi),%ebx                            #ebx=80004000 = page->flags
> 22ab:	89 f2         mov    %esi,%edx                              #remember "page"
> 22ad:	8b 46 08      mov    0x8(%esi),%eax                         #esi+8=-1  page->mapcount
> 22b0:	8b 7e 10      mov    0x10(%esi),%edi                        #esi+16=0  page->mapping
> 22b3:	f6 c7 40      test   $0x40,%bh
> 22b6:	74 03         je     22bb <get_page_from_freelist+0x24b>
> 22b8:	8b 56 0c      mov    0xc(%esi),%edx                         #page = page->first_page
> 22bb:	8b 4a 04      mov    0x4(%edx),%ecx                         #page->_count
>  
> Thank you for disassemble list, from above....
> 
> In prep_new_page()
>  610 static int prep_new_page(struct page *page, int order, gfp_t gfp_flags)
>  611 {
>  612         if (unlikely(page_mapcount(page) |
>  613                 (page->mapping != NULL)  |
>  614                 (page_count(page) != 0)  |
>  615                 (page->flags & PAGE_FLAGS_CHECK_AT_PREP)))
>  616                 bad_page(page);
> 
>  page->mapping = NULL,  (VALID)
>  page->mapcount = -1    (VALID)
>  page->count ==> NULL access because PageTail() is set, see below.
>  (Note: from .config, CONFIG_PAGEFLAGS_EXTENDED is set.)
> 
> ==
>  288 static inline int page_count(struct page *page)
>  289 {
>  290         return atomic_read(&compound_head(page)->_count);
>  291 }
> 
>  281 static inline struct page *compound_head(struct page *page)
>  282 {
>  283         if (unlikely(PageTail(page)))
>  284                 return page->first_page;
>  285         return page;
>  286 }
> ==
> 
> PageTail() is true (this is invalid) and page->first_page contains obsolete data.
> But, here, PG_tail should not be there...
> 

Gene-san, could you set CONFIG_DEBUG_VM (and other debug option ?)
I think it can give us another view.

-Kame



