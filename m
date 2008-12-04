Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbYLDAcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbYLDAcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbYLDAcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:32:36 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47005 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYLDAcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:32:36 -0500
Date: Thu, 4 Dec 2008 09:31:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: gerald.schaefer@de.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       y-goto@jp.fujitsu.com, npiggin@suse.de
Subject: Re: [PATCH] memory hotplug: run lru_add_drain_all() on each cpu
Message-Id: <20081204093143.390afa9f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1228342567.13111.11.camel@nimitz>
References: <1228339524.6598.11.camel@t60p>
	<1228342567.13111.11.camel@nimitz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Dec 2008 14:16:07 -0800
Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> > This let us run
> > into the BUG_ON(!PageBuddy(page)) in __offline_isolated_pages() during
> > memory hotplug stress test on s390. The page in question was still on the
> > pcp list, because of a race with lru_add_drain_all() and drain_all_pages()
> > on different cpus.
> > 
> > This is fixed with this patch by adding CONFIG_MEMORY_HOTREMOVE to the
> > lru_add_drain_all() #ifdef, to let it run on each cpu.
> 
> This doesn't seem right to me.  CONFIG_MEMORY_HOTREMOVE doesn't change
> the layout of the LRUs, unlike NUMA or UNEVICTABLE_LRU.  So, I think
> this bug is more due to the hotremove code mis-expecting behavior out of
> lru_add_drain_all().
> 
How about 

#ifdef CONFIG_SMP

#else..

#endif

rather than

-#if defined(CONFIG_NUMA) || defined(CONFIG_UNEVICTABLE_LRU)
+#if defined(CONFIG_NUMA) || defined(CONFIG_UNEVICTABLE_LRU) || \
+    defined(CONFIG_MEMORY_HOTREMOVE)
...

thanks,
-Kame

