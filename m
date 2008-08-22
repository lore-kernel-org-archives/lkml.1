Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbYHVEQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbYHVEQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 00:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYHVEQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 00:16:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52822 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbYHVEQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 00:16:18 -0400
Date: Fri, 22 Aug 2008 06:15:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Airlie <airlied@gmail.com>, "Li, Shaohua" <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH] x86: have set_memory_array_{uc,wb} coalesce memtypes.
Message-ID: <20080822041544.GF30284@elte.hu>
References: <20080820100440.GE28492@elte.hu> <48ABF6DC.8070305@keyaccess.nl> <48AC29CA.1060203@keyaccess.nl> <20080820194127.GA10887@linux-os.sc.intel.com> <48AC8F69.4050201@keyaccess.nl> <21d7e9970808201446k3c1a6bc1naf04568a8ad06ed4@mail.gmail.com> <20080820221630.GA3598@linux-os.sc.intel.com> <20080821120626.GG5615@elte.hu> <48ADA2C2.8090905@keyaccess.nl> <48ADF3FC.7070002@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48ADF3FC.7070002@keyaccess.nl>
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


* Rene Herman <rene.herman@keyaccess.nl> wrote:

> Actually, might as well simply reconstruct the memtype list at free 
> time I guess. How is this for a coalescing version of the array 
> functions?

impressive! Rarely do we get this much bang for such a low linecount :-)

> NOTE: I am posting this because I'm going to bed but haven't stared 
> comfortably long at this and might be buggy. Compiles, boots and 
> provides me with:
>
> root@7ixe4:~# wc -l /debug/x86/pat_memtype_list
> 53 /debug/x86/pat_memtype_list
>
> otherwise (down from 16384+).
>
> <snore>

cool!

I'd do this in v2.6.27 but i forced myself to be reasonable and applied 
your patches to tip/x86/pat instead, for tentative v2.6.28 merging 
(assuming it all passes testing, etc.):

 # 9a79f4f: x86: {reverve,free}_memtype() take a physical address
 # c5e147c: x86: have set_memory_array_{uc,wb} coalesce memtypes.
 # 5f310b6: agp: enable optimized agp_alloc_pages methods

( note that i flipped them around a bit and have put your 
  enable-agp_alloc_pages()-widely patch last, so that we get better 
  bisection behavior. )

The frontside cache itself is in x86/urgent:

 # 80c5e73: x86: fix Xorg startup/shutdown slowdown with PAT

... and should at least solve the symptom that you've hit in practice 
(the slowdown), without changing the underlying PAT machinery. (which 
would be way too dangerous for v2.6.27)

And it's all merged up in tip/master, you might want to test that too to 
check whether all the pieces fit together nicely.

Tens of thousands of page granular memtypes was Not Nice.

Venki, Suresh, Shaohua, Dave, Arjan - any observations about this line 
of action?

	Ingo
