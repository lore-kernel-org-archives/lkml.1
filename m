Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbXHVCvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbXHVCvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 22:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbXHVCvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 22:51:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37662 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbXHVCvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 22:51:43 -0400
Date: Wed, 22 Aug 2007 11:52:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, clameter@sgi.com
Subject: Re: bug in migrate page
Message-Id: <20070822115258.7d59aaa1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1187748489.8474.21.camel@sli10-conroe.sh.intel.com>
References: <1187748489.8474.21.camel@sli10-conroe.sh.intel.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 10:08:09 +0800
Shaohua Li <shaohua.li@intel.com> wrote:

> commit dc386d4d1e98bb39fb967ee156cd456c802fc692 adds rcu_read_lock, but
> some routines in the lock range might sleep (like lock_buffer,
> aops->writepage), I saw a 'sleep in atomic' warning. It appears the
> patch has several versions before. Doing rcu_read_lock in PageAnon
> sounds break the case of PageAnon(page) && PageSwapCache(page),
> as .writepage might be called. The dummy anon patch maybe is ok.
> 

Thank you for catching.

Maybe you're correct.

BTW, in PageAnon(page) && PageSwapCache(page) case, I can't find when
.writepage is called. Could you explain ?

In my understanding,

rcu_read_lock()
	-> try_to_unmap()
	-> move_to_new_page()
		-> migrate_page() // swap has .migratepage member.
			-> migrate_page_move_mapping().
			-> migrate_page_copy().
		-> remove_migration_ptes().


At quick glance, above path has no writepage() ops.
just replace swap's radix tree entry.

Thanks,
-Kame

