Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbYFUTW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbYFUTW6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 15:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYFUTWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 15:22:18 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:54980 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbYFUTWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 15:22:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ved2j1+9Y5YGib9XXNFeQFERGObxnuOS1QKeOGGi+sd4N0a9YrhQ+moUpVUc0vzPxk
         am03wsuw5fmsKndq6ByqwXygvE1xUCTr6ryb9cKqTPv3TsxHt9pyvj/OmTLT7eWj5Dft
         ssyiRbySU9GHFXIocEJq2+ce5o5mRI7Jb4f64=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 12/18] ide: use ->tf_load in actual_try_to_identify()
Date: Sat, 21 Jun 2008 21:10:30 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain> <20080620213445.13202.61145.sendpatchset@localhost.localdomain> <485C39D6.6020801@ru.mvista.com>
In-Reply-To: <485C39D6.6020801@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806212110.31086.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 June 2008, Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> > Convert actual_try_to_identify() to use ->tf_load instead of ->OUTB.
> >
> > There should be no functional changes caused by this patch.
> >
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >   
> [...]
> > Index: b/drivers/ide/ide-probe.c
> > ===================================================================
> > --- a/drivers/ide/ide-probe.c
> > +++ b/drivers/ide/ide-probe.c
> > @@ -290,9 +290,15 @@ static int actual_try_to_identify (ide_d
> >  	/* set features register for atapi
> >  	 * identify command to be sure of reply
> >  	 */
> > -	if ((cmd == WIN_PIDENTIFY))
> > -		/* disable dma & overlap */
> > -		hwif->OUTB(0, io_ports->feature_addr);
> > +	if (cmd == WIN_PIDENTIFY) {
> > +		ide_task_t task;
> > +
> > +		memset(&task, 0, sizeof(task));
> > +		/* disable DMA & overlap */
> > +		task.tf_flags = IDE_TFLAG_OUT_FEATURE;
> > +
> > +		drive->hwif->tf_load(drive, &task);
> > +	}
> >   
> 
>    Eww, this is bulky but should be a part of your plan to switch to 
> tf_load() method...

Yes on both matters:

- It is a part of The Grand Plan. ;)

- I also don't like the small increase of complexity but these changes
  make the core code completely independent of the hardware I/O registers
  (allowing any taskfile transport method).

PS Thanks for reviewing these patches.

Bart
