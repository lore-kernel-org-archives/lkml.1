Return-Path: <linux-kernel-owner+w=401wt.eu-S1760637AbZASO51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637AbZASO51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbZASO5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:57:07 -0500
Received: from p02c12o145.mxlogic.net ([208.65.145.78]:53045 "EHLO
	p02c12o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbZASO5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:57:05 -0500
Message-ID: <497494BB.3080800@steeleye.com>
Date: Mon, 19 Jan 2009 09:56:59 -0500
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Swiftdove 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: nbd: add locking to nbd_ioctl
References: <20090116115512.GA10771@elf.ucw.cz> <4970A696.9070307@steeleye.com> <20090116153603.GD2022@elf.ucw.cz> <4970B59A.9090807@steeleye.com> <20090119095459.GA11187@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20090119095459.GA11187@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jan 2009 14:56:59.0798 (UTC) FILETIME=[2E303360:01C97A46]
X-Spam: [F=0.2000000000; S=0.200(2008120801)]
X-MAIL-FROM: <paul.clements@steeleye.com>
X-SOURCE-IP: [207.43.68.209]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>> Pavel Machek wrote:
>>> On Fri 2009-01-16 10:24:06, Paul Clements wrote:

>> lo->sock is only modified under tx_lock (except for SET_SOCK, where the 
>> device is being initialized, in which case it's impossible for any other 
>> thread to be accessing the device)
> 
> Well, unless the user is evil or confused? :-).

Even in that case, you're just going to get EBUSY. Nothing bad will 
happen. SET_SOCK checks for lo->file, so it cannot be called on an 
active nbd device.


>> As for other fields, I assume you're talking about blksize, et al. 
>> Taking tx_lock doesn't prevent you from screwing yourself if you modify 
>> those while the device is active. You'd need to disallow those ioctls 
>> when the device is active (check lo->file). Again, this is only going to 
>> happen if you really misuse the ioctls.
> 
> Ok, I'll take a look at the missing checks. I'd really like to make
> this "stable" -- no amount of misuse should crash the kernel.

Just to summarize, I don't think we need to hold tx_lock around the 
entirety of nbd_ioctl. We do need one extra tx_lock around xmit_timeout 
and we do need to check for lo->file and return EBUSY in all of the 
SET_*SIZE* ioctls.

Thanks,
Paul

