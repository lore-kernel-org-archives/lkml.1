Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbZK3RSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbZK3RSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 12:18:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbZK3RSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 12:18:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869AbZK3RSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 12:18:40 -0500
Date: Mon, 30 Nov 2009 09:18:31 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nick Piggin <npiggin@suse.de>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] "fair" rw spinlocks
In-Reply-To: <20091130171333.GG21639@wotan.suse.de>
Message-ID: <alpine.LFD.2.00.0911300914240.2872@localhost.localdomain>
References: <20091123145409.GA29627@wotan.suse.de> <alpine.LFD.2.00.0911280927180.2561@localhost> <20091130075557.GI17484@wotan.suse.de> <alpine.LFD.2.00.0911300706420.2872@localhost.localdomain> <20091130154031.GE21639@wotan.suse.de>
 <alpine.LFD.2.00.0911300754420.2872@localhost.localdomain> <20091130163923.GC6762@linux.vnet.ibm.com> <alpine.LFD.2.00.0911300852410.2872@localhost.localdomain> <20091130171333.GG21639@wotan.suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Nov 2009, Nick Piggin wrote:
> 
> Two questions. Firstly, does tasklist_lock benefit much from read
> side paralellism? Looking at some of the critical sections some seem
> to hold it for quite a while (over task and thread iterations). So
> it might not be the right thing to convert it to a spinlock?

I do agree that it's a potential problem.

> Secondly:
> 
> > 	static void tasklist_read_lock(void)
> > 	{
> > 		preempt_disable();
> > 		if (!current->tasklist_count++)
> 
> What happens if an interrupt and nested tasklist_read_lock() happens
> here?

You're right. We'd still need to disable hardware interrupts. Very 
annoying, because that is pretty much _guaranteed_ to eat up any advantage 
of the faster spin_unlock path. 

So scratch that approach. My earlier suggestion still looks technically 
correct, but has all the performance disadvantages.

The best option really would be to try to make it all use RCU, rather than 
paper over things. That _really_ should improve performance.

			Linus
