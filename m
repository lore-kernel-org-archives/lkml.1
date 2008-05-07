Return-Path: <linux-kernel-owner+w=401wt.eu-S933800AbYEGWev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933800AbYEGWev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbYEGWei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:34:38 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:4090 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbYEGWec convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:34:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 07 May 2008 22:34:30.0620 (UTC) FILETIME=[83FD79C0:01C8B092]
Content-class: urn:content-classes:message
Subject: Re: Deleting large files
Date: Wed, 7 May 2008 18:34:29 -0400
Message-ID: <Pine.LNX.4.61.0805071820010.25395@chaos.analogic.com>
In-Reply-To: <118833cc0805071249w36145eb6g7ed5c18d9fdf6fce@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Deleting large files
thread-index: AciwkoQETeIx10lTQEu9nuSoY6uQeg==
References: <118833cc0805071249w36145eb6g7ed5c18d9fdf6fce@mail.gmail.com>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Morten Welinder" <mwelinder@gmail.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
X-TM-AS-Product-Ver: SMEX-8.0.0.1259-5.500.1026-15896.002
X-TM-AS-Result: No--16.370000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 7 May 2008, Morten Welinder wrote:

> Hi there,
>
> deleting large files, say on the order of 4.6GB, takes approximately forever.
> Why is that?  Well, it is because a lot of things need to take place to free
> the formerly used space, but my real question is "why does the unlink caller
> have to wait for it?"
>
> I.e., could unlink do the directory changes and then hand off the rest of the
> task to a kernel thread?
>
> Morten
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Suppose you had an N GB file that just filled up the disk. You now
delete it, but get control back before it is really deleted. You
now start to write a new file that will eventually just fill up
the disk. Your task will get a media full error long before
the media is really full because the old file's data space
hasn't been freed yet. So, to "fix" this, you modify the file-
system to defer your logical writes until all the previous
spaces has been freed (writes to the physical media are deferred
anyway as long as there is RAM available). The result is that
your new data, that may be precious from a quasi-real-time source,
will fail to be written. To "fix" this, you queue everything.
This will eventually fail because the disk and RAM are of
a finite size. The size of the disk is known, but you don't
know what will be deleted before the queued writes have
completed, so you really don't know when to tell the writer
that there is no more space available.

That's why the task that deletes data can't get control back
until is has been deleted. However, for user applications, at
the user's risk, one can do `rm filename &` and let the shell
do the waiting.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
