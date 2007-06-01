Return-Path: <linux-kernel-owner+w=401wt.eu-S1764009AbXFAUPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764009AbXFAUPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763593AbXFAUOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:14:54 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:22611 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763512AbXFAUOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:14:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=oE7UQx8smKBDwxOoTc4Ozf9zR/cStNGRBupLGn8G9ewYbSVzwIzSthFSHIcg87OQiRJ1D4WtIXtsZ+dho904UfCDV9imI6nYU5EpvXScLbiOEM8A/E9BXYRE8QlThdkcE+ZmsVgxQXdotATtVXJxm1MWiOmgaqazEpY3SwjdAjM=
Message-ID: <4ac8254d0706011314g5468f02m3cf5a5281bd30018@mail.gmail.com>
Date: Fri, 1 Jun 2007 22:14:51 +0200
From: "Tuncer Ayaz" <tuncer.ayaz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.22 libata spindown
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm still seeing the libata warning that disks were not spun down
properly on the following two setups and am wondering whether I need
a new shutdown binary or the changeset mentioned below is not meant
to fix what I'm triggering by halt'ing.

If it's not a bug I will try to update my shutdown utility and if
that does not work I promise not to bother lkml about a problem
caused by my userland. If it is a bug I hope it will be of interest
for 2.6.22 bug tracking.

Setup 1:
SATA 1 Disks
AMD64 3200+
nVidia nForce 3 250 (Ultra?)
Debian i386 Unstable

Setup 2:
SATA 2 disks
Core 2 Duo E6600
Intel 975X
Debian x86_64 Unstable

Just to be clear what warning I'm talking about:
DISK MIGHT NOT BE SPUN DOWN PROPERLY. UPDATE SHUTDOWN UTILITY
For more info, visit http://linux-ata.org/shutdown.html

The following is from the reply I got from Michal Piotrowski while
I was trying to find out what happened to the regression report:

MICHAL>>
I guess you meant this

Subject    : libata crash on halt
References : http://marc.info/?l=linux-ide&m=117899827710565&w=2
Submitter  : Andrew Morton <akpm@linux-foundation.org>
Caused-By  : Tejun Heo <htejun@gmail.com>
            commit 920a4b1038e442700a1cfac77ea7e20bd615a2c3
Status     : problem is being debugged

This bug was fixed by

commit da071b42f73dabbd0daf7ea4c3ff157d53b00648
Author: Tejun Heo <htejun@gmail.com>
Date:   Mon May 14 17:26:18 2007 +0200

   libata: fix shutdown warning message printing

   Unlocking ap->lock and ssleeping don't work because SCSI commands can
   be issued from completion path without context.  Reimplement delayed
   completion by allowing translation functions to override
   qc->scsidone(), storing the original completion function to
   scmd->scsi_done() and overriding qc->scsidone() with a function which
   schedules delayed invocation of scmd->scsi_done().

   This isn't pretty at all but all the ugly parts are thankfully
   contained in the stop translation path where the compat feature is
   implemented.

   Signed-off-by: Tejun Heo <htejun@gmail.com>
   Signed-off-by: Jeff Garzik <jeff@garzik.org>



> [  715.196000] ata3.00: DISK MIGHT NOT BE SPUN DOWN PROPERLY. UPDATE
> SHUTDOWN UTILITY
> [  715.196000] ata3.00: For more info, visit http://linux-ata.org/
> shutdown.html
                  ^^^^
If you think about this, please send a bug report. IMHO it's ABI breakage.
<<MICHAL
