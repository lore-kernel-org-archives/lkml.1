Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477Ab0AZVJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab0AZVJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 16:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128Ab0AZVJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 16:09:41 -0500
Received: from ns.penguin.cz ([84.21.108.25]:52729 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971Ab0AZVJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 16:09:41 -0500
Subject: How to write driver that needs to call another driver?
From: Stanislav Brabec <utx@penguin.cz>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="ISO-8859-2"
Date: Tue, 26 Jan 2010 22:11:05 +0100
Message-Id: <1264540265.2411.20.camel@utx.utx.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My Zaurus SL-C3200 PDA needs a driver that needs to call another driver
from another part of the device tree:

MAX1111 (4 channel A/D) is connected to several other pieces of hardware
(audio player remote keyboard, battery voltage, battery temperature,
external power voltage).

Battery power and charging management needs to read values from MAX1111
during. Also Remote Keyboard input device needs to read MAX1111.

But both drivers also need dedicated GPIO that are allocated on Scoop
chip (different part of the platform device tree).

What is the best way to implement it?

Now it is implemented by a hardcoded static reference. This does not
work well and breaks on suspend. MAX1111 goes to sleep first and attempt
to set-up offline charging fails (see below).

I need to make sure, that MAX1111 is going to suspend after the
battery management and after the audio remote driver (not yet in
vanilla) and resumes before them.

What is the best way to implement it?


Well, in fact, the problem is even worse: Spitz has a dumb charging
management. CPU has to wake-up each few minutes, check the battery,
adjust charging parameters and continue in sleeping.

That is why I either need to disable sleeping of SPI and MAX1111 or
temporarily wake up SPI and MAX111 without going to resume completely.

Is something like this possible?

It was working in past (linux-2.6.26) - MAX1111+SPI driver was hardcoded
into power management and when SPI was probably never suspended. Now it
obviously cannot work.

Thanks.

PM: suspend of devices complete after 549.298 msecs
PM: late suspend of devices complete after 0.359 msecs
max1111 spi2.2: spi_sync failed with -108
max1111 spi2.2: spi_sync failed with -108
max1111 spi2.2: spi_sync failed with -108
max1111 spi2.2: spi_sync failed with -108
max1111 spi2.2: spi_sync failed with -108
sharpsl-pm sharpsl-pm: Error: AC check failed: voltage -108.
sharpsl-pm sharpsl-pm: Offline Charger: Error occurred.
sharpsl-pm sharpsl-pm: Charging Error!
PM: early resume of devices complete after 0.255 msecs


________________________________________________________________________
Stanislav Brabec
http://www.penguin.cz/~utx

