Return-Path: <linux-kernel-owner+w=401wt.eu-S1764621AbZAPJXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764621AbZAPJXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 04:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758389AbZAPJXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 04:23:19 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:55078 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757522AbZAPJXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 04:23:16 -0500
Subject: Re: [PATCH 00/14] Kernel memory leak detector
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mike Snitzer <snitzer@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
In-Reply-To: <170fa0d20901151409p5ce88a4cqb3686d600ac6190e@mail.gmail.com>
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
	 <20090108144538.e5195575.akpm@linux-foundation.org>
	 <1231753866.10982.11.camel@pc1117.cambridge.arm.com>
	 <20090112022138.bd2e6ce4.akpm@linux-foundation.org>
	 <20090112213339.feefdd02.sfr@canb.auug.org.au>
	 <1231936220.24082.11.camel@pc1117.cambridge.arm.com>
	 <20090115010141.42e1dfc5.sfr@canb.auug.org.au>
	 <1231944602.24082.42.camel@pc1117.cambridge.arm.com>
	 <170fa0d20901151409p5ce88a4cqb3686d600ac6190e@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 16 Jan 2009 09:22:32 +0000
Message-Id: <1232097752.31143.12.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2009 09:22:33.0489 (UTC) FILETIME=[F67F3010:01C977BB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-15 at 17:09 -0500, Mike Snitzer wrote:
> When running your latest git kmemleak branch (as is being pulled into
> linux-next AFAIK) I'm still seeing that kmemleak fails to initialize
> with:
> 
> kmemleak: Early log buffer exceeded
[...]
> Kernel memory leak detector disabled

It looks like kmemleak exceeded it's buffer for logging initial memory
allocations requests and disabled itself (since it needs to track all
the memory allocations and kmemleak uses the slab allocator itself, it
uses this buffer). You can try to increase the size of the early_log[]
array (currently 200) in the kmemleak.c file. The current size was fine
on my embedded systems but, well, it looks like it needs to be
increased.

> Doing so yields:
>   MODPOST vmlinux.o
> WARNING: vmlinux.o(.text+0xaed80): Section mismatch in reference from
> the function kmemleak_free() to the function .init.text:log_early()
> The function kmemleak_free() references
> the function __init log_early().
> This is often because kmemleak_free lacks a __init
> annotation or the annotation of log_early is wrong.

That's related to the early_log buffer. Once kmemleak was initialised,
it no longer calls the log_early() function and doesn't use the
early_log[] array, hence they were marked as __init. The warning is
valid but it doesn't cause any bugs in kmemleak. Any idea how to avoid
this warning and still release the __init code and data?

Another solution is to use the page allocator for the early logging
buffer and just free the pages once fully initialised, though this may
complicate the code slightly more.

-- 
Catalin

