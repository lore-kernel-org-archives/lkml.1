Return-Path: <linux-kernel-owner+w=401wt.eu-S932641AbYEGTCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbYEGTCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758675AbYEGTB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:01:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758010AbYEGTB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:01:56 -0400
Date: Wed, 7 May 2008 12:01:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
In-Reply-To: <20080507184304.GA15554@elte.hu>
Message-ID: <alpine.LFD.1.10.0805071150140.3024@woody.linux-foundation.org>
References: <20080506102153.5484c6ac.akpm@linux-foundation.org> <20080507163811.GY19219@parisc-linux.org> <alpine.LFD.1.10.0805070948250.3024@woody.linux-foundation.org> <alpine.LFD.1.10.0805070956060.3024@woody.linux-foundation.org> <20080507172246.GA13262@elte.hu>
 <alpine.LFD.1.10.0805071028400.3024@woody.linux-foundation.org> <20080507174900.GB13591@elte.hu> <alpine.LFD.1.10.0805071057280.3024@woody.linux-foundation.org> <20080507181714.GA14980@elte.hu> <alpine.LFD.1.10.0805071125090.3024@woody.linux-foundation.org>
 <20080507184304.GA15554@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, Ingo Molnar wrote:
> 
> ok, the one below does irq ops and the counter behavior

No it doesn't. The counter isn't used for any actual *testing*, so the 
locking around it and the serialization of it has absolutely no impact on 
the scheduling behaviour!

Since the big slowdown was clearly accompanied by sleeping behaviour (the 
processes who didn't get the lock end up sleeping!), that is a *big* part 
of the slowdown.

Is it possible that your patch gets similar behaviour? Absolutely. But 
you're missing the whole point here. Anybody can make code behave badly 
and perform worse. But if you want to just verify that it's about the 
sleeping behaviour and timings of the BKL, then you need to do exactly 
that: emulate the sleeping behavior, not just the timings _outside_ of the 
sleeping behavior.

The thing is, we definitely are interested to see whether it's the BKL or 
some other semaphore that is the problem. But the best way to test that is 
to just try my patch that *guarantees* that the BKL doesn't have any 
semaphore behaviour AT ALL.

Could it be something else entirely? Yes. We know it's semaphore- related. 
We don't know for a fact that it's the BKL itself. There could be other 
semaphores that are that hot. It sounds unlikely, but quite frankly, 
regardless, I don't really see the point of your patches.

If Yanmin tries my patch, it is *guaranteed* to show something. It either 
shows that it's about the BKL (and that we absolutely have to do the BKL 
as something _else_ than a generic semaphore), or it shows that it's not 
about the BKL (and that _all_ the patches in this discussion are likely 
pointless).

In contrast, these "try to emulate bad behavior with the old known-ok 
semaphores" don't show anything AT ALL. We already know it's related to 
semaphores. And your patches aren't even guaranteed to show the same 
issue.

		Linus
