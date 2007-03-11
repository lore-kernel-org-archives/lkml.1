Return-Path: <linux-kernel-owner+w=401wt.eu-S932794AbXCKDP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbXCKDP4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 22:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932778AbXCKDP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 22:15:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:34313 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932770AbXCKDPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 22:15:55 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: libata-acpi: allow _GTF on SATA, but disable on PATA for now
Date: Sat, 10 Mar 2007 22:14:14 -0500
User-Agent: KMail/1.9.5
Cc: kristen.c.accardi@intel.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan <alan@lxorguk.ukuu.org.uk>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200703100559.l2A5x6kP017578@hera.kernel.org> <45F296B9.7000005@garzik.org>
In-Reply-To: <45F296B9.7000005@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703102214.14881.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 March 2007 06:30, Jeff Garzik wrote:
> Linux Kernel Mailing List wrote:
> > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=df33c77e3981e71afc8727ee5c432ba1a1bba68c
> > Commit:     df33c77e3981e71afc8727ee5c432ba1a1bba68c
> > Parent:     908e0a8a265fe8057604a9a30aec3f0be7bb5ebb
> > Author:     Kristen Accardi <kristen.c.accardi@intel.com>
> > AuthorDate: Fri Mar 9 18:15:33 2007 -0500
> > Committer:  Len Brown <len.brown@intel.com>
> > CommitDate: Fri Mar 9 18:15:33 2007 -0500
> > 
> >     libata-acpi: allow _GTF on SATA, but disable on PATA for now
> >     
> >     The ACPI specification states, and BIOS implementations depend on,
> >     _STM being called before _GTF.
> >     
> >     SATA does this, but PATA does not.  So for now, simply
> >     prevent execution of _GTF on PATA devices.  Longer term we
> >     should implement ACPI support for PATA devices in libata.
> >     
> >     Signed-off-by: Kristen Accardi <kristen.c.accardi@intel.com>
> >     Signed-off-by: Len Brown <len.brown@intel.com>
> > ---
> >  drivers/ata/libata-acpi.c |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> > index d14a48e..89aaf74 100644
> > --- a/drivers/ata/libata-acpi.c
> > +++ b/drivers/ata/libata-acpi.c
> > @@ -561,6 +561,13 @@ int ata_acpi_exec_tfs(struct ata_port *ap)
> >  
> >  	if (noacpi)
> >  		return 0;
> > +	/*
> > +	 * TBD - implement PATA support.  For now,
> > +	 * we should not run GTF on PATA devices since some
> > +	 * PATA require execution of GTM/STM before GTF.
> > +	 */
> > +	if (!(ap->cbl == ATA_CBL_SATA))
> > +		return 0;
> >  
> >  	for (ix = 0; ix < ATA_MAX_DEVICES; ix++) {
> >  		if (!ata_dev_enabled(&ap->device[ix]))
> 
> Grumble!
> 
> This /really/ should have gone through me and linux-ide first.

Back at you Jeff,
This feature /really/ should have never gone upstream in the first place,
as this failure was reported and isolated to git-libata-all.patch
back in 2.6.20-rc6-mm3:

http://bugzilla.kernel.org/show_bug.cgi?id=7907

It then went on to become the most widely reported "ACPI related"
regression in the 2.6.21-rc series -- for which ACPI gets smeared.
Thank you ATA...

> Alan has been actively working on PATA ACPI, and we have been debugging 
> ACPI issues as well.  PLEASE coordinate with the maintainer, when 
> touching code outside of drivers/acpi!

And PLEASE coordinate with the maintainer when invoking methods
that provoke errors in other sub-systems!

Re: "debugging ACPI issues as well"

What issues?
Why haven't I see any mention of them on linux-acpi?
Coordination and communication is a two-way street, Jeff.

> AFAICS this patch went in with zero appearance on LKML or another 
> related list, until submission.  This is /not/ how we do Linux development.

I proudly take credit+blame for shipping Kristen's patch with no delay.
It did appear on linux-acpi, as do all the patches I ship -- though
I admit it was the same day it went upstream.
I'm sorry I didn't CC linux-ide -- I'll get that part right next time.

However, I believe that late -rc3 is _well_ past the time to be developing
new code real-time in the upstream tree; and is instead time to
shut the damn thing off and set sights on the next release.

If you disagree with me, I'm not going to object
when you send a better fix to Linus for 2.6.21-rc4.

However, I do request that you first either start responding
to bugzilla traffic, or delete your account from bugzilla
so that people don't get the false impression that you're
paying attention.

thanks,
-Len
