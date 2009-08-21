Return-Path: <linux-kernel-owner+w=401wt.eu-S932480AbZHUPnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbZHUPnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 11:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932470AbZHUPnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 11:43:11 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39223 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932468AbZHUPnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 11:43:09 -0400
Date: Fri, 21 Aug 2009 11:43:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
In-Reply-To: <20090821112554.18a297fa@pluto.restena.lu>
Message-ID: <Pine.LNX.4.44L0.0908211042380.2912-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Aug 2009, Bruno [UTF-8] Prémont wrote:

> The module refcount was for both. It's the pl2302/ftdi-sio module's
> refcount.
> 
> I don't remember for sure about the panic if it also affects
> pl2302 or not.
> At least one of the panics was when running dmesg after exiting minicom.
> 
> I will redo the tests this evening when I get home and report back with
> more details.

Apparently the problem is in serial_do_free(); it doesn't know 
whether it's getting called for a successful open or an unsuccessful 
open, so it decrements the module count when it shouldn't.  The same is 
true for port->dev's refcount.

Alan, related to this problem is the fact that usb_serial_driver
doesn't include a "hangup" method.  I'm not sure that making
serial_hangup() call serial_do_down() is correct, but if it is then
shouldn't we call port->serial->type->open() afterwards?  Otherwise the
lower driver can't know that the port is still open.

Furthermore, shouldn't we check ASYNCB_INITIALIZED in serial_close()?

Alan Stern

