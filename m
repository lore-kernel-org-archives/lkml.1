Return-Path: <linux-kernel-owner+w=401wt.eu-S1758903AbZD3CnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903AbZD3CnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 22:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbZD3CnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 22:43:08 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:42173 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869AbZD3CnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 22:43:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhYFAAaq+ElMQW1W/2dsb2JhbACBUL0DCJBdgiUWCIEyBQ
Date: Wed, 29 Apr 2009 22:43:03 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, thomas.pi@arcor.dea,
       Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] Fix dirty page accounting in
	redirty_page_for_writepage()
Message-ID: <20090430024303.GB19875@Krystal>
References: <20090429232546.GB15782@Krystal> <alpine.LFD.2.00.0904291701450.22156@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904291701450.22156@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:34:10 up 60 days, 23:00,  1 user,  load average: 0.28, 0.50,
	0.41
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Wed, 29 Apr 2009, Mathieu Desnoyers wrote:
> >
> > This patch adds missing dirty page accounting in redirty_page_for_writepage().
> > This should fix a _lot_ of issues involving machines becoming slow under heavy
> > write I/O. No surprise : eventually the system starts swapping.
> 
> That patch (and description) is odd.
> 
> The patch actually adds the dirty page accounting not to 
> redirty_page_for_writepage(), but to __set_page_dirty_nobuffers().
> 
> And __set_page_dirty_nobuffers() will later (just a few lines down) call 
> down to account_page_dirtied(), which in turn does all that 
> same accounting (assuming the "mapping" is marked to account for dirty.
> 
> So the description seems to be wrong, but so does the patch. 
> 
> Did you attach the wrong patch (explaining both problems)?
> 

Nope, just tried to go back into the OOM problem I experienced when
testing the "heavy I/O latency" bug. But it looks like I can't reproduce
it anyway.

> Or if the patch is what you really meant to do, then you need to fix your 
> explanation, and also explain why the double-dirty accounting is a good 
> idea.

Nope, I just "messed this one up" completely. :-)

> 
> Or is the real problem perhaps that your /tmp is ramdisk, and not marked 
> to do dirty accounting?

Nope, I don't think so. /tmp is on a ext3 partition, on raid 1, sata
disks.

And thanks for the review! This excercise only convinced me that the
kernel memory accounting works as expected. All this gave me the chance
to have a good look at the memory accounting code. We could probably
benefit of Christoph Lameter's cpu ops (using segment registers to
address per-cpu variables with atomic inc/dec) in there. Or at least
removing interrupt disabling by using preempt disable and local_t
variables for the per-cpu counters could bring some benefit.

Mathieu

> 
> 		Linus

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
