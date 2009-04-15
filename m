Return-Path: <linux-kernel-owner+w=401wt.eu-S1752456AbZDOPjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbZDOPjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbZDOPi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:38:56 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:30442 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbZDOPiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:38:55 -0400
Date: Wed, 15 Apr 2009 11:38:32 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: "Moore, Robert" <robert.moore@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [BISECTED] EEE PC hangs when booting off battery
In-reply-to: <200904141056.14159.bjorn.helgaas@hp.com>
Message-id: <alpine.LFD.2.00.0904151056390.5664@localhost.localdomain>
References: <49E065CF.6040408@tuffmail.co.uk>
 <200904140948.37633.bjorn.helgaas@hp.com>
 <4911F71203A09E4D9981D27F9D8308581D3722EB@orsmsx503.amr.corp.intel.com>
 <200904141056.14159.bjorn.helgaas@hp.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > In fact, ACPI methods can execute concurrently -- constrained by the ACPI specification itself. The "big lock" is released before anything that will block for a significant amount of time, allowing other methods to run.
> 
> We had a discussion about this a couple years ago:
>   http://www.mail-archive.com/linux-acpi%40vger.kernel.org/msg06976.html
> 
> Here's my understanding (please correct me if I'm wrong):
> 
> - The ACPI CA holds a mutex while executing an AML method (see
>   acpi_ex_enter_interpreter()).
> 
> - When an AML method blocks, the ACPI CA releases the mutex, which
>   allows another AML method to run while the first is blocked.
> 
> - Because of the mutex, at most one AML method can be executing at
>   any given time.  Others may have started, but they are blocked
>   until the current method completes or blocks itself.
> 
> - The undocumented "acpi_serialize" option makes the ACPI CA hold
>   the mutex for the entire duration of a method, even while a method
>   is blocked.
> 
> Based on that, my guess about the battery init being slow because of
> a long-running AML method might be incorrect, although I suppose
> it's still possible to write AML busy-loops that never block.
> 
> I'd really like to understand what's making it slow.  The only
> thing that looks at all unusual in acpi_battery_add() is
> acpi_battery_update(), and that evaluates _STA and _BIF and
> not much else.
> 
> Arjan, do you have any more information?  Is the battery driver
> slow on all laptops?  If not, where did you see the problem?  Do
> you have a DSDT for them?

Before I added Arjan's async battery patch, I booted a couple of laptops
with async disabled and enabled.  I saw about 40 usec battery init (T61, 
nx6325).

Obviously, this was too fast for async battery to have any measurable
benefit on these machines (though async disk probing, by comparison,
was a big win).

But Arjan saw O(300) usec serial battery init on an EEE PC,
which is why he optimized it.

Indeed, this thread was started b/c a failure was seen on an EEEPC,
probably because of its unusually slow timing.

-Len


