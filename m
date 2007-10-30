Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbXJ3NNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbXJ3NNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 09:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbXJ3NNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 09:13:11 -0400
Received: from mail.softservecom.com ([195.160.232.17]:58112 "EHLO
	mail.softservecom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbXJ3NNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 09:13:09 -0400
Subject: Re: USB: FIx locks and urb->status in adutux
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Reply-To: vitalivanov@gmail.com
To: Pete Zaitcev <zaitcev@redhat.com>, vitalivanov@gmail.com
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb-devel@lists.sourceforge.net,
       greg@kroah.com, linux-kernel@vger.kernel.org, netwiz@crc.id.au
In-Reply-To: <20071029212433.c9837c4b.zaitcev@redhat.com>
References: <20071022203447.db6d7950.zaitcev@redhat.com>
	 <200710231138.38266.oliver@neukum.org>
	 <20071023185302.5ce9d187.zaitcev@redhat.com>
	 <1193234987.13750.21.camel@dell1.softservecom.com>
	 <20071024202555.4f1cd215.zaitcev@redhat.com>
	 <1193681097.20985.31.camel@dell1.softservecom.com>
	 <20071029212433.c9837c4b.zaitcev@redhat.com>
Content-Type: text/plain
Message-Id: <1193749794.27085.15.camel@dell1.softservecom.com>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.4.5 (1.4.5-1) 
Date: Tue, 30 Oct 2007 15:09:54 +0200
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Oct 2007 13:09:54.0880 (UTC) FILETIME=[29FD4400:01C81AF6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-30 at 06:24, Pete Zaitcev wrote:

> However, this looks wrong:
> 
> > +			 dev->interrupt_in_endpoint->bInterval);
> > +	dev->read_urb_finished = 0;
> > +	retval = usb_submit_urb(dev->interrupt_in_urb, GFP_KERNEL);
> > +	/* we ignore failure */
> > +	/* end of fixup for first read */
> > +
> > +	/* initialize out direction */
> > +	dev->out_urb_finished = 1;
> 
> The finished flag is only set when URB is not in use anymore. Did you
> observe an anomaly with my code? Any hangs? If so, I assure you this
> is not the fix. As it's written, even if we ignore the failure (e.g.
> do not pass it to userland), we sill have to maintain the correct
> flag state.

As about read_urb_finished probably it's OK. But we shouldn't decrease open_count in the case of error as then we return normal exit value.
Here is what we had before:

				 dev->interrupt_in_endpoint->bInterval);
		dev->read_urb_finished = 0;
		retval = usb_submit_urb(dev->interrupt_in_urb, GFP_KERNEL);
		if (retval) {
			dev->read_urb_finished = 1;
			--dev->open_count;
		}

So I can left it but w/o this line:
--dev->open_count;

What is more critical is that I added:

	/* initialize out direction */
	dev->out_urb_finished = 1;

Without this we'll always have write timeouts.

		Vitaliy

