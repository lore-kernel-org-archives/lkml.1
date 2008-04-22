Return-Path: <linux-kernel-owner+w=401wt.eu-S1756836AbYDVUK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbYDVUK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbYDVUKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:10:16 -0400
Received: from rv-out-0708.google.com ([209.85.198.242]:10315 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752603AbYDVUKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:10:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KPctYG1H7uHrSkEf4C3i9zbN+M1phPHj42fEPZID4d/5maHKYPcBsa2oQbRh1TPENoZPejSZ8f2HSrDWxeuUXMqJM9s9xMqkvfz+o4aBOvEYEhJZQz0evclqlJQhg/L4BH5uctBWtP+oEZwTTlni666rUniSJa2DYmVQIN5qVAQ=
Message-ID: <38b2ab8a0804221310h6fdb9346q280f75ca2b85ff18@mail.gmail.com>
Date: Tue, 22 Apr 2008 22:10:15 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Seewer Philippe" <philippe.seewer@bfh.ch>
Subject: Re: Disk geometry from /sys
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4807635E.9060101@bfh.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>
	 <480354C9.1050600@bfh.ch>
	 <38b2ab8a0804150040i14840a9fudc3b95ba80d52ac1@mail.gmail.com>
	 <4805AF93.90209@bfh.ch>
	 <38b2ab8a0804170709m58830adagcba46f059ed10809@mail.gmail.com>
	 <4807635E.9060101@bfh.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seewer,

Sorry for being late.

On Thu, Apr 17, 2008 at 4:49 PM, Seewer Philippe <philippe.seewer@bfh.ch> wrote:
>  Take the example above. A disk with 255 heads? Not impossible but
> improbable. Where's the value from?
>
>  -The physical disks behind the example is an older laptop IDE disk. 'hdparm
> -I' shows 16 heads and 63 sectors, which is already an approximated value
> anyway. See Dick Johnson's post about that.
>
>  -The module handling the drive is 'ata_piix', the newer Driver from the
> SATA/PATA tree, which presents all drives (*ATA) to the rest of the system
> through the scsi sublayer.
>
>  -The final "getter" geometry code in the scsi sublayer (scsicam_bios_param
> in scsicam.c):
>
>        /* if something went wrong, then apparently we have to return
>           a geometry with more than 1024 cylinders */
>        if (ret || ip[0] > 255 || ip[1] > 63) {
>                if ((capacity >> 11) > 65534) {
>                        ip[0] = 255;
>                        ip[1] = 63;
>                } else {
>                        ip[0] = 64;
>                        ip[1] = 32;
>                }
>
>                if (capacity > 65535*63*255)
>                        ip[2] = 65535;
>                else
>                        ip[2] = (unsigned long)capacity / (ip[0] * ip[1]);
>        }
>  Read this as ip[0] is heads, ip[1] is sectors and ip[2] is cylinders. Make
> sense of course, since C/H/S values don't really matter to scsi anyway. So

Just out of curiosity, what does scsi use for addressing IO operations ?

> the default return value for the disks we use today is 255/63 for heads and
> sectors. A fixed constant which most of the time makes sense and works for
> most bios and bootloaders, but is wrong in the sense that it doesn't
> represent the actual values printed on the disks back.
>
> >
> > >  versus the second one which tries to
> > > guess a disks geometry by looking at the current partition table. Which
> > > might be just as wrong since its only necessary for bios and/or
> bootloader.
> > >
> >
> > But what happens if you want to guess the geometry of a disk with no
> > partition table ? You need to trust the kernel guess but from what I
> understood
> > it's just wrong.
> >
>  Assuming H/S as 255/63 and calculating C from the disks capaticy is quite
> safe. Except for a few weird use cases like using old OS's and os-installers
> that still trust the BIOS.
>  Depending on the type of disks you work with 'hdparm -I' works well too.
> Otherwise there's always CONFIG_EDD ('BIOS Enhanced Disk Drive calls
> determine boot disk') which exports BIOS geometry values to sysfs for the
> current default boot disk.
>
>  Hope this helps

Thanks a lot for your time.
-- 
Francis
