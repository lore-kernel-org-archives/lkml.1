Return-Path: <linux-kernel-owner+w=401wt.eu-S965769AbXCSHJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965769AbXCSHJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 03:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965751AbXCSHJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 03:09:34 -0400
Received: from smtp-101-monday.noc.nerim.net ([62.4.17.101]:3130 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965764AbXCSHJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 03:09:32 -0400
Date: Mon, 19 Mar 2007 08:08:49 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Richard Voigt" <richardvoigt@gmail.com>
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Rudolf Marek" <r.marek@assembler.cz>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-Id: <20070319080849.17ecf173.khali@linux-fr.org>
In-Reply-To: <2e59e6970703181236l3f92f105je522f2966ffb0a39@mail.gmail.com>
References: <45D6DDCE.5050803@assembler.cz>
	<20070228213803.GA4877@ucw.cz>
	<20070301152655.f232db64.khali@linux-fr.org>
	<20070302114023.GD2163@elf.ucw.cz>
	<20070302114747.GB1212@srcf.ucam.org>
	<20070302151055.d2665d66.khali@linux-fr.org>
	<20070302141840.GA3441@srcf.ucam.org>
	<20070302220454.a0c66d04.khali@linux-fr.org>
	<20070302211251.GA10035@srcf.ucam.org>
	<20070303105316.d51e032d.khali@linux-fr.org>
	<2e59e6970703181236l3f92f105je522f2966ffb0a39@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Sun, 18 Mar 2007 14:36:08 -0500, Richard Voigt wrote:
> On 3/3/07, Jean Delvare wrote:
> > On Fri, 2 Mar 2007 21:12:51 +0000, Matthew Garrett wrote:
> > > Assuming arbitration of access, what's the problem with having two
> > > drivers accessing the same hardware? Do these chips generally have any
> > > significant internal state other than trip points and the like?
> >
> > The "assuming arbitration of access" is the key part of your
> > sentence ;) The problem is that currently no arbitration is done. If it
> > was done, then state would probably not be a problem. Most hardware
> > monitoring drivers don't assume any state is preserved between
> > accesses, and those which do can easily be changed not to. The ACPI
> > side is another story though, I guess we can't assume anything about
> > the AML code's assumption on states, as it differs from one machine to
> > the next. But we can try to be cooperative and restore the sensible
> > registers (e.g. bank selector) in the same state we found them.
> 
> I recall that one of the stated drawbacks of a lock was that no ACPI
> code could execute while the hwmon driver was doing its fairly lengthy
> conversation with the hardware.
> 
> It seems that using transactional concepts here would solve that
> problem.  For example, the hwmon driver issues a start transaction
> request.  The first write request to any given location (bank register
> for example) causes the previous memory value to be saved.  Then,
> instead of locking AML out, AML is allowed to execute, but any access
> to the memory/port ranges reserved by the driver (when the transaction
> is set up) cause the hwmon transaction to be rolled back so the AML
> sees the expected state.  Then AML proceeds as usual.  When hwmon
> tries additional operations, they fail with some "transaction
> interrupted" error message, indicating to the hwmon driver to start
> over.
>
> The only issue with this that I can see, is that if AML isn't
> executed atomically wrt hwmon, then knowing when it is safe for hwmon
> to retry is going to be difficult.

No. We're not rolling back anything, it's totally unrealistic. These
are device drivers we're talking about here, not a database. The I/O
accesses done by the hardware monitoring drivers are not that long, so
AML gets to wait for them to be finished, and that's it. There is no
valid reason to give the priority to AML over regular device drivers.
Rudolf Marek's approach sounds much better.

> This probably requires changes to every hwmon driver, but they can be
> updated piecemeal, starting with the ones most commonly found in
> notebooks, where ACPI is most important.

Most notebooks don't expose their hardware monitoring chip at all.
Those which do use SMBus devices in majority, where I/O forwarding is
going to be difficult, as it needs to be done at the SMBus controller
level, not the hardware monitoring device level. I want to get my hands
on such a laptop first though, as I need to see what exacly ACPI is
doing before I can think of a solution.

-- 
Jean Delvare
