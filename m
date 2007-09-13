Return-Path: <linux-kernel-owner+w=401wt.eu-S932335AbXIMTZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbXIMTZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 15:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932130AbXIMTZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 15:25:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108AbXIMTZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 15:25:20 -0400
Date: Thu, 13 Sep 2007 12:26:47 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Adrian Bunk <bunk@kernel.org>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oliver Neukum <oneukum@suse.de>, zaitcev@redhat.com
Subject: Re: [GIT PATCH] USB autosuspend fixes for 2.6.23-rc6
Message-Id: <20070913122647.525689c2.zaitcev@redhat.com>
In-Reply-To: <alpine.LFD.0.999.0709130912060.16478@woody.linux-foundation.org>
References: <Pine.LNX.4.44L0.0709131154240.7406-100000@iolanthe.rowland.org>
	<alpine.LFD.0.999.0709130912060.16478@woody.linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.11.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007 09:43:13 -0700 (PDT), Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So why not make the 64 sector limit be the default? Get rid of the quirk: 
> we already allow people to override it in /sys if they really want to, but 
> realistically, it's probably not going to make any difference what-so-ever 
> for *any* normal load. So we seem to have a quirk that really doesn't buy 
> us anything but headache.

Well, ub does that today. And there is a measurable performance differential
with usb-storage when driving rotating discs, or so I heard.

> Other quirks worth looking at (but likely unfixable) are:
>  - US_FL_IGNORE_RESIDUE:
> 	Does this really matter? Can we not just always do the 
> 	US_FL_IGNORE_RESIDUE thing? Windows must not be doing what we're 
> 	doing.

I'm afraid this is valuable. However, a number of devices only return
garbage as residue if the transfer length is greater than 32KB. Limiting
that would trim this blacklist, I think. The vast majority of devices
work correctly in this regard, and ub checks the residue without any
blacklist.

>  - US_FL_FIX_CAPACITY: 
> 	This is a generic SCSI issue, not a USB one, and maybe there are 
> 	better solutions to it. Are we perhaps doing something wrong? Is 
> 	there some patterns we haven't seen? Why do we need this, when 
> 	presumably Windows does not?

It has something to do with the way our partition detection works. Linux
tends to rely on the reported device size. Windows reads the first block
and then goes further based on its contents. If we exterminate partitioning
code which uses the reported device size for autodetection, then this
problem will fix itself.

>  - US_FL_SINGLE_LUN:
> 	At least a few of these seem to indicate that the real problem 
> 	could be detected dynamically ("device reports Sub=ff") rather 
> 	than with a quirk. Quirks are unmaintainable (and change), but 
> 	noticing when devices return impossible values and going into a 
> 	"safe mode" is just defensive programming.

This is being worked upon. The recent change for floppies eliminated
a big number of those.

-- Pete
