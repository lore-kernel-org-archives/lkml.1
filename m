Return-Path: <linux-kernel-owner+w=401wt.eu-S1946162AbXBIHOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946162AbXBIHOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 02:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946166AbXBIHOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 02:14:17 -0500
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:33793
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946162AbXBIHOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 02:14:16 -0500
Date: Thu, 8 Feb 2007 23:14:04 -0800
To: Christoph Hellwig <hch@lst.de>
Cc: jack@suse.cz, akpm@osdl.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peter@programming.kicks-ass.net>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [PATCH] remove sb->s_files and file_list_lock usage in dquot.c
Message-ID: <20070209071404.GC28281@gnuppy.monkey.org>
References: <20070206132333.GA9919@lst.de> <20070208090121.GA28005@gnuppy.monkey.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070208090121.GA28005@gnuppy.monkey.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 01:01:21AM -0800, Bill Huey wrote:
> Christoph,
> 
> The i_mutex lock the inode structure is also a source of contention
> heavy when running a lot of parallel "find"s. I'm sure that folks
> would be open to hearing suggestions regarding how to fix that.

Christoph,

And while you're at it, you should also know that dcache_lock is next
in line to be nixed out of existence if possible.

i_mutex is a bitch and I'm not even going to think about how to get
rid of it since it's so widely used in many places (file systems aren't
my think as well). Maybe some more precise tracking of contention paths
would be useful to see if there's a pathological case creating a
cascade of contention events so that can be nixed, don't know.

About 1/10th of the lock stat events I've logged report that the owner
of the rtmutex is the "current" on a runqueue some where. An adaptive
lock would help with those contention events (spin for it while owner
is running for the mutex release) but really, the contention should be
avoided in the first place since they have a kind of (I think) polynomial
increase in contention time as you add more processors to the mix.

I have an adaptive lock implementation in my tree that eliminates
the contention between what looks like the IDE layer, work queues and
the anticipatory scheduler, but that's not a real problem unlike what
I've mentioned above. I can get you and others more specifics on the
problem if folks working on the lower layers want it.

Other than that the -rt patch does quite well with instrumenting all
sort of kernel behaviors that include contention and latency issues.

So I don't need to tell you how valuable the -rt patch is for these
issues since it's obvious, and I'm sure that you'll agree, that it's
been instrumental at discovering many problems with the stock kernel.

bill

