Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbZCJPvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbZCJPvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 11:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbZCJPvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 11:51:24 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:44438 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932AbZCJPvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 11:51:23 -0400
Message-ID: <49B68C37.8010803@freescale.com>
Date: Tue, 10 Mar 2009 10:50:15 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, rdreier@cisco.com, jirislaby@gmail.com,
       peterz@infradead.org, will.newton@gmail.com, hancockrwd@gmail.com,
       jeremy@goop.org
Subject: Re: [PATCH v4] introduce macro spin_event_timeout()
References: <1236699004-1863-1-git-send-email-timur@freescale.com> <20090310153537.5fd5d84d@lxorguk.ukuu.org.uk>
In-Reply-To: <20090310153537.5fd5d84d@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

> NAK this - on a lot of platforms 1uS is the wrong timescale. Also we
> shouldn't be encouraging this kind of polling by making it very easy to
> write.

Well, I can agree that the time scale might be wrong on some platforms.
  The original version of spin_event_timeout() used jiffies, but some
people said that a jiffy is too long of a timescale, so I changed it to
udelay.

However, I disagree about the encouragement part.  Polling a register
until a status bit changes is a common task that cannot be handled any
other way.  If the status bit change does not generate an interrupt, but
the wait for the change takes a few microseconds, what else are you
going to do?

The way I see it, I'm just extending the idea behind cpu_relax().  Just
doing a search for cpu_relax shows dozens, maybe hundreds, of drivers
doing stuff like this:

	while((inb(ioaddr+DAYNA_CARD_STATUS)&DAYNA_TX_READY)==0)
		cpu_relax();

This code doesn't even have a timeout!  In fact, I'd say that at least
90% of all uses of cpu_relax() are in a while loop reading some register
without a timeout.

Ironically, in the situations where there is a timeout, the drivers use
jiffies, not a delay.

Frankly, I just don't see how spin_event_timeout() is not an improvement
 over the current code that drivers use.

-- 
Timur Tabi
Linux kernel developer at Freescale
