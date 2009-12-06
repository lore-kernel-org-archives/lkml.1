Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbZLFCFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbZLFCFR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 21:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbZLFCFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 21:05:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752811AbZLFCFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 21:05:12 -0500
Date: Sat, 5 Dec 2009 18:05:14 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [GIT PULL] PM updates for 2.6.33
In-Reply-To: <200912060254.10081.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0912051758190.3560@localhost.localdomain>
References: <200912052216.19540.rjw@sisk.pl> <200912060055.36130.rjw@sisk.pl> <alpine.LFD.2.00.0912051635330.3560@localhost.localdomain> <200912060254.10081.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 6 Dec 2009, Rafael J. Wysocki wrote:
> 
> While the current settings are probably unsafe (like enabling PCI devices
> to be suspended asynchronously by default if there are not any direct
> dependences between them), there are provisions to make eveything safe, if
> we have enough information (which also is needed to put the required logic into
> the drivers).

I disagree.

Think of a situation that we already handle pretty poorly: USB mass 
storage devices over a suspend/resume.

> The device tree represents a good deal of the dependences
> between devices and the other dependences may be represented as PM links
> enforcing specific ordering of the PM callbacks.

The device tree means nothing at all, because it may need to be entirely 
rebuilt at resume time. 

Optimally, what we _should_ be doing (and aren't) for suspend/resume of 
USB is to just tear down the whole topology and rebuild it and re-connect 
the things like mass storage devices. IOW, there would be no device tree 
to describe the topology, because we're finding it anew. And it's one of 
the things we _would_ want to do asynchronously with other things.

We don't want to build up some irrelevant PM links and callbacks. We don't 
want to have some completely made-up new infrastructure for something that 
we _already_ want to handle totally differently for init time.

IOW, I argue very strongly against making up something PM-specific, when 
there really doesn't seem to be much of an advantage. We're much better 
off trying to share the init code than making up something new.

> I'd say if there's a worry that the same register may be accessed concurrently
> from two different code paths, there should be some locking in place.

Yeah. And I wish ACPI didn't exist at all. We don't know.

And we want to _limit_ our exposure to these things.

			Linus
