Return-Path: <linux-kernel-owner+w=401wt.eu-S1752140AbZGaPOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbZGaPOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 11:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbZGaPOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 11:14:36 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:62077 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbZGaPOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 11:14:35 -0400
Date: Fri, 31 Jul 2009 11:14:05 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Andreas Mohr <andi@lisas.de>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Robert Hancock <hancockrwd@gmail.com>,
       Corrado Zoccolo <czoccolo@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Dynamic configure max_cstate
In-reply-to: <20090731080728.GA25049@rhlx01.hs-esslingen.de>
Message-id: <alpine.LFD.2.00.0907311059560.5528@localhost.localdomain>
References: <20090727073338.GA12669@rhlx01.hs-esslingen.de>
 <1248748935.2560.669.camel@ymzhang>
 <4e5e476b0907280020x242d9ef7gfa05c3d7b66f941f@mail.gmail.com>
 <1248771635.2560.682.camel@ymzhang>
 <20090728101135.GA22358@rhlx01.hs-esslingen.de> <4A726844.7040505@gmail.com>
 <1249024006.2560.735.camel@ymzhang>
 <20090731080728.GA25049@rhlx01.hs-esslingen.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And in addition to this, we should also take into account (read: skip)
> any idle states which kill busmaster DMA completely
> (in case of busmaster DMA I/O activities, that is).

It isn't so simple.
This is system specific.

In the old days, a c3-type C-state would lock down the bus
in order to assure no DMA could pass by to memory
before the processor could wake up to snoop.

Then a few years ago the hardware would allow us to
enter C3-type C-states, but transparently "pop-up"
into C2 to retire the snoop activity without ever
waking the processor to C0.  This was good b/c
it was more efficient than waking to C0, but bad
b/c the OS could not easily tell if it actually
got the C3 time it requested, or if it was actually
spending a bunch of time demoted to C2...

In the most recent hardware, the core's cache is flushed
in deep C-states so that the core need not be woken
at all to snoop DMA activity.

Indeed, Yanmin's Nehalem box advertises two C3-type C-states,
but in reality, Nehalem doesn't have _any_ C3-type C-states,
only C2-type.  The BIOS advertises C3-type C-states
to not break the installed base, which uses the presence
of C3-type C-states to work around the broken LAPIC timer.

I think the issue at hand on the system at hand is waking
up the processor in response to an IO interrupt break events.
ie. Linux doees a good job with timer interrupts, but
isn't so smart about using IO interrupts for demoting
C-states.  Arjan is looking at fixing this.

cheers,
Len Brown, Intel Opoen Source TEchnology Center

