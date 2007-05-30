Return-Path: <linux-kernel-owner+w=401wt.eu-S1757704AbXE3REU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704AbXE3REU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 13:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754931AbXE3RED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 13:04:03 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753874AbXE3REB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 13:04:01 -0400
Date: Wed, 30 May 2007 10:03:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Nathan Lynch <nathanl@austin.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>, Ashok Raj <ashok.raj@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, akpm@linux-foundation.org,
       Dipankar <dipankar@in.ibm.com>
Subject: Re: CPU hotplug: system hang on CPU hot remove during `pfmon
 --system-wide'
In-Reply-To: <20070530165557.GB1626@in.ibm.com>
Message-ID: <alpine.LFD.0.98.0705301000350.26602@woody.linux-foundation.org>
References: <87bqg5emqk.wl%takeuchi_satoru@jp.fujitsu.com>
 <20070528065550.GL6157@in.ibm.com> <alpine.LFD.0.98.0705291347320.26602@woody.linux-foundation.org>
 <20070530165557.GB1626@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 May 2007, Srivatsa Vaddagiri wrote:
> 
> and that's where all the problems started - sleepers needing to take that mutex 
> recursively (which we did/do not support).
> 
> 	foo() takes cpu_bitmask_lock and calls
> 	  foo_bar() which also needs cpu_bitmask_lock
> 
> What is a solution to that?

The solution is to not have crap locking in the first place.

Or, if you absolutely have to, support recursive locking. But the bassic 
rule should always really be that the need for recursive locking is really 
a sign of a locking bug in the first place.

So what's so wrong with just admitting that the locking was crap, and 
doing it properly? The _proper_ locking doesn't need recursive locks, it 
just takes the lock at the outer layers, and then does *not* take it 
internally, because the called routines are called with the lock held and 
know they are safe.

We have been able to do that in _every_ single kernel subsystem. What's so 
special about cpufreq? NOTHING. Except that the code is sometimes horribly 
bad.

		Linus
