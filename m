Return-Path: <linux-kernel-owner+w=401wt.eu-S1752199AbZAIQEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbZAIQEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 11:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbZAIQEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 11:04:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:46317 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbZAIQEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 11:04:04 -0500
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
       Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
In-Reply-To: <alpine.DEB.1.10.0901091051591.17378@gandalf.stny.rr.com>
References: <1231441350.14304.48.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0901081140550.3283@localhost.localdomain>
	 <1231498062.11687.608.camel@twins> <1231513614.442.11.camel@twins>
	 <alpine.DEB.1.10.0901091051591.17378@gandalf.stny.rr.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 09 Jan 2009 17:03:51 +0100
Message-Id: <1231517031.442.15.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-09 at 10:59 -0500, Steven Rostedt wrote:

> > 
> > Adding that blocking on !owner utterly destroys everything.
> 
> I was going to warn you about that ;-)
> 
> Without the check for !owner, you are almost guaranteed to go to sleep 
> every time. Here's why:
> 
> You are spinning and thus have a hot cache on that CPU.
> 
> The owner goes to unlock but will be in a cold cache. It sets lock->owner 
> to NULL, but is still in cold cache so it is a bit slower.
> 
> Once the spinner sees the NULL, it shoots out of the spin but sees the 
> lock is still not available then goes to sleep. All before the owner could 
> release it. This could probably happen at every contention. Thus, you lose 
> the benefit of spinning. You probably make things worse because you add a 
> spin before every sleep.

Which is why I changed the inner loop to:

  l_owner = ACCESS_ONCE(lock->owner)
  if (l_owner && l_owner != owner)
    break

So that that would continue spinning.
