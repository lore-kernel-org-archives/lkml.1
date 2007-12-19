Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbXLSMzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbXLSMzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 07:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbXLSMzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 07:55:35 -0500
Received: from mout2.freenet.de ([195.4.92.92]:38310 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbXLSMze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 07:55:34 -0500
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC/PATCH] 2.6.24-rcx: Make sys_poll() wait at least timeout ms
Date: Wed, 19 Dec 2007 13:55:25 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: linux-kernel@vger.kernel.org
References: <fa.QbT8/KZb1MTA5+n7SD6kFi6mqso@ifi.uio.no> <200712190206.56428.fzu@wemgehoertderstaat.de> <4768820E.9050700@shaw.ca>
In-Reply-To: <4768820E.9050700@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712191355.25993.fzu@wemgehoertderstaat.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 19. Dezember 2007 schrieb Robert Hancock:
> Karsten Wiese wrote:
> > Am Mittwoch, 19. Dezember 2007 schrieb Robert Hancock:
> >> That seems fishy. What is your value of HZ and what is the timeout value 
> >> that was passed in the bad case?
> > 
> > HZ set to 250, timeout to 4ms.
> > Time spent in poll() taken by clock_gettime(CLOCK_MONOTONIC, &time)
> > before and after poll()call: i.e 62us.
> > Time measured with hpet gave 166us once.
> 
> msecs_to_jiffies (kernel/time.c) has this:
> 
> #if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
> 	/*
> 	 * HZ is equal to or smaller than 1000, and 1000 is a nice
> 	 * round multiple of HZ, divide with the factor between them,
> 	 * but round upwards:
> 	 */
> 	return (m + (MSEC_PER_SEC / HZ) - 1) / (MSEC_PER_SEC / HZ);
> 
> With HZ=250 and m=4 this gives 7/4 or only 1 jiffy, which is not more 
> than 4ms, but if we are already at near the end of the current jiffy it 
> could be much less than that (potentially almost no time at all).
> 
> Maybe we could convert poll to use a hrtimer for this instead?

That wouldn't fix configs without hrtimers.

The linux manpage reflects current behaviour:
from man2/poll.2.gz
"The timeout argument specifies an upper limit on the time for which
poll() will block, in milliseconds."
To achieve "at least" timeouts we'd have to add a jiffy's ms to the
timeout in userspace.

I'd like to let sys_poll() behave according to posix's manpage:
from man3p/poll.3p.gz
"poll() shall wait at least timeout milliseconds"
Thats easier to specify in userspace. No need to know the running kernel's
HZ.

Above posix/linux difference also shows in select() manpages.
epoll_wait() (linux only) manpage also says "maximum time of timeout"
A more complete patch would tweek (p)poll (p)select and epoll_(p)wait.
There are possibly more syscalls affected that I'm not aware off.

Is there upstream interest?

      Karsten
