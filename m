Return-Path: <linux-kernel-owner+w=401wt.eu-S1752983AbZGVGYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbZGVGYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 02:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZGVGYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 02:24:22 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51428 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbZGVGYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 02:24:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 22 Jul 2009 15:22:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] kcore: remove noise from walk_memory_resource
Message-Id: <20090722152238.fc6ce3f3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090722062103.GE6281@cr0.nay.redhat.com>
References: <20090722140613.0a751811.kamezawa.hiroyu@jp.fujitsu.com>
	<20090722141227.9712ee7b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090722062103.GE6281@cr0.nay.redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 14:21:03 +0800
Amerigo Wang <xiyou.wangcong@gmail.com> wrote:

> On Wed, Jul 22, 2009 at 02:12:27PM +0900, KAMEZAWA Hiroyuki wrote:
> >From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >
> >Originally, walk_memory_resource() was introduced to traverse all memory
> >of "System RAM" for detecting memory hotplug/unplug range.
> >For doing so, flags of IORESOUCE_MEM|IORESOURCE_BUSY was used and this
> >was enough for memory hotplug because scanning range was controlled properly.
> >
> >But for using other purpose, /proc/kcore, this may includes some firmware
> >area marked as IORESOURCE_BUSY | IORESOUCE_MEM. This patch makes the check
> >strict to find out busy "System RAM".
> >
> >Note: PPC64 keeps their own walk_memory_resouce(), which walk through
> >ppc64's lmb informaton. Because old kclist_add() is called per lmb,
> >this patch makes no difference in behavior, finally.
> >
> >Changelog v2:
> > - new patch from v2.
> >
> >Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >---
> > kernel/resource.c |   18 ++++++++++++++----
> > 1 file changed, 14 insertions(+), 4 deletions(-)
> >
> >Index: mmotm-2.6.31-Jul16/kernel/resource.c
> >===================================================================
> >--- mmotm-2.6.31-Jul16.orig/kernel/resource.c
> >+++ mmotm-2.6.31-Jul16/kernel/resource.c
> >@@ -237,10 +237,10 @@ EXPORT_SYMBOL(release_resource);
> > #if !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
> > /*
> >  * Finds the lowest memory reosurce exists within [res->start.res->end)
> >- * the caller must specify res->start, res->end, res->flags.
> >+ * the caller must specify res->start, res->end, res->flags and "name".
> >  * If found, returns 0, res is overwritten, if not found, returns -1.
> >  */
> >-static int find_next_system_ram(struct resource *res)
> >+static int find_next_system_ram(struct resource *res, char *name)
> > {
> > 	resource_size_t start, end;
> > 	struct resource *p;
> >@@ -256,6 +256,8 @@ static int find_next_system_ram(struct r
> > 		/* system ram is just marked as IORESOURCE_MEM */
> > 		if (p->flags != res->flags)
> > 			continue;
> >+		if (name && strcmp(p->name, name))
> >+			continue;
> > 		if (p->start > end) {
> > 			p = NULL;
> > 			break;
> >@@ -273,19 +275,27 @@ static int find_next_system_ram(struct r
> > 		res->end = p->end;
> > 	return 0;
> > }
> >+
> >+/*
> >+ * This function calls callback against all memory range of "System RAM"
> >+ * which are marked as IORESOURCE_MEM and IORESOUCE_BUSY.
> >+ * Now, this function is only for "System RAM".
> 
> 
> Then we should change its name, shouldn't we? :)
> 
I tried, but not changed in this version bacause the usage/purpose is not changed.

Hmm, How about walk_system_ram_range() ?


> >+ */
> > int
> > walk_memory_resource(unsigned long start_pfn, unsigned long nr_pages, void *arg,
> >-			int (*func)(unsigned long, unsigned long, void *))
> >+		int (*func)(unsigned long, unsigned long, void *))
> 
> 
> This line is a trivial change, I don't want to see it mixed with
> the rest...
Sorry, this was from a trial I tried to change the name ;) I'll remove this.

I'll post v3 but wait for a day to hear other comments.

Thank you for review.

Regards,
-Kame

> 
> 
> > {
> > 	struct resource res;
> > 	unsigned long pfn, len;
> > 	u64 orig_end;
> > 	int ret = -1;
> >+
> > 	res.start = (u64) start_pfn << PAGE_SHIFT;
> > 	res.end = ((u64)(start_pfn + nr_pages) << PAGE_SHIFT) - 1;
> > 	res.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
> > 	orig_end = res.end;
> >-	while ((res.start < res.end) && (find_next_system_ram(&res) >= 0)) {
> >+	while ((res.start < res.end) &&
> >+		(find_next_system_ram(&res, "System RAM") >= 0)) {
> > 		pfn = (unsigned long)(res.start >> PAGE_SHIFT);
> > 		len = (unsigned long)((res.end + 1 - res.start) >> PAGE_SHIFT);
> > 		ret = (*func)(pfn, len, arg);
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >Please read the FAQ at  http://www.tux.org/lkml/
> 

