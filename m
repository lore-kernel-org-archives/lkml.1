Return-Path: <linux-kernel-owner+w=401wt.eu-S1755119AbZBBBMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbZBBBMe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 20:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbZBBBM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 20:12:26 -0500
Received: from mga07.intel.com ([143.182.124.22]:19377 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752192AbZBBBMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 20:12:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,362,1231142400"; 
   d="scan'208";a="105951946"
Subject: Re: hackbench [pthread mode] regression with 2.6.29-rc3
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1233482239.4787.65.camel@laptop>
References: <1233473426.2604.13.camel@ymzhang>
	 <d3f22a0902010026q1db36381j36cb1c9803d48431@mail.gmail.com>
	 <1233476961.13659.12.camel@minggr.sh.intel.com>
	 <1233479836.4787.63.camel@laptop>  <1233482239.4787.65.camel@laptop>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 09:12:14 +0800
Message-Id: <1233537134.2604.24.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-01 at 10:57 +0100, Peter Zijlstra wrote:
> On Sun, 2009-02-01 at 10:17 +0100, Peter Zijlstra wrote:
> > On Sun, 2009-02-01 at 16:29 +0800, Lin Ming wrote:
> > > > Bisect located below patch.
> > > > commit 490dea45d00f01847ebebd007685d564aaf2cd98
> > > > Author: Peter Zijlstra <peterz@infradead.org>
> > > > Date:   Mon Nov 24 17:06:57 2008 +0100
> > > > 
> > > >    itimers: remove the per-cpu-ish-ness
> > > > 
> > > >    Either we bounce once cacheline per cpu per tick, yielding n^2 bounces
> > > >    or we just bounce a single..
> > > > 
> > > >    Also, using per-cpu allocations for the thread-groups complicates the
> > > >    per-cpu allocator in that its currently aimed to be a fixed sized
> > > >    allocator and the only possible extention to that would be vmap based,
> > > >    which is seriously constrained on 32 bit archs.
> > > > 
> > > > 
> > > > After above patch is reverted, hackbench result is restored.
> > > 
> > > oltp has ~3% regression with 2.6.29-rc3 on 4core*2p stokley machine.
> > > After above patch reverted, the regression disappeared.
> > 
> > *sigh*, did they gain anything with introduction of the per-cpu crap?
> 
> No it wouldn't have, I just missed something obvious,.. :-(
> 
> I wish we never merged that crap...
process timer (by setitimer) isn't good. Is per-cpu itimer to improve it?

Prior to kernel 2.6.28, process timer implementation is poor. When the process timer
is near to expire, threads will sum the time from all threads of the thread group
over and over again. If there are thousands of threads, kernel might hang eventually.
I ran into it a couple of months ago when I tried to enable specweb2005 (Apache+PHP
thread mode).

So the per-cpu itimer could improve this situation when thread number is far bigger than
cpu number. I didn't retry specweb2005 with 2.6.28.

-yanmin


