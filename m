Return-Path: <linux-kernel-owner+w=401wt.eu-S1764209AbYHEUiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764209AbYHEUiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760692AbYHEUiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:38:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:60787 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbYHEUip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:38:45 -0400
Date: Tue, 5 Aug 2008 13:38:32 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: "Greg KH" <greg@kroah.com>, "Eric Paris" <eparis@redhat.com>,
       <linux-kernel@vger.kernel.org>, <malware-list@lists.printk.net>,
       <linux-security-module@vger.kernel.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon
 access scanning
Message-ID: <20080805133832.220d71c7@infradead.org>
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4AD9@USILMS12.ca.com>
References: <20080805112747.2c3c4650@infradead.org>
	<2629CC4E1D22A64593B02C43E85553030480743E@USILMS12.ca.com>
	<20080805183845.GA11375@kroah.com>
	<2629CC4E1D22A64593B02C43E855530304AE4AD9@USILMS12.ca.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Aug 2008 16:15:32 -0400
"Press, Jonathan" <Jonathan.Press@ca.com> wrote:

> 
> > Also, it seems to me that for my purposes, close is discrete enough.
> It
> > tells me that there is now something out there that should be looked
> at.
> 
> So, if you hook glibc to catch all calls to close, is that sufficient?
> 
> [JON PRESS]  Let's see...I'm going to use inotify for some events,
> glibc for others, and this API for the rest.  Would you really want
> to write an application like that?

so you have to do 2 cases:

1) inotify to notice files changing
 (no need to hook glibc for that, and no need to hook close() since you
 already get a notify for the change)

This is to catch the *creation* of "bad" content (say a browser saving a
download or somesuch)

By nature this is asynchronous for both performance and "what could you
do if" reasons.
(but so would the close() scan be, and again please explain how you
deal with write-to-mmap-after-close)

2) A synchronous check on open() or exec()

This is to prevent *use* of "bad" content, either by an application
opening a bad file, or by executing a "bad" program. 

For neither do you need to hook the kernel; ld preload works great for
this. 

This does assume that at some point you have a transition from "ok"
program to the first time you run a "bad" one (via exec or open); and
that you catch it at that point.

I don't yet buy the argument "but what if the virus corrupted your ld
preload", because if it can do that your own virus scanner is also
corrupted.


Can you explain what gap is left after you do these two things?



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
