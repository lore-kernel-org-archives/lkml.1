Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbXEIT4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbXEIT4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 15:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbXEIT4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 15:56:46 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:34085
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512AbXEIT4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 15:56:46 -0400
Message-ID: <464235F4.6080006@microgate.com>
Date: Wed, 09 May 2007 14:58:28 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: James Simmons <jsimmons@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux console project <linuxconsole-dev@lists.sourceforge.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Use tty_schedule in VT code.
References: <Pine.LNX.4.64.0705082107460.3459@pentafluge.infradead.org> <1178656361.14867.7.camel@x2.microgate.com>
In-Reply-To: <1178656361.14867.7.camel@x2.microgate.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Fulghum wrote:
> As the tty flip buffer code has evolved, that delay value of 1
> was carried along. It may have had some historical purpose, but
> I can't figure it out and it appears to have no use currently.

I looked further back and in the 2.4 kernels this scheduling
was done with the timer task queue (process receive data on
next timer tick).

I guess the schedule_delayed_work() with a time delay of 1
was the best approximation of the previous behavior.

There is no logical reason to delay the first attempt at
processing receive data so schedule_delayed_work() in
tty_schedule_flip() should be changed to 0 (as was the
case for con_schedule_flip).

The schedule_delayed_work in flush_to_ldisc() will continue
to use a delay of 1 if the ldisc can't accept more data.
This allows the user app and ldisc to catch up.

Subsequent calls to tty_schedule_flip won't affect
this 'back off' delay because once the work is scheduled
(with a delay of 1) new scheduling calls are ignored for
the same work structure.

I've been testing the change to 0 in tty_schedule_flip()
under various loads and data rates with no ill effects.

-- 
Paul Fulghum
Microgate Systems, Ltd.
