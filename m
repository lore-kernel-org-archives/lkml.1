Return-Path: <linux-kernel-owner+w=401wt.eu-S1161923AbXEDULJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161923AbXEDULJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 16:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161925AbXEDULJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 16:11:09 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161584AbXEDULE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 16:11:04 -0400
Date: Fri, 4 May 2007 13:09:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: gregkh@suse.de, paulus@samba.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: [PATCH] Re: 2.6.21-rc7-mm2 -- hvsi console driver registration
 failure
Message-Id: <20070504130952.b43fc676.akpm@linux-foundation.org>
In-Reply-To: <4fe4528cb20beb569a8f2ac817c776e5@pinky>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
	<4fe4528cb20beb569a8f2ac817c776e5@pinky>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 May 2007 12:38:58 +0100
Andy Whitcroft <apw@shadowen.org> wrote:

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

OK, thanks for working that out.

Christoph, we should be emitting loud warnings so that this problem is easy
to debug.

Better, we should be emitting loud warnigns which then disable themselves
and then succeeding the allocation so that people can proceed with their
kernel testing.

When all the loud-warning sites have been fixed, we can take that code out
again.

The present situation is maximally tester-hostile.

> It is not clear to me if this is a bug in the hvsi driver in that
> it should specify some units.  It seems we will try and reserve zero
> devices in this case, which seems pointless.
> 
> I have tested with the patch below which seems safe to me and stops
> the errors and even seems to make the console work.  But perhaps
> someone with more driver fu, could verify if driver->num of zero
> has any meaning and kick this to the hvsi people if not.
> 
> -apw
> 
> === 8< ===
> tty_register_driver: only allocate tty instances when defined
> 
> If device->num is zero we attempt to kmalloc() zero bytes.
> When SLUB is enabled this returns a null pointer and take that as
> an allocation failure and fail the device register.  Check for no
> devices and avoid the allocation.
> 
> Signed-off-by: Andy Whitcroft <apw@shadowen.org>
> ---
> diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
> index 959a616..71c4579 100644
> --- a/drivers/char/tty_io.c
> +++ b/drivers/char/tty_io.c
> @@ -3724,7 +3724,7 @@ int tty_register_driver(struct tty_driver *driver)
>  	if (driver->flags & TTY_DRIVER_INSTALLED)
>  		return 0;
>  
> -	if (!(driver->flags & TTY_DRIVER_DEVPTS_MEM)) {
> +	if (!(driver->flags & TTY_DRIVER_DEVPTS_MEM) && driver->num) {
>  		p = kmalloc(driver->num * 3 * sizeof(void *), GFP_KERNEL);
>  		if (!p)
>  			return -ENOMEM;
