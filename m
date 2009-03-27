Return-Path: <linux-kernel-owner+w=401wt.eu-S1759955AbZC0Dbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955AbZC0Dbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 23:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbZC0Dbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 23:31:35 -0400
Received: from thunk.org ([69.25.196.29]:39733 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbZC0Dbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 23:31:34 -0400
Date: Thu, 26 Mar 2009 23:30:22 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] issue storage device flush via sync_blockdev()
Message-ID: <20090327033022.GO6239@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jeff Garzik <jeff@garzik.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Arjan van de Ven <arjan@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Nick Piggin <npiggin@suse.de>, David Rees <drees76@gmail.com>,
	Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org> <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain> <20090325212923.GA5620@havoc.gtf.org> <20090326032445.GA16999@havoc.gtf.org> <20090327025044.GM6239@mit.edu> <49CC4558.7020701@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CC4558.7020701@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 11:17:44PM -0400, Jeff Garzik wrote:
> Theodore Tso wrote:
>> Jeff,
>>
>> FYI, I tried your patch; it causes the lvm process called out of
>> the initramfs from an Ubuntu 8.10 system to blow up while trying to
>> set up the root filesystem.  The stack trace was:
>>
>> generic_make_request+0x2a3/0x2e6
>> trace_hardirqs_on_caller+0x111/0x135
>> mempool_alloc_slab+0xe/0x10
>> mempool_alloc+0x42/0xe0
>> submit_bio+0xad/0xb5
>> bio_alloc_bioset+0x21/0xfc
>> blkdev_issue_flush+0x7f/0xfc
>> syn_blockdev+0x2a/0x36
>> __blkdev_put_0x44/0x131
>> blkdev_put+0xa/0xc
>> blkdev_close+0x2e/0x32
>> __fput+0xcf/0x15f
>> fput+0x19/0x1b
>> filp_close+0x51/0x5b
>> sys_close+0x73/0xad
>
> hmmm, I wonder if DM/LVM doesn't like blkdev_issue_flush, or it's too  
> early, or what.  I'll toss Ubuntu onto a VM and check it out...

I forgot to mention.  The failure was the EIP was NULL; so it looks
like we called a null function pointer.  The only function pointer
derference I can find is q->make_request_fn() in line 1460 of
blk-core.c, in __generic_make_request.  But that doesn't seem make any
sense....  

Anyway, maybe you can figure out what's going on.  The problem
disappeared as soon as I popped off this patch, though, so it was
pretty clearly the culprit.

					- Ted
