Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbZH1TIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbZH1TIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbZH1TIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:08:49 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:46572 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752000AbZH1TIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:08:46 -0400
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Aug 2009 15:08:46 EDT
Date: Fri, 28 Aug 2009 14:57:11 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Thomas Gleixner <tglx@linutronix.de>
cc: Gregory Haskins <ghaskins@novell.com>, Rik van Riel <riel@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, raz ben yehuda <raziebe@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       peterz@infradead.org, maximlevitsky@gmail.com, efault@gmx.de,
       wiseman@macs.biu.ac.il, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
In-Reply-To: <alpine.LFD.2.00.0908281218560.2888@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0908281446520.7317@gentwo.org>
References: <1251282598.3514.20.camel@raz>  <alpine.DEB.1.10.0908260943090.9924@gentwo.org>  <1251297910.1791.22.camel@maxim-laptop> <1251298443.4791.7.camel@raz>  <1251300625.18584.18.camel@twins>  <alpine.DEB.1.10.0908261136590.9933@gentwo.org> 
 <1251302598.18584.31.camel@twins>  <alpine.DEB.1.10.0908261211340.9933@gentwo.org>  <20090826180407.GA13632@elte.hu>  <alpine.DEB.1.10.0908261509580.9933@gentwo.org>  <20090826193252.GA14721@elte.hu>  <alpine.DEB.1.10.0908261627110.5554@gentwo.org> 
 <20090826135041.e6169d18.akpm@linux-foundation.org>  <4A95A5EE.90400@nortel.com> <1251322663.3882.48.camel@raz> <4A96B997.1070001@nortel.com> <alpine.DEB.1.10.0908271257270.17470@gentwo.org> <alpine.LFD.2.00.0908272242500.2888@localhost.localdomain>
 <4A97071F.5070804@novell.com> <4A973DAE.4020508@redhat.com> <4A975025.8030500@novell.com> <4A975CC4.1090208@novell.com> <alpine.LFD.2.00.0908281218560.2888@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009, Thomas Gleixner wrote:

> That makes sense and should not be rocket science to implement.

I like it and such a thing would do a lot for reducing noise.

However, look at a typical task (from the HPC world) that would be
running on an isolated processors. It would

1. Spin on some memory location waiting for an event.

2. Process data passed to it, prepare output data and then go back to 1.

The enticing thing about doing 1 with shared memory and/or infiniband is
that it can be done in a few hundred nanoseconds instead of 10-20
microseconds. This allows a much faster IPC communication if we bypass
the OS.

For many uses deterministic responses are desired. If the handler that
runs is never disturbed by extraneous processing (IPI, faults, irqs etc)
then we can say that we run at the maximum speed that the machine can run
at. That is what many sites expect.

In an HPC environment synchronization points are essential and the
frequency of synchronization points (where we spin on a cacheline) is
important for the ability to scale the accuratey and the performance of
the algorithm. If we can make N processor operate in a deterministic
fashion on f.e. an array of floating point numbers then the rendezvous
occurring with minimal wait time in each of the N processes. Getting rid
of all sources of interruptions gets us the best performance possible.

Right now often strong variability makes it necessary to have long
durations of the processing periods and deal with long wait times because
one of the N processes has not finished yet.


