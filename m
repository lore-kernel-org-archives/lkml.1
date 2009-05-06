Return-Path: <linux-kernel-owner+w=401wt.eu-S1760229AbZEFPdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760229AbZEFPdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbZEFPdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:33:00 -0400
Received: from kroah.org ([198.145.64.141]:37479 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084AbZEFPdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:33:00 -0400
Date: Wed, 6 May 2009 08:25:21 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jason Wessel <jason.wessel@windriver.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] usb_debug: EXPERIMENTAL - poll hcd device to force
	writes
Message-ID: <20090506152521.GA4603@kroah.com>
References: <1241575205-12199-6-git-send-email-jason.wessel@windriver.com> <Pine.LNX.4.44L0.0905061058230.3227-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0905061058230.3227-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 11:18:07AM -0400, Alan Stern wrote:
> On Tue, 5 May 2009, Jason Wessel wrote:
> 
> > The problem that this patch tries to solve is that data is lost
> > because there are too many outstanding transmit urb's.
> > 
> > The question is what is the right way to force the controller to catch
> > up, and ideally let the kernel do some other things in the mean time?
> 
> What do standard serial port drivers do?

Not this :)

They use the proper flow control hooks that the tty layer provides.

> > This patch takes the route of forcibly polling the hcd device to drain
> > the urb queue and initiate the bulk write call backs.
> > 
> > NOTE this patch is not signed off, it is a question of what is the
> > right way to do this?
> 
> This patch is highly questionable.

I agree.

> Is the idea to force the HCD to search for completed URBs before the
> host controller has issued a completion interrupt?  Wouldn't it be
> better instead to use more URBs?
> 
> Besides, why should there be too many outstanding transmit URBs?  A
> normal serial debugging port running at 115200 baud can transmit no
> more than 12 bytes per ms.  You should be able to surpass that using
> only three URBs!  In fact, if you buffer up to 8 bytes per URB then
> with only two URBs you could send 64 bytes per ms, which is equivalent
> to 640000 baud.  Do you really need to go more than (say) ten times
> faster than that?

Yeah, something seems wrong here.

Jason, why is this really needed?  With your ring buffer, you shouldn't
need this at all anymore.

Or if you do, just bump up the number outstanding urbs that are
possible.  Or the urb buffer size.

This patch isn't acceptable as-is.

thanks,

greg k-h
