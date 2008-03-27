Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbYC0MgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbYC0MgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 08:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759393AbYC0Mf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 08:35:58 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:37394 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756799AbYC0Mf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 08:35:57 -0400
Message-ID: <47EB94AB.6090608@steeleye.com>
Date: Thu, 27 Mar 2008 08:35:55 -0400
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Swiftdove 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Mike Snitzer <snitzer@gmail.com>
CC: nbd-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: nbd: Oops because nbd doesn't prevent NBD_CLEAR_SOCK while sock_xmit()
 is working on a receive
References: <170fa0d20803261143s1ab258b2ra470c158ac5744a@mail.gmail.com>
In-Reply-To: <170fa0d20803261143s1ab258b2ra470c158ac5744a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Snitzer wrote:

> In practice this looks like:
> 
> nbd1: NBD_DISCONNECT
> nbd1: Send control failed (result -32)
> end_request: I/O error, dev nbd1, sector 0
> end_request: I/O error, dev nbd1, sector 8032264
> md: super_written gets error=-5, uptodate=0
> raid1: Disk failure on nbd1, disabling device.
>         Operation continuing on 1 devices
> Unable to handle kernel NULL pointer dereference at 0000000000000028 RIP:
>  [<ffffffff88b1e125>] :nbd:sock_xmit+0x9d/0x301

> The fact that sock_xmit() in receive mode is unprotected seems to be
> the WHY a NULL pointer is possible; but I'm still trying to identify
> the HOW.

Do you know who is setting the socket NULL? Is it already NULL when you 
get to this point? Is it the nbd-client -d? Is it the original 
nbd-client/kernel that does it? Figuring that out would help narrow down 
the cause.

> But for me this begs the question:  why isn't the nbd_device's socket
> always protected during sock_xmit() for both
> transmits and receives; rather than just transmits (via tx_lock)!?

It would deadlock if we held the lock over both. Generally we don't have 
to worry about receives, since they're always done in the nbd-client 
process, so we have control over when and how it exits and cleans up. 
The odd case, as you've discovered, is when another process (nbd-client 
-d) comes along and starts mucking with the queue and socket. Would 
"kill -9 <nbd-client-pid>" work for you instead? That is what I use to 
break the connection, and it's safe, as it tells the original nbd-client 
to exit (which it does cleanly and safely).

--
Paul
