Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbYIGUb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbYIGUb6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 16:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbYIGUbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 16:31:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35887 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbYIGUbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 16:31:48 -0400
Subject: Re: [RFC 07/13] sched: Reduce stack size requirements in
 kernel/sched.c
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <20080907040009.611ac986.akpm@linux-foundation.org>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>
	 <20080906235037.880702000@polaris-admin.engr.sgi.com>
	 <1220783087.8687.73.camel@twins.programming.kicks-ass.net>
	 <20080907040009.611ac986.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sun, 07 Sep 2008 22:28:01 +0200
Message-Id: <1220819281.8687.100.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-09-07 at 04:00 -0700, Andrew Morton wrote:

> make cpu_hotplug.refcount an atomic_t.

That might actually be a worthwhile idea, but it will not make
get_online_cpus() atomic. The whole point of get_online_cpus() is to
serialize against actual hotplug operations, so it will have to sleep at
some point.

Now, turning cpu_hotplug.refcount into an atomic_t might be worthwhile
because it will reduce the amount of atomic operations in its fastpath
from 2 to 1.

You'd have to make recount==1 the stable situation and use
atomic_inc_unless() and atomic_dec_and_test() in get_online_cpus() and
put_online_cpus() resp. that way !refcount can signify a hotplug
operation and we'd fall back into the slow paths.

