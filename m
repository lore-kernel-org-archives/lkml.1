Return-Path: <linux-kernel-owner+w=401wt.eu-S1762361AbYBUA0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762361AbYBUA0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 19:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934161AbYBUAZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 19:25:48 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43706 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933953AbYBUAZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 19:25:41 -0500
Date: Wed, 20 Feb 2008 16:25:20 -0800 (PST)
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
In-Reply-To: <200802210113.05733.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.00.0802201617050.7833@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802210035.14058.rjw@sisk.pl> <alpine.LFD.1.00.0802201548000.7833@woody.linux-foundation.org> <200802210113.05733.rjw@sisk.pl>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Feb 2008, Rafael J. Wysocki wrote:
> 
> > Secondly, the one that people should use ("pci_choose_state()") doesn't 
> > actually do what you claim it does. It does all kinds of wrong things, and 
> > doesn't even take the target state into account at all. So look again.
> 
> Well, if platform_pci_choose_state() is defined, pci_choose_state() returns
> its result and on ACPI systems that points to acpi_pci_choose_state(), so in
> fact it does what I said (apart from the error path). 

Did you check closer?

I repeat: acpi_pci_choose_state() (when called from pci_choose_state()) 
doesn't even look at the target 'state'. It just blindly assumes that you 
want the deepest sleep-state you can have.

Which happens to be correct for normal suspend, but means that if you want 
to test other states (through '/sys/devices/.../power'), that sounds 
broken.

I didn't check any closer, but go check it yourself. The short and sweet: 
acpi_pci_choose_state() totally ignores its 'state' argument. Do you 
really think that's correct? But yes, "pci_choose_state()' effectively 
does that too, apart from PM_EVENT_ON, which is never used.

(But the whole and only point of pci_choose_state() was to do the 
PM_EVENT_FREEZE thing differently, which it doesn't do, so I think the 
real issue here is that the interface is really rather mis-designed)

I suspect most people who ever really looked and worked on this code had a 
specific device in mind, and I'm sure that all of the code individually 
always ends up making sense from the standpoint of some specific device 
driver. It's just that it never seems to make sense from a bigger issues 
standpoint, and often seems senseless from the standpoint of other devices 
of other types.

			Linus
