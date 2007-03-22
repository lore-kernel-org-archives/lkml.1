Return-Path: <linux-kernel-owner+w=401wt.eu-S965662AbXCVES2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965662AbXCVES2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 00:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965671AbXCVES2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 00:18:28 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:35035 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965662AbXCVES1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 00:18:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=SC7u44hQFZE+xgtPgXbf9U+KCMv6ZK45Haxjnk+vV8z8h1chUfB5lPLyrelimhPrEtGWw0nyUoQEBKOX5FVU84G8+A6sPB5L1g+ae5nhdkboUplBE9eArPQXo/cuG3XdC+K4KNsuapiPhVRJOieE5SMBzaVNLShwsaDJr8WwIC4=  ;
X-YMail-OSG: TY8qW9YVM1lydosK_imRKJacUk9ibeDhbzOOuJZka58gtI0LSb06kFXaeRhpnFROEt.kKJD9FRXOcLNxEBNwwVe.m2UnhGE5555WG8c.Svjp1QJlv4zU2cxGPVNKCDit
Message-ID: <46020385.50301@yahoo.com.au>
Date: Thu, 22 Mar 2007 15:18:13 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [1/6] 2.6.21-rc4: known regressions
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070318184908.GU752@stusta.de> <Pine.LNX.4.64.0703212023550.6730@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703212023550.6730@woody.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:

> In contrast, the hang reported by Mariusz Kozlowski has a slightly 
> different feel to it, but there's a tantalizing pattern in there too:
> 
>   http://www.ussg.iu.edu/hypermail/linux/kernel/0703.0/1243.html
> 
> 	Call Trace:
> 	[<c03ec87e>] io_schedule+0x42/0x59
> 	[<c0184915>] sleep_on_buffer+0x8/0xc
> 	[<c03ed217>] __wait_on_bit+0x47/0x6c
> 	[<c03ed297>] out_of_line_wait_on_bit+0x5b/0x64
> 	[<c01848a8>] __wait_on_buffer+0x27/0x2d
> 	[<c01b4228>] journal_commit_transaction+0x707/0x127f
> 	[<c01b868b>] kjournald+0xac/0x1ed
> 	[<c0126af5>] kthread+0xa2/0xc9
> 	[<c010422b>] kernel_thread_helper+0x7/0x1c
> 
> which certainly also looks like an IO never completed (or completed but 
> never woke anything up).
> 
> It also seems to be related to *buffers*. Maybe the whole bh layer thing 
> is a fluke, but it's not waiting for normal data, it's very much waiting 
> for those journal things that all use buffer heads.Which just makes me 
> worry about those patches by Nick (which did come in through Andrew). I 
> don't think it's the memorder one (it looks safe and shouldn't matter on 
> x86 anyway!), but what about the
> 
> 	fs: fix __block_write_full_page error case buffer submission
> 
> locking change for example? Or that "fs: fix nobh data leak" thing with 
> its fix? It uses "SetPageUptodate(page);" without waking up anybody who 
> might wait for it (but the waiters here seem to wait on buffers, so that's 
> probably not it)..

Nothing sleeps on PageUptodate, so I don't think that could explain it.

The fs: fix __block_write_full_page error case buffer submission patch
does change the locking, but I'd be really suprised if that was the
problem, because it changes locking to match the regular non-error path
submission.

It could be possible that ext3 is doing something weird and expecting
the old behaviour if it failed get_block, but that seems pretty weird
to do, and would need fixing.

fs: nobh data leak... again hard to see how it could cause an unlock/wakeup
to get lost. Is Mariusz using the nobh mount option?

It wouldn't hurt to test with these patches backed out...

> Alternatively, maybe it really is an _io_ problem (and the buffer-head 
> thing is just a red herring, and it could happen to other IO, it's just 
> that metadata IO uses buffer heads), and it's the scheduler changes since 
> 2.6.20..

I see what you mean. Could it be an ext3 or jbd change I wonder?

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
