Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbYEONQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbYEONQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 09:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbYEONQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 09:16:05 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:2054 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919AbYEONQE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 09:16:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 15 May 2008 13:16:00.0975 (UTC) FILETIME=[D1FD6DF0:01C8B68D]
Content-class: urn:content-classes:message
Subject: Re: How to avoid data copies in a driver ?
Date: Thu, 15 May 2008 09:16:00 -0400
Message-ID: <Pine.LNX.4.61.0805150857220.13699@chaos.analogic.com>
In-Reply-To: <38b2ab8a0805150040s6933de14p7c2014945ba0810d@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: How to avoid data copies in a driver ?
thread-index: Aci2jdIEWaGuhY9SRdKDC74umdpw/g==
References: <38b2ab8a0805141254i2437a0ccq130b914748f53db0@mail.gmail.com> <Pine.LNX.4.61.0805141716120.11052@chaos.analogic.com> <38b2ab8a0805150040s6933de14p7c2014945ba0810d@mail.gmail.com>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Francis Moreau" <francis.moro@gmail.com>
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
X-TM-AS-Product-Ver: SMEX-8.0.0.1259-5.500.1026-15910.007
X-TM-AS-Result: No--18.608700-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 15 May 2008, Francis Moreau wrote:

> Hello,
>
> On Wed, May 14, 2008 at 11:23 PM, linux-os (Dick Johnson)
> <linux-os@analogic.com> wrote:
>> You memory-map the data. Impliment mmap() in your driver.
>> You can also impliment poll()  { select() } so your
>> application knows when new data are available.
>>
>> You cannot use a user-mode file-descriptor in the kernel.
>>
>
> Why not ?
>
> I'm suprised because what I need doens't seem so uncommon, usually
> devices send or
> receive data to/from files. So a helper (system call ?) to achieve
> that other than the basic
> read/write seems needed, no ?
>
> -- 
> Francis
>

The kernel is designed to perform services on behalf of
a caller. The kernel itself doesn't have a process context.
Therefore, a file-descriptor, which requires a process context
to mean anything, is not useful within the kernel unless the
kernel either uses your process context (which happens
efficiently when YOU call the kernel) or it steals one
from somebody else, which means their context gets trashed.
Note that every process is created with at file descriptors
0, 1, and 2. It's only the process context that keeps them
separate.

That said, you can create a kernel-mode task in your driver.
That task would have a context. However it wouldn't be YOUR
context, so you would need to signal it when data was
available, adding overhead and communicate with it from.
your user-space program context. It would share the same
data-space as your driver so it wouldn't need to copy.
However, such data would get copied into kernel buffers
by the I/O code so it's a waste anyway. You save one
copy, which you would do with memory-mapping, plus you
have the added communications overhead.

Using memory mapping as previously advised, lets you DMA
data directly to a user if your hardware does DMA. It also
would allow you to save one copy, even if you don't have
DMA capabilities. As far as copies are concerned, there are
many copies before your data actually gets to a disk platter.
Those copies (usually) occur when the kernel doesn't have
anything else to do.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
