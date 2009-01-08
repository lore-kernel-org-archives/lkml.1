Return-Path: <linux-kernel-owner+w=401wt.eu-S1761322AbZAHQ7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761322AbZAHQ7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 11:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbZAHQ7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 11:59:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239AbZAHQ7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 11:59:11 -0500
Date: Thu, 8 Jan 2009 08:58:06 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
       Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
In-Reply-To: <1231426014.11687.456.camel@twins>
Message-ID: <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>
References: <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>  <1231347442.11687.344.camel@twins>  <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>  <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com>  <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>
  <1231365115.11687.361.camel@twins>  <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain>  <1231366716.11687.377.camel@twins>  <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain>  <1231408718.11687.400.camel@twins>  <20090108141808.GC11629@elte.hu>
 <1231426014.11687.456.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ok, I've gone through -v7, and I'm sure you're all shocked to hear it, but 
I have no complaints. Except that you dropped all the good commit 
commentary you had earlier ;)

The patch looks pretty good (except for the big "#if 0" block in 
mutex-debug.c that I hope gets fixed, but I can't even really claim that I 
can be bothered), the locking looks fine (ie no locking at all), and the 
numbers seem pretty convinving.

Oh, and I think the open-coded

	atomic_cmpxchg(count, 1, 0) == 1

could possibly just be replaced with a simple __mutex_fastpath_trylock(). 
I dunno.

IOW, I'd actually like to take it, but let's give it at least a day or 
two. Do people have any concerns? 

And as far as I'm concerned, the nice part about not having any locking 
there is that now the spinning has no impact what-so-ever on the rest of 
the mutex logic. There are no subtleties about any of that - it's 
literally about falling back to a (fairly educated) "try a few trylocks if 
you fail". So it _looks_ pretty robust. I don't think there should be any 
subtle interactions with anything else. If the old mutexes worked, then 
the spinning should work.

Discussion?

		Linus
