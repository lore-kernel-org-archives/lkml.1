Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbYKKHN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbYKKHN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 02:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbYKKHNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 02:13:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751500AbYKKHNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 02:13:20 -0500
Date: Mon, 10 Nov 2008 23:13:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: rc4-mmotm1110 - Another build error
Message-Id: <20081110231314.27e639a4.akpm@linux-foundation.org>
In-Reply-To: <20081111155438.a46bdac1.kamezawa.hiroyu@jp.fujitsu.com>
References: <38231.1226373633@turing-police.cc.vt.edu>
	<20081110194353.1a1f616e.akpm@linux-foundation.org>
	<20081111155438.a46bdac1.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008 15:54:38 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Mon, 10 Nov 2008 19:43:53 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Mon, 10 Nov 2008 22:20:33 -0500 Valdis.Kletnieks@vt.edu wrote:
> > 
> > > gcc --version says:
> > > gcc (GCC) 4.3.2 20081105 (Red Hat 4.3.2-7)
> > > 
> > > ka-blam number 2:
> > > 
> > >   CC      kernel/audit.o
> > > In file included from include/net/dst.h:15,
> > >                  from include/net/sock.h:57,
> > >                  from kernel/audit.c:54:
> > > include/net/neighbour.h:114: error: braced-group within expression allowed only inside a function
> > > make[1]: *** [kernel/audit.o] Error 1
> > > 
> > > I'm placing bets on patches/align-avoid-evaluating-its-argument-twice.patch
> > > 
> > > Yep, revert that patch, and audit.o compiles again.
> > > 
> > 
> > I hadn't got around to testing that one yet.
> > 
> > So ug.  ALIGN() is used in array sizing and hence has to be a
> > compile-time thing.  But ALIGN(foo, bar()) will call bar() twice.
> > 
> > Now how do we fix that?
> 
> How about provoding
>   - ALIGN()  - args can be evaluated twice.

Well.  The problem here is the risk of mistakes, and such an ALIGN()
could still be called by mistake.

>  and
>   - static inline unsigned long align()

ALIGN() is designed so that it can take any scalar types as arguments
and still do the right thing, so it can't really be implemented as an
inline.

> messy ?

I suppose we could switch all those ALIGN calls which must occur at
compile-time over to a new STATIC_ALIGN() (?) which is allowed to
evaluate its args twice, then fix ALIGN().

A bit of a pain, but any missed conversions would reliably fail to
compile and would get fixed quickly.

hm, ALIGN() is used in assembly too, but it means something totally
different, sigh.

<greps>

./arch/x86/mm/hugetlbpage.c:    addr = ALIGN(start_addr, huge_page_size(h));
./arch/x86/mm/hugetlbpage.c:            addr = ALIGN(vma->vm_end, huge_page_size(h));
./arch/x86/mm/hugetlbpage.c:            addr = ALIGN(addr, huge_page_size(h));

These will presently be calling huge_page_size() twice.

Will these:

./drivers/mtd/ubi/build.c:	ubi->ec_hdr_alsize = ALIGN(UBI_EC_HDR_SIZE, ubi->hdrs_min_io_size);
./drivers/mtd/ubi/build.c:	ubi->vid_hdr_alsize = ALIGN(UBI_VID_HDR_SIZE, ubi->hdrs_min_io_size);

do the dereference twice?  Probably not.

I didn't immediately spot any bugs, but I didn't look very closely. 
Hopefully if there are any there, we'd have heard about it.

