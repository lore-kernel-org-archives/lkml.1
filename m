Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbZCREsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbZCREsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 00:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbZCREsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 00:48:13 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:51965 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbZCREsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 00:48:11 -0400
Date: Wed, 18 Mar 2009 10:18:01 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, balbir@linux.vnet.ibm.com,
       Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip] cpuacct: Make cpuacct hierarchy walk in
	cpuacct_charge() safe when rcupreempt is used.
Message-ID: <20090318044801.GC3960@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090317061754.GD3314@in.ibm.com> <49BF42FB.4030103@cn.fujitsu.com> <20090317073649.GH3314@in.ibm.com> <20090317131251.GU16897@balbir.in.ibm.com> <1237296361.7867.16.camel@twins> <20090317135938.GV16897@balbir.in.ibm.com> <1237298686.7867.17.camel@twins> <20090318032558.GB3960@in.ibm.com> <20090318125434.63d833e4.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090318125434.63d833e4.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 12:54:34PM +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 18 Mar 2009 08:55:58 +0530
> Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:
> 
> > On Tue, Mar 17, 2009 at 03:04:46PM +0100, Peter Zijlstra wrote:
> > > On Tue, 2009-03-17 at 19:29 +0530, Balbir Singh wrote:
> > > > * Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-03-17 14:26:01]:
> > > > 
> > > > > On Tue, 2009-03-17 at 18:42 +0530, Balbir Singh wrote:
> > > > > 
> > > > > > I'd like to get the patches in -tip and see the results, I would
> > > > > > recommend using percpu_counter_sum() while reading the data as an
> > > > > > enhancement to this patch. If user space does not overwhelm with a lot
> > > > > > of reads, sum would work out better.
> > > > > 
> > > > > You trust userspace? I'd rather not.
> > > > >
> > > > 
> > > > Fair enough.. A badly written application monitor can frequently read
> > > > this data and cause horrible performance issues. On the other hand
> > > > large number of CPUs can make the lag even worse. Is it time yet for
> > > > percpu_counter batch numbers? I've tested this patch and the results
> > > > were not badly off the mark. 
> > > 
> > > I'd rather err on the side of caution here, you might get some crazy
> > > folks depending on it and then expecting us to maintain it.
> > 
> > So if we want to be cautious, we could use percpu_counter_sum() as
> > Balbir suggested. That would address both the issues with percpu_counter
> > that I pointed out earlier:
> > 
> > - Readers are serialized with writers and we get consistent/correct
> >   values during reads.
> > - Negates the effect of batching and reads would always get updated/current
> >   values.
> > 
> 
> Is this wrong ?
> ==
> -- CONFIG_32BIT
> s64 static inline s64 percpu_counter_read_slow(struct percpu_counter *fbc)
> {
>    s64 val;
> retry:
>     val = fbc->counter;
>     smp_mb();
>     wait_spin_unlock(&fbc->lock);
>     if (fbc->counter < val) {
>             goto retry;
>     return val;
> }
> ==

Looks ok to me, but will wait for experts' comments.

However, I did a quick measurement of read times with percpu_counter_read()
(no readside lock) and percpu_counter_sum() (readside lock) and I don't
see a major slowdown with percpu_counter_sum().

Time taken for 100 reads of cpuacct.stat with 1s delay b/n every read.
percpu_counter_read() - 9845 us
percpu_counter_sum() - 9974 us

This is on a 8cpu system.

Regards,
Bharata.
