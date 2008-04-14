Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbYDNUze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbYDNUze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 16:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbYDNUzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 16:55:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:42144 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761309AbYDNUzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 16:55:01 -0400
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks (rev. 8)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.0804141105460.2406-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0804141105460.2406-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Tue, 15 Apr 2008 06:48:50 +1000
Message-Id: <1208206130.6958.178.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-14 at 11:13 -0400, Alan Stern wrote:
> On Mon, 14 Apr 2008, Rafael J. Wysocki wrote:
> 
> >     "you can assume that the user space is there while ->prepare() is running,
> >     but you are supposed to prevent new children of the device from being
> >     registered from that point on _and_ you have to make sure that freezable
> >     tasks will be able to freeze after ->prepare() has run" (but why on Earth a
> >     driver writer is now required to know what's a freezable task etc.?)
> 
> This reminds me...  We're going to need a way to make certain
> activities mutually exclusive with system sleep.  The simplest example
> is loading a kernel module; init and probe routines often end up
> causing new child devices to be registered.
> 
> The most straightforward approach is to use an rwsem like the one we 
> used to have.  However I'm concerned that under some circumstances 
> there might be recursive read-locking.  (For example, the init routine 
> in a newly-loaded module decides to load yet another module.  Can this 
> actually happen?  libusual does something much like it.)
> 
> So it's quite possible we'll end up needing a mechanism that resembles 
> an rwsem but allows recursive (properly nested) read-locking.  Does 
> such a thing exist already, or would it have to be invented?

Despite what Oliver says, that's a perfect example where the module load
syscalls should return an error. Maybe something like -EAGAIN would do
tho... that might need a minor update of the module init tools so they
retry instead of failing.

Ben.


