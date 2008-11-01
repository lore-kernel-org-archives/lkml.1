Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbYKAQ25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbYKAQ25 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 12:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYKAQ2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 12:28:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:51038 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbYKAQ2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 12:28:48 -0400
Date: Sat, 1 Nov 2008 09:29:05 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: (BUG?) round_jiffies() is non-monotonic on SMP
Message-ID: <20081101092905.443a2dc5@infradead.org>
In-Reply-To: <Pine.LNX.4.44L0.0811011205030.21703-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0811011205030.21703-100000@netrider.rowland.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Nov 2008 12:14:41 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> Is it generally recognized that round_jiffies() can be non-monotonic
> on SMP systems?  By this, I mean that if cpu-a and cpu-b respectively
> do:
> 
> 	ra = round_jiffies(ja);
> 
> 		and
> 
> 	rb = round_jiffies(jb);
> 
> then the ordering of ra and rb can be opposite the ordering of ja and 
> jb.

round_jiffies() tends to be used (and is designed to be used) for cases
where you don't really care when exactly timers will fire... including
the order against other such timers.

 
> If this is known, is it regarded as a potential problem?  It certainly
> seems likely that some code somewhere depends on timeouts expiring in
> the correct order.

I don't think timeouts EVER have that guarantee between different cpus;
even if you don't round the timeouts.
After all, your CPU A can be in some delay loop with irqs off for
longer than the delta was, and boom.. the timers fire in different
order.
If we ever have such ordering requirements in the kernel that
don't handle this... they're a bug...

> 
> Alan Stern
> 
> P.S.: As a related matter, it seems very odd that we don't have a 
> round_jiffies_up() routine.  Surely there are plenty of places where
> it doesn't matter if an event is a little late but where the event
> must not be early.  (I know two such places offhand.)  Any objection
> to having one added?

no objection per se, but I would almost argue we should convert such
places to range timers....
that way the kernel can, rather an aligning them, group them with other
activity.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
