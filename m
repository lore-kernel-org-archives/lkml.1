Return-Path: <linux-kernel-owner+w=401wt.eu-S1751297AbXCCJzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbXCCJzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 04:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXCCJzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 04:55:45 -0500
Received: from smtp-106-saturday.noc.nerim.net ([62.4.17.106]:2005 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751297AbXCCJzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 04:55:44 -0500
Date: Sat, 3 Mar 2007 10:53:16 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Pavel Machek <pavel@ucw.cz>, Chuck Ebbert <cebbert@redhat.com>,
       Rudolf Marek <r.marek@assembler.cz>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-Id: <20070303105316.d51e032d.khali@linux-fr.org>
In-Reply-To: <20070302211251.GA10035@srcf.ucam.org>
References: <45D6DDCE.5050803@assembler.cz>
	<45D7461A.2040808@redhat.com>
	<20070218183805.5a4fd813.khali@linux-fr.org>
	<20070228213803.GA4877@ucw.cz>
	<20070301152655.f232db64.khali@linux-fr.org>
	<20070302114023.GD2163@elf.ucw.cz>
	<20070302114747.GB1212@srcf.ucam.org>
	<20070302151055.d2665d66.khali@linux-fr.org>
	<20070302141840.GA3441@srcf.ucam.org>
	<20070302220454.a0c66d04.khali@linux-fr.org>
	<20070302211251.GA10035@srcf.ucam.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

On Fri, 2 Mar 2007 21:12:51 +0000, Matthew Garrett wrote:
> On Fri, Mar 02, 2007 at 10:04:54PM +0100, Jean Delvare wrote:
> > It might be more elegant but it won't work. We don't want to prevent
> > ACPI from accessing these I/O ports. If we need to choose only one
> > "driver" accessing the I/O port, it must be acpi, at leat for now,
> > despite the fact that acpi provides very weak hardware monitoring
> > capabilities compared to the specific drivers.
> 
> Assuming arbitration of access, what's the problem with having two 
> drivers accessing the same hardware? Do these chips generally have any 
> significant internal state other than trip points and the like?

The "assuming arbitration of access" is the key part of your
sentence ;) The problem is that currently no arbitration is done. If it
was done, then state would probably not be a problem. Most hardware
monitoring drivers don't assume any state is preserved between
accesses, and those which do can easily be changed not to. The ACPI
side is another story though, I guess we can't assume anything about
the AML code's assumption on states, as it differs from one machine to
the next. But we can try to be cooperative and restore the sensible
registers (e.g. bank selector) in the same state we found them.

Anyway, just because we can't get things right on 100% of the machines
is no reason not to try anything at all. The current situation is bad,
any improvement would be welcome.

> > Why would we end up with an overestimation if we check the I/O ports at
> > boot time? Do you have concrete cases in mind?
> 
> ACPI will often describe large operation regions, but won't necessarily 
> touch all of them. Effectively, every codepath would have to be walked 
> through at boot time and checked for io access.

Is there anything preventing us from doing such a walk and pre-allocate
all the I/O ranges? I am not familiar with the ACPI code at all, would
you possibly propose a patch doing that?

If we can't do that, the overestimation approach might still work. I
wonder if it would cause problems in practice. If it does, we're back
to Pavel's AML lock.

-- 
Jean Delvare
