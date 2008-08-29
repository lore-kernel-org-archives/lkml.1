Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbYH3Dui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbYH3Dui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 23:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbYH3Du3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 23:50:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37333 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbYH3Du2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 23:50:28 -0400
Date: Fri, 29 Aug 2008 13:01:33 -0700
From: Greg KH <greg@kroah.com>
To: Marcel Janssen <korgull@home.nl>
Cc: stefan_kopp@agilent.com, stern@rowland.harvard.edu, oliver@neukum.org,
       linux-usb@vger.kernel.org, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, Marcel Janssen <marcel.janssen@admesy.nl>
Subject: Re: [PATCH] USB: add USB test and measurement class driver - round
	2
Message-ID: <20080829200133.GA20682@kroah.com>
References: <20080827183615.GA15692@kroah.com> <7D8F552F9FFBAC438A816966BEC4516BFBA328@cos-us-mb07.cos.agilent.com> <20080829143902.GC18136@kroah.com> <200808291841.15853.korgull@home.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808291841.15853.korgull@home.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 06:41:15PM +0200, Marcel Janssen wrote:
> On Friday 29 August 2008 16:39:02 Greg KH wrote:
> > > The issue with using cat on the shell level is that it uses fread
> > > which has the (in this case) ugly behaviour of recalling the driver's
> > > read method until the full number of characters requested has been
> > > accumulated (or until zero characters are returned, indicating the end
> > > of file). With USBTMC instruments, this behavour is bad because the
> > > retry will not just return zero characters, it will cause a timeout
> > > with the associated error condition in the device. So, to enable the
> > > use of echo/cat, I added some fread handling to the driver (which
> > > catches the retries). I believe this also has been removed, so I
> > > assume cat/fread will not work (?).
> >
> > I do not know, but we do not do wierd things in the kernel just because
> > of broken userspace programs.  This logic should be done in userspace,
> > and programs should look at the return value of read() and handle it
> > properly.  Otherwise it is a bug.
> 
> I don't think this is broken in user space. The problem is that when you issue 
> a measurement command it is not known how many bytes it will return. This is 
> probably due to ASCII output being very common in  T&M devices instead of raw 
> data (int, float etc). The ASCII formatting is done in the device and this 
> returns just a string which may or may not be terminated by the term char. 
> This is of course not true for all T&M devices, but the majority works this 
> way. 
> 
> I admit that the above produces a lot of overhead, but it's just a fact that 
> T&M devices work this way, including ours for most of their data processing 
> (not all though). 

How is this overhead in userspace, just do something like the following:
	char big_buffer[16000];		/* bigger than any possible request */
	size = read(file_desc, &big_buffer[0], sizeof(big_buffer));

and size is the amount of data you actually read from the device, i.e.
one request.

> I think the USBTMC spec is quite clear on how it should be implemented on 
> messaging level. Basically when you issue  the command "*IDN?" the device 
> will process this and return the device ID string. The length of this string 
> is set in the TransferSize of the 12 byte header that the device returns. The 
> problem when you issue a read command is that the read command does not yet 
> know how much data to expect. It should issue the  REQUEST_DEV_DEP_MSG_IN 
> first and set the TransferSize value high enough.
> In the USBTMC_488 extension you find an example (chapter 3.3.1 page 7) that 
> shows the REQUEST_DEV_DEP_MSG_IN TransferSize being set to 64 although the 
> actual data being returned from the device is less (only 36 bytes).
> 
> What you do see in practice is that when someone would issue a read command 
> and asking for less bytes than are available is that the user program may 
> handle this as a warning telling the user that he did not request all 
> available data. 

Then that's a userspace bug, don't do that in your program that reads
from these types of devices :)

> Stefan's driver works exactly the way I would expect from a users point of 
> view. Whether the implementation can be improved is another issue, but the 
> behaviour is correct and compliant with other usbtmc drivers on other 
> platforms.

But it's not compliant with the "standard" way of using a file
descriptor in unix, and might break some POSIX requirements as well (I'm
not a good POSIX follower, so I don't know for sure...)

As this is trivial to handle in userspace, and requires no additional
wierd code in the kernel driver, I don't see this as something we should
change the driver for.

thanks,

greg k-h
