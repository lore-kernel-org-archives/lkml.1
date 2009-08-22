Return-Path: <linux-kernel-owner+w=401wt.eu-S933281AbZHVLSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281AbZHVLSu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 07:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933260AbZHVLSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 07:18:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53805 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933248AbZHVLSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 07:18:44 -0400
Date: Sat, 22 Aug 2009 13:18:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org, nhorman@redhat.com,
       ebiederm@xmission.com, andi@firstfloor.org, bernhard.walle@gmx.de,
       fenghua.yu@intel.com, kamezawa.hiroyu@jp.fujitsu.com,
       avorontsov@ru.mvista.com
Subject: Re: [Patch 5/8] ia64: implement crashkernel=auto
Message-ID: <20090822111816.GA12281@elte.hu>
References: <20090821065637.4855.32234.sendpatchset@localhost.localdomain> <20090821065729.4855.47860.sendpatchset@localhost.localdomain> <20090821172407.d3a5cd2b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090821172407.d3a5cd2b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 21 Aug 2009 02:55:04 -0400
> Amerigo Wang <amwang@redhat.com> wrote:
> 
> > +#ifdef CONFIG_KEXEC_AUTO_RESERVE
> > +#define ARCH_HAS_DEFAULT_CRASH_SIZE
> > +static inline
> > +unsigned long long arch_default_crash_size(unsigned long long total_size)
> > +{
> > +	if (total_size >= 4ULL<<30 && total_size < 12ULL<<30)
> > +		return 1ULL<<28;
> > +	else if (total_size >= 12ULL<<30 && total_size < 128ULL<<30)
> > +		return 1ULL<<29;
> > +	else if (total_size >= 128ULL<<30 && total_size < 256ULL<<30)
> > +		return 3ULL<<28;
> > +	else if (total_size >= 256ULL<<30 && total_size < 378ULL<<30)
> > +		return 1ULL<<30;
> > +	else if (total_size >= 318ULL<<30 && total_size < 512ULL<<30)
> > +		return 3ULL<<29;
> > +	else if (total_size >= 512ULL<<30 && total_size < 768ULL<<30)
> > +		return 2ULL<<30;
> > +	else if (total_size >= 768ULL<<30)
> > +		return 3ULL<<30;
> > +}
> > +#include <asm-generic/kexec.h>
> > +#endif
> 
> a) Why on earth is this inlined?
> 
> b) Please consider making arch_default_crash_size() a __weak
>    function.  You'll probably find the result to be pleasing.
> 
> c) If we can't use __weak then please don't add
>    ARCH_HAS_DEFAULT_CRASH_SIZE.  Instead do this trick:
> 
> 
> 	#ifndef arch_default_crash_size
> 	static inline unsigned long long arch_default_crash_size(unsigned long long total_size)
> 	{
> 		...
> 	}
> 	#define arch_default_crash_size arch_default_crash_size
> 	#endif
> 
> 	because i) it's good to standardise on something and ii) one less
> 	symbol gets added to the kernel.
> 
> d) why is asm-generic/kexec.h only included in asm/kexec.h if
>    CONFIG_KEXEC_AUTO_RESERVE happened to be defined?  That makes no
>    sense - there may be a multitude of reasons why asm/kexec.h wants
>    to include asm-generic/kexec.h.

e) All the 'else' statements are superflous and make it all harder 
   to read.

f) 2ULL<<30 should be written as 1ULL<31, to keep things consistent.

g) A nice comment explaining the purpose and logic wouldnt hurt.

	Ingo
