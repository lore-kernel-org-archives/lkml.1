Return-Path: <linux-kernel-owner+w=401wt.eu-S1759577AbZJGQpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577AbZJGQpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 12:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759344AbZJGQpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 12:45:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58029 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758826AbZJGQpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 12:45:34 -0400
Date: Wed, 7 Oct 2009 17:46:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, Alan Cox <alan@linux.intel.com>,
       <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 4/5] usb_serial: Kill port mutex
Message-ID: <20091007174611.439a7a5a@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.0910071157390.2762-100000@iolanthe.rowland.org>
References: <200910070702.32266.oliver@neukum.org>
	<Pine.LNX.4.44L0.0910071157390.2762-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009 12:03:08 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Wed, 7 Oct 2009, Oliver Neukum wrote:
> 
> > We will need some generic way to autoresume from open.
> > Resume will need to lock against open() and need to be called
> > from within open(). Any ideas for an unugly interface?
> 
> It's not quite that bad.  Resume doesn't need to lock against open. 
> If open is called while resume is running then when it tries to do its
> own resume, it will either block (waiting for the pm_mutex) or return
> immediately (if it sees the device is already resumed).

It would probably be cleaner if they could lock against each other

> A more interesting question is how to synchronize both open/close and
> suspend/resume against throttle/unthrottle.

throttle and unthrottle can sleep and obviously have to as they do a fair
bit of work sometimes (xon/xoff, mode line waggling etc)

The current ordering here is quite ugly because we open the ldisc before
the tty which means the ldisc sometimes calls unthrottle before the tty
is opened which is not nice. On the close side we have the same thing via
tty_ldisc_release.

We can take the port->mutex lock in the throttle/unthrottle methods as
far as I can see - there are no obvious problem cases. We do call
->throttle and ->unthrottle from the ldisc open but this occurs outside
of any call to the tty driver open/close method so I don't see any
deadlock.

It adds an ordering of termios lock before port mutex when taking both
but that's not a problem and really implicit in the structure of the code
anyway.

Alan


