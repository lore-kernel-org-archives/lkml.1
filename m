Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbZCaJKC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbZCaJKC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 05:10:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbZCaJJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 05:09:51 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:32989 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbZCaJJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 05:09:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18897.56790.860287.221427@cargo.ozlabs.ibm.com>
Date: Tue, 31 Mar 2009 20:09:42 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] perf_counter: provide generic callchain bits
In-Reply-To: <1238488993.28248.1929.camel@twins>
References: <20090330170701.856843742@chello.nl>
	<20090330171024.254266860@chello.nl>
	<18897.46177.528910.51044@cargo.ozlabs.ibm.com>
	<1238481552.28248.1384.camel@twins>
	<49D1C544.7020403@linux.vnet.ibm.com>
	<1238488993.28248.1929.camel@twins>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> >  One simplification would be that reading 
> > the fd of a group leader would always read up all of the counters in the 
> > group (along with their enabled and running times if those bits are 
> > set), and that reading a single counter's fd would yield only that 
> > counter's values and times (if enabled).  In effect, these two values, 
> > PERF_COUNTER_GROUP and PERF_COUNTER_SIMPLE would no longer be necessary 
> > at all.  Other bits would be used to determine what's in the mmap'd samples.
> 
> Quite so, that sounds sensible, Paul?

I think the readout of the other group members (for a group leader)
should be enabled by a bit in hw_event.read_format, say
PERF_FORMAT_GROUP.

There is a slight complication - we would want to read all the
counters in the group atomically, or as close to atomically as we
could get, and we don't have any way to do that at the moment.

> Would you be overly bothered by the read() output also having that
> {type,size} header we use for the mmap() data?

How about a PERF_FORMAT_HEADERS bit in hw_event.read_format to say that
we want to get the headers in the read() output?

With those two extra bits we can fulfill these desires without adding
overhead for programs that don't want the extra stuff, and without
breaking compatibility.

Paul.
