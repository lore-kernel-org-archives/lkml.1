Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbZDWRNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbZDWRNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 13:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbZDWRNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 13:13:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752094AbZDWRNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 13:13:11 -0400
Date: Thu, 23 Apr 2009 10:07:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, serue@us.ibm.com,
       viro@zeniv.linux.org.uk,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] It may not be assumed that wake_up(), finish_wait() and
 co. imply a memory barrier
In-Reply-To: <21209.1240504344@redhat.com>
Message-ID: <alpine.LFD.2.00.0904231004120.3101@localhost.localdomain>
References: <20090422175753.GA14236@elte.hu> <20090415162712.342d4c07.akpm@linux-foundation.org> <1239649429.16771.9.camel@heimdal.trondhjem.org> <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com>
 <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com> <21239.1240407420@redhat.com> <5591.1240417398@redhat.com>  <21209.1240504344@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 23 Apr 2009, David Howells wrote:
>
> I was wondering if wake_up() and friends should in fact imply smp_wmb(), but I
> guess that they're often used in conjunction with spinlocks - and in such a
> situation a barrier is unnecessary overhead.

I think we _have_ to imply a smp_wmb() in the wakup semantics, because 
otherwise sleepers can't do anything sane (no amount of barriers on the 
sleeping side will help). IOW, there basically has to be an implied write 
barrier between the thing that causes an event to become true, and the 
thing that turns 'task->state' back to RUNNING.

This is similar to the issue of doing cross-CPU IPI's: sending an IPI 
_must_ imply a memory barrier with the IPI mechanism, because otherwise 
the receiver could never do anything sane.

		Linus
