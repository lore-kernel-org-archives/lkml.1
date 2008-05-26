Return-Path: <linux-kernel-owner+w=401wt.eu-S1752054AbYEZNKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbYEZNKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 09:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbYEZNKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 09:10:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49372 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbYEZNKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 09:10:38 -0400
Date: Mon, 26 May 2008 22:10:06 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Circular include dependencies
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
In-Reply-To: <20080523181728.b30409b2.akpm@linux-foundation.org>
References: <20080523132034.GB15384@flint.arm.linux.org.uk> <20080523181728.b30409b2.akpm@linux-foundation.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080526195803.F779.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 23 May 2008 14:20:34 +0100 Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> 
> > Hi,
> > 
> > Having discovered some circular include dependencies in the ARM header
> > files which were causing build issues, I created a script to walk ARM
> > includes and report any similar issues found - which includes traversing
> > any referenced linux/ includes.
> > 
> > It identified the following two in include/linux/:
> > 
> >   linux/mmzone.h <- linux/memory_hotplug.h <- linux/mmzone.h
> >   linux/mmzone.h <- linux/topology.h <- linux/mmzone.h
> > 
> > Checking them by hand reveals that these are real.  Whether they're
> > capable of causing a problem or not, I'm not going to comment on.
> > However, they're not a good idea and someone should probably look at
> > resolving the loops.
> 
> (cc's added).
> 
> Thanks.
> 
> I'm not sure who we could tap for the topology.h one.
> 
> A suitable (and often good) way of solving this is to identify the
> things which a.h needs from b.h and hoist them out into a new c.h and
> include that from both a.h and b.h.

Kame-san and I reviewed memory_hotplug.h.
We found its including was not necessary certainly.

This is the patch to fix it. I tested on IA64, and checked cross-compile
on powerpc. Kame-san tested this on x86-64.

Thanks for your report.

Bye.

----
Fix no need including of mmzone.h in memory_hotplug.h

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---
 include/linux/memory_hotplug.h |    1 -
 1 file changed, 1 deletion(-)

Index: dptest/include/linux/memory_hotplug.h
===================================================================
--- dptest.orig/include/linux/memory_hotplug.h	2008-05-21 10:56:00.000000000 +0900
+++ dptest/include/linux/memory_hotplug.h	2008-05-26 20:32:06.000000000 +0900
@@ -1,7 +1,6 @@
 #ifndef __LINUX_MEMORY_HOTPLUG_H
 #define __LINUX_MEMORY_HOTPLUG_H
 
-#include <linux/mmzone.h>
 #include <linux/spinlock.h>
 #include <linux/notifier.h>
 
-- 
Yasunori Goto 


