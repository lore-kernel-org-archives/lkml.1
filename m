Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbYEZTZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbYEZTZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 15:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbYEZTYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 15:24:00 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:33106 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649AbYEZTXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 15:23:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=kSc/0k6QSehdVJ7euLiwG3DFxNvk2SjE5+WjUo9RNQ7jwapfd4mOmhoyeK/cNEu1Kj0O+Kvi8Q0OItMuPe/3APAMm7MwlqB8QQzCEOhzqDWuromxDFKMlyeGZextRT/+bXsYZV3R78n5tqoP9/cT2FRn2pHMmx6IRMgggWXVwcA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Riccardo Gori <goric@trivenet.it>
Subject: Re: [Bug #10749] the system doesn't shutdown
Date: Tue, 27 May 2008 20:58:52 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik> <200805260019.09846.bzolnier@gmail.com> <200805251740.07631.goric@trivenet.it>
In-Reply-To: <200805251740.07631.goric@trivenet.it>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805272058.52125.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 May 2008, Riccardo Gori wrote:
> On Monday 26 May 2008 00:19:09 Bartlomiej Zolnierkiewicz wrote:
> > Hi,
> >
> > On Saturday 24 May 2008, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > >
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.25.  Please verify if it still should be listed.
> > >
> > >
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10749
> > > Subject		: the system doesn't shutdown
> > > Submitter	: Riccardo <goric@trivenet.it>
> > > Date		: 2008-05-19 09:00 (6 days old)
> >
> > Riccardo, thanks for bisecting the problem.  Could you also attach dmesgs
> > for "good" and "bad" kernels at bugzilla entry (so we can see if there are
> > any clues for solving the regression in messages printed by the driver)?
> >
> > Also does the following patch help (we should always setup PCI device
> > with pci_enable_device() before using it, my patch changed it)?
> >
> > ---
> >  drivers/ide/pci/sis5513.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > Index: b/drivers/ide/pci/sis5513.c
> > ===================================================================
> > --- a/drivers/ide/pci/sis5513.c
> > +++ b/drivers/ide/pci/sis5513.c
> > @@ -569,6 +569,11 @@ static int __devinit sis5513_init_one(st
> >  {
> >  	struct ide_port_info d = sis5513_chipset;
> >  	u8 udma_rates[] = { 0x00, 0x00, 0x07, 0x1f, 0x3f, 0x3f, 0x7f, 0x7f };
> > +	int rc;
> > +
> > +	rc = pci_enable_device(dev);
> > +	if (rc)
> > +		return rc;
> >
> >  	if (sis_find_family(dev) == 0)
> >  		return -ENOTSUPP;
> 
> 
> Hello,
> I'm bisecting again the kernel because I think I made something wrong.
> 
> I don't think that is this the first bad commit because, after bisecting, I 
> tried to git reset hard to that commit 3 times and build the kernel, and once 
> the problem was not present. I'm really sorry.
> 
> This is the output of dmesg when the problem is present:
> 
> # dmesg
> r (psparse-0537): Method parse/execution failed [\ISMI] (Node f7c18630), 
> AE_NO_MEMORY
> ACPI Error (psparse-0537): Method parse/execution failed 
> [\_SB_.PCI0.PX40.MIDI._STA] (Node f7c1ef68), AE_NO_MEMORY
> ACPI Error (exregion-0164): Could not map memory at F7C218943FFFFF00, size 200 
> [20070126]
> ACPI Exception (evregion-0420): AE_NO_MEMORY, Returned by Handler for 
> [SystemMemory] [20070126]
> ACPI Error (psparse-0537): Method parse/execution failed [\ISMI] (Node 
> f7c18630), AE_NO_MEMORY
> ACPI Error (psparse-0537): Method parse/execution failed 
> [\_SB_.PCI0.PX40.GAME._STA] (Node f7c1eedc), AE_NO_MEMORY

[...]

> Sorry again

No problem and thanks for quickly & honestly reporting it (instead
of silently going away leaving us scratching our heads for months)...

[ + wrong bisect resulted in a valid bugfix patch, cool! ]

Thanks,
Bart
