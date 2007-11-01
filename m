Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbXKAQKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbXKAQKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 12:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbXKAQJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 12:09:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51635 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751389AbXKAQJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 12:09:53 -0400
Date: Thu, 1 Nov 2007 09:08:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
cc: Duane Griffin <duaneg@dghda.com>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: 2.6.23 regression: accessing invalid mmap'ed memory from gdb
 causes unkillable spinning
In-Reply-To: <20071101154705.GA745@wotan.suse.de>
Message-ID: <alpine.LFD.0.999.0711010901290.3342@woody.linux-foundation.org>
References: <e9e943910710301745u429b14fj6c5a66fcbf6b0efa@mail.gmail.com>
 <20071031041932.GA12189@wotan.suse.de> <alpine.LFD.0.999.0710310756220.30120@woody.linux-foundation.org>
 <20071031151934.GA19211@wotan.suse.de> <alpine.LFD.0.999.0710310854560.3340@woody.linux-foundation.org>
 <20071031225541.GA28552@wotan.suse.de> <alpine.LFD.0.999.0710311602170.3342@woody.linux-foundation.org>
 <20071101023758.GA30613@wotan.suse.de> <alpine.LFD.0.999.0711010809171.3342@woody.linux-foundation.org>
 <20071101154705.GA745@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Nov 2007, Nick Piggin wrote:
> 
> Untested patch follows

Ok, this looks ok.

Except I would remove the VM_MAYSHARE bit from the test.

That whole bit should go, in fact.

We used to make it something different: iirc, a read-only SHARED mapping 
was downgraded to a non-shared mapping, because we wanted to avoid some of 
the costs we used to have with the VM implementation (actually, I think it 
was various filesystems that don't like shared mappings because they don't 
have a per-page writeback). But we left the VM_MAYSHARE bit on, to get 
/proc/<pid>/mmap things right.

Or something like that. I forget the details. But I *think* we don't 
actually need this any more.

But basically, the "right" way to test for shared mappings is historically 
to just test the VM_MAYSHARE bit - but not *both* bits. Because VM_SHARE 
may have been artificially cleared.

Somebody should double-check my memory.

		Linus
