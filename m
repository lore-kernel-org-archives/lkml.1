Return-Path: <linux-kernel-owner+w=401wt.eu-S1758276AbXGDKqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbXGDKqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 06:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757059AbXGDKp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 06:45:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60469 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330AbXGDKpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 06:45:55 -0400
To: Dan Williams <dan.j.williams@intel.com>
Cc: neilb@suse.de, raziebe@gmail.com, akpm@linux-foundation.org,
       davidsen@tmr.com, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] raid5: 65% sequential-write performance improvement, stripe-queue take2
References: <20070703231838.17500.34505.stgit@dwillia2-linux.ch.intel.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 04 Jul 2007 13:41:26 +0200
In-Reply-To: <20070703231838.17500.34505.stgit@dwillia2-linux.ch.intel.com>
Message-ID: <p73wsxg2y6x.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams <dan.j.williams@intel.com> writes:

> The write performance numbers are better than I expected and would seem
> to address the concerns raised in the thread "Odd (slow) RAID
> performance"[2].  The read performance drop was not expected.  However,
> the numbers suggest some additional changes to be made to the queuing
> model.

Have you considered supporting copy-xor in MD for non accelerated
RAID? I've been looking at fixing the old dubious slow crufty x86 SSE
XOR functions. One thing I discovered is that it seems fairly
pointless to make them slower with cache avoidance when most of the data is
copied before anyways. I think much more advantage could be gotten by
supporting copy-xor because XORing during a copy should be nearly
free.

On the other hand ext3 write() also uses a cache avoiding copy now
and for the XOR it would need to load the data from memory again.
Perhaps this could be also optimized somehow (e.g. setting a flag
somewhere and using a normal copy for the RAID-5 case)

-Andi

