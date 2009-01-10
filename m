Return-Path: <linux-kernel-owner+w=401wt.eu-S1752332AbZAJP3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbZAJP3j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 10:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbZAJP3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 10:29:14 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40124 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752531AbZAJP3M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 10:29:12 -0500
Date: Sat, 10 Jan 2009 15:28:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [bisected] Re: todays git: WARNING: at
 drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x45e/0x750()
Message-ID: <20090110152800.44308491@lxorguk.ukuu.org.uk>
In-Reply-To: <4968BA6F.8050207@ru.mvista.com>
References: <200901091334.55823.borntraeger@de.ibm.com>
	<200901101009.13699.borntraeger@de.ibm.com>
	<20090110104114.633cacd8@lxorguk.ukuu.org.uk>
	<200901101242.05203.borntraeger@de.ibm.com>
	<49688B63.5030105@ru.mvista.com>
	<20090110122130.318cf168@lxorguk.ukuu.org.uk>
	<20090110130745.GA14049@elte.hu>
	<49689EA8.20506@garzik.org>
	<20090110132412.GB14049@elte.hu>
	<20090110133617.GA22304@elte.hu>
	<20090110135731.0da08c90@lxorguk.ukuu.org.uk>
	<4968BA6F.8050207@ru.mvista.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>     All the S/G counts printed out were divisible by 4 (36 for INQUIRY and 96 
> for REQUSET SENSE). It's the *actual* byte count for the REQUEST SENSE that's 
> no divisible. The SCSI/ATAPI devices are free to sent less data than requested 
> on non block transfer commands.

That is just fine - if the sg list is not corrupt or being mishandled and
the atapi pio code is not buggy.

RTFS a bit and it becomes obvious that the core libata code has a bug:


>From libata-sff.c:

        /* consumed can be larger than count only for the last transfer */
        WARN_ON_ONCE(qc->cursg && count != consumed);

The big clue turns out to be that the code doesn't match the comment.

Next note the check on qc->cursg. If my input sg list is a 36 byte single
sg entry then qc->cursg should be NULL by the WARN_ON() - but it isn't.

If qc->cursg is NULL when the sg_next() is run then we don't warn because
we are quite happy with the last segment being padded or underrunning.
What we actually want to explode on is a case where we transfer more
bytes than are wanted and where there are more sg entries to perform - at
that point we would corrupt.


So at least one failure case is

	Core code issues an SG list for 96 bytes
	Drive indicates it wishes to return 18 bytes

	data_xfer transfers 18 bytes + 2 padding (correctly) -> 20 bytes

	
At this point __atapi_pio_bytes breaks

	it updates qc->curbytes by 18
	it updates the offset by 18

	The last segment is not exhausted so it does not update qc->cursg

	qc->cursg is not updated and the WARN erroneously uses !=

The bogus WARN_ON_ONCE() triggers.

So the bug is the WARN_ON being wrong. In fact __atapi_pio_bytes doesn't
know enough to do the WARN check correctly as it doesn't know if it is
the last request being made. It just happens it didn't break before
because all our transfers are word aligned.

We can remove the WARN for the moment, but someone should probably fix
the sanity check logic.

Alan
