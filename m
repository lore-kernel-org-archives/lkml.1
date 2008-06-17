Return-Path: <linux-kernel-owner+w=401wt.eu-S1758238AbYFQVV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbYFQVV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 17:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbYFQVVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 17:21:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753464AbYFQVVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 17:21:18 -0400
Date: Tue, 17 Jun 2008 14:20:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bron Gondwana <brong@fastmail.fm>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386,
 bisected, reproducable)
In-Reply-To: <alpine.LFD.1.10.0806171356320.2908@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0806171415060.2907@woody.linux-foundation.org>
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org>
 <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org> <alpine.LFD.1.10.0806171331460.2908@woody.linux-foundation.org> <alpine.LFD.1.10.0806171356320.2908@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jun 2008, Linus Torvalds wrote:
> 
> Hmm. Something like this *may* salvage it.
> 
> Untested, so far (I'll reboot and test soon enough), but even if it fixes 
> things, it's not really very good. 

Ok, so I just rebooted with this, and it does indeed fix the bug.

I'd be happier with a more complete fix (ie being byte-accurate and 
actually doing the partial copy when it hits a fault in the middle), but 
this seems to be the minimal fix, and at least fixes the totally bogus 
return values from the x86-64 __copy_user*() functions.

Not that I checked that I got _all_ cases correct (and maybe there are 
other versions of __copy_user that I missed entirely), but Bron's 
test-case at least seems to work properly for me now.

Bron? If you have a more complete test-suite (ie the real-world case that 
made you find this), it would be good to verify the whole thing. 

And again, this is the kind of thing that really wants others looking at 
it. I personally think that this thing should likely be written as C code, 
with just the inner loops done as asm (ie the inner "rep movsq" and the 
inner 64-byte unrolled cached/uncached copies done as inline asms, and 
then the outer layers could be C).

		Linus
