Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZGWU2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZGWU2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 16:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbZGWU2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 16:28:03 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:46587 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbZGWU2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 16:28:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAK9kaEqrR7PD/2dsb2JhbAC4RIglkQkFhA0
X-IronPort-AV: E=Sophos;i="4.43,257,1246838400"; 
   d="scan'208";a="218341701"
From: Roland Dreier <rdreier@cisco.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jeff Squyres <jsquyres@cisco.com>
Subject: Re: [PATCH/RFC] ummunot: Userspace support for MMU notifications
References: <ada3a8oobis.fsf@cisco.com>
	<20090722111538.58a126e3.akpm@linux-foundation.org>
	<adad47smsb5.fsf@cisco.com> <4A682795.8050609@cn.fujitsu.com>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 23 Jul 2009 13:28:01 -0700
In-Reply-To: <4A682795.8050609@cn.fujitsu.com> (Li Zefan's message of "Thu, 23
	Jul 2009 17:04:21 +0800")
Message-ID: <adafxcn401a.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Jul 2009 20:28:02.0014 (UTC) FILETIME=[136997E0:01CA0BD4]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > This can be implemented as a tracer or trace events, though I'm
 > not sure if it can fully meet your requirements or not.
 > 
 > To implement it as trace events, we add tracepoints in mmu_inlivadate_xxx(),
 > and define some TRACE_EVENT() macros.
 > 
 > And below shows how to use it:
 > 
 >   # mount -t debugfs xxx /mnt
 >   # cd /mnt/tracing/
 >   # echo 1 > events/mmu/enable
 >   # echo '(start >= 10000000 && end <= 10004096) || \
 > 	(start >= 20000000 && end <= 20004096)' > events/mmu/filter
 >   # cat trace_pipe
 >         bash-2066  [001]   795.239077: mmu_invalidate_range_start: start=10000000 end=10000100
 >         bash-2066  [001]   795.239091: mmu_invalidate_range_start: start=10000000 end=10000100
 >         bash-2066  [001]   795.239098: mmu_invalidate_range_start: start=10000000 end=10000100
 >          cat-2189  [001]   795.239502: mmu_invalidate_page: start=20000000 end=20003000
 >          cat-2189  [001]   795.239578: mmu_invalidate_page: start=20000000 end=20003000
 >         bash-2066  [001]   795.239626: mmu_invalidate_page: start=20000000 end=20003000
 > 
 > The patch is extremely simple:

Thanks... unfortunately I don't think this really helps for the use case
I'm trying to address.  What's desired is a way for an unprivileged
userspace process to monitor (parts of) its own address space; I think
getting a single stream of all such events is not going to be helpful,
because, first, the overhead of filtering out the subset of useful
events may be too high to make this useful and, second, exposing events
about unrelated processes is probably a security hole (eg "allocation
channel" attacks on crypto processes analogous to timing channel attacks)

If there were some way for each process to get a trace of its own events
then that would be very close to what I'm trying to implement.

Thanks,
  Roland
