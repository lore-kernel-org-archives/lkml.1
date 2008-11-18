Return-Path: <linux-kernel-owner+w=401wt.eu-S1752752AbYKRMGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbYKRMGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 07:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbYKRMGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 07:06:09 -0500
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:33554 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751250AbYKRMGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 07:06:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=4GdrQQt3zRD47ivGZgvMhfKUl8BN7j9xVnYwx4YC6jn5dJysSa65p9wvcw2sfv+cc+sTpNCLHQd6DjhI6SblcZuvNJs9HWkqgeLL8rRnLb88apSQhy7VuVnRe13BgwCIYsBfkP9XqvxSUkTcQ+KA8Z7hKpKN/C2Vg1dUpOMkEUs=  ;
X-YMail-OSG: yEoiFMAVM1mh57Il3Zmt2oEiLV.bJkVpeH1iNDuiiaibDZfjIVuf9Sb2jmw6Yzu.p8URtqWCiFPND0cd1A6kGhTWFVhXLz4L6LohzS2Hm0Lo_DgZgAG_c.UrW6v0Z2bJP8tf
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH V2 1/4] vmalloc: introduce vfree_atomic()
Date: Tue, 18 Nov 2008 23:05:52 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       David Miller <davem@davemloft.net>, Dave Airlie <airlied@gmail.com>,
       Paul Menage <menage@google.com>, kamezawa.hiroyu@jp.fujitsu.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, Jan Kara <jack@suse.cz>,
       Jes Sorensen <jes@sgi.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, dada1@cosmosbay.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <npiggin@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>
References: <492162E4.9080902@cn.fujitsu.com> <200811182019.44064.nickpiggin@yahoo.com.au> <4922A93B.6060102@cn.fujitsu.com>
In-Reply-To: <4922A93B.6060102@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_i+qIJDDQ5sXvTs+"
Message-Id: <200811182305.54287.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_i+qIJDDQ5sXvTs+
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 18 November 2008 22:38, Lai Jiangshan wrote:
> Nick Piggin wrote:
> > On Tuesday 18 November 2008 19:51, Lai Jiangshan wrote:
> >> fdtable and sysipc use vfree() in RCU callback. this patch
> >> introduce vfree_atomic() for them.
> >
> > AFAIKS, vfree is usable from atomic context? What am I missing?
>
> Hi, Nick Piggin,
>
> Sorry for misled you.
>
> fdtable and sysipc use vfree() in RCU callback.(_but defer it by
> schedule_work()_) current vfree() is not usable from atomic context, so
> this patches are worthy.

Hi,

I just wonder why vfree is not usable from atomic context? It is well
known that it can't be used in interrupt context, but just atomic
should work?


> even if vfree() is usable from atomic context soon,
> [PATCH 3/4] [PATCH 4/4] are still worthy now. Because these two patches are
> independent from vfree().(just needs to be changed one or two lines
> when vfree() is usable from atomic context)
>
> I suggest we can use vfree_atomic() before vfree() is available
> for atomic context. Because fdtable and sysipc need a grace way for
> using RCU and vmalloc/vfree. (actually, fdtable and sysipc have implemented
> they own "vfree_atomic()", but it's very ugly)

It's probably not a bad idea to consolidate these into one place.
Using vfree directly is not a trivial change, it could cause
regressions.


> Thanx, Lai.
>
> > Actually, one could argue that we don't want to perform such
> > costly operations in the atomic context, however with lazy
> > unmapping, vfree is very cheap now (amortized, at least).
>
> I'm looking forward to vfree() is available for atomic context.

Something like this. Actually, this is something we quite possibly
should be doing anyway, so that the expensive flush path can be
deferred to a less critical context.

--Boundary-00=_i+qIJDDQ5sXvTs+
Content-Type: text/x-diff;
  charset="utf-8";
  name="mm-vfree-defer.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mm-vfree-defer.patch"

Index: linux-2.6/mm/vmalloc.c
===================================================================
--- linux-2.6.orig/mm/vmalloc.c
+++ linux-2.6/mm/vmalloc.c
@@ -531,6 +531,17 @@ static void purge_vmap_area_lazy(void)
 	__purge_vmap_area_lazy(&start, &end, 0, 0);
 }
 
+static void deferred_purge(struct work_struct *work)
+{
+	purge_vmap_area_lazy();
+}
+
+static struct work_struct purge_work;
+static void kick_purge_vmap_area_lazy(void)
+{
+	schedule_work(&purge_work);
+}
+
 /*
  * Free and unmap a vmap area
  */
@@ -539,7 +550,7 @@ static void free_unmap_vmap_area(struct 
 	va->flags |= VM_LAZY_FREE;
 	atomic_add((va->va_end - va->va_start) >> PAGE_SHIFT, &vmap_lazy_nr);
 	if (unlikely(atomic_read(&vmap_lazy_nr) > lazy_max_pages()))
-		purge_vmap_area_lazy();
+		kick_purge_vmap_area_lazy();
 }
 
 static struct vmap_area *find_vmap_area(unsigned long addr)
@@ -938,6 +949,7 @@ void __init vmalloc_init(void)
 {
 	int i;
 
+	INIT_WORK(&purge_work, deferred_purge);
 	for_each_possible_cpu(i) {
 		struct vmap_block_queue *vbq;
 

--Boundary-00=_i+qIJDDQ5sXvTs+--
