Return-Path: <linux-kernel-owner+w=401wt.eu-S1767388AbXCIQpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767388AbXCIQpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767391AbXCIQpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:45:35 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49757 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767388AbXCIQpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:45:33 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: "No handler for vector" patches don't work on some systems
References: <45F188ED.7030202@redhat.com>
Date: Fri, 09 Mar 2007 09:45:08 -0700
In-Reply-To: <45F188ED.7030202@redhat.com> (Chuck Ebbert's message of "Fri, 09
	Mar 2007 11:18:53 -0500")
Message-ID: <m1slce4b8r.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert <cebbert@redhat.com> writes:

> [sorry for the dup: this time to the right recipient]
>
> So far I've tried the simple "survive having no handler
> for a vector" patch and the preliminary 3-patch series
> that was in -mm for a while, and neither work on the
> Dell PowerEdge 29xx and 19xx systems. These servers
> have the Intel 5000X chipset with the 6700PXH PCI Hub
> with dual independent PCI-X busses, each with its own
> I/OxAPIC with 24 interrupts. The fixes do work on
> "simple" systems but not on these high-end ones.

Ok thanks for the report.  It sounds like there is another cause
for the problem in the Dell case.

The simple patch drops the interrupt handler but acknowledges the
hardware so if the driver can survive missing an interrupt we
should be ok.  With level triggered interrupts this should pretty
much be guaranteed as after the acknowledgement the unhandled
interrupt will be refired.

One of my internal test systems had a 6700PXH PCI hub (at least I
think that was the part) the E7520 chipset.  So I don't think it is
just a matter of the hardware.  Although I do recall Intel having an
errata out on that class of hardware for occasionally reordering
interrupt messages with the end of interrupt coming before the 
interrupt message itself.  Causing various things to get confused.
It would not surprise me if we were tickling some errata like that.

I would very much like to know if what I merged linus's tree helps.
It is a little more conservative, than my earlier patches.  I need
a way to reproduce this or to work closely with someone who is, because
this sounds like it has a different cause and I need to start with
that assumption.

Eric
