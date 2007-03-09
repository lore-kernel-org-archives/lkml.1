Return-Path: <linux-kernel-owner+w=401wt.eu-S1423015AbXCIAwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423015AbXCIAwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 19:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423019AbXCIAwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 19:52:30 -0500
Received: from kepler.fjfi.cvut.cz ([147.32.6.11]:58315 "EHLO
	kepler.fjfi.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423015AbXCIAwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 19:52:30 -0500
Date: Fri, 9 Mar 2007 01:52:18 +0100 (CET)
From: Martin Drab <drab@kepler.fjfi.cvut.cz>
To: Robert Hancock <hancockr@shaw.ca>
cc: hugh@veritas.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Question about memory mapping mechanism
In-Reply-To: <45F0ABEB.3030201@shaw.ca>
Message-ID: <Pine.LNX.4.64.0703090138470.25365@kepler.fjfi.cvut.cz>
References: <fa.8Fy6n0Le4Y2mDfeEy936/5bbJHA@ifi.uio.no> <45F0ABEB.3030201@shaw.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2007, Robert Hancock wrote:

> Martin Drab wrote:
> > Hi,
> > 
> > I'm writing a driver for a sampling device that is constantly delivering a
> > relatively high amount of data (about 16 MB/s) and I need to deliver the
> > data to the user-space ASAP. To prevent data loss I create a queue of
> > buffers (consisting of few pages each) which are more or less directly
> > filled by the device and then mapped to the user-space via mmap().
> > 
> > The thing is that I'd like to prevent kernel to swap these pages out,
> > because then I may loose some data when they are not available in time for
> > the next round.
> 
> It would likely be easier to just mlock this buffer from the userspace
> application, rather than trying to achieve this in the driver..

Well yes, but it is the kernel that needs to have it guaranteed and 
especially on the buffers that aren't currently mmapped to user-space, but 
are free to be filled with data from the device. And generally we can not 
rely on an application to do the mlock(), I guess. If the application 
wouldn't do it and if it would happen that some of the buffers would be 
swapped out, we may end up with a page fault within an interrupt.

And besides, I guess the mlock() is effective only as long as the pages 
are really mapped into the user-space. Since when they are then unmapped 
by munmap(2) when the application have read the data, their VMA eventually 
seizes to exist and the mlock() protection would be gone anyway. Right?

We need a permanent protection. But perhaps artificially increasing the 
page's reference count via get_page() upon allocation, instead of setting 
the PG_reserved bit, would do. (If I got it right.)

Martin
