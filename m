Return-Path: <linux-kernel-owner+w=401wt.eu-S1761830AbYBAFlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761830AbYBAFlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 00:41:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1749667AbYBAFky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 00:40:54 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:33678 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbYBAFky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 00:40:54 -0500
Message-ID: <47A2B0DF.1050504@davidnewall.com>
Date: Fri, 01 Feb 2008 16:10:47 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Xmit buffer overflow in pl2303
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been working on a buffer overflow problem in pl2303.  Admittedly
I'm using a 2.4 kernel, but I've back-ported the latest pl2303.c. 
(Please make no unnecessary fuss over that.)  For the record, the
pl2303.c from 2.6.23 is substantially identical to that from 2.4.  The
significant change, other than addition of some extra product ids, is
the inclusion of a couple of 1k circular buffers, which hide the
problem; but buffers are finite and when sufficiently motivated, the
problem reappears.

The problem relates to hardware handshaking.  When CTS is off, the
userspace application can continue to write to the device, eventually
filling all buffers, both kernel and hardware, after which data is
dropped and pl2303_write returns 0.  Loading the module with debug=1, I
see each user write of n bytes reflected in the log as a sequence of
writes of length n, n-1, ..., 0.  I guess something above the module is
catching the 0 return from pl2303_write and repeating with one less byte
each time, perhaps on the basis that a smaller count might succeed where
the larger doesn't.  At no point does the user application block until
CTS is re-asserted.  The driver correctly records CTS (and other line)
state transitions, but nothing seems to care.

I have inserted code in pl2303_write which sleeps while CTS is off (if
it's being monitored), and likewise DSR.  That works nicely, but it
seems to me that this is a common requirement that should be handled
elsewhere.  I don't see it in char/tty, either in usbserial.  I don't
even see it in any other driver.  Where should I be looking?
