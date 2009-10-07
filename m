Return-Path: <linux-kernel-owner+w=401wt.eu-S1759728AbZJGRYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728AbZJGRYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759703AbZJGRYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:24:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42002 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759627AbZJGRYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:24:36 -0400
Date: Wed, 7 Oct 2009 13:23:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 4/5] usb_serial: Kill port mutex
In-Reply-To: <20091007174611.439a7a5a@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.0910071320120.3051-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009, Alan Cox wrote:

> On Wed, 7 Oct 2009 12:03:08 -0400 (EDT)
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > On Wed, 7 Oct 2009, Oliver Neukum wrote:
> > 
> > > We will need some generic way to autoresume from open.
> > > Resume will need to lock against open() and need to be called
> > > from within open(). Any ideas for an unugly interface?
> > 
> > It's not quite that bad.  Resume doesn't need to lock against open. 
> > If open is called while resume is running then when it tries to do its
> > own resume, it will either block (waiting for the pm_mutex) or return
> > immediately (if it sees the device is already resumed).
> 
> It would probably be cleaner if they could lock against each other

What you mean isn't clear.  After all, open sometimes has to call
resume.  So how could resume lock against open?

> > A more interesting question is how to synchronize both open/close and
> > suspend/resume against throttle/unthrottle.
> 
> throttle and unthrottle can sleep and obviously have to as they do a fair
> bit of work sometimes (xon/xoff, mode line waggling etc)
> 
> The current ordering here is quite ugly because we open the ldisc before
> the tty which means the ldisc sometimes calls unthrottle before the tty
> is opened which is not nice. On the close side we have the same thing via
> tty_ldisc_release.
> 
> We can take the port->mutex lock in the throttle/unthrottle methods as
> far as I can see - there are no obvious problem cases. We do call
> ->throttle and ->unthrottle from the ldisc open but this occurs outside
> of any call to the tty driver open/close method so I don't see any
> deadlock.
> 
> It adds an ordering of termios lock before port mutex when taking both
> but that's not a problem and really implicit in the structure of the code
> anyway.

Does this imply that unthrottle should try to autoresume?  There does 
appear to be a potential race between unthrottle and autosuspend.

Alan Stern

