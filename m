Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbZDNPt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbZDNPt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbZDNPtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:49:17 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:20496 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbZDNPtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:49:15 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [BISECTED] EEE PC hangs when booting off battery
Date: Tue, 14 Apr 2009 09:48:36 -0600
User-Agent: KMail/1.9.10
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>, linux-acpi@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
References: <49E065CF.6040408@tuffmail.co.uk> <200904140859.02188.bjorn.helgaas@hp.com> <20090414081728.10de978a@infradead.org>
In-Reply-To: <20090414081728.10de978a@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904140948.37633.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 April 2009 09:17:28 am Arjan van de Ven wrote:
> On Tue, 14 Apr 2009 08:59:01 -0600
> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
> > I can't help with the real problem of why the asynchronous battery
> > init causes the hang.
> 
> that got fixed already for the module case.

But apparently still broken for the builtin case?  I think Alan is
running pretty new bits -- he said "latest git" on April 11.

> > But I do object to the magic makefile ordering change in that commit.
> > Nobody reading the makefile can tell why battery is down at the end,
> > and moving it apparently slows down boot significantly. 
> 
> for all cases I've seen it actually speeds it up, because the battery
> now runs concurrently with the disk probe.

I understand; I just meant that if somebody moves it back where it
was, we'll mysteriously lose the speedup you got.  Maybe a comment
in the makefile would be a short-term solution.

> > So the
> > ordering change just feels like a band-aid that covers up a place
> > where ACPI could be improved.
> 
> the reason for the move is that both the battery and other pieces take
> the big acpi lock; which defeats the parallelism. So the battery needs
> to happen at the end instead.

Yep.  But I don't think it's anything about the Linux battery driver
itself that makes it slow.  I think it's more likely that some of the
ACPI methods it executes happen to be slow.  And that could afflict
*any* driver, depending on the whim of a BIOS writer.

My guess is that if we could run ACPI methods concurrently and avoid
that big lock, the ordering wouldn't matter.  I know we probably can't
do that any time soon, but I think it's good to make the problem
visible at least with a "we need this magic order because ACPI doesn't
support concurrent method execution" sort of comment.

Bjorn
