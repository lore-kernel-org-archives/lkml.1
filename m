Return-Path: <linux-kernel-owner+w=401wt.eu-S1423039AbXDXTTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423039AbXDXTTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 15:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423040AbXDXTTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 15:19:22 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2189 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423039AbXDXTTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 15:19:21 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Alex Vorona" <voron@amhost.net>, <linux-kernel@vger.kernel.org>
Subject: RE: Re[2]: sendfile to nonblocking socket
Date: Tue, 24 Apr 2007 12:19:08 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKCEGNDEAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <1211570752.20070424143348@amhost.net>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 24 Apr 2007 13:19:29 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 24 Apr 2007 13:19:30 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> DS> Threads plus epoll is another.

> 20k threads and maybe more is too much :). Look at http://nginx.net/
> senction "Architecture and scalability" for example.
> DS> It really depends upon how much performance you need
> all, that hardware can take and hold :)

Why would you want 20k threads? You aren't seriously suggesting that you
need to have 20,000 outstanding disk operations, are you? Surely you don't
think that would be efficient. If the disk is the limiting factor, it may
get slightly faster as you pend more concurrent requests, but surely 20,000
is not the best number! (256 is probably closer to the optimal value, and it
may be less.)

Your application has to manage the outstanding disk read requests. I don't
know of any way to foist this task on the kernel. Perhaps a pool of disk
read threads?

I would keep a flag for each connection to track whether the last write got
a 'would block' or was incomplete. So long as this flag is clear, let the
disk read thread attempt the socket 'write'. If the disk read thread gets a
partial write (or a would block indication), set the flag on the socket and
let the socket I/O threads takeover the connection (based on 'epoll'
notification). When a write completes and you need more disk data, clear the
flag and let the disk read threads takeover the connection until a write
blocks again. (This disk read threads can use 'sendfile' or 'splice' so long
as they don't block on the socket.)

Perhaps the disk read threads should be using 'mmap' with MAP_POPULATE.

There are certainly many possible approaches.

DS


