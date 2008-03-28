Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbYC1DRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbYC1DRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 23:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbYC1DRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 23:17:03 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48556 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbYC1DRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 23:17:02 -0400
Date: Fri, 28 Mar 2008 12:17:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <clameter@sgi.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2 of 4] hotplug-memory: adding non-section-aligned
 memory is bad
Message-Id: <20080328121758.7f355925.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47EC5D2E.8060001@goop.org>
References: <e0b16cc8349b38a5f3f9.1206664118@localhost>
	<20080328102719.3ab9162b.kamezawa.hiroyu@jp.fujitsu.com>
	<20080328102342.B0BF.E1E9C6FF@jp.fujitsu.com>
	<20080328105406.5dc61c6c.kamezawa.hiroyu@jp.fujitsu.com>
	<47EC5440.5020107@goop.org>
	<20080328113312.65cca8b5.kamezawa.hiroyu@jp.fujitsu.com>
	<47EC5D2E.8060001@goop.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008 19:51:26 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> > (I wrote online_page() in above, but online_pages() is maybe better.
> >  It does all what you want.)
> >   
> 
> No, for my use-case the pages must be onlined one by one as they get 
> some physical memory assigned to them.  At the time I do add_memory(), 
> I'm just allocating page structures, but there's no memory backing that 
> range.
> 
yes, I see.

> That's why I need to disable the sysfs onlining interface, because it 
> bulk onlines the pages before there's anything behind them.
>

My point is. online_pages() does following things.

- call notifier
- update information , total_pages etc...
- re-configure zonelist if necessary...

But online_page() not. Hmm...

How about capturing online_page() by balloon ?
ex.)
==
call add_memory() to create mem_map
call online_pages() against the whole section. <=== call this without sysfs.
     online_pages() do misc. jobs
        call online_page() one by one (arch dependent) called by walk_memory_resource.
            online_page() will finally call free_page(page).
            <=========== Xen capture here.
            Don't free onlined page and swallow them into baloon driver.
==

Thanks,
-Kame

