Return-Path: <linux-kernel-owner+w=401wt.eu-S1758553AbYH0QYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553AbYH0QYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbYH0QX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:23:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33062 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094AbYH0QX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:23:58 -0400
Date: Wed, 27 Aug 2008 09:08:54 -0700
From: Greg KH <greg@kroah.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb@vger.kernel.org, Stefan Kopp <stefan_kopp@agilent.com>,
       Marcel Janssen <korgull@home.nl>, Felipe Balbi <me@felipebalbi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: add USB test and measurement class driver
Message-ID: <20080827160854.GC19710@kroah.com>
References: <20080827000501.GA29570@kroah.com> <200808271013.07561.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200808271013.07561.oliver@neukum.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 10:13:06AM +0200, Oliver Neukum wrote:
> Am Mittwoch 27 August 2008 02:05:01 schrieb Greg KH:
> > +static ssize_t usbtmc_read(struct file *filp, char __user *buf,
> > +                          size_t count, loff_t *f_pos)
> > +{
> > +       struct usbtmc_device_data *data;
> > +       struct device *dev;
> > +       unsigned long int n_characters;
> > +       u8 *buffer;
> > +       int actual;
> > +       int done;
> > +       int remaining;
> > +       int retval;
> > +       int this_part;
> > +
> > +       /* Get pointer to private data structure */
> > +       data = filp->private_data;
> > +       dev = &data->intf->dev;
> > +       buffer = data->buffer;
> > +
> > +       remaining = count;
> > +       done = 0;
> > +
> > +       while (remaining > 0) {
> > +               if (remaining > USBTMC_SIZE_IOBUFFER - 12 - 3)
> > +                       this_part = USBTMC_SIZE_IOBUFFER - 12 - 3;
> > +               else
> > +                       this_part = remaining;
> > +
> > +               /* Setup IO buffer for DEV_DEP_MSG_IN message
> > +                * Refer to class specs for details
> > +                */
> > +               buffer[0] = 2;
> > +               buffer[1] = data->bTag;
> > +               buffer[2] = ~(data->bTag);
> > +               buffer[3] = 0; /* Reserved */
> > +               buffer[4] = (this_part - 12 - 3) & 255;
> > +               buffer[5] = ((this_part - 12 - 3) >> 8) & 255;
> > +               buffer[6] = ((this_part - 12 - 3) >> 16) & 255;
> > +               buffer[7] = ((this_part - 12 - 3) >> 24) & 255;
> > +               buffer[8] = data->TermCharEnabled * 2;
> > +               /* Use term character? */
> > +               buffer[9] = data->TermChar;
> > +               buffer[10] = 0; /* Reserved */
> > +               buffer[11] = 0; /* Reserved */
> 
> This function will go bad if concurrent readers enter, yet it has no locking.

Now fixed with an i/o mutex.

thanks,

greg k-h
