Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbYE2Rqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbYE2Rqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 13:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbYE2RqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 13:46:22 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52743 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbYE2RqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 13:46:22 -0400
Message-ID: <483EEBE5.5030708@garzik.org>
Date: Thu, 29 May 2008 13:46:13 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: RESEND: [PATCH] libata-sff: Fix oops reported in kerneloops.org
 for pnp devices with no ctl
References: <20080529161453.24735.805.stgit@core> <alpine.LFD.1.10.0805290950230.2958@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805290950230.2958@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 29 May 2008, Alan Cox wrote:
>> (Jeff would you please take a look at this: Its #4 or #5 top OOPS on Arjan's
>>  oops tracker, and it generally causes the boot to fail. First sent 20th May)
> 
> Quite frankly, if I was Jeff, I'd have refused to apply this patch as "too 
> damn ugly to live".
> 
> Why the *hell* doesn't it just fix "ata_sff_altstatus()" instead? Why does 
> it introduce a ludicrously named stupid "maybe" version of it that doesn't 
> oops?
> 
> In other words: in *any* case where the old "ata_sff_altstatus()" function 
> worked correctly, the new "ata_sff_maybe_altstatus()" function does THE 
> EXACT SAME THING. And in any case where the old "ata_sff_altstatus()" 
> function oopsed, the new "maybe" version at least is _better_.
> 
> In other words: there is absolutely no excuse for keeping the old (and 
> known-to-be-broken) "ata_sff_altstatus()" function at all. It should be 
> removed, not left around with an alternate function that works.

That's my general feeling on the issue.  It was ugly and seemed to 
needlessly avoid the existing one, which we would probably have to 
bugfix later on...


> I also think your "ata_sff_sync()" thing is buggy. It has a "ndelay(400)" 
> that is almost certainly buggy (it's the one that is already in 
> ata_sff_pause()).
> 
> It may be that you meant to make it an "else if" case, ie if there was no 
> IO-read, then you do a ndelay(400) as a last desperate case, but that's 
> not how your ata_sdd_sync() is actually written.

The double-ndelay is definitely wrong, but we do need one.  Technically 
it should -only- be a 400ns delay, but we also have a register read in 
there to make sure any posted writes are flushed.

	Jeff



