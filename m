Return-Path: <linux-kernel-owner+w=401wt.eu-S1764928AbYDVTXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764928AbYDVTXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbYDVTXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:23:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758246AbYDVTXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:23:17 -0400
Date: Tue, 22 Apr 2008 12:22:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Jens Axboe <jens.axboe@oracle.com>, linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       npiggin@suse.de, peterz@infradead.org, sam@ravnborg.org
Subject: Re: [PATCH 2/11] x86: convert to generic helpers for IPI function
 calls
In-Reply-To: <20080422191213.GA6370@elte.hu>
Message-ID: <alpine.LFD.1.10.0804221218410.2779@woody.linux-foundation.org>
References: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com> <1208890227-24808-3-git-send-email-jens.axboe@oracle.com> <alpine.LFD.1.10.0804221157220.2779@woody.linux-foundation.org> <20080422191213.GA6370@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 Apr 2008, Ingo Molnar wrote:
> 
> > Or is it just a performance optimization? [...]
> 
> yes and i gave in - Nick and Jens wants to do some crazy stuff and they 
> had the numbers. Here's the previous discussion:
> 
>   http://lkml.org/lkml/2008/2/27/125

No, the previous discussion was about single *queues* vs single *vectors*.

I agree unconditionally with the decision to use a separate per-cpu queue 
from the shared queue (in fact, I would argue that the "mask" code might 
want to notice when the mask is just a single CPU, and turn a mask request 
into a targeted request). 

But I wonder why we want to then have two IPI target vectors, when it 
would appear to be perfectly fine and cheap to have just a single vector 
that can handle both the per-cpu case and the shared queue case (since the 
thing would tend to be one or the other, not both).

A single vector is still pefectly fine, if 99% of all usage cases are the 
targeted-to-a-single-cpu thing, because the shared queue will basically be 
empty (and you can test that without even taking any locks).

		Linus
