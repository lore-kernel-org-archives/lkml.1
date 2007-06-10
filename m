Return-Path: <linux-kernel-owner+w=401wt.eu-S1753676AbXFJJQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbXFJJQp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 05:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbXFJJQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 05:16:37 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:47199 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbXFJJQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 05:16:36 -0400
Message-ID: <466BC0E3.4050600@cosmosbay.com>
Date: Sun, 10 Jun 2007 11:14:11 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Al Viro <viro@ftp.linux.org.uk>, Kyle Moffett <mrmacman_g4@mac.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
References: <20070609003622.GB4095@ftp.linux.org.uk> <466A0020.50406@redhat.com> <20070609014140.GC4095@ftp.linux.org.uk> <466A0BFB.3070908@redhat.com> <20070609151521.GD4095@ftp.linux.org.uk> <466AD4BA.80407@redhat.com> <20070609165454.GE4095@ftp.linux.org.uk> <466ADEAB.7080202@redhat.com> <20070609172429.GF4095@ftp.linux.org.uk> <2E51520E-EC73-457F-809A-4749ED9A3C97@mac.com> <20070609200645.GG4095@ftp.linux.org.uk> <alpine.LFD.0.98.0706091311040.20321@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706091311040.20321@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sun, 10 Jun 2007 11:14:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds a écrit :
> (And dammit, that _is_ a *real*issue*. No races necessary, no NR_OPEN 
> iterations, no even *halfway* suspect code. It's perfectly fine to do
> 
> 	close(0);
> 	close(1);
> 	close(2);
> 	.. generate filenames, whatever ..
> 	if (open(..) < 0 || open(..) < 0 || open(..) < 0)
> 		die("Couldn't redirect stdin/stdout/stderr");
> 
> and there's absolutely nothing wrong with this kind of setup, even if you 
> could obviously have done it other ways too (ie by using "dup2()" instead 
> of "close + open"),
> 

This kind of setup was OK 25 years ago, before multithreading era.
You cannot reasonably expect it to work in a multithreaded program.

Anyway, I would like to give an alternative idea of the double fdmap, and 
probably more *secure* .

Current fd API mandates integers (32 bits)

Lot of broken code consider a fd must be >= 0, so we currently are limited to 
31 bits.

With NR_OPEN = 1024*1024 = 2^20, that give us 11 bits that we could use as a 
signature.

That is, we could use O_NONSEQ as a indication to kernel to give us a 
composite fd : 20 low order bits give the slot in file table, then 11 bits can 
  be use to make sure the fd was not stolen by malicious code.


Legacy app, (without O_NONSEQ in flags) would get POSIX compatables fd in [0, 
2^20-1] range, with the lowest available fd.

If O_NONSEQ is given, kernel is free to give an fd in [0, 2^31 - 1], with a 
strategy that could be the one Davide gave in its patch (with a list of 
available slots). But instead of FIFO, we can use now LIFO, more cache friendly.

In fget()/fget_light()/close(), we can then use 20 bits to select the slot in 
the single fdmap.
And 11 bits to check the 'signature'.

So if open( O_NONSEQFD) gave us 0x77000010, we cannot do close(0x10) or 
read(0x10, ....)

Storage for these bits is already there in Davide fd_slot structure, where we 
currently use one long to store 3 bits 'only'.

This should work even bumping NR_OPEN to say... 8*1024*1024, and 8 bits signature.

