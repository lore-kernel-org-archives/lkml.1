Return-Path: <linux-kernel-owner+w=401wt.eu-S932081AbXCHRQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbXCHRQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 12:16:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932074AbXCHRQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 12:16:09 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53043 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081AbXCHRQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 12:16:08 -0500
Date: Thu, 8 Mar 2007 09:15:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: "David M. Lloyd" <dmlloyd@flurg.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/5] signalfd v2 - signalfd core ...
In-Reply-To: <Pine.LNX.4.64.0703080825420.7015@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0703080852170.10832@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703071712210.3672@alien.or.mcafeemobile.com>
 <1173364264.6891.3.camel@localhost> <Pine.LNX.4.64.0703080742220.7015@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703080812290.10832@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703080825420.7015@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Mar 2007, Davide Libenzi wrote:
> 
> The reason for the special function, was not to provide a non-blocking 
> behaviour with zero timeout (that just a side effect), but to read the 
> siginfo. I was all about using read(2) (and v1 used it), but when you have 
> to transfer complex structures over it, it becomes hell. How do you 
> cleanly compat over a f_op->read callback for example?

I agree that it gets a bit "interesting", and one option might be that the 
"read()" interface just gets the signal number and the minimal siginfo 
information, which is, after all, what 99% of all apps actually care
about.

But "siginfo_t" is really a *horrible* structure. Nobody sane should ever 
use siginfo_t, and the designer of that thing was so high on LSD that it's 
not even funny. Re-using fields in a union? Values that depend on other 
bits in the thing in random manners? 

In other words, I bet that we could just make it a *lot* better by making 
the read structure be:

 - 16 4-byte fields (fixed 64-byte packet), where each field is an 
   uint32_t (we could even do it in network byte order if we care and if 
   you want to just pipe the information from one machine to another, but 
   that sounds a bit excessive ;)

 - Just put the fields people actually use at fixed offsets: si_signo, 
   si_errno, si_pid, si_uid, si_band, si_fd.

 - that still leaves room for the other cases if anybody ever wants them 
   (but I doubt it - things like si_addr are really only useful for 
   synchronous signals that are actually done as *signals*, since you 
   cannot defer a SIGBUS/SIGSEGV/SIGILL *anyway*).

So I bet 99% of users actually just want si_signo, while some small subset 
might want the SIGCHLD info and some of the special cases (eg we migth 
want to add si_addr as a 64-bit thing just because the USB stack sends a 
SI_ASYNCIO thing for completed URB's, so a libusb might want it, but 
that's probably the only such user).

And it would be *cleaner* than the mess that is siginfo_t..

(I realize that siginfo_t is ugly because it built up over time, using the 
same buffer for many different things. I'm just saying that we can 
probably do better by *not* using it, and just laying things out in a 
cleaner manner to begin with, which also solves any compatibility issues)

		Linus
