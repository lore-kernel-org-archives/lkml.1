Return-Path: <linux-kernel-owner+w=401wt.eu-S1750878AbXBUXkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750878AbXBUXkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750926AbXBUXky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:40:54 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:39611 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbXBUXkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:40:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DYBXsVT51rcSlMeET3uUD/KnL1xk0CKgYqBTRop0lbwCn24vVHdHnI0SSAAZm3Rh5uZcdXDucD+GjNrUY5LsC/WR/Dsy8Dc8BKS//YAqiY/dhSDAhB6rnoZPWkEI180/zsbBxRv+6ffQIpo7tNzkzFw9Byru9lfulDhJ2vkGBsk=
Subject: Re: [Linux-fbdev-devel] [PATCH 2.6.20 1/1] fbdev, mm: hecuba/E-Ink
	fbdev driver
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: Paul Mundt <lethal@linux-sh.org>, Jaya Kumar <jayakumar.lkml@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Geert.Uytterhoeven@sonycom.com,
       jsimmons@infradead.org
In-Reply-To: <45a44e480702192013s7d49d05ai31e576f0448a485e@mail.gmail.com>
References: <20070217104215.GB25512@localhost>
	 <1171715652.5186.7.camel@lappy>
	 <45a44e480702170525n9a15fafpb370cb93f1c1fcba@mail.gmail.com>
	 <20070217135922.GA15373@linux-sh.org>
	 <45a44e480702180331t7e76c396j1a9861f689d4186b@mail.gmail.com>
	 <20070218235741.GA22298@linux-sh.org>
	 <45a44e480702192013s7d49d05ai31e576f0448a485e@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 07:43:33 +0800
Message-Id: <1172101413.4217.18.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-19 at 23:13 -0500, Jaya Kumar wrote: 
> On 2/18/07, Paul Mundt <lethal@linux-sh.org> wrote:
> > Given that, this would have to be something that's dealt with at the
> > subsystem level rather than in individual drivers, hence the desire to
> > see something like this more generically visible.
> >
> 
> Hi Peter, Paul, fbdev folk,
> 
> Ok. Here's what I'm thinking for abstracting this:
> 
> fbdev drivers would setup fb_mmap with their own_mmap as usual. In
> own_mmap, they would do what they normally do and setup a vm_ops. They
> are free to have their own nopage handler but would set the
> page_mkwrite handler to be fbdev_deferred_io_mkwrite().
> fbdev_deferred_io_mkwrite would build up the list of touched pages and
> pass it to a delayed workqueue which would then mkclean on each page

Yes, this functionality is sorely needed by more than a few driver
writers.

> and then pass a copy of that page list down to a driver's callback
> function. The fbdev driver's callback function can then do the actual
> IO to the framebuffer or coalesce DMA based on the provided page list.
> I would like to add something like the following to struct fb_info:
> 
> #ifdef CONFIG_FB_DEFERRED_IO
> struct fb_deferred_io *defio;
> #endif
> 
> to store the mutex (to protect the page list), the touched page list,
> and the driver's callback function.
> 
> I hope this sounds sufficiently generic to meet everyone's (the two of
> us? :) needs.

There's definitely more than two :-).  For the past several years,
various people have been asking for this functionality.  So yes,
implementing this in a generic manner will be a big help.

Tony

