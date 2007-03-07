Return-Path: <linux-kernel-owner+w=401wt.eu-S1422708AbXCGKJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422708AbXCGKJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 05:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422709AbXCGKJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 05:09:40 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:59994 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422708AbXCGKJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 05:09:37 -0500
Date: Wed, 7 Mar 2007 02:09:11 -0800
From: Bill Irwin <bill.irwin@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bill Irwin <bill.irwin@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes nonlinear)
Message-ID: <20070307100911.GO18774@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
	Linux Memory Management <linux-mm@kvack.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
References: <20070221023656.6306.246.sendpatchset@linux.site> <20070221023735.6306.83373.sendpatchset@linux.site> <20070306225101.f393632c.akpm@linux-foundation.org> <20070307070853.GB15877@wotan.suse.de> <20070307081948.GA9563@wotan.suse.de> <20070307082755.GA25733@elte.hu> <20070307003520.08b1a082.akpm@linux-foundation.org> <20070307092903.GJ18774@holomorphy.com> <20070307013942.5c0fadff.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307013942.5c0fadff.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 01:29:03 -0800 Bill Irwin <bill.irwin@oracle.com> wrote:
>> Guess what major real-life application not only uses nonlinear daily
>> but would even be very happy to see it extended with non-vma-creating
>> protections and more?

On Wed, Mar 07, 2007 at 01:39:42AM -0800, Andrew Morton wrote:
> uh-oh.  SQL server?

Close enough. ;)


On Wed, 7 Mar 2007 01:29:03 -0800 Bill Irwin <bill.irwin@oracle.com> wrote:
>> It's not terribly typical for things to be
>> truncated while remap_file_pages() is doing its work, though it's been
>> proposed as a method of dynamism. It won't stress remap_file_pages() vs.
>> truncate() in any meaningful way, though, as userspace will be rather
>> diligent about clearing in-use data out of the file offset range to be
>> truncated away anyway, and all that via O_DIRECT.

On Wed, Mar 07, 2007 at 01:39:42AM -0800, Andrew Morton wrote:
> The problem here isn't related to truncate or direct-IO.  It's just
> plain-old MAP_SHARED.  nonlinear VMAs are now using the old-style
> dirty-memory management.  msync() is basically a no-op and the code is
> wildly tricky and pretty much untested.  The chances that we broke it are
> considerable.

This would be of concern for swapping out tmpfs-backed nonlinearly-
mapped files under extreme stress in Oracle's case, though it's rather
typical for it all to be mlock()'d in-core and cases where that's
necessary to be considered grossly underprovisioned. As far as I know,
msync() is not used to manage the nonlinearly-mapped objects, which are
most typically expected to be memory-backed, rendering writeback to
disk of questionable value. Also quite happily, I'm not aware of any
data integrity issues it would explain. Bug though it may be, it
requires a usage model very rarely used by Oracle to trigger, so we've
not run into it.


-- wli
