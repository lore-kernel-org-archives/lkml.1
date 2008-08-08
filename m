Return-Path: <linux-kernel-owner+w=401wt.eu-S1755627AbYHHHah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627AbYHHHah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 03:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbYHHHaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 03:30:14 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:60796 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753510AbYHHHaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 03:30:11 -0400
X-SourceIP: 80.57.229.25
Subject: Re: VolanoMark regression with 2.6.27-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <1912217169.25608.228.camel@ymzhang>
References: <1217489463.25608.157.camel@ymzhang>
	 <1217489949.8157.78.camel@twins> <1217490560.25608.168.camel@ymzhang>
	 <1217551154.25608.169.camel@ymzhang>
	 <20080801051407.GA5232@linux.vnet.ibm.com>
	 <1217826278.25608.198.camel@ymzhang>
	 <20080804052228.GA5444@linux.vnet.ibm.com>
	 <1217828278.25608.206.camel@ymzhang>
	 <20080804055339.GB5444@linux.vnet.ibm.com> <1217831171.9016.42.camel@twins>
	 <20080804070508.GA4028@linux.vnet.ibm.com> <1217833939.9016.47.camel@twins>
	 <1912217169.25608.228.camel@ymzhang>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 09:30:05 +0200
Message-Id: <1218180605.8625.64.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2030-08-06 at 11:26 +0800, Zhang, Yanmin wrote:
> On Mon, 2008-08-04 at 09:12 +0200, Peter Zijlstra wrote:
> > On Mon, 2008-08-04 at 12:35 +0530, Dhaval Giani wrote:
> > > On Mon, Aug 04, 2008 at 08:26:11AM +0200, Peter Zijlstra wrote:
> > > > On Mon, 2008-08-04 at 11:23 +0530, Dhaval Giani wrote:
> > > > 
> > > > > Peter, vatsa, any ideas?
> > > > 
> > > > ---
> > > > 
> > > > Revert:
> > > >   a7be37ac8e1565e00880531f4e2aff421a21c803  sched: revert the revert of: weight calculations
> > > >   c9c294a630e28eec5f2865f028ecfc58d45c0a5a  sched: fix calc_delta_asym()
> > > >   ced8aa16e1db55c33c507174c1b1f9e107445865  sched: fix calc_delta_asym, #2
> > > > 
> > > 
> > > Did we not fix those? :) 
> > 
> > Works for me,.. just guessing here.
> I did more investigation on 16-core tigerton.
> 
> Firstly, let's focus on CONFIG_GROUP_SCHED=n. With 2.6.26, the result
> has little difference
> between with and without CONFIG_GROUP_SCHED.
> 
> 1) I tried different sched_features and found AFFINE_WAKEUPS has big
> impact on volanoMark. Other
> features have little impact.
> 
> 2) With kernel 2.6.26, if disabling AFFINE_WAKEUPS, the result is
> 260000; if enabling AFFINE_WAKEUPS,
> the result is 515000, so the improvement caused by AFFINE_WAKEUPS is
> about 100%. With kernel 2.6.27-rc1,
> the improvement is only about 25%.
> 
> 3) I turned on CONFIG_SCHETSTATS in kernel and collect
> ttwu_move_affine. Mostly, collect ttwu_move_affine,
> then recollect it after 30 seconds and calculate the difference. With
> 2.6.26, I got below data:

<snip data>

> So with kernel 2.6.27-rc1, the successful wakeup_affine is about
> double of the one of 2.6.27-rc1
> on domain 0, but about 10 times on domain 1. That means more tasks are
> woken up on waker cpus.
> 
> Does that mean it doesn't follow cache-hot checking?

I'm a bit puzzled, but you're right - I too noticed that volanomark is
_very_ sensitive to affine wakeups.

I'll try and find what changed in that code for GROUP=n.

