Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbYFKNos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbYFKNos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 09:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbYFKNoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 09:44:39 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:30519 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751447AbYFKNoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 09:44:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=lTurt8HLD6AvQKEbMEnJesTLLMXPVp5CoZp6S/D5T6zuGa5tD3ctbPhy+WsR/FxaADzifcIGYsEfwy90EwYj0CoJNBxoRtrCbEne8bZKjTDNx5MKIsJaxJpgCkGaxJnZ4hi5YelI4/MEPIBB0mh7rkh4WiNGOJe9AYGxO3ExS6g=  ;
X-YMail-OSG: jJkcpnIVM1mWo7jhrYNXBBWOfwnFevjy8JUfaEx2feVCCjhmBroAcgyYfKVUksKP59jv5rUIOb5NqQbf9fU1lJ33kcL7cC.lPiZF9r5eyhHxOd36PV8NByd3kyUL5KhBnEI-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Rik van Riel <riel@redhat.com>
Subject: Re: 2.6.26-rc5-mm2: OOM with 1G free swap
Date: Wed, 11 Jun 2008 23:44:17 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org
References: <20080609223145.5c9a2878.akpm@linux-foundation.org> <20080610232705.3aaf5c06.akpm@linux-foundation.org> <20080611085724.1c18164f@bree.surriel.com>
In-Reply-To: <20080611085724.1c18164f@bree.surriel.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_xa9TItkcit2Pj1U"
Message-Id: <200806112344.17627.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_xa9TItkcit2Pj1U
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 11 June 2008 22:57, Rik van Riel wrote:
> On Tue, 10 Jun 2008 23:27:05 -0700
>
> Andrew Morton <akpm@linux-foundation.org> wrote:
> > Well I assume that Rik ran LTP.  Perhaps a merge problem.
> >
> > Zero pages on active_anon and inactive_anon.  I suspect we lost those
> > pages.
>
> Known problem.  I fixed this one in the updates I sent you last night.

Oh good. Yeah I was just running some tests, and got as far as verifying
that the upstream kernel + lockless pagecache patches reclaims file pages
like a dream, but -mm2 sucks very badly at it.

During which, I also did find by inspection a little problem with my
speculative references patch. Andrew please apply this fix.


--Boundary-00=_xa9TItkcit2Pj1U
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="mm-speculative-page-references-hugh-fix3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mm-speculative-page-references-hugh-fix3.patch"

Fix the VM_BUG_ON assertion check to actually do what I want, noted by
Christoph.

Also, fix an error-path-leak type issue with frozen refcount not being
unfrozen. Found by review. In practice, this check is very rare to hit
because a page dirtier is likely to hold the refcount elevated for much
longer than it takes to check and non-racy-recheck. So it doesn't pose
a big problem for users of -mm, but of course needs fixing.

---
Index: linux-2.6/mm/vmscan.c
===================================================================
--- linux-2.6.orig/mm/vmscan.c	2008-06-11 23:36:07.000000000 +1000
+++ linux-2.6/mm/vmscan.c	2008-06-11 23:36:18.000000000 +1000
@@ -415,8 +415,10 @@ static int __remove_mapping(struct addre
 	if (!page_freeze_refs(page, 2))
 		goto cannot_free;
 	/* note: atomic_cmpxchg in page_freeze_refs provides the smp_rmb */
-	if (unlikely(PageDirty(page)))
+	if (unlikely(PageDirty(page))) {
+		page_unfreeze_refs(page, 2);
 		goto cannot_free;
+	}
 
 	if (PageSwapCache(page)) {
 		swp_entry_t swap = { .val = page_private(page) };
Index: linux-2.6/include/linux/pagemap.h
===================================================================
--- linux-2.6.orig/include/linux/pagemap.h	2008-06-11 23:36:07.000000000 +1000
+++ linux-2.6/include/linux/pagemap.h	2008-06-11 23:36:18.000000000 +1000
@@ -165,7 +165,7 @@ static inline int page_cache_get_specula
 		return 0;
 	}
 #endif
-	VM_BUG_ON(PageCompound(page) && (struct page *)page_private(page) != page);
+	VM_BUG_ON(PageTail(page));
 
 	return 1;
 }

--Boundary-00=_xa9TItkcit2Pj1U--
