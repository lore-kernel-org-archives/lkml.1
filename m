Return-Path: <linux-kernel-owner+w=401wt.eu-S1751553AbXA2Q6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbXA2Q6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 11:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbXA2Q6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 11:58:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56657 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbXA2Q6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 11:58:53 -0500
Date: Mon, 29 Jan 2007 18:00:56 +0100
From: Andrea Arcangeli <andrea@suse.de>
To: Denis Vlasenko <vda.linux@googlemail.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Michael Tokarev <mjt@tls.msk.ru>,
       Phillip Susi <psusi@cfl.rr.com>, Linus Torvalds <torvalds@osdl.org>,
       Viktor <vvp01@inbox.ru>, Aubrey <aubreylee@gmail.com>,
       Hua Zhong <hzhong@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, hch@infradead.org, kenneth.w.chen@suse.de
Subject: Re: O_DIRECT question
Message-ID: <20070129170056.GJ8030@opteron.random>
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <200701270035.31285.vda.linux@googlemail.com> <45BCBECE.4080405@tmr.com> <200701281803.08201.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701281803.08201.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28, 2007 at 06:03:08PM +0100, Denis Vlasenko wrote:
> I still don't see much difference between O_SYNC and O_DIRECT write
> semantic.

O_DIRECT is about avoiding the copy_user between cache and userland,
when working with devices that runs faster than ram (think >=100M/sec,
quite standard hardware unless you've only a desktop or you cannot
afford raid).

O_SYNC is about working around buggy or underperforming VM growing the
dirty levels beyond optimal levels, or to open logfiles that you want
to save to disk ASAP (most other journaling usages are better done
with fsync instead). Or you can mount the fs in sync mode when you
deal with users not capable of unmounting devices before unplugging
them. Ideally you should never need O_SYNC, when you need O_SYNC it's
usually a very bad sign. If you need O_DIRECT it's not a bad sign
(needing O_DIRECT is mostly a sign you've a very fast storage).

The only case where I ever used O_SYNC myself is during backups (when
run on standard or mainline kernels that dirty half ram during
backup). For the logfiles I don't find it very useful, if something I
log them remotely (when system crashes usually the logs won't hit the
disk anyway, so it's just slower).

I use "tar | dd oflag=sync" and that generates a huge speedup to the
rest of the system (not necessairly to the backup itself). Yes I could
use even oflag=direct, but I'm fine to pass through the cache (the
backup device runs at 10M/sec through USB, so the copy_user is _sure_
worth it, if something it will help, it will never be a measurable
slowdown), what is not fine is to see half of the ram dirty the whole
time... (hence the need of o_sync).

O_SYNC and O_DIRECT are useful for different scenarios.
