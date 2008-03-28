Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbYC1S1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbYC1S1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 14:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbYC1S12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 14:27:28 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36559 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466AbYC1S11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 14:27:27 -0400
Subject: Re: [PATCH 2 of 4] hotplug-memory: adding non-section-aligned
	memory is bad
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <47ED36AC.9000807@goop.org>
References: <e0b16cc8349b38a5f3f9.1206664118@localhost>
	 <20080328102719.3ab9162b.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080328102342.B0BF.E1E9C6FF@jp.fujitsu.com>
	 <20080328105406.5dc61c6c.kamezawa.hiroyu@jp.fujitsu.com>
	 <47EC5440.5020107@goop.org>
	 <20080328113312.65cca8b5.kamezawa.hiroyu@jp.fujitsu.com>
	 <47EC5D2E.8060001@goop.org>
	 <20080328121758.7f355925.kamezawa.hiroyu@jp.fujitsu.com>
	 <47EC7202.3040009@goop.org>
	 <20080328133940.dc3be13d.kamezawa.hiroyu@jp.fujitsu.com>
	 <47ED36AC.9000807@goop.org>
Content-Type: text/plain
Date: Fri, 28 Mar 2008 11:27:23 -0700
Message-Id: <1206728843.7883.138.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-28 at 11:19 -0700, Jeremy Fitzhardinge wrote:
> KAMEZAWA Hiroyuki wrote:
> >> What would happen if I did online_pages(pfn, 1) on each page as I 
> >> populate it?
> >>
> >>     
> > I think (hope) it works well. But it seems no one tries to do that.
> 
> Well I had immediate problems because I try to use it under spinlock and 
> it calls online_pages -> build_all_zonelists -> stop_machine_run.  I can 
> easily rearrange to fix that, but it seems to me that stop_machine_run() 
> is probably too expensive to call thousands of times (one for each page, 
> rather than once per section).

Yeah, you certainly don't want to be messing with things like the zone
boundaries for each page online operation.  

All that you really want to do is hook into add_one_highpage_hotplug()
and keep the pages from going back into the allocator, right?  Then, you
can have the Xen code go and actually free_page() on them, later.

I don't think *any* of this code actually touches the new physical pages
themselves.  The issue that you're probably seeing is because they get
stuck into the allocator and some other user grabs them right away and
*does* touch them.  

-- Dave

