Return-Path: <linux-kernel-owner+w=401wt.eu-S1753079AbYL3Lof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbYL3Lof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 06:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbYL3Lo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 06:44:26 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:35144 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751629AbYL3LoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 06:44:25 -0500
Subject: Re: [PATCH 00/14] Kernel memory leak detector
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
In-Reply-To: <20081229162310.705a25fe.akpm@linux-foundation.org>
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
	 <20081229162310.705a25fe.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 30 Dec 2008 11:43:50 +0000
Message-Id: <1230637430.3909.38.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Dec 2008 11:43:52.0471 (UTC) FILETIME=[E3576A70:01C96A73]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-29 at 16:23 -0800, Andrew Morton wrote:
> What is the track record of this code?  Has it found many leaks?  Do
> we expect that it will find sufficient leaks of sufficient importance
> to justify kmemleak's inclusion and maintenance?

It found a few leaks not found by static code analysis (not many though)
but I mainly tested it on small embedded systems. I think it may be
better to include it in the -mm tree for a while so that more people
test it before deciding whether to merge it into mainline.

FYI, here are some past reports:

http://lkml.org/lkml/2006/5/28/37
http://lkml.org/lkml/2006/7/10/370
http://lkml.org/lkml/2006/8/10/207
http://lkml.org/lkml/2006/8/12/11
http://lkml.org/lkml/2006/8/19/44
http://lkml.org/lkml/2006/12/9/178
http://lkml.org/lkml/2006/12/9/176
http://lkml.org/lkml/2007/3/8/222
http://lkml.org/lkml/2008/11/19/204

> I'm a little doubtful personally.  We often fix leaks, and they are
> almost always things which nobody noticed at runtime, and which were
> found by code inspection or source-code checking tools.  And they're
> usually leaks which nobody would care about much anyway?

I'm a bit biased to comment on the usefulness of kmemleak :-). Anyway,
AFAIK static code checking tools (like coverity) are good for relatively
simple things like not freeing on an error return path (maybe they can
go further across multiple files, I haven't tried it). I doubt such
tools can catch leaks caused by incorrect reference counting or very
complex code. OTOH, kmemleak doesn't report a leak unless it occurred,
so static and dynamic checking tools are rather complementary.

Now, as long as the code is correctly written and with additional static
checking, kmemleak shouldn't find a significant number of bugs. However,
some (earlier) bugs mentioned above were causing tens of (small) leaks
in a few minutes. They may have become visible after days of running but
it's much easier to catch and fix them early.

You can't really tell whether a leak is serious or not until you check
the code. A leak doesn't necessarily mean that you can no longer reuse a
block of memory but the code possibly frees a different one still in use
by other parts of the kernel (e.g. the last report mentioned above).

-- 
Catalin

