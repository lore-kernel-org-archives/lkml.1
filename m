Return-Path: <linux-kernel-owner+w=401wt.eu-S936142AbXGZXGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936142AbXGZXGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 19:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbXGZXG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 19:06:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60155 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934512AbXGZXG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 19:06:26 -0400
Date: Thu, 26 Jul 2007 16:04:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: matthew@wil.cx, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: IRQF_DISABLED problem
In-Reply-To: <20070726.152352.70218024.davem@davemloft.net>
Message-ID: <alpine.LFD.0.999.0707261557150.3442@woody.linux-foundation.org>
References: <20070726201355.GP19275@parisc-linux.org>
 <20070726.152352.70218024.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Jul 2007, David Miller wrote:
> > 
> > Another possibility is to force it if *any* of the handlers want
> > IRQF_DISABLED.  This seems to work:
> 
> Yes, this is consistent with how we handle sharing, we should
> enforce that all the flags on the chain are compatible.

No. It's no better than the current situation.

There are really a few choices:

 (a) Keep it like we always have.  What's the downside, really? It's what 
     we've got, it's what is tested.

 (b) Enforce that flags match. This may sound logical, but it will 
     actually *break* existing setups, because tons of drivers set 
     IRQF_DISABLED for no good reason (probably all totally historical)

 (c) "one IRQF_DISABLED means that everything runs disabled". This is 
     quite possibly buggy. There have been SCSI drivers with timeout 
     behaviour where they actually wait for timers to happen while in 
     their irq handlers. Bad form, and I *hope* we've fixed them all, but 
     I distinctly remember it being important that the timer had higher 
     priority than some SCSI drivers on some architecture.

 (d) "one !IRFQ_DISABLED means that everything runs with irq's on". I 
     don't think it's any better than the other behaviour.

 (e) Just ignore IRQF_DISABLED entirely when mixed with IRQF_SHARED, 
     because they're all pretty much guaranteed to be legacy and buggy and 
     pointless.

 (f) Disable and re-enable interrupts per handler.

Quite frankly, my preference would be (a) followed by (e) or (f), and 
(b)-(d) are in my opinion the worst of the lot with no upsides at all (and 
(b) in particular is pretty much _guaranteed_ to break existing setups).

			Linus
