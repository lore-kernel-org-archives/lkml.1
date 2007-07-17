Return-Path: <linux-kernel-owner+w=401wt.eu-S935081AbXGQWa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935081AbXGQWa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 18:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757942AbXGQWaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 18:30:18 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:35380 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136AbXGQWaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 18:30:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=MGuIwGSGh/JR5spSM9UT6U1DHiXhLZ7zzE7vn0UzT1idQrxsbp1UAe1RdqrtMFoyN96PgGZRlAvZ92LrAdYMHyqygHu1/PxkRBNie/eFZM13Kvd3/4Ux2sj+OfwoiA62iyFWwKnJyDfoIDVvuEHboH9vpqF9RuDkw06HuD1RI64=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: regression: disk error loop (panic?) ide_do_rw_disk-bad:
Date: Wed, 18 Jul 2007 00:45:03 +0200
User-Agent: KMail/1.9.6
Cc: Giacomo Catenazzi <cate@cateee.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, akpm@linux-foundation.org
References: <469D1D5E.8050609@cateee.net> <200707172320.12141.bzolnier@gmail.com> <alpine.LFD.0.999.0707171417560.27353@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707171417560.27353@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707180045.03352.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2007, Linus Torvalds wrote:
> 
> On Tue, 17 Jul 2007, Bartlomiej Zolnierkiewicz wrote:
> > 
> > ide-disk driver and type 2 (REQ_TYPE_BLOCK_PC) requests don't mix well
> > 
> > Probably some dumb application is sending packet commands without
> > checking the device type...

My original mail contained link to mail explaining the source of the issue
and also commit number introducing the problem...  Both have been stripped
from the reply thus valuable context is lost.

> Ok, we should definitely try to just translate the things, and instead of 
> having user apps that have to know about the (generally not very 
> interesting) differences between IDE and SCSI command set, and when the 
> IDE driver gets a SCSI request (whether from the new generic SG layer or 

The new generic SG layer is CONFIG_SCSI=y "generic" in the current tree.

James has a patch to fix it but IDE subsystem (and probably not only it)
still requires addition of struct class devices to be able to use bsg.

> obviously the older SCSI-ioctl layer) it should "just work".

Agreed but IDE driver has never claimed to have full SAT layer and
full SCSI-ioctl layer support has been provided only for ide-cd.

Full SAT could be done though, possibly by reusing libata-scsi.c.

> So I object to that "dumb application" statement. It's the kernel that has 
> traditionally been dumb in not smoothing over the differences between 
> devices well enough.
> 
> We shouldn't _need_ to have applications care. They should be able to just 
> use regular SCSI commands, and if the device cannot handle a 10-byte read 
> command, the kernel should have translated that into a 6-byte one (for 
> example) rather than the application having to know about idiotic small 
> differences like that.
> 
> That said, I dunno how to fix this particular one, and the IDE driver is 

For now it should be sufficient to revert ide.c chunks of

commit 3d6392cfbd7dc11f23058e3493683afab4ac13a3
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Mon Jul 9 12:38:05 2007 +0200

    bsg: support for full generic block layer SG v3

    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

which are completely unrelated to bsg and which never got posted for review.

> singularly unhelpful in actually talking about *what* the command tried to 
> be.

Agreed, debugging info needs some love, being worked on.

Thanks,
Bart
