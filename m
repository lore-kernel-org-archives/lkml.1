Return-Path: <linux-kernel-owner+w=401wt.eu-S1752575AbYDEAli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbYDEAli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 20:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbYDEAl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 20:41:29 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:43079
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbYDEAl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 20:41:29 -0400
Date: Sat, 5 Apr 2008 02:41:27 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Christoph Lameter <clameter@sgi.com>, Robin Holt <holt@sgi.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 01/10] emm: mm_lock: Lock a process against reclaim
Message-ID: <20080405004127.GG14784@duo.random>
References: <20080404223048.374852899@sgi.com> <20080404223131.271668133@sgi.com> <47F6B5EA.6060106@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F6B5EA.6060106@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 04:12:42PM -0700, Jeremy Fitzhardinge wrote:
> I think you can break this if() down a bit:
>
> 			if (!(vma->vm_file && vma->vm_file->f_mapping))
> 				continue;

It makes no difference at runtime, coding style preferences are quite
subjective.

> So this is an O(n^2) algorithm to take the i_mmap_locks from low to high 
> order?  A comment would be nice.  And O(n^2)?  Ouch.  How often is it 
> called?

It's called a single time when the mmu notifier is registered. It's a
very slow path of course. Any other approach to reduce the complexity
would require memory allocations and it would require
mmu_notifier_register to return -ENOMEM failure. It didn't seem worth
it.

> And is it necessary to mush lock and unlock together?  Unlock ordering 
> doesn't matter, so you should just be able to have a much simpler loop, no?

That avoids duplicating .text. Originally they were separated. unlock
can't be a simpler loop because I didn't reserve vm_flags bitflags to
do a single O(N) loop for unlock. If you do malloc+fork+munmap two
vmas will point to the same anon-vma lock, that's why the unlock isn't
simpler unless I mark what I locked with a vm_flags bitflag.
