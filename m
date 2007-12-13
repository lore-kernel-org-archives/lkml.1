Return-Path: <linux-kernel-owner+w=401wt.eu-S1761473AbXLMQBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761473AbXLMQBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbXLMQBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:01:16 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:57234 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbXLMQBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:01:14 -0500
Date: Thu, 13 Dec 2007 08:00:04 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, paulus@samba.org, akpm@linux-foundation.org,
       gregkh@suse.de, mucci@cs.utk.edu, wcohen@redhat.com,
       robert.richter@amd.com, andi@firstfloor.org, eranian@gmail.com,
       Stephane Eranian <eranian@hpl.hp.com>
Subject: Re: [perfmon2] perfmon2 merge news
Message-ID: <20071213160004.GC6740@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071119.050843.48408777.davem@davemloft.net> <18242.900.101842.261763@cargo.ozlabs.ibm.com> <20071119224845.GA27766@frankl.hpl.hp.com> <20071119.165313.163834190.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119.165313.163834190.davem@davemloft.net>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

A few weeks back, I mentioned that I would post some
interesting problems that I have encountered while
implementing perfmon and for which I am still looking
for better solutions.

Here is one that I would like to solve right now and
for which I am interested in your comments.

One of the perfmon syscall (pfm_restart()) is used to
resume monitoring after a user level notification. When
 operating in per-thread non self-monitoring mode, the
syscall needs to operate on the machine state of the
monitored thread. So you get into this situation:


        Thread T0                        Thread T1
            |                                |
       pfm_restart()                         |
            |                                |
    spin_lock_irqsave()                      |
            |                                |
  <modify T1's machine state>--------------->|
            |                                |
    spin_unlock_irqrestore()                 |
            |                                |
            v                                v

Thread T1 may be running at the time T0 needs to modify its state.
The current solution is to set a TIF flag in T1. That TIF flag will
cause T1 (on kernel exit) to go into a perfmon function that will
then modify the state, i.e., state is self-modified. That works okay
but there are a few race conditions. For self-monitoring sessions
(e.g., system-wide or per-thread), it is easy because we operate in
the correct thread.

But there is a big difference between self-monitoring and non
self-monitoring. The pfm_restart() syscall does not provide the
same guarantee.

In self-monitoring modes, the interface guarantees that by the time you
return from the call, the effects of the call are visible. Whereas when
monitoring another thread, the call currently does not provide such
guarantee, i.e., it does not wait until T1 has seen the TIF flag and
completed the state modification before returning. We could add a semaphore
to enforce that guarantee but it gets difficult with corner cases and
cleanups in case of unpexected termination.

AFAIK, there is no single call to stop T1 and wait until it is completely
off the CPU, unless we go through the (internal) ptrace interface. 

Would you have anything better to suggest?

Thanks.

--
-Stephane
