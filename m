Return-Path: <linux-kernel-owner+w=401wt.eu-S933732AbXG0Pu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933732AbXG0Pu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 11:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbXG0PuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 11:50:16 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:39678
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854AbXG0PuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 11:50:14 -0400
Subject: Fwd: PROBLEM: serial port receive buffers not being flushed
	properly
From: Paul Fulghum <paulkf@microgate.com>
To: craigeger@comcast.net
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 10:50:13 -0500
Message-Id: <1185551413.3285.13.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: craigeger@comcast.net
> [1.] PROBLEM: serial port receive buffers not being flushed properly
> [2.] After calling tcflush() or ioctl() with the TCFLSH argument,
> an ioctl() with the FIONREAD argument reports 0 bytes available
> for reading. However, a subsequent select() and read() of the port
> returns data. This problem is seen in 2.6.21.1 and 2.6.20,
> but is not seen in version 2.6.17.14. Other versions have
> not been tested.

There is receive buffering between the serial driver and
line discipline. The line discipline processes FIONREAD
and TCFLSH with regard to the line discipline receive
buffers but not the intermediate buffering.

In 2.6.17 the intermediate buffering pushed
receive data to the line discipline without
regard for tty->receive_room, so if the ldisc buffers
were full the data was lost.

In 2.6.18 the intermediate buffering was changed to
hold receive data until the line discipline could
accept it.

So in 2.6.17 all the extra data you sent was simply
discarded and flushing the ldisc buffers cleared all
of the receive data. Starting with 2.6.18, flushing the
ldisc buffers just allowed the intermediate buffering to
start feeding more data to the ldisc. This results in the
receive data you see after a TCFLSH.

Starting with 2.6.22 TCFLSH is processed by the intermediate
buffering as well as the ldisc to eliminate any remaining
receive data in the intermediate buffering.


--
Paul Fulghum
Microgate Systems, Ltd

