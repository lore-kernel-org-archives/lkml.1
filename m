Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbYJPWaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbYJPWaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbYJPW3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:29:53 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:7244 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbYJPW3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:29:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nkYFbrhvnypcVFTWVsuLT4zruSx3O91PZl5HTcnooIGG5c7gkz/yAnJ2f7ZBmJGZKf
         4tQYOf2TU+gD26Q4KGx1vioZ7lV7joVRldgGe0dnOYCODW/Dep7Pjr2S4PKBxjVEM6oD
         4ToAH6DHwJEO82t/klCh3k44ltdMI/pCuE4jY=
Date: Fri, 17 Oct 2008 02:32:51 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 2/2] cciss: fix regression in procfs display fw
	version, obsoletes previous patch 2 of 2
Message-ID: <20081016223251.GA10270@x200.localdomain>
References: <20081016215016.GB25704@roadking.ldev.net> <20081016145642.2ba2adba.akpm@linux-foundation.org> <0F5B06BAB751E047AB5C87D1F77A77884C019B4CBE@GVW0547EXC.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A77884C019B4CBE@GVW0547EXC.americas.hpqcorp.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 10:21:22PM +0000, Miller, Mike (OS Dev) wrote:
> 
> 
> > -----Original Message-----
> > From: Andrew Morton [mailto:akpm@linux-foundation.org]
> > Sent: Thursday, October 16, 2008 4:57 PM
> > To: Miller, Mike (OS Dev)
> > Cc: JensAxboejens.axboe@oracle.com;
> > linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org
> > Subject: Re: [PATCH 2/2] cciss: fix regression in procfs
> > display fw version, obsoletes previous patch 2 of 2
> >
> > On Thu, 16 Oct 2008 16:50:16 -0500
> > Mike Miller <mike.miller@hp.com> wrote:
> >
> > >
> > > Patch 2 of 2
> > >
> > > This patch obsoletes patch 2/2 from yesterday. It fixes a
> > regression
> > > in procfs where the controller firmware version is not
> > displayed. The
> > > previous patch also addressed the problem but the code
> > would be called
> > > whenever anything changed on the array such as the number
> > of logical volumes, etc.
> > > This patch only gets called once for each controller.
> > > Please consider this for inclusion.
> > >
> >
> > Again, this description doesn't contain enough information
> > for us to work out which kernels need patching.
> >
> > >
> > > diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c index
> > > 0f367b1..efa5414 100644
> > > --- a/drivers/block/cciss.c
> > > +++ b/drivers/block/cciss.c
> > > @@ -3404,7 +3404,8 @@ static int __devinit
> > cciss_init_one(struct pci_dev *pdev,
> > >       int i;
> > >       int j = 0;
> > >       int rc;
> > > -     int dac;
> > > +     int dac, return_code;
> > > +     InquiryData_struct *inq_buff = NULL;
> >
> > This initialisation is not needed.
> >
> > >       i = alloc_cciss_hba();
> > >       if (i < 0)
> > > @@ -3510,6 +3511,25 @@ static int __devinit
> > cciss_init_one(struct pci_dev *pdev,
> > >       /* Turn the interrupts on so we can service requests */
> > >       hba[i]->access.set_intr_mask(hba[i], CCISS_INTR_ON);
> > >
> > > +     /* Get the firmware version */
> > > +     inq_buff = kzalloc(sizeof(InquiryData_struct), GFP_KERNEL);
> > > +        if (inq_buff == NULL) {
> > > +                printk(KERN_ERR "cciss: out of memory\n");
> >
> > Whitespace is all screwed up.
> >
> > > +                return ENOMEM;
> >
> > Should be -ENOMEM.
> >
> > > +        }
> > > +
> > > +     return_code = sendcmd_withirq(CISS_INQUIRY, i, inq_buff,
> > > +             sizeof(InquiryData_struct), 0, 0 ,0, TYPE_CMD);
> > > +     if (return_code == IO_OK) {
> > > +             hba[i]->firm_ver[0] = inq_buff->data_byte[32];
> > > +             hba[i]->firm_ver[1] = inq_buff->data_byte[33];
> > > +             hba[i]->firm_ver[2] = inq_buff->data_byte[34];
> > > +             hba[i]->firm_ver[3] = inq_buff->data_byte[35];
> > > +     } else {         /* send command failed */
> > > +             printk(KERN_WARNING "cciss: unable to
> > determine firmware"
> > > +                     " version of controller\n");
> > > +     }
> > > +
> > >       cciss_procinit(i);
> > >
> > >       hba[i]->cciss_max_sectors = 2048;
> 
> Sorry, in too much of a hurry. I'll fix (again).

And inq_buff is leaked, if I'm not missing simething.
