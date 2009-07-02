Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbZGBRaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbZGBRaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbZGBRaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:30:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751783AbZGBRaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:30:01 -0400
Date: Thu, 2 Jul 2009 10:27:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Joe Perches <joe@perches.com>
cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: printk regression?
In-Reply-To: <1246513356.28915.62.camel@Joe-Laptop.home>
Message-ID: <alpine.LFD.2.01.0907021020200.4830@localhost.localdomain>
References: <4A4C3410.8080704@kernel.org>  <alpine.LFD.2.01.0907012119370.3380@localhost.localdomain> <1246513356.28915.62.camel@Joe-Laptop.home>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 1 Jul 2009, Joe Perches wrote:
> 
> There's at least 72 of them:
> 
> $ grep -Pr --include=*.[ch] "\bprintk.*\\\n.*KERN_" *

Yes. Most of these seem to be of the type that have just "\n" in front - 
probably exactly because the old code wasn't smart enough to notice the 
log-level unless it started a line.

For those cases, the trivial fix is to just remove the "\n". The new world 
order for printk is very much a simplification: the log-level is _always_ 
at the front of the printk, and printk will add the newline automatically 
if a log-level exists (unless it's KERN_CONT, of course).

So a simple

	sed 's/printk("\n"[ 	]*KERN_/printk(KERN_/'

should basically take care of it.

Of course, some cases are just crazy. Here's one:

	arch/m68knommu/kernel/traps.c:          printk(KERN_CONT "\n" KERN_EMERG " [%08lx] ", addr);

and I have no clue about why it would have KERN_CONT there. That makes 
little sense. Again, with the new printk logic, it really should be just

	printk(KERN_EMERG " [%08lx] ", addr);

and nothing odd.

		Linus
