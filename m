Return-Path: <linux-kernel-owner+w=401wt.eu-S1753217AbYFBVN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbYFBVN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 17:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbYFBVNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 17:13:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54639 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbYFBVNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 17:13:49 -0400
Date: Mon, 2 Jun 2008 18:13:25 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, Brandon Philips <bphilips@suse.de>,
       linux-kernel@vger.kernel.org, Bastien Nocera <bnocera@redhat.com>
Subject: Re: v4l regression: V4L2_CID_[VH]CENTER disappeared without notice.
Message-ID: <20080602181325.3aacf56a@gaivota>
In-Reply-To: <1212436778.8810.27.camel@shinybook.infradead.org>
References: <200804241931.m3OJVQiR022368@hera.kernel.org>
	<1212421611.16924.246.camel@pmac.infradead.org>
	<20080602165649.01c2c680@core>
	<1212434648.8810.10.camel@shinybook.infradead.org>
	<20080602201911.1a48cc83@core>
	<1212436778.8810.27.camel@shinybook.infradead.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jun 2008 20:59:38 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Mon, 2008-06-02 at 20:19 +0100, Alan Cox wrote:
> > > Don't forget to document how people are _supposed_ to use the v4l api
> > > from userspace, though.
> > 
> > Correct but those methods are not part of the V4L2 API and have not been
> > for some considerable time. 
> 
> It seems that message hadn't got through. Any suggestions as to how we
> could make sure it does in future?
> 
> The usual answers are (in order of preference):
>  1) don't remove userspace APIs
>  2) don't remove userspace APIs
>  3) Documentation/feature-removal-schedule.txt
>  4) don't remove userspace APIs
> 
> It would be good if we could combine #3 with some form of
> __deprecated... can we make that work for ioctls in userspace?

David, 

V4L2_CID_[VH]CENTER are not ioctls.

They are just magic id's, to uniquely identify a parameter that needs to be
controlled by userspace. There are magic numbers for volume, hue, contrast, etc.

The V4L API has two ioctl's that lists what magic numbers exist at a given driver
and helps the userspace app to build an input entry for that parameter. 

On a very few cases, the userspace app might need to use the symbol aliases.
That's why those symbols are at videodev2.h. For example, the volume ID is
somewhat interesting for an userspace app to know, since it can associate the IR
volume UP/Down keys to control the board volume.

On most cases, userspace will just call VIDIOC_QUERYCTRL ioctl, passing an index,
starting on 0, until it receives an -EINVAL. If the ioctl returns 0, the
userspace will have the magic number, a string with the control name,
its minimum/maximum value, its type (integer/boolean), and its default value
and step, and will dynamically construct a table of controls.

In the case of V4L2_CID_[VH]CENTER those magic numbers were intended to control
X and Y positions, but were never used, in fact.

So, it was a complete surprise to me that an userspace API wants to do a
special treatment to an id that weren't used (since no kernel driver will
enumerate  V4L2_CID_[VH]CENTER).

So, I don't think that a __deprecated macro for ioctls should deal with those
stuff.

Cheers,
Mauro
