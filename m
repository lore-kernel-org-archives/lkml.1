Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbYKMCRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbYKMCRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 21:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYKMCRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 21:17:42 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33154 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbYKMCRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 21:17:41 -0500
Date: Thu, 13 Nov 2008 11:17:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc4 mem_cgroup_charge_common panic
Message-Id: <20081113111702.9a5b6ce7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1226527376.4835.8.camel@badari-desktop>
References: <1226353408.8805.12.camel@badari-desktop>
	<20081111101440.f531021d.kamezawa.hiroyu@jp.fujitsu.com>
	<20081111110934.d41fa8db.kamezawa.hiroyu@jp.fujitsu.com>
	<1226527376.4835.8.camel@badari-desktop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 14:02:56 -0800
Badari Pulavarty <pbadari@us.ibm.com> wrote:

> On Tue, 2008-11-11 at 11:09 +0900, KAMEZAWA Hiroyuki wrote:
> > On Tue, 11 Nov 2008 10:14:40 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > > On Mon, 10 Nov 2008 13:43:28 -0800
> > > Badari Pulavarty <pbadari@us.ibm.com> wrote:
> > > 
> > > > Hi KAME,
> > > > 
> > > > Thank you for the fix for online/offline page_cgroup panic.
> > > > 
> > > > While running memory offline/online tests ran into another
> > > > mem_cgroup panic.
> > > > 
> > > 
> > > Hm, should I avoid freeing mem_cgroup at memory Offline ?
> > > (memmap is also not free AFAIK.)
> > > 
> > > Anyway, I'll dig this. thanks.
> > > 
> > it seems not the same kind of bug..
> > 
> > Could you give me disassemble of mem_cgroup_charge_common() ?
> > (I'm not sure I can read ppc asm but I want to know what is "0x20"
> >  of fault address....)
> > 
> > As first impression, it comes from page migration..
> > rc4's page migration handler of memcg handles *usual* path but not so good.
> > 
> > new migration code of memcg in mmotm is much better, I think.
> > Could you try mmotm if you have time ?
> 
> I tried mmtom. Its even worse :(
> 
> Ran into following quickly .. Sorry!!
> 
>From 
> Instruction dump:
> 794b1f24 794026e4 7d6bda14 7d3b0214 7d234b78 39490008 e92b0048 39290001 
> f92b0048 419e001c e9230008 f93c0018 <f9090008> f9030008 f9480008 48000018 

the reason doesn't seem to be different from the one you saw in rc4.

We'do add_list() hear, so (maybe) used page_cgroup is zero-cleared, I think.
We usually do migration test on cpuset and confirmed this works with migration.

Hmm...I susupect following. could you try ?

Sorry.
-Kame
==

Index: mmotm-2.6.28-Nov10/mm/page_cgroup.c
===================================================================
--- mmotm-2.6.28-Nov10.orig/mm/page_cgroup.c
+++ mmotm-2.6.28-Nov10/mm/page_cgroup.c
@@ -166,7 +166,7 @@ int online_page_cgroup(unsigned long sta
 	end = ALIGN(start_pfn + nr_pages, PAGES_PER_SECTION);
 
 	for (pfn = start; !fail && pfn < end; pfn += PAGES_PER_SECTION) {
-		if (!pfn_present(pfn))
+		if (!pfn_valid(pfn))
 			continue;
 		fail = init_section_page_cgroup(pfn);
 	}



