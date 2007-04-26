Return-Path: <linux-kernel-owner+w=401wt.eu-S933751AbXDZJT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751AbXDZJT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933766AbXDZJT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:19:59 -0400
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:33510 "EHLO
	mailhub.fokus.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933751AbXDZJT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:19:58 -0400
Date: Thu, 26 Apr 2007 11:19:32 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: stern@rowland.harvard.edu, dougg@torque.net
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       James.Bottomley@steeleye.com
Subject: Re: [PATCH] Block layer: separate out queue-oriented ioctls
Message-ID: <46306ea4.nlqf3c05IYBhob1c%Joerg.Schilling@fokus.fraunhofer.de>
References: <Pine.LNX.4.44L0.0702191148421.13197-100000@netrider.rowland.org>
 <45DA23C7.6090800@torque.net>
In-Reply-To: <45DA23C7.6090800@torque.net>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Any chance to that this bug will be fixed anytime soon?

The Bug has been reported February 2004 but is still not fixed in sg.c
Is Linux development really sooooo slow?


Douglas Gilbert <dougg@torque.net> wrote:

> Alan,
> The SG_GET_RESERVED_SIZE ioctl is also defined in
> the block layer, see block/scsi_ioctl.c .
> I suspect it is just a kludge to fool cdrecord that it
> is talking to a sg device. [One of many kludges in the
> block SG_IO ioctl implementation to that end.]
> So perhaps the block layer versions of SG_SET_RESERVED_SIZE
> and SG_GET_RESERVED_SIZE need to be similarly capped.
> Actually I think that I would default SG_GET_RESERVED_SIZE to
> request_queue->max_sectors * 512 in the block layer
> implementation (as there is no "reserve buffer" associated
> with a block device).
>
>
> <aside>
> The idea of a reserved buffer may live on in bsg as experience
> with sg has shown that it is the fastest way to do (mmap-ed) IO.
> Having one reserved buffer per file descriptor means not
> having to create and tear down a scatter gather list
> per IO. [Having a pool of such lists would be even better.]
> Until optical storage needs 10 times its current datarates
> then cdrecord will not need this mechanism.
> </aside>
>
> Doug Gilbert
>
>
> > Index: usb-2.6/drivers/scsi/sg.c
> > ===================================================================
> > --- usb-2.6.orig/drivers/scsi/sg.c
> > +++ usb-2.6/drivers/scsi/sg.c
> > @@ -917,6 +917,8 @@ sg_ioctl(struct inode *inode, struct fil
> >  			return result;
> >                  if (val < 0)
> >                          return -EINVAL;
> > +		if (val > sdp->device->request_queue->max_sectors * 512)
> > +			return -EOVERFLOW;
> >  		if (val != sfp->reserve.bufflen) {
> >  			if (sg_res_in_use(sfp) || sfp->mmap_called)
> >  				return -EBUSY;
> > @@ -925,7 +927,8 @@ sg_ioctl(struct inode *inode, struct fil
> >  		}
> >  		return 0;
> >  	case SG_GET_RESERVED_SIZE:
> > -		val = (int) sfp->reserve.bufflen;
> > +		val = min_t(int, sfp->reserve.bufflen,
> > +				sdp->device->request_queue->max_sectors * 512);
> >  		return put_user(val, ip);
> >  	case SG_SET_COMMAND_Q:
> >  		result = get_user(val, ip);
> > 

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
