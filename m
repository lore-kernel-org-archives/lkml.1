Return-Path: <linux-kernel-owner+w=401wt.eu-S934341AbZJGSYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934341AbZJGSYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 14:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758373AbZJGSYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 14:24:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56254 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757348AbZJGSYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 14:24:31 -0400
Date: Wed, 7 Oct 2009 19:25:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 4/5] usb_serial: Kill port mutex
Message-ID: <20091007192507.2784266a@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.0910071320120.3051-100000@iolanthe.rowland.org>
References: <20091007174611.439a7a5a@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.0910071320120.3051-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It would probably be cleaner if they could lock against each other
> 
> What you mean isn't clear.  After all, open sometimes has to call
> resume.  So how could resume lock against open?

Probably it needs a counting lock as the code is currently structured -
which is a bit ugly. What paths do we end up going through the device
open method into resume in the same thread ?

> Does this imply that unthrottle should try to autoresume?  There does 
> appear to be a potential race between unthrottle and autosuspend.

The more I look at it the more it implies to me that the ldiscs doing
this should instead be taught some better manners instead. The real nasty
is that a driver might not have initialised the locking it needs do that
exclusion until open occurs. I think n_tty is probably the only offender
and if so I'd rather fix that and make it a rule that you don't do that,
trying to fix it other ways is going to be more horrible I imagine.
