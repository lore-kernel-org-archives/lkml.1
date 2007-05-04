Return-Path: <linux-kernel-owner+w=401wt.eu-S1161891AbXEDTEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161891AbXEDTEM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 15:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161893AbXEDTEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 15:04:12 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56863 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161891AbXEDTEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 15:04:10 -0400
Date: Fri, 4 May 2007 14:04:08 -0500
To: Andy Whitcroft <apw@shadowen.org>
Cc: gregkh@suse.de, paulus@samba.org, Andrew Morton <akpm@osdl.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Re: 2.6.21-rc7-mm2 -- hvsi console driver registration failure
Message-ID: <20070504190408.GN6193@austin.ibm.com>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <4fe4528cb20beb569a8f2ac817c776e5@pinky>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fe4528cb20beb569a8f2ac817c776e5@pinky>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 12:38:58PM +0100, Andy Whitcroft wrote:
> 
> Trying to get 2.6.21-rc7-mm2 to boot on large PPC64 seems to be a
> bit of a challenge.  We have been seeing panics on boot from the
> hvsi driver:
> 
> 	Couldn't register hvsi console driver
> 
> Tracking this back, this seems to come from hvsi driver trying to
> register itself via tty_register_driver() with a zero units.
> 
> The failure is triggered by a change in semantics for kmalloc()
> between SLAB and SLUB; kmalloc(0) now returns NULL rather than an
> allocation at the smallest size.  Looking at the code in question
> even when the allocation succeeds we will not actually use the
> memory when device->num is zero.
> 
> It is not clear to me if this is a bug in the hvsi driver in that
> it should specify some units.  It seems we will try and reserve zero
> devices in this case, which seems pointless.

Yes, it seems pointless to me ... 

> I have tested with the patch below which seems safe to me and stops
> the errors and even seems to make the console work.  But perhaps
> someone with more driver fu, could verify if driver->num of zero
> has any meaning and kick this to the hvsi people if not.

Hollis nominated me to be "hvsi people", although I'm near-totally
ignorant of the thing.

If hvsi_count is zero, then the device tree did not have any
"serial" nodes that speak "hvterm-protocol". The hvsi should not 
have even tried to register anything. The attached patch seems more 
to the point.

--linas


The hvsi driver is used whenever the device-tree contains
nodes for serial ports, and those serial ports speak the hvterm
protocol. However, if no such nodes are found, then the hvsi
driver should not even register. 

This patch avoids a kernel panic with "Couldn't register hvsi 
console driver". 

In addition, this patch makes tty_register_driver refuse
to do anything, if there are no actual tty ports to be 
registered.

Utterly & completely untested.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>

----
 drivers/char/hvsi.c   |    4 ++++
 drivers/char/tty_io.c |    3 +++
 2 files changed, 7 insertions(+)

Index: linux-2.6.21-rc7-mm2/drivers/char/hvsi.c
===================================================================
--- linux-2.6.21-rc7-mm2.orig/drivers/char/hvsi.c	2007-04-26 15:37:33.000000000 -0500
+++ linux-2.6.21-rc7-mm2/drivers/char/hvsi.c	2007-05-04 13:55:56.000000000 -0500
@@ -1148,6 +1148,10 @@ static int __init hvsi_init(void)
 {
 	int i;
 
+	/* No serial hvterm-protocol device-tree nodes found. */
+	if (hvsi_count == 0)
+		return 0;
+
 	hvsi_driver = alloc_tty_driver(hvsi_count);
 	if (!hvsi_driver)
 		return -ENOMEM;
Index: linux-2.6.21-rc7-mm2/drivers/char/tty_io.c
===================================================================
--- linux-2.6.21-rc7-mm2.orig/drivers/char/tty_io.c	2007-04-26 15:37:33.000000000 -0500
+++ linux-2.6.21-rc7-mm2/drivers/char/tty_io.c	2007-05-04 13:54:14.000000000 -0500
@@ -3724,6 +3724,9 @@ int tty_register_driver(struct tty_drive
 	if (driver->flags & TTY_DRIVER_INSTALLED)
 		return 0;
 
+	if (driver->num == 0)
+		return -ENODEV;
+
 	if (!(driver->flags & TTY_DRIVER_DEVPTS_MEM)) {
 		p = kmalloc(driver->num * 3 * sizeof(void *), GFP_KERNEL);
 		if (!p)
