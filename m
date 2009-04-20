Return-Path: <linux-kernel-owner+w=401wt.eu-S1757632AbZDTVva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632AbZDTVva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 17:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756292AbZDTVvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 17:51:18 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46228 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753852AbZDTVvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 17:51:17 -0400
Date: Mon, 20 Apr 2009 17:51:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: David VomLehn <dvomlehn@cisco.com>, <linux-kernel@vger.kernel.org>,
       <linux-embedded@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [Patch] Wait for console to become available, ver 3
In-Reply-To: <20090420143010.697c7380.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0904201744410.6832-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009, Andrew Morton wrote:

> If we want b) then how to do it?
> 
> One possibility: the initcalls have been completed when init_post() is
> called.  How about: if one of those initcalls will be asynchronously
> registering a console, it should inform the console layer about this. 
> It should call the new i_will_be_adding_a_console_soon() function
> within its initcall.  The console subsystem will remember this, and we
> can cause init_post() to block until that registration has occurred.
> 
> We'll need to be able to handle errors, and we'll need to be able to
> handle the case where the initcall function isn't sure whether or not
> it will be registering a console.  So there will also need to be an
> oops_im_not_adding_a_console_after_all() function, which will withdraw
> the effects of i_will_be_adding_a_console_soon().
> 
> Which means that i_will_be_adding_a_console_soon() will need to return
> a handle for the oops_im_not_adding_a_console_after_all() caller to
> pass.
> 
> If init_post() is currently blocked awaiting the arrival of the
> console, oops_im_not_adding_a_console_after_all() will unblock
> init_post() if there are no more potential console registrations
> pending, and inti_post()'s attempt to open a console will fail.
> 
> 
> Or something like that?

What if a subsystem simply doesn't know in advance whether or not it's 
going to register a console?  Or doesn't know when it has finished 
probing all devices (since a new device could be plugged in at any 
time)?

Not to mention that this scheme appears more complicated than the one 
it's intended to replace... although it doesn't have any boot-line 
parameters.

Personally, I'm in favor of adding a boot parameter.  Things could be 
simplified slightly by treating a negative value (or a missing value) 
as indicating an infinite timeout; then only one new parameter would be 
needed instead of two.

Alan Stern

