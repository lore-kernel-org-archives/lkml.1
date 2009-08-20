Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbZHTTdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbZHTTdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 15:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbZHTTdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 15:33:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35541 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751967AbZHTTdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 15:33:40 -0400
Date: Thu, 20 Aug 2009 15:33:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: More usb-serial problems
Message-ID: <Pine.LNX.4.44L0.0908201523490.2670-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan:

I have uncovered yet another problem with usb-serial.  The refcount of
the tty_struct is getting set wrong.

I didn't trace it fully, but here's what I found.  Opening the device
increases the refcount from 1 to 2.  Closing the device decreases the
refcount all the way to 0, causing the structure to be deallocated.  
The next time a program tries to open it, there's an access violation.

The two decrements occur in the following paths:

	tty_release_dev -> serial_close -> tty_port_tty_set ->
		tty_kref_put

	tty_release_dev -> release_tty -> tty_kref_put

Those both seem reasonable, which suggests that something is wrong 
with __tty_open.  I tried replacing

	filp->private_data = tty;

with

	filp->private_data = tty_kref_get(tty);

but that failed dismally (no tty device could be opened more than 
once).  Maybe you have already run across this problem, but if you 
haven't, please take a look.

Alan Stern

