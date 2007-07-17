Return-Path: <linux-kernel-owner+w=401wt.eu-S934534AbXGQUar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934534AbXGQUar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932136AbXGQU3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:29:50 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:50318
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764680AbXGQU3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:29:48 -0400
Message-ID: <469D2713.30703@microgate.com>
Date: Tue, 17 Jul 2007 14:31:15 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: James Simmons <jsimmons@infradead.org>
CC: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux console project <linuxconsole-dev@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use tty_schedule in VT code.
References: <Pine.LNX.4.64.0707171933180.6721@pentafluge.infradead.org> <20070717184943.GA3768@interface.famille.thibault.fr> <Pine.LNX.4.64.0707172016470.9131@pentafluge.infradead.org>
In-Reply-To: <Pine.LNX.4.64.0707172016470.9131@pentafluge.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Simmons wrote:
>> James Simmons, le Tue 17 Jul 2007 19:37:57 +0100, a écrit :
>>> -	schedule_delayed_work(&t->buf.work, 0);
>> It was schedule_delayed_work(&t->buf.work, 1); in con_schedule_flip() ;
>> could that matter?
> 
> I did not detect any regressions.

The console behavior stays exactly the same as the patch
changes tty_schedule_flip to use the 0 delay. The change
to tty_schedule_flip() to use 0 delay also is OK. I had
looked at this when James originally posted this patch and found:

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
