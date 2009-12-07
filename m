Return-Path: <linux-kernel-owner+w=401wt.eu-S964925AbZLGSGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964925AbZLGSGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 13:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964908AbZLGSGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 13:06:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964859AbZLGSGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 13:06:16 -0500
Date: Mon, 7 Dec 2009 10:05:56 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
cc: Zhang Rui <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
In-Reply-To: <Pine.LNX.4.44L0.0912071217220.2644-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.0912070956350.3560@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912071217220.2644-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Dec 2009, Alan Stern wrote:
> 
> Okay, I think I've got it.  But you're wrong about one thing: Resume
> isn't _exactly_ the reverse of suspend.

Yeah, no. But I think I made it much closer by getting rid of pre-suspend 
and post-resume (my next email to the one you quoted).

And yeah, I started thinking along those lines exactly because it wasn't 
as clean a mirror image as I thought it should be able to be.

> A non-async driver (i.e., most of them) would ignore the pre- pass
> entirely and do all its work in the second pass.

See my second email, where I think I can get rid of the whole second pass 
thing. I think you'll agree that it's an even nicer mirror image.

> There's some question about what to do if a suspend or resume fails.  A
> bunch of async threads will have been launched for other devices, but
> now there won't be anything to wait for them.  It's not clear how this
> should be handled.

I think the rule for "suspend fails" is very simple: you can't fail in the 
async codepath. There's no sane way to return errors, and trying to would 
be too complex anyway. What would you do? 

In fact, even though we _can_ fail in the synchronous path, I personally 
consider a device driver that ever fails its suspend to be terminally 
broken. We're practically always better off suspending and simply turning 
off the power than saying "uh, I failed the suspend".

I've occasionally hit a few drivers that caused suspend failures, and each 
and every time it was a driver bug, and the right thing to do was to just 
ignore the error and suspend anyway - returning an error code and trying 
to undo the suspend is not what anybody ever really wants, even if our 
model _allows_ for it.

(And the rule for "resume fails" is even simpler: there's nothing we can 
really do if something fails to resume - and that's true whether the 
failure is synchronous or asynchronous. The device is dead. Try to reset 
it, or remove it from the device tree. Tough).

				Linus
