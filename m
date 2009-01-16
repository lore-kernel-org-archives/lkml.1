Return-Path: <linux-kernel-owner+w=401wt.eu-S932708AbZAPQ21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708AbZAPQ21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 11:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760118AbZAPQ2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 11:28:15 -0500
Received: from p02c12o145.mxlogic.net ([208.65.145.78]:55181 "EHLO
	p02c12o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759176AbZAPQ2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 11:28:13 -0500
Message-ID: <4970B59A.9090807@steeleye.com>
Date: Fri, 16 Jan 2009 11:28:10 -0500
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Swiftdove 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: nbd: add locking to nbd_ioctl
References: <20090116115512.GA10771@elf.ucw.cz> <4970A696.9070307@steeleye.com> <20090116153603.GD2022@elf.ucw.cz>
In-Reply-To: <20090116153603.GD2022@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2009 16:28:10.0446 (UTC) FILETIME=[6BB596E0:01C977F7]
X-Spam: [F=0.2000000000; S=0.200(2008120801)]
X-MAIL-FROM: <paul.clements@steeleye.com>
X-SOURCE-IP: [207.43.68.209]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Fri 2009-01-16 10:24:06, Paul Clements wrote:
>> Pavel Machek wrote:
>>> The code was written with "oh big kernel lock, please protect me from
>>> all the evil" mentality: it does not locks its own data structures, it
>>> just hopes that big kernel lock somehow helps.
>>>
>>> It does not. (My fault).
>>>
>>> So this uses tx_lock to protect data structures from concurrent use
>>> between ioctl and worker threads.
>> What is the particular problem that this fixes? I thought we had already  
>> been careful to take tx_lock where necessary to protect data structures.  
>>   Perhaps there is something I missed?
> 
> for example lo->sock / lo->file are written to without holding any
> lock in current code. (lo->xmit_timeout has similar problem, and other
> fields, too).

lo->sock is only modified under tx_lock (except for SET_SOCK, where the 
device is being initialized, in which case it's impossible for any other 
thread to be accessing the device)

no one else uses lo->file except for the ioctls

I agree that if you really misuse the ioctls you could potentially get 
yourself in trouble with the xmit_timeout (the timer not being deleted 
or initialized properly if you hit the correct window). Taking tx_lock 
would prevent this.

As for other fields, I assume you're talking about blksize, et al. 
Taking tx_lock doesn't prevent you from screwing yourself if you modify 
those while the device is active. You'd need to disallow those ioctls 
when the device is active (check lo->file). Again, this is only going to 
happen if you really misuse the ioctls.

--
Paul
