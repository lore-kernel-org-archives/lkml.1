Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbZFHN6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbZFHN6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbZFHN6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:58:10 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39574 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899AbZFHN6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:58:09 -0400
Date: Mon, 8 Jun 2009 16:58:10 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
cc: Rik van Riel <riel@redhat.com>, Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
In-Reply-To: <20090608110303.GD15377@csn.ul.ie>
Message-ID: <Pine.LNX.4.64.0906081657001.7036@melkki.cs.Helsinki.FI>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera> <D9VoutSOyXP.A.hvH.Ha7KKB@chimera>
 <4A2BBC30.2030300@lwfinger.net> <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com>
 <4A2BCC6F.8090004@redhat.com> <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com>
 <20090608101739.GA15377@csn.ul.ie> <84144f020906080352k57f12ff9pbd696da5f332ac1a@mail.gmail.com>
 <20090608110303.GD15377@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Mon, 8 Jun 2009, Mel Gorman wrote:
> Is there any chance you could hatchet together a patch
> slab-allocation-failure that reports on slab allocation failures similar
> to what the page allocator does? Minimally, it should tell us what
> the size of the allocation was but any other information such as the
> same of the slab, the size of pages it normally uses are, etc. would
> also be useful.

Would something like this be sufficient? Figuring out the actual _size_ 
passed to kmalloc() is pretty difficult as then we would need to do the 
NULL test in fastpath code or pass the argument deeper in the call-chain.

			Pekka

diff --git a/mm/slub.c b/mm/slub.c
index 65ffda5..b5acf18 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1565,6 +1565,8 @@ new_slab:
 		c->page = new;
 		goto load_freelist;
 	}
+	printk(KERN_WARNING "SLUB: unable to satisfy allocation for cache %s (size=%d, node=%d, gfp=%x)\n",
+		s->name, s->size, node, gfpflags);
 	return NULL;
 debug:
 	if (!alloc_debug_processing(s, c->page, object, addr))
