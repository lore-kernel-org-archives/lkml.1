Return-Path: <linux-kernel-owner+w=401wt.eu-S933460AbZHWCv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460AbZHWCv1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 22:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933446AbZHWCv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 22:51:27 -0400
Received: from netrider.rowland.org ([192.131.102.5]:34700 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933438AbZHWCv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 22:51:26 -0400
Date: Sat, 22 Aug 2009 22:51:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Bruno =?ISO-8859-14?B?UHLpbW9udA==?= <bonbons@linux-vserver.org>,
       Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
In-Reply-To: <20090822001637.72a08078@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.0908222236100.11562-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan:

There's a problem with the tty->ops->shutdown method.  It needs to
release the last port reference owned by the current tty.  But when was
that reference originally acquired?  Evidently during the first time
serial_open() was called for the current tty.

The problem is that serial_open() has no way to know if a particular 
invocation is the first one for this tty!  The ASYNCB_INITIALIZED flag 
doesn't help, because it might not get set during the first call (i.e., 
if an error occurs).

To do this right, we need a flag in the tty_struct or the tty_port
which serial_open() can set when acquiring that first reference and
shutdown method can clear.  Should I add such a flag?

Alan Stern

