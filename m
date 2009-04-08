Return-Path: <linux-kernel-owner+w=401wt.eu-S1761396AbZDHUU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761396AbZDHUU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 16:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbZDHUUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 16:20:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:60317 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145AbZDHUUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 16:20:09 -0400
Message-ID: <49DD068F.8040102@kernel.org>
Date: Wed, 08 Apr 2009 13:18:23 -0700
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
References: <49D2B04D.4070604@kernel.org> <20090401101054.0a4b187d@skybase> <49D3231D.2040403@kernel.org> <20090401103257.12c2517e@skybase> <49D32B96.3060102@kernel.org> <20090401130731.785714c5@skybase> <49D41B79.60708@kernel.org> <20090402072418.GA14071@jurassic.park.msu.ru> <20090402131341.08ef4184@skybase> <49D558CE.9090608@kernel.org> <20090407160940.GA31956@jurassic.park.msu.ru>
In-Reply-To: <20090407160940.GA31956@jurassic.park.msu.ru>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 20:17:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Ivan Kokshaysky wrote:
> On Fri, Apr 03, 2009 at 09:31:10AM +0900, Tejun Heo wrote:
>> Can STATIC_DEFINE_PER_CPU() be made to work?  It's not pretty but if
>> that's the only sensible way to reach uniform static/dynamic handling,
>> I suppose we can ignore the slight ugliness.
> 
> Well, I've got a workaround that has zero impact on common code (patch
> appended).
> 
> The idea is that we can effectively discard the "static" specifier
> by declaring a dummy variable right before actual per-cpu variable
> definition:
> 
> #define DEFINE_PER_CPU_SECTION(type, name, section)			\
> 	__attribute__((__section__(".garbage"), __unused__))		\
> 		char __dummy__##name;					\
> 	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
> 		__weak __typeof__(type) per_cpu__##name

Nice.  I think .discard would suit better for the dummy variable tho
(x86 discards the section and it seems to be more common name with
ldscript using /DISCARD/ identifier for things to throw away).  Also,
it seems like if two different files happen to use static percpu
variables with the same name, they would end up sharing it, right?
That looks a tad bit dangerous.

Thanks.

-- 
tejun
