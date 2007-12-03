Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbXLCJa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbXLCJa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 04:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbXLCJav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 04:30:51 -0500
Received: from mga10.intel.com ([192.55.52.92]:21540 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751494AbXLCJau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 04:30:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,243,1194249600"; 
   d="scan'208";a="415056295"
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071130100845.GB2201@elte.hu>
References: <1196155985.25646.31.camel@ymzhang>
	 <200711301346.22573.nickpiggin@yahoo.com.au>
	 <1196392527.25646.65.camel@ymzhang>
	 <200711301429.15664.nickpiggin@yahoo.com.au>
	 <20071130100845.GB2201@elte.hu>
Content-Type: text/plain; charset=utf-8
Date: Mon, 03 Dec 2007 17:29:30 +0800
Message-Id: <1196674170.25646.121.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-30 at 11:08 +0100, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> > Haven't we been asking JVMs to use futexes or posix locking for years 
> > and years now? [...]
> 
> i'm curious, with what JVM was it tested and where's the source so i can 
> fix their locking for them? Can the problem be reproduced with:
> 
>   http://download.fedora.redhat.com/pub/fedora/linux/development/source/SRPMS/java-1.7.0-icedtea-1.7.0.0-0.20.b23.snapshot.fc9.src.rpm
I used BEA Jrockit to run volanoMark. Because of no Jrockit source codes, so
I retested volanoMark by jre-1.7.0-icedtea.x86_64 java of Fedora Core 8 on my stoakley (8-core)
machine with kernel 2.6.24-rc3.

1) Jrockit: sched_compat_yield=0's result is less than 15% of sched_compat_yield=1's.
2) jre-1.7.0-icedtea: sched_compat_yield=0's result is less than 89% of sched_compat_yield=1's.

So JVM really has much impact on the regression.

I checked the source codes of openjdk and found Thread.yield is implemented as native sched_yield.
If java applications call Thread.yield, it just calls sched_yield. garbage collection and other JVM
threads also calls Thread.yield. That's why 2 different JVM have different regression percentage.

Although no source codes of volanoMark, I suspect it calls Thread.sched. volanoMark is a kind
of chatroom benchmark. When a client sends out a message, server will send the message to all clients.
I suspect the client calls Thread.yield after sending out a couple of messages.

2 JVM all have regression if sched_compat_yield=0.

I ran some testing, such like iozone/specjbb/tbench/dbench/sysbench, and didn't see regression.

-yanmin

