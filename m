Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbXHVC7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbXHVC7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 22:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbXHVC7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 22:59:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:11797 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbXHVC7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 22:59:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,292,1183359600"; 
   d="scan'208";a="286169678"
Subject: Re: bug in migrate page
From: Shaohua Li <shaohua.li@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: lkml <linux-kernel@vger.kernel.org>, clameter@sgi.com
In-Reply-To: <20070822115258.7d59aaa1.kamezawa.hiroyu@jp.fujitsu.com>
References: <1187748489.8474.21.camel@sli10-conroe.sh.intel.com>
	 <20070822115258.7d59aaa1.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Date: Wed, 22 Aug 2007 10:50:53 +0800
Message-Id: <1187751053.17976.2.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-22 at 11:52 +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 22 Aug 2007 10:08:09 +0800
> Shaohua Li <shaohua.li@intel.com> wrote:
> 
> > commit dc386d4d1e98bb39fb967ee156cd456c802fc692 adds rcu_read_lock, but
> > some routines in the lock range might sleep (like lock_buffer,
> > aops->writepage), I saw a 'sleep in atomic' warning. It appears the
> > patch has several versions before. Doing rcu_read_lock in PageAnon
> > sounds break the case of PageAnon(page) && PageSwapCache(page),
> > as .writepage might be called. The dummy anon patch maybe is ok.
> > 
> 
> Thank you for catching.
> 
> Maybe you're correct.
> 
> BTW, in PageAnon(page) && PageSwapCache(page) case, I can't find when
> .writepage is called. Could you explain ?
> 
> In my understanding,
> 
> rcu_read_lock()
> 	-> try_to_unmap()
> 	-> move_to_new_page()
> 		-> migrate_page() // swap has .migratepage member.
> 			-> migrate_page_move_mapping().
> 			-> migrate_page_copy().
> 		-> remove_migration_ptes().
> 
> 
> At quick glance, above path has no writepage() ops.
> just replace swap's radix tree entry.
I missed swap has .migratepage and thought fallback_migrate_page is
used, then I thought doing rcu lock in PageAnon case is ok.

Thanks,
Shaohua
