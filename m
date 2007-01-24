Return-Path: <linux-kernel-owner+w=401wt.eu-S1752078AbXAXVUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbXAXVUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 16:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbXAXVUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 16:20:55 -0500
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:52332
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbXAXVUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 16:20:54 -0500
Message-ID: <45B7CDB5.7020909@microgate.com>
Date: Wed, 24 Jan 2007 15:20:53 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 1.5.0.8 (Windows/20061025)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: Strange problem with tty layer
References: <20070124204009.GA7584@csclub.uwaterloo.ca>
In-Reply-To: <20070124204009.GA7584@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> I have confirmed that the driver does in fact receive all the
> characters, and that they are correct, and that they are being passed to
> the tty layer using tty_insert_flip_string, and that it returns that all
> the characters have been passed to the tty layer.  The user space
> application however still doesn't see the last few characters (when it
> fails).
> 
> The problem seems to occour every few hours of testing on a 266MHz Geode
> SC1200.  When I change the clock to 133MHz, it happens every few minutes
> instead (so much more frequently).  I suspect there is some race
> condition that allows the tty layer to not get around to processing all
> the data in the buffer, even when asked for data by the application
> (which is waiting on the serial port using select, with a 4s timeout).

In 2.6.16 the tty buffering pushes data to the line
discipline without regard to tty->receive_room.
If the line discipline can't keep up, the data gets dropped.
I observed this data loss at higher speeds when
placing the system under heavy load.

2.6.18 added code to respect tty->receive_room.

This may or may not be your problem, but you should
be able to check by adding a conditional printk
to drivers/char/tty_io.c:flush_to_ldisc()

If tty->receive_room is less than the size of the buffer
passed to disc->receive_buf() then you are losing data.

-- 
Paul Fulghum
Microgate Systems, Ltd.
