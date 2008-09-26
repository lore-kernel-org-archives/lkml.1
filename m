Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbYIZHvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbYIZHvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 03:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbYIZHvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 03:51:43 -0400
Received: from nebensachen.de ([195.34.83.29]:58676 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbYIZHvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 03:51:42 -0400
X-Hashcash: 1:20:080926:mingo@elte.hu::KEsbN1nnK34xOP7q:00000Rve
X-Hashcash: 1:20:080926:tglx@linutronix.de::cWfsl48JTcr8H26H:000000000000000000000000000000000000000000052Lz
X-Hashcash: 1:20:080926:linux-kernel@vger.kernel.org::ZcECN6ba9083U4m9:00000000000000000000000000000000014V1
From: Elias Oltmanns <eo@nebensachen.de>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: udelay and timers
Date: Fri, 26 Sep 2008 09:51:27 +0200
Message-ID: <87skrnz6o0.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

finally, I have managed to identify the cause of some odd symptoms on my
system, but I need your help to understand what is really going on and
what should be done to fix things. My problem is this: I have written a
small test module which, in due course, does the following:

...
        mod_timer(&timera, jiffies + msecs_to_jiffies(10000));
        mod_timer(&timerb, jiffies + HZ/50);
...

The callbacks for those timers are defined as follows:

void timera.function(unsigned long data)
{
        udelay(120);
        mod_timer(&timera, jiffies + msecs_to_jiffies(10000));
}

void timerb.function(unsigned long data)
{
...
        mod_timer(&timerb, jiffies + HZ/50);
}

Now, I can observe that because of the call to udelay() in the callback
of timera, timerb rather frequently fires *much* too early, i.e. after
less than 1 msec rather than 20 msecs. This means that an udelay in a
timer callback heavily affects the precision of other timers running at
the time. The effect if particularly grave on a tickless system, but
even when NO_HZ was not set, I have observed this behaviour.

As I understand, udelay() is meant to be usable in softirq context. What
can I do to find out what exactly causes the problem?

Thank you very much for your assistance,

Elias
