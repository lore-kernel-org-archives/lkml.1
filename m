Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbZGVG1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbZGVG1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 02:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbZGVG1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 02:27:31 -0400
Received: from mail-px0-f186.google.com ([209.85.216.186]:45156 "EHLO
	mail-px0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbZGVG1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 02:27:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AnzDtAtgm6X84KUsjgh2LJdQR+hSSwqSg6BbipIbh9D2CEMjWGyAcUKsnPj8d42+Vz
         n3HA/+fMVgGlox3RlxXlVdLO39mi1QGpjpzqtWj4uQiSLr7Y6gYYspA3S8v9KpDuyVNn
         hXta/lQ9sEyRrHUQMq3eimNUjZstqiXwcVZWQ=
Date: Wed, 22 Jul 2009 14:29:43 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] kcore: remove noise from walk_memory_resource
Message-ID: <20090722062943.GF6281@cr0.nay.redhat.com>
References: <20090722140613.0a751811.kamezawa.hiroyu@jp.fujitsu.com> <20090722141227.9712ee7b.kamezawa.hiroyu@jp.fujitsu.com> <20090722062103.GE6281@cr0.nay.redhat.com> <20090722152238.fc6ce3f3.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090722152238.fc6ce3f3.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 03:22:38PM +0900, KAMEZAWA Hiroyuki wrote:
>On Wed, 22 Jul 2009 14:21:03 +0800
>Amerigo Wang <xiyou.wangcong@gmail.com> wrote:
>
>> On Wed, Jul 22, 2009 at 02:12:27PM +0900, KAMEZAWA Hiroyuki wrote:
>> >From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> >
>> >Originally, walk_memory_resource() was introduced to traverse all memory
>> >of "System RAM" for detecting memory hotplug/unplug range.
>> >For doing so, flags of IORESOUCE_MEM|IORESOURCE_BUSY was used and this
>> >was enough for memory hotplug because scanning range was controlled properly.
>> >
>> >But for using other purpose, /proc/kcore, this may includes some firmware
>> >area marked as IORESOURCE_BUSY | IORESOUCE_MEM. This patch makes the check
>> >strict to find out busy "System RAM".
>> >
>> >Note: PPC64 keeps their own walk_memory_resouce(), which walk through
>> >ppc64's lmb informaton. Because old kclist_add() is called per lmb,
>> >this patch makes no difference in behavior, finally.
>> >
>> >Changelog v2:
>> > - new patch from v2.
>> >
>> >Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> >---
>> > kernel/resource.c |   18 ++++++++++++++----
>> > 1 file changed, 14 insertions(+), 4 deletions(-)
>> >
>> >Index: mmotm-2.6.31-Jul16/kernel/resource.c
>> >===================================================================
>> >--- mmotm-2.6.31-Jul16.orig/kernel/resource.c
>> >+++ mmotm-2.6.31-Jul16/kernel/resource.c
>> >@@ -237,10 +237,10 @@ EXPORT_SYMBOL(release_resource);
>> > #if !defined(CONFIG_ARCH_HAS_WALK_MEMORY)
>> > /*
>> >  * Finds the lowest memory reosurce exists within [res->start.res->end)
>> >- * the caller must specify res->start, res->end, res->flags.
>> >+ * the caller must specify res->start, res->end, res->flags and "name".
>> >  * If found, returns 0, res is overwritten, if not found, returns -1.
>> >  */
>> >-static int find_next_system_ram(struct resource *res)
>> >+static int find_next_system_ram(struct resource *res, char *name)
>> > {
>> > 	resource_size_t start, end;
>> > 	struct resource *p;
>> >@@ -256,6 +256,8 @@ static int find_next_system_ram(struct r
>> > 		/* system ram is just marked as IORESOURCE_MEM */
>> > 		if (p->flags != res->flags)
>> > 			continue;
>> >+		if (name && strcmp(p->name, name))
>> >+			continue;
>> > 		if (p->start > end) {
>> > 			p = NULL;
>> > 			break;
>> >@@ -273,19 +275,27 @@ static int find_next_system_ram(struct r
>> > 		res->end = p->end;
>> > 	return 0;
>> > }
>> >+
>> >+/*
>> >+ * This function calls callback against all memory range of "System RAM"
>> >+ * which are marked as IORESOURCE_MEM and IORESOUCE_BUSY.
>> >+ * Now, this function is only for "System RAM".
>> 
>> 
>> Then we should change its name, shouldn't we? :)
>> 
>I tried, but not changed in this version bacause the usage/purpose is not changed.
>
>Hmm, How about walk_system_ram_range() ?


Fine for me.

Thank you.
