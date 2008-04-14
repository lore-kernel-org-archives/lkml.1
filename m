Return-Path: <linux-kernel-owner+w=401wt.eu-S1762163AbYDNPNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762163AbYDNPNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760775AbYDNPNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:13:42 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54821 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759865AbYDNPNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:13:41 -0400
Date: Mon, 14 Apr 2008 11:13:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: benh@kernel.crashing.org, Greg KH <greg@kroah.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and hibernation
 callbacks (rev. 8)
In-Reply-To: <200804141411.19385.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0804141105460.2406-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008, Rafael J. Wysocki wrote:

>     "you can assume that the user space is there while ->prepare() is running,
>     but you are supposed to prevent new children of the device from being
>     registered from that point on _and_ you have to make sure that freezable
>     tasks will be able to freeze after ->prepare() has run" (but why on Earth a
>     driver writer is now required to know what's a freezable task etc.?)

This reminds me...  We're going to need a way to make certain
activities mutually exclusive with system sleep.  The simplest example
is loading a kernel module; init and probe routines often end up
causing new child devices to be registered.

The most straightforward approach is to use an rwsem like the one we 
used to have.  However I'm concerned that under some circumstances 
there might be recursive read-locking.  (For example, the init routine 
in a newly-loaded module decides to load yet another module.  Can this 
actually happen?  libusual does something much like it.)

So it's quite possible we'll end up needing a mechanism that resembles 
an rwsem but allows recursive (properly nested) read-locking.  Does 
such a thing exist already, or would it have to be invented?

Alan Stern

