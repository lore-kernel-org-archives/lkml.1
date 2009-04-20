Return-Path: <linux-kernel-owner+w=401wt.eu-S1759477AbZDTWaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477AbZDTWaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 18:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758936AbZDTW0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 18:26:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758949AbZDTW0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 18:26:35 -0400
Date: Mon, 20 Apr 2009 15:14:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: dvomlehn@cisco.com, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [Patch] Wait for console to become available, ver 3
Message-Id: <20090420151400.11afd62a.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.0904201744410.6832-100000@iolanthe.rowland.org>
References: <20090420143010.697c7380.akpm@linux-foundation.org>
	<Pine.LNX.4.44L0.0904201744410.6832-100000@iolanthe.rowland.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009 17:51:16 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Mon, 20 Apr 2009, Andrew Morton wrote:
> 
> > If we want b) then how to do it?
> > 
> > One possibility: the initcalls have been completed when init_post() is
> > called.  How about: if one of those initcalls will be asynchronously
> > registering a console, it should inform the console layer about this. 
> > It should call the new i_will_be_adding_a_console_soon() function
> > within its initcall.  The console subsystem will remember this, and we
> > can cause init_post() to block until that registration has occurred.
> > 
> > We'll need to be able to handle errors, and we'll need to be able to
> > handle the case where the initcall function isn't sure whether or not
> > it will be registering a console.  So there will also need to be an
> > oops_im_not_adding_a_console_after_all() function, which will withdraw
> > the effects of i_will_be_adding_a_console_soon().
> > 
> > Which means that i_will_be_adding_a_console_soon() will need to return
> > a handle for the oops_im_not_adding_a_console_after_all() caller to
> > pass.
> > 
> > If init_post() is currently blocked awaiting the arrival of the
> > console, oops_im_not_adding_a_console_after_all() will unblock
> > init_post() if there are no more potential console registrations
> > pending, and inti_post()'s attempt to open a console will fail.
> > 
> > 
> > Or something like that?
> 
> What if a subsystem simply doesn't know in advance whether or not it's 
> going to register a console?  Or doesn't know when it has finished 
> probing all devices (since a new device could be plugged in at any 
> time)?

Fix it.  It's trivial to make a sub-driver call back into a higher
layer to tell it that it registered a console.  Or just do the
i_will_be_adding_a_console_soon()/oops_im_not_adding_a_console_after_all()
calls from the layer which _does_ know.

> Not to mention that this scheme appears more complicated than the one 
> it's intended to replace... although it doesn't have any boot-line 
> parameters.

It isn't very complicated.

Yes, a boot parameter is "simple" to inplement.  But it's ghastly from
a usability POV.  Especially if you care about boot times.  For how
long do you delay?  The user has to experiment with different delays
until he finds the magic number.  Then he adds 10% and waits for the
inevitable failure reports to come in.

It's much better to just get it right, even if that makes it more
"complex".


