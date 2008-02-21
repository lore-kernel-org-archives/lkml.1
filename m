Return-Path: <linux-kernel-owner+w=401wt.eu-S1764955AbYBUABX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764955AbYBUABX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 19:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758460AbYBUABC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 19:01:02 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34966 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758388AbYBUABA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 19:01:00 -0500
Date: Wed, 20 Feb 2008 16:00:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Jesse Barnes <jesse.barnes@intel.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>, Alexey Starikovskiy <aystarik@gmail.com>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk.
 Screen becomes green.
In-Reply-To: <200802210035.14058.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.00.0802201548000.7833@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802202336.45492.rjw@sisk.pl> <alpine.LFD.1.00.0802201455430.7833@woody.linux-foundation.org> <200802210035.14058.rjw@sisk.pl>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Feb 2008, Rafael J. Wysocki wrote:
> 
> In fact we have acpi_pci_choose_state() that tells the driver which power
> state to put the device into in ->suspend().  If that is used, the device ends
> up in the state expected by to BIOS for S4.

First off, nobody should *ever* use that directly anyway.

Secondly, the one that people should use ("pci_choose_state()") doesn't 
actually do what you claim it does. It does all kinds of wrong things, and 
doesn't even take the target state into account at all. So look again.

> No.  Again, if there are devices that wake us up from S4, but not from S5,
> they need to be handled differently in the *enter S4* case (hibernation) and
> in the *enter S5* case (powering off the system).

And again, what does this have to do with (the example I used) the 
graphics hardware? Answer: nothing. The example I gave you we simply DO 
THE WRONG THING FOR.

Same thing for things like USB devices - where pci_choose_state() doesn't 
work to begin with. Why do we call "suspend()" on such a thing when we 
don't want to suspend it? We shouldn't. We should call "freeze/unfreeze" 
(which are no-ops) and then finally perhaps "poweroff", and that final 
stage might want to spin things down or similar.

But *none* of it has anything to do with suspend, and none of it has 
anything to do with pci_choose_state() (much less acpi_pci_choose_state)

The fact is, we should let the driver decide, and we should make it clear 
to the driver writer what he is deciding about - rather than basically lie 
and say "suspend the device and put it into D3" even when that's the last 
thing it should ever do.

			Linus
