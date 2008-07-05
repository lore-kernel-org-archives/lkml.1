Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbYGEDN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbYGEDN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 23:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbYGEDNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 23:13:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:53123 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbYGEDNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 23:13:47 -0400
Message-ID: <486EE6CA.2040908@kernel.org>
Date: Sat, 05 Jul 2008 12:13:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes for .26
References: <20080704131005.GA30768@havoc.gtf.org> <alpine.LFD.1.10.0807040955100.2815@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807040955100.2815@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 05 Jul 2008 03:13:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Linus Torvalds wrote:
> Looking at the AHCI change, I think it's still potentially buggy.
> 
> I think it is potentially buggy for two separate reasons:
> 
>  - if the interrupt happens because of some port that we don't handle, we 
>    should still ACK it, in order to get rid of it. I don't think Tejun's 
>    patch fixed anything at all, since it still did a binary 'and' with 
>    hpriv->port_map on the bits, so it would never ACK anything that didn't 
>    have a bit set, and the (bogus) interrupt would keep screaming.

Strange.  Yeah, the AND should go.  The original patch was...

http://htj.dyndns.org/export/testing/head-x86_64-bug390937_dbg0/0001-ahci-interrupt-debug.patch

And the reporter verified debug option 2 (the posted patch) and 3
(always write 0xffffffff) fixed the problem.  The report was complete
w/ boot log showing which debug option was active.  Ah... weird.  The
debug option 2 shouldn't have made any difference.  :-(

Anyways, will send a patch to drop the AND.

>  - I also wonder if / suspect that the IRQ ACK should happen _before_ we 
>    handle the source of the interrupt, because otherwise if one port ends 
>    up having two events in close succession (can this happen? I think so), 
>    then we end up perhaps getting the irq for the first one, and handle 
>    that first event, but then the second event happens immediately 
>    afterwards, and before we do the writel() to ACK it, so now the 
>    _hardware_ thinks we have handled both of them, even though we never 
>    actually reacted to the second event.
> 
> So I think the appended (TOTALLY UNTESTED!) patch - based on top of the 
> pull that I already did - might be a good idea.
> 
> NOTE! I _really_ didn't test it. I do not know how AHCI works at a low 
> level, and maybe there is some reason why the IRQ ACK writel() actually 
> has to happen after you've handled the event (to avoid getting a new 
> interrupt immediately. But based on other controllers I've worked with, 
> this is the correct way to not lose irq events.
> 
> [ And yes, the race for the irq ack issue is small. And yes, the 
>   likelihood of a bogus interrupt triggering is probably small too. And 
>   see above about my lack of specific knowledge about AHCI.
> 
>   So I'm sure as heck not going to commit this patch, I'm just sending it 
>   out as a "Are you sure you shouldn't do it like this?" RFC patch.. ]

The current code is correct.  From 10.6.2.1 of ahci 1.1,

  In order to clear an interrupt, software must first clear the event
  from the PxIS register, then clear the interrupt event from the IS
  register. If software clears IS register only, leaving the level of
  the virtual wire from the PxIS register set, the resulting level of
  1 shall cause the IS register bit to be re-set.

so, it basically behaves like level triggered IRQ latch for ports,
which also creates an easy-to-miss requirement for MSI implementation
where the controller should generate a new MSI message when the driver
clears some of the IRQ pending bits but not all.

I do agree it's strange.  Whenever I come back to ahci_interrupt()
after enough time has passed, that clearing code always makes me look
up the spec.  I guess it's about time to add some comment there.

Thanks.

-- 
tejun

