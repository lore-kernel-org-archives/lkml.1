Return-Path: <linux-kernel-owner+w=401wt.eu-S1765023AbZDILz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765023AbZDILz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 07:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756745AbZDILzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 07:55:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:57563 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895AbZDILzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 07:55:48 -0400
Message-ID: <49DDE1B5.4070407@kernel.org>
Date: Thu, 09 Apr 2009 04:53:25 -0700
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
 percpu allocator
References: <49D3231D.2040403@kernel.org> <20090401103257.12c2517e@skybase> <49D32B96.3060102@kernel.org> <20090401130731.785714c5@skybase> <49D41B79.60708@kernel.org> <20090402072418.GA14071@jurassic.park.msu.ru> <20090402131341.08ef4184@skybase> <49D558CE.9090608@kernel.org> <20090407160940.GA31956@jurassic.park.msu.ru> <49DD068F.8040102@kernel.org> <20090409094713.GA6538@jurassic.park.msu.ru>
In-Reply-To: <20090409094713.GA6538@jurassic.park.msu.ru>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Apr 2009 11:52:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ivan.

Ivan Kokshaysky wrote:
>> it seems like if two different files happen to use static percpu
>> variables with the same name, they would end up sharing it, right?
>> That looks a tad bit dangerous.
> 
> True. One of possible solutions is to add another dummy variable,
> like this:
> 
> #define DEFINE_PER_CPU_SECTION(type, name, section)			\
> 	__attribute__((__section__(".discard"), __unused__))		\
> 		char __dummy__##name;					\
> +	__attribute__((__section__(".discard")))			\
> +		char __per_cpu_multiple_def__##name;			\
> 	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
> 		__weak __typeof__(type) per_cpu__##name
> 
> so in that situation we'll get a link failure.

Hmmm... yeah, I agree not allowing common static names is the lesser
poison here.  It's generally a good idea to use uniquely
distinguisible identifier for static symbols anyway to help debugging.
If this limitation is acceptable, I think we should also add the dup
build failure thing to the generic definition too tho so that such
cases can be discovered before they hit alpha and s390 later.

Any objections?

Thanks.

-- 
tejun
