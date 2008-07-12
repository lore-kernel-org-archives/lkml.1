Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbYGLRJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbYGLRJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 13:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbYGLRJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 13:09:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:47489 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbYGLRJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 13:09:47 -0400
Subject: Re: [PATCH] advansys: use request_firmware
From: Jaswinder Singh <jaswinder@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>, linux-scsi@vger.kernel.org,
       hch@infradead.org
In-Reply-To: <20080712162921.GZ14894@parisc-linux.org>
References: <1215770322.2733.12.camel@jaswinder.satnam>
	 <20080712162921.GZ14894@parisc-linux.org>
Content-Type: text/plain; charset=utf8
Date: Sat, 12 Jul 2008 22:39:08 +0530
Message-Id: <1215882548.19076.57.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mattew,

On Sat, 2008-07-12 at 10:29 -0600, Matthew Wilcox wrote:
> > +	if (AscLoadMicroCode(iop_base, 0, &fw->data[4],
> > +			     fw->size - 4) != chksum) {
> >  		asc_dvc->err_code |= ASC_IERR_MCODE_CHKSUM;
> >  		return warn_code;
> >  	}
> > +	release_firmware(fw);
> 

Sorry, It should be :-
+       if (AscLoadMicroCode(iop_base, 0, &fw->data[4],
+                            fw->size - 4) != chksum) {
                asc_dvc->err_code |= ASC_IERR_MCODE_CHKSUM;
+               release_firmware(fw);
                return warn_code;
        }
+       release_firmware(fw);
        warn_code |= AscInitMicroCodeVar(asc_dvc);

You can get updated patch from
http://git.infradead.org/users/jaswinder/firm-jsr-2.6.git 

This is first draft, final patch will available at David's firmware tree
http://git.infradead.org/users/dwmw2/firmware-2.6.git

> You're calling release_firmware() here.  I don't know if that actually
> frees the firmware when it's built-in, but if it does, then freeing the
> firmware could cause the chip to stop working if it gets reset before
> userspace is up.

Normally release_firmware will be called after loading microcode.

Even it gets reset then It will again call request_firmware and load
firmware and then frees after loading microcode.

Logically it will work same as microcode_buffer say _adv_asc3550_buf[]
when you need to load microcode you just read from ﻿_adv_asc3550_buf[]
and load it. And if reset occurs you again read from ﻿_adv_asc3550_buf[]
and then load microcode, but you keep ﻿_adv_asc3550_buf[] all the time
in memory.
In our case we just request_firmware when need to load microcode and
release_firmware after loading. So we frees the memory after loading
microcode.

So it will not stop the chip from working.

> If it is OK to call release_firmware here, then the error path is
> missing a release_firmware() call.
> 

Fixed. Thanks.

If you still have some doubts, please let me know.

Thank you,

Jaswinder Singh.

