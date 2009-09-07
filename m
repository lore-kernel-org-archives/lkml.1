Return-Path: <linux-kernel-owner+w=401wt.eu-S1758965AbZIGGQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758965AbZIGGQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 02:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758939AbZIGGQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 02:16:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35952 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758856AbZIGGQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 02:16:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 7 Sep 2009 15:14:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Craig-Wood <nick@craig-wood.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Reading /proc/kcore causes a BUG()
Message-Id: <20090907151422.4d42e382.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090907093856.5c453d3f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090903113428.GA6986@craig-wood.com>
	<84144f020909030514k1d9fe596pf2c4d8ffa45f7af@mail.gmail.com>
	<20090904090642.f727458b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090904090039.GA25804@craig-wood.com>
	<20090904181645.d114d1c9.kamezawa.hiroyu@jp.fujitsu.com>
	<20090904103156.a04179f3.akpm@linux-foundation.org>
	<20090907093856.5c453d3f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Sep 2009 09:38:56 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > That's a lot of stuff for 2.6.31.  Is there some simple quickfix we can do?
> > 
> I don't like this patch. But here, my 1st version which wasn't sent out.
> -Kame

Fixed warnings. (I confirmed this patch works well on x86-64.)
==
To access vmalloc area which may have memory holes, copy_from_user is
useful. By this, 
 # cat /proc/kcore > /dev/null
will not panic.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/proc/kcore.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6.31-rc8/fs/proc/kcore.c
===================================================================
--- linux-2.6.31-rc8.orig/fs/proc/kcore.c
+++ linux-2.6.31-rc8/fs/proc/kcore.c
@@ -361,7 +361,13 @@ read_kcore(struct file *file, char __use
 				/* don't dump ioremap'd stuff! (TA) */
 				if (m->flags & VM_IOREMAP)
 					continue;
-				memcpy(elf_buf + (vmstart - start),
+				/*
+				 * we may access memory holes, then use
+				 * ex_table. checking return value just for
+				 * avoid warnings.
+				 */
+				vmsize = __copy_from_user_inatomic(
+					elf_buf + (vmstart - start),
 					(char *)vmstart, vmsize);
 			}
 			read_unlock(&vmlist_lock);

