Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbZDTVdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbZDTVdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 17:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbZDTVdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 17:33:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752219AbZDTVdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 17:33:09 -0400
Date: Mon, 20 Apr 2009 14:30:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David VomLehn <dvomlehn@cisco.com>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [Patch] Wait for console to become available, ver 3
Message-Id: <20090420143010.697c7380.akpm@linux-foundation.org>
In-Reply-To: <20090417213148.GA27825@cuplxvomd02.corp.sa.net>
References: <20090417213148.GA27825@cuplxvomd02.corp.sa.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009 14:31:48 -0700
David VomLehn <dvomlehn@cisco.com> wrote:

> Parallelization to improve boot times has been successful enough that race
> conditions now exist between the init_post() open of /dev/console and
> initialization of the console device. When this occurs, opening /dev/console
> fails and any applications inherited from init have no standard in/out/error
> devices. This is expected behavior if no console device is available, but
> quite unfortunate in the case where the console is just a bit slow waking up.
> 
> Some buses, such as USB, offer no guarantees about how long it takes to
> discover devices, so there is no reliable way to distinguish between a missing
> console and a slow one.  The pragmatic approach taken in this patch is to
> wait for a while to see if a console shows up, and just go on if it doesn't.
> The default delay is 1000 msec (1 second).
> 
> There are two new command line parameters:
> consolewait		Wait forever for a console to be registered
> consoledelay=msec	Use the given number of milliseconds as the delay
> 			interval instead of the default

This is all pretty nasty, isn't it?

Let's step back for a bit from any implementation and ask "what is the
ideal behaviour"?  I think it's one of

a) we permit init_post()'s open() to succeed.  Console output is
   buffered by the kernel (could be in the printk log_buf).  When the
   initial console is eventually registered, we flush all the queued
   characters into it.

b) we block in init_post(), waiting for the initial console to
   become available.

I think b) is better.  Simpler, safer, less likely for information loss
if the kernel were to crash in that delay window.

Am I right?  Did I miss any options?

If we want b) then how to do it?

One possibility: the initcalls have been completed when init_post() is
called.  How about: if one of those initcalls will be asynchronously
registering a console, it should inform the console layer about this. 
It should call the new i_will_be_adding_a_console_soon() function
within its initcall.  The console subsystem will remember this, and we
can cause init_post() to block until that registration has occurred.

We'll need to be able to handle errors, and we'll need to be able to
handle the case where the initcall function isn't sure whether or not
it will be registering a console.  So there will also need to be an
oops_im_not_adding_a_console_after_all() function, which will withdraw
the effects of i_will_be_adding_a_console_soon().

Which means that i_will_be_adding_a_console_soon() will need to return
a handle for the oops_im_not_adding_a_console_after_all() caller to
pass.

If init_post() is currently blocked awaiting the arrival of the
console, oops_im_not_adding_a_console_after_all() will unblock
init_post() if there are no more potential console registrations
pending, and inti_post()'s attempt to open a console will fail.


Or something like that?
