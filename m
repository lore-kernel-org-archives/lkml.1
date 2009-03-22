Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbZCVUFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbZCVUFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 16:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbZCVUFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 16:05:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52355 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228AbZCVUFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 16:05:41 -0400
Date: Sun, 22 Mar 2009 21:05:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus <M4rkusXXL@web.de>, Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12872] pwc mmap always fails with EAGAIN
Message-ID: <20090322200521.GA5355@elte.hu>
References: <GPBuLTara4J.A.3kH.TZTxJB@chimera> <20090322142837.2df0d93d@lxorguk.ukuu.org.uk> <20090322144516.GA13129@elte.hu> <200903222058.12924.M4rkusXXL@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903222058.12924.M4rkusXXL@web.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Markus <M4rkusXXL@web.de> wrote:

> > > > Still valid for 2.6.29-rc8-git5.
> > > 
> > > And not really likely to change until someone with a pwc camera adds 
> lots
> > > of printks to the code to work out why this happens.
> > 
> > Or does a bisection to figure out the bad commit, because the report 
> > says that 2.6.28 worked.
> > 
> > The 'howto bisect' portion of:
> > 
> >   http://www.kernel.org/doc/local/git-quick.html
> 
> 
> Well I did a bisect:
> be03d9e8022030c16abf534e33e185bfc3d40eef is first bad commit
> commit be03d9e8022030c16abf534e33e185bfc3d40eef
> Author: Suresh Siddha <suresh.b.siddha@intel.com>
> Date:   Wed Feb 11 11:20:23 2009 -0800
> 
>     x86, pat: fix warn_on_once() while mapping 0-1MB range with /dev/mem
> 
>     Jeff Mahoney reported:
> 
>     > With Suse's hwinfo tool, on -tip:
>     > WARNING: at arch/x86/mm/pat.c:637 reserve_pfn_range+0x5b/0x26d()
> 
>     reserve_pfn_range() is not tracking the memory range below 1MB
>     as non-RAM and as such is inconsistent with similar checks in
>     reserve_memtype() and free_memtype()
> 
>     Rename the pagerange_is_ram() to pat_pagerange_is_ram() and add the
>     "track legacy 1MB region as non RAM" condition.
> 
>     And also, fix reserve_pfn_range() to return -EINVAL, when the pfn
>     range is RAM. This is to be consistent with this API design.
> 
>     Reported-and-tested-by: Jeff Mahoney <jeffm@suse.com>
>     Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
>     Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> :040000 040000 feb3bf21d762e885284cb1bedb5d2c6c0d16811b 
> b4c2143775386ce15dd49b6749c1f7913d8beb00 M      arch
> 
> So I ran "git bisect reset ; git revert 
> be03d9e8022030c16abf534e33e185bfc3d40eef" and rebuild. That worked!
> 
> I dont know if this is valid to do, but its working fine.
> Its an amd64 system with CONFIG_X86_PAT=y.
> 
> Need some feedback ;)

First thing to check would be whether the latest round of PAT fixes 
(not yet upstream) fix the problem:

   http://people.redhat.com/mingo/tip.git/README

Suresh, any ideas?

	Ingo
