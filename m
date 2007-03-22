Return-Path: <linux-kernel-owner+w=401wt.eu-S933113AbXCVPZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113AbXCVPZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 11:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933185AbXCVPZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 11:25:11 -0400
Received: from smtp.osdl.org ([65.172.181.24]:35186 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933113AbXCVPZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 11:25:08 -0400
Date: Thu, 22 Mar 2007 08:21:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>, Mingming Cao <cmm@us.ibm.com>
cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [1/6] 2.6.21-rc4: known regressions
In-Reply-To: <46020385.50301@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0703220813340.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
 <20070318184908.GU752@stusta.de> <Pine.LNX.4.64.0703212023550.6730@woody.linux-foundation.org>
 <46020385.50301@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 22 Mar 2007, Nick Piggin wrote:
> 
> Nothing sleeps on PageUptodate, so I don't think that could explain it.

Good point. I forget that we just test "uptodate", but then always sleep 
on "locked".

> The fs: fix __block_write_full_page error case buffer submission patch
> does change the locking, but I'd be really suprised if that was the
> problem, because it changes locking to match the regular non-error path
> submission.

I'd agree, except something clearly has changed ;^)

> > Alternatively, maybe it really is an _io_ problem (and the buffer-head thing
> > is just a red herring, and it could happen to other IO, it's just that
> > metadata IO uses buffer heads), and it's the scheduler changes since
> > 2.6.20..
> 
> I see what you mean. Could it be an ext3 or jbd change I wonder?

jbd hasn't changed since 2.6.20, and the ext3 changes are mostly 
things like const'ness fixes. And others were things like changing 
"journal_current_handle()" into "ext3_journal_current_handle()", which 
looked exciting considering that the hung processes were waiting for the 
journal, but the fact is, that's just an inline function that just calls 
the old function, so..

But interestingly, there *is* a "EA block reference count racing fix" 
that does move a lock_buffer()/unlock_buffer() to cover a bigger area. It 
looks "obviously correct", but maybe there's a deadlock possibility there 
with ext3_forget() or something?

		Linus
