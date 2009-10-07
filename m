Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbZJGP46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbZJGP46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 11:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759489AbZJGP45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 11:56:57 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33618 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759490AbZJGP45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 11:56:57 -0400
Date: Wed, 7 Oct 2009 11:56:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Oliver Neukum <oliver@neukum.org>, Johan Hovold <jhovold@gmail.com>,
       Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 5/5] opticon: Fix resume logic
In-Reply-To: <20091006232331.5684bbee@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.0910071147020.2762-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009, Alan Cox wrote:

> On Tue, 6 Oct 2009 23:12:17 +0200
> Oliver Neukum <oliver@neukum.org> wrote:
> 
> > Am Dienstag, 6. Oktober 2009 17:06:57 schrieb Alan Cox:
> > > Opticon now takes the right mutex to check the port status but the status
> > > check is done wrongly for the modern serial code, so fix it.
> > 
> > As Alan Stern noticed, it seems like we have an ab-ba deadlock here
> > between open and resume regarding pm_mutex and port->mutex.

Johan pointed out that I was mistaken in saying the pm_mutex is
acquired during open.  It actually is acquired in serial_install() and
serial_cleanup(), which are called without the port mutex.  So I guess
we're okay after all.

In the general case, that is.  Specific drivers may still run into
trouble.  For example, option_open() and sierra_open() do acquire the 
pm_mutex.

> Oh well I guess someone with hardware will have to fix that.
> 
> Do we actually need a separate pm_mutex anyway ?

In principle we don't, and Rafael Wysocki's new runtime PM framework
doesn't use one.  However the current USB runtime PM framework does, so
until we switch over (hopefully in time for 2.6.33) it's important to
watch out for this sort of conflict.

Alan Stern

