Return-Path: <linux-kernel-owner+w=401wt.eu-S1757636AbXJKDX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636AbXJKDX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 23:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756571AbXJKDXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 23:23:51 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:24485 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756587AbXJKDXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 23:23:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=DLzI3JzaDGHCRh+r3ztAmZ/uHusd3jmKDDDb2iBbuW8w4OW625c02e8a7Ny6mHGCCFFlPbWUXr2C9JyfQR7iy8rkAyC4b6VIrvTdTW6v224BiqwFTQjs1HMJ/NvOwHayPjLyCGeAuI7SqBM9x9hbgkRcVXK/11vtEavIg6CF6Kw=  ;
X-YMail-OSG: IzhclxcVM1kTEpbD8TYxh.WMqY5rNSAa6tqtFwF9IGsTb2GP
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Berkley Shands <berkley@cse.wustl.edu>
Subject: Re: 2.6.23 spinlock hang in kswapd under heavy disk write loads
Date: Wed, 10 Oct 2007 20:52:07 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20071010153332.71479CECBD@tamarack.cse.wustl.edu> <200710101531.26944.nickpiggin@yahoo.com.au> <470EC64C.10402@cse.wustl.edu>
In-Reply-To: <470EC64C.10402@cse.wustl.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710102052.07539.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 October 2007 10:56, Berkley Shands wrote:
> 100% reproducible on the two motherboards in question.
> Does not happen on any other motherboard I have in my possession
> (not tyan, not uniwide, not socket 940...)
>
> No errors, no dmesg, nothing with debug_spinlock set.
> <sysrq> shows lots (when it works), but by then too many things are
> locked up to be of much use. I can get into KDB and look around
> (2.6.22 for kdb - it hangs there too). Even access to the local disk is
> blocked.
> Processes in core and running remain there (iostat, top, ...).
> I personally think the bios are suspect on the PCIe, as symptoms change
> with the bios rev. I did a major paper on SAS performance with one H8DMi,
> but it got a bios rev, and now crashes. Missed interrupt? APIC sending an
> interrupt to multiple cpus? I don't know.
>
> Tell me what to look at, and I can get you the info. It usually takes 20
> seconds
> to go bang, using either the LSI8888ELP or the rocket raid 2340. Other
> controllers
> are too slow. 2.6.20 does not lock up. It is also 200MB/Sec slower in
> writing :-)
>
> thanks for the response.

OK, it does sound suspiciously like a hardware bug, or some
unrelated software bug that is causing memory scribbles...

A few things you could do.

One is that you could verify that it indeed is the kswapd_wait
spinlock that it is spinning on, and then when you see the lockup,
you could verify that no other tasks are holding the lock. (it is
quite an inner lock, so you shouldn't have to wade through call
chains...). That would confirm corruption. Dumping the lock
contents and the fields in the structure around the lock might
give a clue.

You could put the spinlock somewhere else and see what happens
(move it around in the structure, or get even more creative...).
or do something like have 2 spinlocks, and when you encounter
the lockup, verify whether or not they agree.

(It sounds like you're pretty capable, but if you want me to have
a look at doing a patch or two to help, let me know.)

Another is to bisect the problem, however as you say the kernel
is going slower, so you may just bisect to the point where it
is sustaining enough load to trigger the bug, so this may not be
worth you time just yet.

You could _try_ turning on slab debugging. If there is random
corruption, it might get caught. Maybe it will just change
things enough to hide the problem though.

Thanks for reporting!
