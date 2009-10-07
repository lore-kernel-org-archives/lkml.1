Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZJGVeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZJGVeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754008AbZJGVeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:34:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40480 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753518AbZJGVet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:34:49 -0400
Date: Wed, 7 Oct 2009 17:34:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 4/5] usb_serial: Kill port mutex
In-Reply-To: <20091007220252.5b672399@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.0910071720440.4512-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009, Alan Cox wrote:

> On Wed, 7 Oct 2009 22:56:20 +0200
> Oliver Neukum <oliver@neukum.org> wrote:
> 
> > Am Mittwoch, 7. Oktober 2009 20:52:21 schrieb Alan Stern:
> > > However in the option and sierra drivers there is a perverse path from
> > > close to resume: Both their close methods call
> > > usb_autopm_get_interface().  This could be removed without much
> > > trouble; perhaps we should do so.
> > 
> > I am afraid this won't do in the long run. Some drivers will want to
> > shut down devices by communicating with them in close().
> 
> drivers/serial will need a power management hook to use
> tty_port_{open/close} so perhaps that can be covered for both. In the
> serial case it needs to kick stuff out of PCI D3 mostly and could
> probably be fudged but if USB needs it perhaps it should be explicit.

I'm losing track of the original point of this thread.  IIRC, the 
problem is how the resume method should know whether or not to submit 
the receive URB(s).  It can't afford to acquire the port mutex because 
it might be called by open or close, at which time the mutex is already 
held.

Other schemes could work, but to me it seems simplest to rely on a flag
protected by a spinlock.  The flag would mean "URBs are supposed to be
queued unless we are suspended".  It would be set by open and 
unthrottle, and cleared by close and throttle.

Alan Stern

