Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbZAZR0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbZAZR0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 12:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbZAZR0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 12:26:08 -0500
Received: from smtp.ultrahosting.com ([74.213.174.254]:56131 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbZAZR0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 12:26:07 -0500
Date: Mon, 26 Jan 2009 12:22:28 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch] SLQB slab allocator (try 2)
In-Reply-To: <1232960840.4863.7.camel@laptop>
Message-ID: <alpine.DEB.1.10.0901261219350.32192@qirst.com>
References: <20090123154653.GA14517@wotan.suse.de>  <1232959706.21504.7.camel@penberg-laptop> <1232960840.4863.7.camel@laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009, Peter Zijlstra wrote:

> Then again, anything that does allocation is per definition not bounded
> and not something we can have on latency critical paths -- so on that
> respect its not interesting.

Well there is the problem in SLAB and SLQB that they *continue* to do
processing after an allocation. They defer queue cleaning. So your latency
critical paths are interrupted by the deferred queue processing. SLAB has
the awful habit of gradually pushing objects out of its queued (tried to
approximate the loss of cpu cache hotness over time). So for awhile you
get hit every 2 seconds with some free operations to the page allocator on
each cpu. If you have a lot of cpus then this may become an ongoing
operation. The slab pages end up in the page allocator queues which is
then occasionally pushed back to the buddy lists. Another relatively high
spike there.

