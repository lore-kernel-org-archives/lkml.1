Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbZCZAMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbZCZAMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 20:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbZCZAMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 20:12:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752990AbZCZAMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 20:12:05 -0400
Date: Wed, 25 Mar 2009 17:04:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jan Kara <jack@suse.cz>
cc: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <20090325235041.GA11024@duck.suse.cz>
Message-ID: <alpine.LFD.2.00.0903251657510.3032@localhost.localdomain>
References: <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324041249.1133efb6.akpm@linux-foundation.org> <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>
 <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Mar 2009, Jan Kara wrote:
>
>   I can write a patch to make writepage() in the non-"mmapped creation"
> case non-blocking on journal. But I'll also have to find out whether it
> really helps something. But it's probably worth trying...

Actually, it really should be easier to make a patch that just does the 
journal thing if ->set_page_dirty() is called, and buffers weren't already 
allocated.

Then ext3_[ordered|writeback]_writepage() _should_ just become something 
like

	if (test_opt(inode->i_sb, NOBH))
		return nobh_writepage(page, ext3_get_block, wbc);

	return block_write_full_page(page, ext3_get_block, wbc);

and that's it. The code would be simpler to understand to boot.

			Linus
