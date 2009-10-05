Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbZJEVqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbZJEVqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 17:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbZJEVqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 17:46:19 -0400
Received: from rtr.ca ([76.10.145.34]:34335 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168AbZJEVqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 17:46:18 -0400
Message-ID: <4ACA6904.1060509@rtr.ca>
Date: Mon, 05 Oct 2009 17:45:40 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bernie Innocenti <bernie@codewiz.org>
Cc: linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       sysadmin <sysadmin@gnu.org>
Subject: Re: sata_mv 0000:03:06.0: PCI ERROR; PCI IRQ cause=0x30000040
References: <1254546642.1438.135.camel@giskard>
In-Reply-To: <1254546642.1438.135.camel@giskard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernie Innocenti wrote:
> The error in the subject appears in the console immediately followed bv
> a hard freeze of the machine.  The error occurs reproducibly on two
> identical Opteron servers, each one equipped with two identical
> controller cards:
> 
> 03:04.0 SCSI storage controller: Marvell Technology Group Ltd. MV88SX6081 8-port SATA II PCI-X Controller (rev 09)
> 03:06.0 SCSI storage controller: Marvell Technology Group Ltd. MV88SX6081 8-port SATA II PCI-X Controller (rev 09)
> 
> We can trigger the problem within a few seconds by starting a
> reconstruction on a drive hooked to port 4 (counting from 0) of the
> second controller.  Oddly, every other drive works reliably and the
> faulty drive works if we connect it to, for example, port 4 of the first
> controller.
> 
> I'd like to stress that the problem occurs systematically, on two
> completely distinct machines.  We swapped drives, cables and controllers
> to exclude other possibilities.
> 
> Tested with Debian kernels 2.6.26-19 and 2.6.30-8.  Let me know if
> further details are needed.
..
> 0000:03:06.0: PCI ERROR; PCI IRQ cause=0x30000040..
..

  0x30000040 here means "MRdPerr":
    "bad data parity detected during PCI master read".

Which means there that a data parity error happened
during outgoing data transfer on the PCI-X bus.
This could happen due to noise on the bus,
dying capacitors, or (?) bad RAM (not sure about the last one).

The expected behaviour here is for sata_mv to then perform
perform a full SATA reset, after which the I/O will be reattempted.

But it appears to lock up before that happens.
The code does try and clear the PCI error interrupt,
but perhaps it needs clearing in more than the one register
where it currently does so.

Looking over the code and the documentation I have (NDA),
nothing obvious springs to view.  There are some extra registers
we could be dumping out, to show exactly what PCI phase and address
caused the error, but reading those won't cause or prevent a lockup.

Best bet would be to try replacing the RAM in that box,
and see if the problem goes away.

Cheers
