Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711AbXJ3EYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbXJ3EYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 00:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbXJ3EYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 00:24:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbXJ3EYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 00:24:41 -0400
Date: Mon, 29 Oct 2007 21:24:33 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: vitalivanov@gmail.com
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb-devel@lists.sourceforge.net,
       greg@kroah.com, linux-kernel@vger.kernel.org, netwiz@crc.id.au,
       zaitcev@redhat.com
Subject: Re: USB: FIx locks and urb->status in adutux
Message-Id: <20071029212433.c9837c4b.zaitcev@redhat.com>
In-Reply-To: <1193681097.20985.31.camel@dell1.softservecom.com>
References: <20071022203447.db6d7950.zaitcev@redhat.com>
	<200710231138.38266.oliver@neukum.org>
	<20071023185302.5ce9d187.zaitcev@redhat.com>
	<1193234987.13750.21.camel@dell1.softservecom.com>
	<20071024202555.4f1cd215.zaitcev@redhat.com>
	<1193681097.20985.31.camel@dell1.softservecom.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007 20:04:57 +0200, Vitaliy Ivanov <vitalivanov@gmail.com> wrote:

> Finally had a time on my weekend to perform tests and fix Pete's patch a little. Now it seems to be correct.

Great!

> 1. One device per user space application. Old driver allowed many users application to work with same device which can lead to IO mess.

OK. This trick was popular in UNIX. Personally I think it's in a bad
taste, because good applications still need to verify if only one
instance is running, and threfore can use application level locking.
But if you are gunning for the maintenership I'm not going to argue
your style. The busy lock-out certainly works better than "/dev/cua" :-)

However, this looks wrong:

> +			 dev->interrupt_in_endpoint->bInterval);
> +	dev->read_urb_finished = 0;
> +	retval = usb_submit_urb(dev->interrupt_in_urb, GFP_KERNEL);
> +	/* we ignore failure */
> +	/* end of fixup for first read */
> +
> +	/* initialize out direction */
> +	dev->out_urb_finished = 1;

The finished flag is only set when URB is not in use anymore. Did you
observe an anomaly with my code? Any hangs? If so, I assure you this
is not the fix. As it's written, even if we ignore the failure (e.g.
do not pass it to userland), we sill have to maintain the correct
flag state.

-- Pete
