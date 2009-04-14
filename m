Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbZDNQ5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbZDNQ5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbZDNQ4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:56:47 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:43426 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbZDNQ4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:56:46 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Moore, Robert" <robert.moore@intel.com>
Subject: Re: [BISECTED] EEE PC hangs when booting off battery
Date: Tue, 14 Apr 2009 10:56:13 -0600
User-Agent: KMail/1.9.10
Cc: Arjan van de Ven <arjan@infradead.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
References: <49E065CF.6040408@tuffmail.co.uk> <200904140948.37633.bjorn.helgaas@hp.com> <4911F71203A09E4D9981D27F9D8308581D3722EB@orsmsx503.amr.corp.intel.com>
In-Reply-To: <4911F71203A09E4D9981D27F9D8308581D3722EB@orsmsx503.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904141056.14159.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 April 2009 09:55:58 am Moore, Robert wrote:
> In fact, ACPI methods can execute concurrently -- constrained by the ACPI specification itself. The "big lock" is released before anything that will block for a significant amount of time, allowing other methods to run.

We had a discussion about this a couple years ago:
  http://www.mail-archive.com/linux-acpi%40vger.kernel.org/msg06976.html

Here's my understanding (please correct me if I'm wrong):

- The ACPI CA holds a mutex while executing an AML method (see
  acpi_ex_enter_interpreter()).

- When an AML method blocks, the ACPI CA releases the mutex, which
  allows another AML method to run while the first is blocked.

- Because of the mutex, at most one AML method can be executing at
  any given time.  Others may have started, but they are blocked
  until the current method completes or blocks itself.

- The undocumented "acpi_serialize" option makes the ACPI CA hold
  the mutex for the entire duration of a method, even while a method
  is blocked.

Based on that, my guess about the battery init being slow because of
a long-running AML method might be incorrect, although I suppose
it's still possible to write AML busy-loops that never block.

I'd really like to understand what's making it slow.  The only
thing that looks at all unusual in acpi_battery_add() is
acpi_battery_update(), and that evaluates _STA and _BIF and
not much else.

Arjan, do you have any more information?  Is the battery driver
slow on all laptops?  If not, where did you see the problem?  Do
you have a DSDT for them?

Bjorn

> >-----Original Message-----
> >From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
> >owner@vger.kernel.org] On Behalf Of Bjorn Helgaas
> >Sent: Tuesday, April 14, 2009 8:49 AM
> >To: Arjan van de Ven
> >Cc: Alan Jenkins; linux-acpi@vger.kernel.org; linux-kernel; Kernel Testers
> >List; Pallipadi, Venkatesh
> >Subject: Re: [BISECTED] EEE PC hangs when booting off battery
> >
> >On Tuesday 14 April 2009 09:17:28 am Arjan van de Ven wrote:
> >> On Tue, 14 Apr 2009 08:59:01 -0600
> >> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> >>
> >> > I can't help with the real problem of why the asynchronous battery
> >> > init causes the hang.
> >>
> >> that got fixed already for the module case.
> >
> >But apparently still broken for the builtin case?  I think Alan is
> >running pretty new bits -- he said "latest git" on April 11.
> >
> >> > But I do object to the magic makefile ordering change in that commit.
> >> > Nobody reading the makefile can tell why battery is down at the end,
> >> > and moving it apparently slows down boot significantly.
> >>
> >> for all cases I've seen it actually speeds it up, because the battery
> >> now runs concurrently with the disk probe.
> >
> >I understand; I just meant that if somebody moves it back where it
> >was, we'll mysteriously lose the speedup you got.  Maybe a comment
> >in the makefile would be a short-term solution.
> >
> >> > So the
> >> > ordering change just feels like a band-aid that covers up a place
> >> > where ACPI could be improved.
> >>
> >> the reason for the move is that both the battery and other pieces take
> >> the big acpi lock; which defeats the parallelism. So the battery needs
> >> to happen at the end instead.
> >
> >Yep.  But I don't think it's anything about the Linux battery driver
> >itself that makes it slow.  I think it's more likely that some of the
> >ACPI methods it executes happen to be slow.  And that could afflict
> >*any* driver, depending on the whim of a BIOS writer.
> >
> >My guess is that if we could run ACPI methods concurrently and avoid
> >that big lock, the ordering wouldn't matter.  I know we probably can't
> >do that any time soon, but I think it's good to make the problem
> >visible at least with a "we need this magic order because ACPI doesn't
> >support concurrent method execution" sort of comment.
> >
> >Bjorn
