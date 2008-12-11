Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbYLKQW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbYLKQW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756582AbYLKQWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:22:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756579AbYLKQWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:22:49 -0500
Date: Thu, 11 Dec 2008 08:22:21 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Frans Pop <elendil@planet.nl>
cc: Eric Anholt <eric@anholt.net>, nix.or.die@googlemail.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: Linux 2.6.28-rc8
In-Reply-To: <200812111707.20857.elendil@planet.nl>
Message-ID: <alpine.LFD.2.00.0812110814360.3340@localhost.localdomain>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain> <49407CE1.9090600@googlemail.com> <49407CE1.9090600@googlemail.com> <1228979963.3254.8.camel@gaiman.anholt.net> <200812111707.20857.elendil@planet.nl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Dec 2008, Frans Pop wrote:

> Eric Anholt wrote:
> > My recommended solution, of course, is to remove vesafb.
> 
> How is taking away useful functionality from users a better option than 
> just fixing the bug?

Well, just to clarify: it's not a _bug_. It's a benign warnign that two 
subsystems are trying to map the same memory differently.

In this case, we have:

	resource map sanity check conflict: 0xd0000000 0xdfffffff 0xd0000000 0xd07effff vesafb

and what it means is that the caller (which is i915_gem_entervt_ioctl) is 
trying to apparently ioremap the _whole_ graphics card MMIO resource 
(0xd0000000-0xdfffffff), but the vesafb driver has already registered the 
fact that it uses _part_ of that resource (0xd0000000-0xd07effff).

There's no bug there. It's a warning. It's usually a very odd situation 
when somebody tries to ioremap something that crosses resource reservation 
boundaries, but the thing is, in this case it's not really a problem.

It's triggered by a couple of oddities:

 - fbcon (vesafb) is odd and only requests a partial resource, because it 
   only uses part of the MMIO window.

 - the interaction between fbcon and X is odd to begin with, since they 
   both use the same physical resource.

so it's a generic warning that triggers because these things _shouldn't_ 
happen, but it's not actually an error in this case. We could just remove 
the warning. Or leave it in, in case it finds other (real) issues, and 
just ignore it.

		Linus
