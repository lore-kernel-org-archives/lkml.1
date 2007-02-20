Return-Path: <linux-kernel-owner+w=401wt.eu-S965650AbXBTENI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965650AbXBTENI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 23:13:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965659AbXBTENI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 23:13:08 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:11244 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965650AbXBTENF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 23:13:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VS/ZkOXF2Bqur6mQoYY7NGzngfpx5nB5STZWBkMmtOGlqgbnHgCofUiu+0/+Rm/l0KgoZcGp6i5PMIxwSDDfe7/BB23HeyaKwCEr+b9BlhhK9edFJLEf6gJtIBC3v0mKi7xSK7NGmP6cTsmjRl+NyVuh8ECGRFnYQ0Xp/tT+HM4=
Message-ID: <45a44e480702192013s7d49d05ai31e576f0448a485e@mail.gmail.com>
Date: Mon, 19 Feb 2007 23:13:04 -0500
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>,
       "Jaya Kumar" <jayakumar.lkml@gmail.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2.6.20 1/1] fbdev,mm: hecuba/E-Ink fbdev driver
Cc: jsimmons@infradead.org, Geert.Uytterhoeven@sonycom.com
In-Reply-To: <20070218235741.GA22298@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070217104215.GB25512@localhost> <1171715652.5186.7.camel@lappy>
	 <45a44e480702170525n9a15fafpb370cb93f1c1fcba@mail.gmail.com>
	 <20070217135922.GA15373@linux-sh.org>
	 <45a44e480702180331t7e76c396j1a9861f689d4186b@mail.gmail.com>
	 <20070218235741.GA22298@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/18/07, Paul Mundt <lethal@linux-sh.org> wrote:
> Given that, this would have to be something that's dealt with at the
> subsystem level rather than in individual drivers, hence the desire to
> see something like this more generically visible.
>

Hi Peter, Paul, fbdev folk,

Ok. Here's what I'm thinking for abstracting this:

fbdev drivers would setup fb_mmap with their own_mmap as usual. In
own_mmap, they would do what they normally do and setup a vm_ops. They
are free to have their own nopage handler but would set the
page_mkwrite handler to be fbdev_deferred_io_mkwrite().
fbdev_deferred_io_mkwrite would build up the list of touched pages and
pass it to a delayed workqueue which would then mkclean on each page
and then pass a copy of that page list down to a driver's callback
function. The fbdev driver's callback function can then do the actual
IO to the framebuffer or coalesce DMA based on the provided page list.

I would like to add something like the following to struct fb_info:

#ifdef CONFIG_FB_DEFERRED_IO
struct fb_deferred_io *defio;
#endif

to store the mutex (to protect the page list), the touched page list,
and the driver's callback function.

I hope this sounds sufficiently generic to meet everyone's (the two of
us? :) needs.

Thanks,
jaya

ps: I've added James and Geert to the CC list. I would appreciate any
advice on whether this is a suitable approach.
