Return-Path: <linux-kernel-owner+w=401wt.eu-S1762993AbYHFD0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762993AbYHFD0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 23:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbYHFD03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 23:26:29 -0400
Received: from mga10.intel.com ([192.55.52.92]:44811 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751548AbYHFD02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 23:26:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,314,1215414000"; 
   d="scan'208";a="368196493"
Subject: Re: VolanoMark regression with 2.6.27-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <1217833939.9016.47.camel@twins>
References: <1217489463.25608.157.camel@ymzhang>
	 <1217489949.8157.78.camel@twins> <1217490560.25608.168.camel@ymzhang>
	 <1217551154.25608.169.camel@ymzhang>
	 <20080801051407.GA5232@linux.vnet.ibm.com>
	 <1217826278.25608.198.camel@ymzhang>
	 <20080804052228.GA5444@linux.vnet.ibm.com>
	 <1217828278.25608.206.camel@ymzhang>
	 <20080804055339.GB5444@linux.vnet.ibm.com> <1217831171.9016.42.camel@twins>
	 <20080804070508.GA4028@linux.vnet.ibm.com> <1217833939.9016.47.camel@twins>
Content-Type: text/plain
Date: Tue, 06 Aug 2030 11:26:09 +0800
Message-Id: <1912217169.25608.228.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-08-04 at 09:12 +0200, Peter Zijlstra wrote:
> On Mon, 2008-08-04 at 12:35 +0530, Dhaval Giani wrote:
> > On Mon, Aug 04, 2008 at 08:26:11AM +0200, Peter Zijlstra wrote:
> > > On Mon, 2008-08-04 at 11:23 +0530, Dhaval Giani wrote:
> > > 
> > > > Peter, vatsa, any ideas?
> > > 
> > > ---
> > > 
> > > Revert:
> > >   a7be37ac8e1565e00880531f4e2aff421a21c803  sched: revert the revert of: weight calculations
> > >   c9c294a630e28eec5f2865f028ecfc58d45c0a5a  sched: fix calc_delta_asym()
> > >   ced8aa16e1db55c33c507174c1b1f9e107445865  sched: fix calc_delta_asym, #2
> > > 
> > 
> > Did we not fix those? :) 
> 
> Works for me,.. just guessing here.
I did more investigation on 16-core tigerton.

Firstly, let's focus on CONFIG_GROUP_SCHED=n. With 2.6.26, the result has little difference
between with and without CONFIG_GROUP_SCHED.

1) I tried different sched_features and found AFFINE_WAKEUPS has big impact on volanoMark. Other
features have little impact.

2) With kernel 2.6.26, if disabling AFFINE_WAKEUPS, the result is 260000; if enabling AFFINE_WAKEUPS,
the result is 515000, so the improvement caused by AFFINE_WAKEUPS is about 100%. With kernel 2.6.27-rc1,
the improvement is only about 25%.

3) I turned on CONFIG_SCHETSTATS in kernel and collect ttwu_move_affine. Mostly, collect ttwu_move_affine,
then recollect it after 30 seconds and calculate the difference. With 2.6.26, I got below data:
domain0 279521 142332 0
domain1 184589 22823 0
domain0 289170 142168 0
domain1 185491 23778 0
domain0 291842 139687 0
domain1 187807 23174 0
domain0 292426 144879 0
domain1 179721 22122 0
domain0 287669 137756 0
domain1 201236 25156 0
domain0 268374 139532 0
domain1 210145 25268 0
domain0 292002 144530 0
domain1 196146 24669 0
domain0 298406 145023 0
domain1 178381 22743 0
domain0 275685 141086 0
domain1 203797 25686 0
domain0 285818 140260 0
domain1 180506 23002 0
domain0 290562 139757 0
domain1 186669 23086 0
domain0 296466 142084 0
domain1 186346 24161 0
domain0 283394 137930 0
domain1 195596 23895 0
domain0 269296 142978 0
domain1 210648 25682 0
domain0 281672 144002 0
domain1 189959 23685 0
domain0 301834 145922 0
domain1 172737 22351 0


The 3rd column is ttwu_move_affine difference.

With 2.6.27-rc1:
domain0 39054 302678 0
domain1 315384 245684 0
domain0 39142 304117 0
domain1 312896 244796 0
domain0 38636 304438 0
domain1 310687 244409 0
domain0 39534 304167 0
domain1 313746 245381 0
domain0 39082 304231 0
domain1 312592 245219 0
domain0 39057 305460 0
domain1 311395 245195 0
domain0 38224 301351 0
domain1 314482 244448 0
domain0 38016 300573 0
domain1 309031 241127 0
domain0 40285 306397 0
domain1 318707 243595 0
domain0 39685 305034 0
domain1 315380 241506 0
domain0 39828 306178 0
domain1 314515 243039 0
domain0 39870 303382 0
domain1 315457 244483 0
domain0 38892 304697 0
domain1 313808 241948 0
domain0 39255 303937 0
domain1 314531 244301 0
domain0 38850 300187 0
domain1 310727 240255 0
domain0 38847 302327 0
domain1 312538 241857 0


So with kernel 2.6.27-rc1, the successful wakeup_affine is about double of the one of 2.6.27-rc1
on domain 0, but about 10 times on domain 1. That means more tasks are woken up on waker cpus.

Does that mean it doesn't follow cache-hot checking?

I will collect more data.

-yanmin


