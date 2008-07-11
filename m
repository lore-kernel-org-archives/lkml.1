Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbYGKScW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbYGKScW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 14:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbYGKScK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 14:32:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755361AbYGKScJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 14:32:09 -0400
Date: Fri, 11 Jul 2008 11:31:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Roland McGrath <roland@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Elias Oltmanns <eo@nebensachen.de>,
       =?ISO-8859-15?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: <alpine.LFD.1.10.0807111102450.2936@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807111120470.2936@woody.linux-foundation.org>
References: <20080710215039.2A143154218@magilla.localdomain> <20080711054605.GA17851@elte.hu> <alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org> <alpine.LFD.1.10.0807111102450.2936@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Jul 2008, Linus Torvalds wrote:
> 
> Btw, did any of the impacted people test -rc9? Edwin's report is about 
> -rc2 and -rc8, and one of the things we fixed since -rc8 is that incorrect 
> and unintentional nr_zones zeroing that effectively disabled kswapd - and 
> made everybody do synchronous memory freeing when they wanted to allocate 
> more memory.. That can play havoc with any interactive stuff.

Hmm. Edwin's latencytop output includes this (ignoring the _very_ top 
entries that are all either CD-ROM media change tests or are interruptible 
pipe/select things) at the top:

	21 10264428 915514 get_request_wait __make_request generic_make_request
		submit_bio xfs_submit_ioend_bio xfs_submit_ioend 
		xfs_page_state_convert xfs_vm_writepage __writepage 
		write_cache_pages generic_writepages xfs_vm_writepages

	26 3369263 2260529 down xfs_buf_iowait xfs_buf_iostart xfs_buf_read_flags 
		xfs_trans_read_buf xfs_imap_to_bp xfs_itobp xfs_iread 
		xfs_iget_core xfs_iget xfs_lookup xfs_vn_lookup 1 17888 17888 down 
		xfs_buf_iowait xfs_buf_iostart xfs_buf_read_flags 
		xfs_trans_read_buf xfs_da_do_buf xfs_da_read_buf 
		xfs_dir2_block_getdents xfs_readdir xfs_file_readdir vfs_readdir 
		sys_getdents64
	..

which says that (a) yes, readdir() is part of the problematic paths, so my 
patch may make a difference but also (b) we also have so many writeback 
IO's in flight that the write request queue is totally full, and the 
writing side is simply waiting for the queue to empty.

I guess (b) isn't a surprise (considering the load), but it does explain 
why any IO read will be very much delayed. If the IO scheduler (or the 
disk itself - tagged commands etc) doesn't prioritize reads and 
effectively always put them ahead of the queue, you can get very very long 
latencies just because you have to wait for lots of writes to complete 
first.

			Linus
