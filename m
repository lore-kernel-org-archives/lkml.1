Return-Path: <linux-kernel-owner+w=401wt.eu-S1752740AbZI2WrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbZI2WrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 18:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbZI2WrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 18:47:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45142 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751510AbZI2WrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 18:47:18 -0400
Date: Tue, 29 Sep 2009 23:47:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jason Wessel <jason.wessel@windriver.com>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: How to handle console devices
Message-ID: <20090929234733.5b9fbc67@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.0909291310200.18601-100000@netrider.rowland.org>
References: <4AB93983.5070404@windriver.com>
	<Pine.LNX.4.44L0.0909291310200.18601-100000@netrider.rowland.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't know what the best way is to accomplish this.  Create dummy
> inode and file structs and pass them to the usual tty_open() routine?  
> (But then what about hangup event handling?)  What do you think?

What I long term envisioned was that 

- Every tty (or at least every interesting tty) would have a tty_port
  object for the hardware  [done now for all consoles but vt]
- Every tty port object would have an "output" method
- The tty->termios would move to the tty_port
- The tty receive buffers would move to the tty_port (only needed for a
  console that supports input)

At that point
- The tty lock/refcount isn't needed all the time for the receive data
  paths which speeds it up a fair bit
- A console can be implemented without a tty_struct anywhere in sight
- Flow control and speed setting can be done on hardware generically on
  resume paths

That fixes the lifetime and magic object invention issues that plague the
current console.

I still think that is the right way to fix it.

Alan
