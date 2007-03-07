Return-Path: <linux-kernel-owner+w=401wt.eu-S932706AbXCGGvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706AbXCGGvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 01:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932830AbXCGGvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 01:51:14 -0500
Received: from smtp.osdl.org ([65.172.181.24]:51590 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932739AbXCGGvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 01:51:11 -0500
Date: Tue, 6 Mar 2007 22:51:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes
 nonlinear)
Message-Id: <20070306225101.f393632c.akpm@linux-foundation.org>
In-Reply-To: <20070221023735.6306.83373.sendpatchset@linux.site>
References: <20070221023656.6306.246.sendpatchset@linux.site>
	<20070221023735.6306.83373.sendpatchset@linux.site>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007 05:50:17 +0100 (CET) Nick Piggin <npiggin@suse.de> wrote:

> Nonlinear mappings are (AFAIKS) simply a virtual memory concept that
> encodes the virtual address -> file offset differently from linear
> mappings.
> 
> I can't see why the filesystem/pagecache code should need to know anything
> about it, except for the fact that the ->nopage handler didn't quite pass
> down enough information (ie. pgoff). But it is more logical to pass pgoff
> rather than have the ->nopage function calculate it itself anyway. And
> having the nopage handler install the pte itself is sort of nasty.
> 
> This patch introduces a new fault handler that replaces ->nopage and
> ->populate and (later) ->nopfn. Most of the old mechanism is still in place
> so there is a lot of duplication and nice cleanups that can be removed if
> everyone switches over.
> 
> The rationale for doing this in the first place is that nonlinear mappings
> are subject to the pagefault vs invalidate/truncate race too, and it seemed
> stupid to duplicate the synchronisation logic rather than just consolidate
> the two.
> 

It's awkward to layer a largely do-nothing patch like this on top of a
significant functional change.  Makes it harder to isolate the source of
regressions, harder to revert the do-something patch.

> After this patch, MAP_NONBLOCK no longer sets up ptes for pages present in
> pagecache. Seems like a fringe functionality anyway.

Does Ingo agree?

> NOPAGE_REFAULT is removed. This should be implemented with ->fault, and
> no users have hit mainline yet.

Did benh agree with that?


The patch unchangeloggedly adds a basic new structure to core mm
(fault_data).  Would be nice to document its fields, especially `flags'.


Please add less pointless blank lines.


How well has this been tested?  The ocfs2 changes?  gfs2?  We should at
least give those guys a heads-up.


Does anybody really pass a NULL `type' arg into filemap_nopage()?


This patch seems to churn things around an awful lot for minimal benefit.

