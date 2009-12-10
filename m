Return-Path: <linux-kernel-owner+w=401wt.eu-S933612AbZLJKb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612AbZLJKb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 05:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933594AbZLJKb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 05:31:56 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:54864 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933589AbZLJKbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 05:31:55 -0500
To: paulmck@linux.vnet.ibm.com
Cc: Oleg Nesterov <oleg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0911302206370.24119@localhost.localdomain>
	<1259616429.26472.499.camel@laptop>
	<alpine.LFD.2.00.0911302300550.24119@localhost.localdomain>
	<alpine.LFD.2.00.0911301409560.2872@localhost.localdomain>
	<alpine.LFD.2.00.0911302328350.24119@localhost.localdomain>
	<alpine.LFD.2.00.0911301443110.2872@localhost.localdomain>
	<m1y6lg7q3n.fsf@fess.ebiederm.org> <20091207183226.GA20139@redhat.com>
	<m1aaxu305x.fsf@fess.ebiederm.org> <20091209153709.GA13192@redhat.com>
	<20091210062220.GC6720@linux.vnet.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 10 Dec 2009 02:31:39 -0800
In-Reply-To: <20091210062220.GC6720@linux.vnet.ibm.com> (Paul E. McKenney's message of "Wed\, 9 Dec 2009 22\:22\:20 -0800")
Message-ID: <m1my1rnmr8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [rfc] "fair" rw spinlocks
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:

> My main concern would be "fork storms", where each CPU in a large
> system is spawning children in a pgrp that some other CPU is attempting
> to kill.  The CPUs spawning children might be able to keep ahead of
> the single CPU, so that the pgrp never is completely killed.
>
> Enlisting the aid of the CPUs doing the spawning (e.g., by having them
> consult a list of signals being sent) prevents this fork-storm scenario.

We almost have a worst case bound. We can have at most max_thread
processes.  Unfortunately it appears we don't force an rcu grace
period anywhere.  So It does appear theoretically possible to fork and
exit on a bunch of other cpus infinitely extending the rcu interval.

Still that is all inside the tasklist_lock, which serializes all of those
other cpus.  So as long as the cost of queuing signals is less than the
cost of adding processes to the task lists we won't have a problem.

Eric
