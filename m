Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786AbZFCVdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbZFCVdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 17:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbZFCVc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 17:32:56 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:6933 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbZFCVcz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 17:32:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rzekV0oD+3oCu6hXZhbPPhpaARGLh+SDNm+YnJ5wpYe20sRkORUwt44cxKBAi64vPm
         TY5fAs0YRXeHfyakSX/tBhGkEiHoFd7VDIDsF/OeVkg4w6hXP/hOj/VfUvgKWz15iGBt
         TYgQ/5uAHltWLFof1ZbscZY71DtfXYfO36Lco=
MIME-Version: 1.0
In-Reply-To: <4A0AFC62.3090002@pentek.com>
References: <4A0838D1.5090102@pentek.com> <20090511192253.GH4694@kernel.dk>
	 <4A0AFC62.3090002@pentek.com>
Date: Wed, 3 Jun 2009 23:32:56 +0200
Message-ID: <c384c5ea0906031432x2675c5a4xcc940a567ca408b8@mail.gmail.com>
Subject: Re: splice methods in character device driver
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Steve Rottinger <steve@pentek.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

On Wed, May 13, 2009 at 6:59 PM, Steve Rottinger <steve@pentek.com> wrote:
> is passing in the pages into splice_to_pipe.  The pages are associated
> with a PCI BAR, not main memory.  I'm wondering if this could be a problem?
>
Good question; my newbie answer would be the pages need to be mapped
in kernel space.

I have a similar use case but with memory being DMA'd to host main
memory (instead of the data sitting in your PCI device) in a character
device driver. The driver is a complete rewrite from scratch from
what's currently sitting-butt-ugly in staging/altpcichdma.c
so-please-don't-look-there.

I have already implemented zero-latency overlapping transfers in the
DMA engine (i.e. it never sits idle if async I/O is performed through
threads), now it would be really cool to add zero-copy.

What is it my driver is expected to do?

.splice_read:

- Allocate a bunch of single pages
- Create a scatter-gather list
- "stuff the data pages in question into a struct page *pages[]." a la
"fs/splice.c:vmsplice_to_pipe()"
- Start the DMA from the device to the pages (i.e. the transfer)
- Return.

.splice_write:

- Create a scatter-gather list

interrupt handler / DMA service routine:
- device book keeping
- wake_up_interruptible(transfer_queue)

.confirm():

"then you need to provide a suitable ->confirm() hook that can wait on
this IO to complete if needed."
- wait_on_event_interruptibe(transfer_queue)

.release():

- release the pages

.steal():

unsure

.map

unsure

Regards,
-- 
Leon
