Return-Path: <linux-kernel-owner+w=401wt.eu-S376271AbXECRiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376271AbXECRiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 13:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S376269AbXECRip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 13:38:45 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S376261AbXECRim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 13:38:42 -0400
Date: Thu, 3 May 2007 10:36:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2 1/1] Misc: add sensable phantom driver
Message-Id: <20070503103607.e59773ae.akpm@linux-foundation.org>
In-Reply-To: <4639D821.9010308@gmail.com>
References: <219403193181341921@karneval.cz>
	<20070502234956.cdfe31c2.akpm@linux-foundation.org>
	<4639D821.9010308@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 May 2007 14:40:01 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:

> >> +static int phantom_release(struct inode *inode, struct file *file)
> >> +{
> >> +	struct phantom_device *dev = file->private_data;
> >> +
> >> +	if (mutex_lock_interruptible(&dev->open_lock))
> >> +		return -ERESTARTSYS;
> >> +
> >> +	dev->opened = 0;
> >> +	phantom_status(dev, dev->status & ~PHB_RUNNING);
> >> +
> >> +	mutex_unlock(&dev->open_lock);
> >> +
> >> +	return 0;
> >> +}
> > 
> > The mutex_lock_interruptible() is wrong, I think.  This function is called
> > when we do the final close().  If the signal _is_ taken then it's game
> > over: the device can no longer be opened.
> 
> Yes, starving at sys_close, I think so.
> 
> <fast searching in drivers/*>
> 
> Wouldn't this be a problem here too:
> drivers/media/dvb/cinergyT2/cinergyT2.c
> drivers/usb/misc/auerswald.c
> at least that the device won't be stopped or something like that?

Yes, those drivers appear to have the same problem.  I'll fix 'em.

> >> +/*
> >> + * Init and deinit driver
> >> + */
> >> +
> >> +static unsigned int __devinit phantom_get_free(void)
> >> +{
> >> +	unsigned int i;
> >> +
> >> +	for (i = 0; i < PHANTOM_MAX_MINORS; i++)
> >> +		if (phantom_devices[i] == 0)
> >> +			break;
> >> +
> >> +	return i;
> >> +}
> > 
> > This function assumes that the phantom_devices[] array will never have any
> > holes in it.  But if phantom_remove() is called out-of-order, it _will_
> > have holes.  Perhaps - I didn't look too hard.
> 
> I'm afraid I didn't get this. It goes through all phantom_devices and
> returns first free index. If a hole is present it will return "i" which
> corresponds to the hole, because phantom_devices[i] is 0. Note that it is
> unsigned char array.
> 

I guess I must have misread the code.
