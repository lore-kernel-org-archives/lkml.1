Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbZLBJrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbZLBJrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 04:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbZLBJrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 04:47:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59514 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbZLBJri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 04:47:38 -0500
Date: Wed, 2 Dec 2009 10:47:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Ma, Ling" <ling.ma@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Dave Jones <davej@redhat.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] [X86] Compile Option Os versus O2 on latest x86
 platform
Message-ID: <20091202094730.GC22654@elte.hu>
References: <1259222752-8161-1-git-send-email-ling.ma@intel.com>
 <20091126094930.GD32275@elte.hu>
 <8FED46E8A9CA574792FC7AACAC38FE7714FED213BE@PDSMSX501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8FED46E8A9CA574792FC7AACAC38FE7714FED213BE@PDSMSX501.ccr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ma, Ling <ling.ma@intel.com> wrote:

> Hi Ingo
> 
> Thanks for your correction, so we use perf stat --repeat 3 to test 
> volano, tbench, and kbuild, Because netperf has multiple items we may 
> send out later.
> 
> volano_Os:

>  18680627716893  cycles                   #   2925.196 M/sec   ( +-   0.339% )
>   7247421283541  instructions             #      0.388 IPC     ( +-   0.124% )
>    226838591574  cache-references         #     35.521 M/sec   ( +-   0.971% )
>      9420427393  cache-misses             #      1.475 M/sec   ( +-   0.897% )

> volano_O2:

>  17145170491943  cycles                   #   2918.985 M/sec   ( +-   0.288% )
>   7324126478801  instructions             #      0.427 IPC     ( +-   0.090% )
>    219064318074  cache-references         #     37.296 M/sec   ( +-   0.792% )
>      9491237013  cache-misses             #      1.616 M/sec   ( +-   0.439% )

> O2 is better than Os for volano
> O2 is not different with Os for tbench
> O2 is not different with Os for kbuild 

Ok, this looks pretty credible, thanks for going through it.

For Volano, the difference is 8.9%, well above the 0.3% noise level, so 
it's significant.

Would it be possible to do a 'perf record' and 'perf report' comparison 
between two volano runs, to see where the nearly 10% overhead comes 
from? It might be one or two functions mis-optimized by GCC perhaps. Or 
it could be across-the-spectrum slowdown.

Note that the number of instructions increased only by 1%, but the 
overhead by 9%. So we might be hitting some nasty corner case - or it 
might be some caching effect. (which does not seem to be supported by 
the numbers though - the LLC cache-misses does not look significantly 
higher in the Os case)

'perf annotate fn_name' will also help you see where the overhead 
hot-spots are. If you build the vmlinux via CONFIG_DEBUG_INFO the perf 
annotate output will interleave assembly and source code output. 
(otherwise it will be assembly output only)

You probably want to use the latest version of 'perf' for all that 
analysis, from:

  http://people.redhat.com/mingo/tip.git/README

Thanks,

	Ingo
