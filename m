Return-Path: <linux-kernel-owner+w=401wt.eu-S1760929AbZDSMlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760929AbZDSMlY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 08:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760493AbZDSMku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 08:40:50 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57698 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759505AbZDSMkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 08:40:47 -0400
Date: Sun, 19 Apr 2009 21:37:35 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: Re: [RFC][PATCH v3 6/6] fix wrong get_user_pages usage in iovlock.c
Cc: kosaki.motohiro@jp.fujitsu.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Andrea Arcangeli <aarcange@redhat.com>,
       Jeff Moyer <jmoyer@redhat.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Leech, Christopher" <christopher.leech@intel.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <129600E5E5FB004392DDC3FB599660D792A39DCE@irsmsx504.ger.corp.intel.com>
References: <20090415174658.AC4F.A69D9226@jp.fujitsu.com> <129600E5E5FB004392DDC3FB599660D792A39DCE@irsmsx504.ger.corp.intel.com>
Message-Id: <20090419202447.FFC2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> KOSAKI Motohiro wrote:
> >>> I would perhaps not fold gup_fast conversions into the same patch as
> >>> the fix.
> >> 
> >> OK. I'll fix.
> > 
> > Done.
> > 
> > 
> > 
> > ===================================
> > Subject: [Untested][RFC][PATCH] fix wrong get_user_pages usage in iovlock.c
> > 
> > 	down_read(mmap_sem)
> > 	get_user_pages()
> > 	up_read(mmap_sem)
> > 
> > is fork unsafe.
> > fix it.
> > 
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: Chris Leech <christopher.leech@intel.com>
> > Cc: netdev@vger.kernel.org
> > ---
> >  drivers/dma/iovlock.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > Index: b/drivers/dma/iovlock.c
> > ===================================================================
> > --- a/drivers/dma/iovlock.c	2009-04-13 22:58:36.000000000 +0900
> > +++ b/drivers/dma/iovlock.c	2009-04-14 20:27:16.000000000 +0900
> > @@ -104,8 +104,6 @@ struct dma_pinned_list *dma_pin_iovec_pa
> >  			0,	/* force */
> >  			page_list->pages,
> >  			NULL);
> > -		up_read(&current->mm->mmap_sem);
> > -
> >  		if (ret != page_list->nr_pages)
> >  			goto unpin;
> > 
> > @@ -127,6 +125,8 @@ void dma_unpin_iovec_pages(struct dma_pi
> >  	if (!pinned_list)
> >  		return;
> > 
> > +	up_read(&current->mm->mmap_sem);
> > +
> >  	for (i = 0; i < pinned_list->nr_iovecs; i++) {
> >  		struct dma_page_list *page_list = &pinned_list->page_list[i];
> >  		for (j = 0; j < page_list->nr_pages; j++) {
> 
> I have tried it with net_dma and here is what I've got.

Thanks.
Instead, How about this?


============================================
Subject: [Untested][RFC][PATCH v3] fix wrong get_user_pages usage in iovlock.c

	down_read(mmap_sem)
	get_user_pages()
	up_read(mmap_sem)

is fork unsafe.
mmap_sem should't be released until dma_unpin_iovec_pages() is called.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Chris Leech <christopher.leech@intel.com>
Cc: netdev@vger.kernel.org
---
 drivers/dma/iovlock.c |    5 ++---
 net/ipv4/tcp.c        |    9 +++++++++
 2 files changed, 11 insertions(+), 3 deletions(-)

Index: b/drivers/dma/iovlock.c
===================================================================
--- a/drivers/dma/iovlock.c	2009-04-19 17:27:25.000000000 +0900
+++ b/drivers/dma/iovlock.c	2009-04-19 17:29:42.000000000 +0900
@@ -45,6 +45,8 @@ static int num_pages_spanned(struct iove
  * We are allocating a single chunk of memory, and then carving it up into
  * 3 sections, the latter 2 whose size depends on the number of iovecs and the
  * total number of pages, respectively.
+ *
+ * Caller must hold mm->mmap_sem
  */
 struct dma_pinned_list *dma_pin_iovec_pages(struct iovec *iov, size_t len)
 {
@@ -94,7 +96,6 @@ struct dma_pinned_list *dma_pin_iovec_pa
 		pages += page_list->nr_pages;
 
 		/* pin pages down */
-		down_read(&current->mm->mmap_sem);
 		ret = get_user_pages(
 			current,
 			current->mm,
@@ -104,8 +105,6 @@ struct dma_pinned_list *dma_pin_iovec_pa
 			0,	/* force */
 			page_list->pages,
 			NULL);
-		up_read(&current->mm->mmap_sem);
-
 		if (ret != page_list->nr_pages)
 			goto unpin;
 
Index: b/net/ipv4/tcp.c
===================================================================
--- a/net/ipv4/tcp.c	2009-04-19 17:27:25.000000000 +0900
+++ b/net/ipv4/tcp.c	2009-04-19 18:09:42.000000000 +0900
@@ -1322,6 +1322,9 @@ int tcp_recvmsg(struct kiocb *iocb, stru
 	int copied_early = 0;
 	struct sk_buff *skb;
 
+#ifdef CONFIG_NET_DMA
+	down_read(&current->mm->mmap_sem);
+#endif
 	lock_sock(sk);
 
 	TCP_CHECK_TIMER(sk);
@@ -1688,11 +1691,17 @@ skip_copy:
 
 	TCP_CHECK_TIMER(sk);
 	release_sock(sk);
+#ifdef CONFIG_NET_DMA
+	up_read(&current->mm->mmap_sem);
+#endif
 	return copied;
 
 out:
 	TCP_CHECK_TIMER(sk);
 	release_sock(sk);
+#ifdef CONFIG_NET_DMA
+	up_read(&current->mm->mmap_sem);
+#endif
 	return err;
 
 recv_urg:


