Return-Path: <linux-kernel-owner+w=401wt.eu-S1760120AbYFRAsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760120AbYFRAsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 20:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758217AbYFRAsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 20:48:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757868AbYFRAsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 20:48:12 -0400
Date: Tue, 17 Jun 2008 20:47:57 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
cc: Alasdair G Kergon <agk@redhat.com>
Subject: stack overflow on Sparc64
Message-ID: <Pine.LNX.4.64.0806171954060.2560@engineering.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am getting stack overflows on my Sparc64 station. They happen when I 
copy to device-mapper snapshot origin device using small IO size (512 
bytes) and simultaneously execute "lvs" command. The kernel is compiled 
with most debugging functions enabled. The stack trace is this:

__ide_end_request
__blk_end_request
__end_that_request_first
req_bio_endio
bio_endio
clone_endio
dec_pending
bio_endio
clone_endio
dec_pending
bio_endio
clone_endio
dec_pending
bio_endio
end_bio_bh_io_sync
end_buffer_read_sync
__end_buffer_read_notouch
unlock_buffer
wake_up_bit
__wake_up_bit
__wake_up
__wake_up_common
wake_bit_function
autoremove_wake_function
default_wake_function
try_to_wake_up
task_rq_lock
__spin_lock
lock_acquire
__lock_acquire
*** crash, stack overflow

--- observations:

That loop bio_endio->clone_endio->dec_pending is repeating for each level 
of nested devices --- so for any architecture there exists a level at 
which it causes trouble. We need something to prevent recursion, maybe the 
similar trick that was done with avoing bio request function recursion 
(i.e. if bio_endio is called recursively, it just adds the bio to queue 
and lets the top level to call endio method).

Wait queue waking looks like being written by a high-level maniac --- it 
contains 8 levels of calls (none of them inlined). 7 of these calls (until 
try_to_wake_up) do nothing but pass arguments to lower level call. And 
each of these calls allocate at least 192 bytes of stack space. All these 
7 useless calls consume 1360 bytes of stack (and cause windows traps that 
needlessly damage performance). Would you agree to inline most of the 
calls to save stack? Or do you see another solution?

Long-term consideration: Is it possible to implement interrupt stacks on 
sparc64? Functions on sparc eat stack much more aggressively than on other 
architectures (minimum stack size for a function is 192 bytes).

Mikulas
