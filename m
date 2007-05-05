Return-Path: <linux-kernel-owner+w=401wt.eu-S1767983AbXEEEPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767983AbXEEEPf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 00:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767984AbXEEEPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 00:15:35 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:35482 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031733AbXEEEPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 00:15:34 -0400
Message-ID: <463C04C6.7000205@cosmosbay.com>
Date: Sat, 05 May 2007 06:15:02 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Davi Arnaut <davi@haxent.com.br>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rfc: threaded epoll_wait thundering herd
References: <20070504225730.490334000@haxent.com.br> <463BC3CA.6050109@haxent.com.br>
In-Reply-To: <463BC3CA.6050109@haxent.com.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 05 May 2007 06:15:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davi Arnaut a écrit :
> Hi,
> 
> If multiple threads are parked on epoll_wait (on a single epoll fd) and
> events become available, epoll performs a wake up of all threads of the
> poll wait list, causing a thundering herd of processes trying to grab
> the eventpoll lock.
> 
> This patch addresses this by using exclusive waiters (wake one). Once
> the exclusive thread finishes transferring it's events, a new thread
> is woken if there are more events available.
> 
> Makes sense?
> 

Yes it makes sense.

But... what happens if the thread that was chosen exits from the loop in 
ep_poll() with res = -EINTR (because of signal_pending(current))


Me thinks in this case some ready events can wait forever (up to next 
ep_poll_callback() or another thread enters ep_poll())


