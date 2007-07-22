Return-Path: <linux-kernel-owner+w=401wt.eu-S1765487AbXGVJxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765487AbXGVJxZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 05:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758284AbXGVJxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 05:53:17 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:36202 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757273AbXGVJxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 05:53:16 -0400
Message-ID: <385097985.30112@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sun, 22 Jul 2007 17:53:14 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tim Pepper <lnxninja@us.ibm.com>,
       Chris Snook <csnook@redhat.com>
Subject: Re: [PATCH 3/3] readahead: scale max readahead size depending on memory size
Message-ID: <20070722095313.GA8136@mail.ustc.edu.cn>
Mail-Followup-To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-kernel <linux-kernel@vger.kernel.org>, riel <riel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Tim Pepper <lnxninja@us.ibm.com>, Chris Snook <csnook@redhat.com>
References: <20070721210005.000228000@chello.nl> <20070721210052.497469000@chello.nl> <385093918.09754@ustc.edu.cn> <1185094751.20032.221.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185094751.20032.221.camel@twins>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 10:59:11AM +0200, Peter Zijlstra wrote:
> On Sun, 2007-07-22 at 16:45 +0800, Fengguang Wu wrote:
> > How about the following rules?
> > - limit it under 1MB: we have to consider latencies
> 
> readahead is done async and we have these cond_resched() things
> sprinkled all over, no?

Yeah, it should not be a big problem.

> > - make them alignment-friendly, i.e. 128K, 256K, 512K, 1M.
> 
> Would that actually matter? but yeah, that seems like a sane suggestion.
> roundup_pow_of_two() comes to mind.

E.g. RAID stride size, and the max_sectors_kb.
Typically they are power-of-two.

> > My original plan is to simply do the following:
> > 
> > - #define VM_MAX_READAHEAD        128     /* kbytes */
> > + #define VM_MAX_READAHEAD        512     /* kbytes */
> 
> Yeah, the trouble I have with that is that it might adversely affect
> tiny systems (although the trash detection might mitigate that impact)

I'm also OK with the scaling up scheme. It's reasonable.

> > I'd like to post some numbers to back-up the discussion:
> > 
> >   readahead   readahead
> >        size        miss
> >        128K         38%
> >        512K         45%
> >       1024K         49%
> > 
> > The numbers are measured on a fresh booted KDE desktop.
> > 
> > The majority misses come from the larger mmap read-arounds.
> 
> the mmap code never gets into readahead unless madvise(MADV_SEQUENTIAL)
> is used afaik.

Sadly mmap read-around reuses the same readahead size.
- for read-around, VM_MAX_READAHEAD is the _real_ readahead size
- for readahead, VM_MAX_READAHEAD is the _max_ readahead size
If we simply increasing VM_MAX_READAHEAD, tiny systems can be
immediately hurt by large read-arounds. That's the problem.

