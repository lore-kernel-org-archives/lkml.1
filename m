Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbYHNRtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbYHNRtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 13:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYHNRs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 13:48:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59202 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbYHNRsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 13:48:55 -0400
Subject: Re: [PATCH RFC] pm_qos_requirement might sleep
From: Peter Zijlstra <peterz@infradead.org>
To: mgross@linux.intel.com
Cc: John Kacur <jkacur@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, arjan <arjan@infradead.org>
In-Reply-To: <20080814155241.GA31050@linux.intel.com>
References: <520f0cf10808041352h78bd4319x1802f018aeffe6dc@mail.gmail.com>
	 <1217921101.3589.98.camel@twins> <20080805204901.GA31132@linux.intel.com>
	 <1217970588.29415.36.camel@lappy.programming.kicks-ass.net>
	 <520f0cf10808051518h1459d353r8de78e98f79ec57c@mail.gmail.com>
	 <20080812224926.GA20652@linux.intel.com>
	 <520f0cf10808130124o301b6691ra37ac9007120b9df@mail.gmail.com>
	 <20080814155241.GA31050@linux.intel.com>
Content-Type: text/plain
Date: Thu, 14 Aug 2008 19:48:57 +0200
Message-Id: <1218736137.10800.234.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-14 at 08:52 -0700, mark gross wrote:

> Keeping a lock around the different "target_value"s may not be so
> important.  Its just a 32bit scaler value, and perhaps we can make it an
> atomic type?  That way we loose the raw_spinlock.

My suggestion was to keep the locking for the write side - so as to
avoid stuff stomping on one another, but drop the read side as:

 spin_lock
 foo = var;
 spin_unlock
 return foo;

is kinda useless, it doesn't actually serialize against the usage of
foo, that is, once it gets used, var might already have acquired a new
value.

The only thing it would protect is reading var, but since that is a
machine sized read, its atomic anyway (assuming its naturally aligned).

So no need for atomic_t (its read-side is just a read too), just drop
the whole lock usage from pq_qos_requirement().



