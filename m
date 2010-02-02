Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab0BBU2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 15:28:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754612Ab0BBU2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 15:28:30 -0500
Date: Tue, 2 Feb 2010 12:22:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: david@lang.hm
cc: Olivier Galibert <galibert@pobox.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/11] readahead: dont do start-of-file readahead after
 lseek()
In-Reply-To: <alpine.DEB.2.00.1002021157280.3707@asgard.lang.hm>
Message-ID: <alpine.LFD.2.00.1002021216310.3664@localhost.localdomain>
References: <20100202152835.683907822@intel.com> <20100202153317.644170708@intel.com> <20100202181321.GB75577@dspnet.fr.eu.org> <alpine.LFD.2.00.1002021037110.3664@localhost.localdomain> <20100202184831.GD75577@dspnet.fr.eu.org>
 <alpine.LFD.2.00.1002021111240.3664@localhost.localdomain> <alpine.DEB.2.00.1002021157280.3707@asgard.lang.hm>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Feb 2010, david@lang.hm wrote:

> On Tue, 2 Feb 2010, Linus Torvalds wrote:
> > 
> > Also, keep in mind that read-ahead is not always a win. It can be a huge
> > loss too. Which is why we have _heuristics_. They fundamentally cannot
> > catch every case, but what they aim for is to do a good job on average.
> 
> as a note from the field, I just had an application that needed to be changed
> because it did excessive read-ahead. it turned a 2 min reporting run into a 20
> min reporting run because for this report the access was really random and the
> app forced large read-ahead.

Yeah. And the reason Wu did this patch is similar: something that _should_ 
have taken just quarter of a second took about 7 seconds, because 
read-ahead triggered on this really slow device that only feeds about 
15kB/s (yes, _kilo_byte, not megabyte).

You can always use POSIX_FADVISE_RANDOM to disable it, but it's seldom 
something that people do. And there are real loads that have random 
components to them without being _entirely_ random, so in an optimal world 
we should just have heuristics that work well.

The problem is, it's often easier to test/debug the "good" cases, ie the 
cases where we _want_ read-ahead to trigger. So that probably means that 
we have a tendency to read-ahead too aggressively, because those cases are 
the ones where people can most easily look at it and say "yeah, this 
improves throughput of a 'dd bs=8192'". 

So then when we find loads where read-ahead hurts, I think we need to take 
_that_ case very seriously. Because otherwise our selection bias for 
testing read-ahead will fail.

		Linus
