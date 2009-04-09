Return-Path: <linux-kernel-owner+w=401wt.eu-S1762642AbZDIJri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762642AbZDIJri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762955AbZDIJrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:47:09 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:55774 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762346AbZDIJrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:47:08 -0400
Date: Thu, 9 Apr 2009 13:47:14 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Tejun Heo <tj@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
	percpu allocator
Message-ID: <20090409094713.GA6538@jurassic.park.msu.ru>
References: <49D3231D.2040403@kernel.org> <20090401103257.12c2517e@skybase> <49D32B96.3060102@kernel.org> <20090401130731.785714c5@skybase> <49D41B79.60708@kernel.org> <20090402072418.GA14071@jurassic.park.msu.ru> <20090402131341.08ef4184@skybase> <49D558CE.9090608@kernel.org> <20090407160940.GA31956@jurassic.park.msu.ru> <49DD068F.8040102@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DD068F.8040102@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 01:18:23PM -0700, Tejun Heo wrote:
> > #define DEFINE_PER_CPU_SECTION(type, name, section)			\
> > 	__attribute__((__section__(".garbage"), __unused__))		\
> > 		char __dummy__##name;					\
> > 	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
> > 		__weak __typeof__(type) per_cpu__##name
> 
> Nice.  I think .discard would suit better for the dummy variable tho
> (x86 discards the section and it seems to be more common name with
> ldscript using /DISCARD/ identifier for things to throw away).  Also,

Indeed, .discard sounds better.

> it seems like if two different files happen to use static percpu
> variables with the same name, they would end up sharing it, right?
> That looks a tad bit dangerous.

True. One of possible solutions is to add another dummy variable,
like this:

#define DEFINE_PER_CPU_SECTION(type, name, section)			\
	__attribute__((__section__(".discard"), __unused__))		\
		char __dummy__##name;					\
+	__attribute__((__section__(".discard")))			\
+		char __per_cpu_multiple_def__##name;			\
	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
		__weak __typeof__(type) per_cpu__##name

so in that situation we'll get a link failure.

Ivan.
