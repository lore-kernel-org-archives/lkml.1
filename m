Return-Path: <linux-kernel-owner+w=401wt.eu-S1758397AbZIGAlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397AbZIGAlL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 20:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758332AbZIGAlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 20:41:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47097 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499AbZIGAlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 20:41:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 7 Sep 2009 09:38:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Craig-Wood <nick@craig-wood.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Reading /proc/kcore causes a BUG()
Message-Id: <20090907093856.5c453d3f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090904103156.a04179f3.akpm@linux-foundation.org>
References: <20090903113428.GA6986@craig-wood.com>
	<84144f020909030514k1d9fe596pf2c4d8ffa45f7af@mail.gmail.com>
	<20090904090642.f727458b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090904090039.GA25804@craig-wood.com>
	<20090904181645.d114d1c9.kamezawa.hiroyu@jp.fujitsu.com>
	<20090904103156.a04179f3.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Sep 2009 10:31:56 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 4 Sep 2009 18:16:45 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Fri, 4 Sep 2009 10:00:39 +0100
> > Nick Craig-Wood <nick@craig-wood.com> wrote:
> > 
> > > On Fri, Sep 04, 2009 at 09:06:42AM +0900, KAMEZAWA Hiroyuki wrote:
> > > > On Thu, 3 Sep 2009 15:14:55 +0300
> > > > Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > > > > On Thu, Sep 3, 2009 at 2:34 PM, Nick Craig-Wood<nick@craig-wood.com> wrote:
> > > > > > Is a fix for this going to make 2.6.31?
> > > > > >
> > > > > > To replicate
> > > > > >
> > > > > > __cat /proc/kcore >/dev/null
> > > > > >
> > > > > > See also
> > > > > >
> > > > > > __http://bugzilla.kernel.org/show_bug.cgi?id=13850
> > > [snip]
> > > > > > I tried this on the latest git checkout (as of 2009-09-03 11:00 GMT)
> > > > > > under Xen as a domU. __The bugzilla report states it happens on non xen
> > > > > > machines also.
> 
> Is this a regression?  I've lost track..
> 
regression. (this comes from new per-cpu area implemantation, which uses
vmalloc area with memory holes.)


> > > > > > I know reading /proc/kcore isn't such a good idea, but badly written
> > > > > > backup scripts are triggering this on our customer's servers :-(
> > > > > 
> > > > > AFAICT the bug was fixed but I can't seem to find the patches in
> > > > > Linus' git either. Lets CC Andrew and Hiroyuki-san.
> > > > 
> > > > Ah, it's now tested under mmotm. please wait.
> > > 
> > > I tried mmotm but I couldn't get it to boot under Xen :-(
> > > 
> > > If you send me a patch against latest git I'm willing to test it (I
> > > tried to extract the relevant patch from mmotm but failed dismally)
> > > 
> > > Thanks
> > > 
> > 
> > If you already downloaded mmotm, use these patches.
> > 
> > vmalloc-unmap-vmalloc-area-after-hiding-it.patch
> > kcore-fix-vread-vwrite-to-be-aware-of-holes.patch
> > kcore-fix-vread-vwrite-to-be-aware-of-holes-update.patch
> > kcore-proc-kcore-should-use-vread.patch
> > 
> > All I tested was x86-32/x86-64. then more tests are welcomed.
> 
> That's a lot of stuff for 2.6.31.  Is there some simple quickfix we can do?
> 
I don't like this patch. But here, my 1st version which wasn't sent out.
-Kame
==
/proc/kcore may access in memory holes in vmalloc area. skip it
by using copy_from_user().

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/proc/kcore.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.31-rc8/fs/proc/kcore.c
===================================================================
--- linux-2.6.31-rc8.orig/fs/proc/kcore.c
+++ linux-2.6.31-rc8/fs/proc/kcore.c
@@ -361,7 +361,9 @@ read_kcore(struct file *file, char __use
 				/* don't dump ioremap'd stuff! (TA) */
 				if (m->flags & VM_IOREMAP)
 					continue;
-				memcpy(elf_buf + (vmstart - start),
+				/* we may access memory holes */
+				__copy_from_user_inatomic(
+					elf_buf + (vmstart - start),
 					(char *)vmstart, vmsize);
 			}
 			read_unlock(&vmlist_lock);






