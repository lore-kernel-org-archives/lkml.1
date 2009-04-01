Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbZDALIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbZDALIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761256AbZDALHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:07:39 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:52546 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761136AbZDALHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:07:38 -0400
Date: Wed, 1 Apr 2009 13:07:31 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, rusty@rustcorp.com.au, tglx@linutronix.de,
       x86@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
 percpu allocator
Message-ID: <20090401130731.785714c5@skybase>
In-Reply-To: <49D32B96.3060102@kernel.org>
References: <1236671631-9305-1-git-send-email-tj@kernel.org>
	<20090316190132.7965a49a@skybase>
	<49C300D8.5080204@kernel.org>
	<49C8FAC4.6060508@kernel.org>
	<20090325122738.42d105b7@skybase>
	<49CA1AC3.9080908@kernel.org>
	<20090325122241.GE11571@elte.hu>
	<49CA2345.70204@kernel.org>
	<20090325141330.2717dc97@skybase>
	<49CA2FBF.9000207@kernel.org>
	<20090325142525.2d31c522@skybase>
	<49CA32F6.2030408@kernel.org>
	<20090331185431.72ff1707@skybase>
	<49D2B04D.4070604@kernel.org>
	<20090401101054.0a4b187d@skybase>
	<49D3231D.2040403@kernel.org>
	<20090401103257.12c2517e@skybase>
	<49D32B96.3060102@kernel.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Apr 2009 17:53:42 +0900
Tejun Heo <tj@kernel.org> wrote:

> Hello, Martin.
> 
> Martin Schwidefsky wrote:
> > Yes, @GOTENT is a relocation against the GOT slot that contains the
> > address of the symbol. It is a special version of @GOT that uses larl
> > to locate the got slot directly without the need of a got base pointer.
> > 
> > The code sequence with @GOT:
> > 
> > 	larl	%r12,_GLOBAL_OFFSET_TABLE_
> > 	lg	%r1,symbol@GOT(%r12)
> > 
> > is equivalent to:
> > 
> > 	larl	%r1,symbol@GOTENT
> > 	lg	%r1,0(%r1)
> > 
> > The advantage of the second code sequence is that it need a single
> > register and the size of the GOT is not limited to 4K as in the first
> > example (the offset in an RX format instruction is limited to 12 bits -
> > but that is probably something you don't want to know ;-).
> 
> Maybe we can build indirection pointer manually by twiddling with
> DEFINE_PER_CPU() in such a way that it doesn't have to distinguish
> symbols and variables?

Hmm, a provocative idea: can we ban the use of static per-cpu variables
for modules in common code? There are not many common code modules
doing this, with a visibility hack I found the following relevant
locations:

block/as-iosched.c:152: warning: 'visibility' attribute ignored
crypto/sha512_generic.c:30: warning: 'visibility' attribute ignored
block/cfq-iosched.c:51: warning: 'visibility' attribute ignored
mm/kmemleak-test.c:39: warning: 'visibility' attribute ignored
kernel/rcutorture.c:117: warning: 'visibility' attribute ignored
kernel/rcutorture.c:119: warning: 'visibility' attribute ignored
drivers/acpi/processor_core.c:663: warning: 'visibility' attribute ignored
drivers/acpi/processor_thermal.c:99: warning: 'visibility' attribute ignored
drivers/cpufreq/cpufreq_stats.c:46: warning: 'visibility' attribute ignored
drivers/cpufreq/cpufreq_userspace.c:30: warning: 'visibility' attribute ignored
drivers/cpufreq/cpufreq_userspace.c:31: warning: 'visibility' attribute ignored
drivers/cpufreq/cpufreq_userspace.c:32: warning: 'visibility' attribute ignored
drivers/cpufreq/cpufreq_userspace.c:33: warning: 'visibility' attribute ignored
drivers/cpufreq/cpufreq_userspace.c:35: warning: 'visibility' attribute ignored
drivers/cpufreq/cpufreq_ondemand.c:90: warning: 'visibility' attribute ignored
drivers/cpufreq/cpufreq_conservative.c:83: warning: 'visibility' attribute igno\
red
drivers/cpufreq/freq_table.c:177: warning: 'visibility' attribute ignored
net/ipv6/syncookies.c:77: warning: 'visibility' attribute ignored

That would "fix" the problem as well..

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

