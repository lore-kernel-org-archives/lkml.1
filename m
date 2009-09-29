Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbZI2RY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbZI2RY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbZI2RY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:24:26 -0400
Received: from netrider.rowland.org ([192.131.102.5]:57421 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753177AbZI2RYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:24:25 -0400
Date: Tue, 29 Sep 2009 13:24:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Jason Wessel <jason.wessel@windriver.com>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: How to handle console devices
In-Reply-To: <4AB93983.5070404@windriver.com>
Message-ID: <Pine.LNX.4.44L0.0909291310200.18601-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan:

Jason and I discussed how console devices (both USB-serial and others)  
should be handled.  My feeling is that these devices should persist
throughout the entire life of the kernel, not disappearing until the
system goes down.  So for example, if ttyUSB0 were to be a console and
the user were to unplug the corresponding USB serial device, ttyUSB0
would remain in existence -- unusable but still there -- and any new
USB serial devices would show up as ttyUSB1 or higher.

In addition, console output shouldn't be sent through these devices 
before the driver has properly initialized the hardware.  And once 
initialized, the hardware should never be shut down.

In the end, this amounts to making the kernel open each console device
when it is registered as a console.  The open call would create a tty
and termios to go with the device.  The open "file" reference would
never be closed, preventing the tty and termios from being released and
preventing the hardware from being shut down.

I don't know what the best way is to accomplish this.  Create dummy
inode and file structs and pass them to the usual tty_open() routine?  
(But then what about hangup event handling?)  What do you think?

Alan Stern

