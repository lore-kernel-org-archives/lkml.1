Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbYJPOjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbYJPOjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 10:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbYJPOir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 10:38:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49651 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754013AbYJPOiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 10:38:46 -0400
Date: Thu, 16 Oct 2008 10:38:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: prasad@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <mingo@elte.hu>,
       <jason.wessel@windriver.com>, <avi@qumranet.com>,
       <richardj_moore@uk.ibm.com>
Subject: Re: [RFC Patch 1/9] Introducing generic hardware breakpoint handler
 interfaces
In-Reply-To: <20081016024956.602C61544CB@magilla.localdomain>
Message-ID: <Pine.LNX.4.44L0.0810161027100.2487-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008, Roland McGrath wrote:

> AFAIK no hardware's facility delivers two separate exceptions for a single
> hit of a single breakpoint slot.  There is just one hit, and it's either
> before the instruction or after it.  So you only need one handler function,
> and one pointer slot for it.

Hmm...  What happens on x86 if you have both an instruction breakpoint 
and a data breakpoint triggered for the same instruction?  My old 386 
manual seems to imply that you'll get two exceptions: a fault and a 
trap.

But I guess this would count as two separate breakpoint slots, with two 
different handlers registered.  So it shouldn't pose a problem.

> For fire-before types, there are two flavors.  On powerpc, data breakpoints
> are fire-before, and to actually complete the triggering load/store you
> have to clear the dabr (disable the breakpoint) before resuming (and then
> potentially deal with step-then-reenable, etc).  On x86, instruction
> breakpoints are fire-before, but there is the option of using the magic RF
> bit to suppress the hit without disabling the breakpoint.  So you need
> another inline a la *_supported() to indicate what's possible.  (Possibly
> the handler should be able to control this with its return value,
> i.e. allow returning with RF clear for some reason.)

There's another RF-related issue which the patch currently ignores.  
Namely, what should happen if a new user breakpoint is registered at
the current PC address?  We should force the RF flag to 0 so that the
breakpoint will be triggered when execution resumes.  The problem is
that it's not easy to tell whether the current PC corresponds to the
same linear address as that registered for the breakpoint -- i.e., I
don't know how the code should go about translating from virtual
addresses to linear addresses.  Would this in fact always be the
identity mapping?  Presumably not if we're in VM86 mode.

Alan Stern

