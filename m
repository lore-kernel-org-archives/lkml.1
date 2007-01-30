Return-Path: <linux-kernel-owner+w=401wt.eu-S1751740AbXA3WXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbXA3WXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXA3WXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:23:25 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54389 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbXA3WXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:23:24 -0500
Date: Tue, 30 Jan 2007 14:23:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Zach Brown <zach.brown@oracle.com>
cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
In-Reply-To: <Pine.LNX.4.64.0701301345060.3611@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0701301416250.3611@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <Pine.LNX.4.64.0701301345060.3611@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Jan 2007, Linus Torvalds wrote:
> 
> But from a quick overview of the patches, I really don't see anything 
> fundamentally wrong. It needs some error checking and some limiting (I 
> _really_ don't think we want a regular user starting a thousand fibrils 
> concurrently), but it actually looks much less invasive than I thought it 
> would be.

Side note (and maybe this was obvious to people already): I would suggest 
that the "limiting" not be done the way fork() is limited ("return EAGAIN 
if you go over a limit") but be done as a per-task counting semaphore 
(down() on submit, up() on fibril exit).

So we should limit these to basically have some maximum concurrency 
factor, but rather than consider it an error to go over it, we'd just cap 
the concurrency by default, so that people can freely use asynchronous 
interfaces without having to always worry about what happens if their 
resources run out..

However, that also implies that we should probably add a "flags" parameter 
to "async_submit()" and have a FIBRIL_IMMEDIATE flag (or a timeout) or 
something to tell the kernel to rather return EAGAIN than wait. Sometimes 
you don't want to block just because you already have too much work.

Hmm?

		Linus
