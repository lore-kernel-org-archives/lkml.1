Return-Path: <linux-kernel-owner+w=401wt.eu-S932278Ab0A1AQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab0A1AQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 19:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932257Ab0A1AQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 19:16:10 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50793 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753902Ab0A1AQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 19:16:09 -0500
Date: Thu, 28 Jan 2010 00:16:36 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, rientjes@google.com,
       minchan.kim@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] oom-kill: add lowmem usage aware oom kill handling
Message-ID: <20100128001636.2026a6bc@lxorguk.ukuu.org.uk>
In-Reply-To: <20100127095812.d7493a8f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com>
	<20100122152332.750f50d9.kamezawa.hiroyu@jp.fujitsu.com>
	<20100125151503.49060e74.kamezawa.hiroyu@jp.fujitsu.com>
	<20100126151202.75bd9347.akpm@linux-foundation.org>
	<20100127085355.f5306e78.kamezawa.hiroyu@jp.fujitsu.com>
	<20100126161952.ee267d1c.akpm@linux-foundation.org>
	<20100127095812.d7493a8f.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Now, /proc/<pid>/oom_score and /proc/<pid>/oom_adj are used by servers.

And embedded, and some desktops (including some neat experimental hacks
where windows slowly get to be bigger bigger oom targes the longer
they've been non-focussed)

> For my customers, I don't like oom black magic. I'd like to recommend to
> use memcg, of course ;) But lowmem oom cannot be handled by memcg, well.
> So I started from this. 

I can't help feeling this is the wrong approach. IFF we are running out
of low memory pages then killing stuff for that reason is wrong to begin
with except in extreme cases and those extreme cases are probably also
cases the kill won't help.

If we have a movable user page (even an mlocked one) then if there is
space in other parts of memory (ie the OOM is due to a single zone
problem) we should *never* be killing in the first place, we should be
moving the page. The mlock case is a bit hairy but the non mlock case is
exactly the same sequence of operations as a page out and page in
somewhere else skipping the widdling on the disk bit in the middle.

There are cases we can't do that - eg if the kernel has it pinned for
DMA, but in that case OOM isn't going to recover the page either - at
least not until the DMA or whatever unpins it (at which point you could
just move it).

Am I missing something fundamental here ?

Alan
