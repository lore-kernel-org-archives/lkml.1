Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbYJGN5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbYJGN5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 09:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbYJGN5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 09:57:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:37328 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbYJGN5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 09:57:39 -0400
Subject: [BUG] SLOB's krealloc() seems bust
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-mm <linux-mm@kvack.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 07 Oct 2008 15:57:20 +0200
Message-Id: <1223387841.26330.36.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My test box would crash 50% of the bootups like so:

[   12.002323] BUG: unable to handle kernel paging request at ffff88047bdd513c              
[   12.003310] IP: [<ffffffff80261f17>] load_module+0x6c8/0x1b2a                            
[   12.003310] PGD 202063 PUD 0                                                             
[   12.003310] Oops: 0000 [1] PREEMPT SMP
[   12.003310] CPU 0
[   12.003310] Modules linked in: kvm_amd kvm sg sr_mod serio_raw k8temp floppy pcspkr button cdrom shpchp
[   12.003310] Pid: 1219, comm: modprobe Not tainted 2.6.27-rc9 #452

Which points us to the percpu_modalloc() code.

After adding some printk's to get some insight into the matter I got the
following:

[   10.058055] percpu_modalloc: pcpu_size: ffff88007d82c0e8 size: 8 align: 8 name: kvm_amd  
[   10.066042] percpu_modalloc: pcpu_size[0] = -37536 ptr: ffffffff80757000 extra: 0        
[   10.073505] percpu_modalloc: pcpu_size[1] = 8192 ptr: ffffffff807602a0 extra: 0          
[   10.080795] split_block: pcpu_size: ffff88007d82c0e8 i: 1 size: 8                        
[   10.086875] split_block: pcpu_size: ffff88007bdd5140                                     
[   10.091828] split_block: pcpu_size[0] = 2078109024                                       
[   10.096607] split_block: pcpu_size[1] = -30720                                           
[   10.101039] split_block: pcpu_size[0] = 2078109024                                       
[   10.105817] split_block: pcpu_size[1] = -30720                                           
[   10.110249] split_block: pcpu_size[2] = -30720                                           
[   10.114682] split_block: pcpu_size[1] = 8 pcpu_size[2] = -30728   

Which basically shows us that the content of the pcpu_size[] array got
corrupted after the krealloc() call in split_block().

Which made me look at which slab allocator I had selected, which turned
out to be SLOB (from testing the network swap stuff).

Flipping it back to SLUB seems to cure the issue...

Will put poking at SLOB on the todo list somewhere, feel free to beat me
to it ;-)

