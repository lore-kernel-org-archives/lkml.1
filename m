Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbZBCSb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbZBCSb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 13:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbZBCSbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 13:31:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158AbZBCSbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 13:31:50 -0500
Date: Tue, 3 Feb 2009 10:31:20 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore
 standard config registers of all devices early)
In-Reply-To: <alpine.LFD.2.00.0902030955370.3247@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0902031022390.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <1233633061.16867.41.camel@pasglop> <200902031026.34093.rjw@sisk.pl> <200902031804.26752.rjw@sisk.pl> <alpine.LFD.2.00.0902030955370.3247@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Feb 2009, Linus Torvalds wrote:
> 
> So don't worry about putting devices in D3 - disable_irq() will not care 
> AT ALL whether the device is alive or not, and will never try to touch it 
> anyway.

Btw, this is very much the case for MSI irq's in particular. If you ask to 
_mask_ them, it will go to the look up the device list and try to mask 
them (quite frankly, that sounds insane to me, but whatever), but that not 
what the irq layer does for the simple "disable()" case.

It will literally just set the flag, and then even if an interrupt happens 
afterwards, it will just ->ack it, and then call the ->end thing - and 
doesn't need to do anything else in the whole "disable" path because MSI's 
are obviously edge-triggered.

And the ACK is a pure (x2/io)apic thing, and again doesn't actually touch 
the device itself, only the irq controller itself.

So while it is possible in theory that some irq controller ends up trying 
to access the device for disable_irq, I don't think it's ever true in 
reality.

But it's possible that I overlooked some really odd case, of course.

			Linus
