Return-Path: <linux-kernel-owner+w=401wt.eu-S1756402AbYLaRgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbYLaRgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 12:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbYLaRgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 12:36:13 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:32125 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbYLaRgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 12:36:12 -0500
X-IronPort-AV: E=Sophos;i="4.36,309,1228089600"; 
   d="scan'208";a="119244810"
From: Roland Dreier <rdreier@cisco.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Helge Deller <deller@gmx.de>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-parisc <linux-parisc@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Randolph Chung <randolph@tausq.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       John David Anglin <dave@hiauly1.hia.nrc.ca>
Subject: Re: [PATCH] parisc: fix module loading failure of large kernel modules (take 4)
References: <4959346E.7060600@gmx.de>
	<200812310915.41693.rusty@rustcorp.com.au> <495B5806.3080505@gmx.de>
	<alpine.LFD.2.00.0812310926450.5086@localhost.localdomain>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 31 Dec 2008 09:36:09 -0800
In-Reply-To: <alpine.LFD.2.00.0812310926450.5086@localhost.localdomain> (Linus
	Torvalds's message of "Wed, 31 Dec 2008 09:29:36 -0800 (PST)")
Message-ID: <ada63l0qmba.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 31 Dec 2008 17:36:10.0022 (UTC) FILETIME=[44B77C60:01C96B6E]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Some gcc versions will inline weak functions if they are in scope - even 
 > if there is a non-weak function somewhere else. So you MUST NOT have the 
 > weak definition in the same file (or indirectly called through some inline 
 > functions in a header file) as the call. Because if you do, then any user 
 > with the wrong version of gcc will get the weak function semantics, even 
 > if it was meant to be overridden by something else.

Does this mean lib/swiotlb.c is broken now?  It has eg:

	void * __weak swiotlb_alloc_boot(size_t size, unsigned long nslabs)

and then

	void __init
	swiotlb_init_with_default_size(size_t default_size)
	{
...
		io_tlb_start = swiotlb_alloc_boot(bytes, io_tlb_nslabs);

later on in the same file.

(I just notice this because I saw the warning about swiotlb_alloc_boot()
not being __init but calling __alloc_bootmem_low and so I looked at the
code yesterday)

 - R.
