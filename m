Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbYBYTq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbYBYTq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 14:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbYBYTqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 14:46:38 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55100 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755645AbYBYTqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 14:46:36 -0500
Date: Mon, 25 Feb 2008 14:46:35 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer
 removal
In-Reply-To: <Pine.LNX.4.44L0.0802251010330.2133-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.44L0.0802251439030.5536-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008, Alan Stern wrote:

> The only possible solution is to have the drivers themselves be
> responsible for preventing calls to device_add() or device_register()  
> during a system sleep.  (It's also necessary to prevent driver binding,
> but this isn't a major issue.)  The most straightforward approach is to
> add a new pair of driver methods: one to disable adding children and
> one to re-enable it.  Of course this would represent a significant
> addition to the Power Management driver interface.
> 
> (Note that the existing suspend and resume methods cannot be used for 
> this purpose.  Drivers assume that when the suspend method is called, 
> it has already been called for all the child devices.  This wouldn't be 
> true if one of the purposes of the method was to prevent addition of 
> new children.)

On further thought maybe the existing methods can be used, with care.  
Drivers would have to assume the responsibility of synchronizing with
their helper threads and stopping addition of new children (something
they should already be doing), and they would also have to check that
all the existing children are already suspended.  They should not make
the assumption that the PM core has already suspended all the children.

The PM core could help detect errors here.  If it tries to suspend a 
device and sees that the device's parent is already suspended, then the 
parent's driver has a bug.

Alan Stern

