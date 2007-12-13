Return-Path: <linux-kernel-owner+w=401wt.eu-S932579AbXLMVtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579AbXLMVtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbXLMVtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:49:07 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:57928 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbXLMVtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:49:06 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 13 Dec 2007 13:49:04 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk.manpages@googlemail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, tytso@thunk.org,
       Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@suse.de>,
       Christoph Hellwig <hch@lst.de>,
       Linux Torvalds <torvalds@linux-foundation.org>
Subject: Re: Tesing of / bugs in new timerfd API
In-Reply-To: <47614369.3060906@gmail.com>
Message-ID: <Pine.LNX.4.64.0712131333030.10881@alien.or.mcafeemobile.com>
References: <47614369.3060906@gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2007, Michael Kerrisk wrote:

> Davide, Andrew,
> 
> I applied Davide's v3 patchset (sent into LKML on 25 Nov) against
> 2.4.24-rc3, and did various tests (all on x86).  Several tests
> were done using the program at the foot of this mail.  Various others
> were done by cobbling together bits of code that I haven't included
> here.

Thanks for such a thorough test Michael.



> Tested: after setting a CLOCK_REALTIME timer with the
> TFD_TIMER_ABSTIME flag to expire at some time in the past with
> a non-zero interval (e.g., setting 100 seconds in the past, with
> a 5 second interval), read() from the file descriptor returns
> the correct number of expirations (e.g., 20).
> 
> This seems a reasonable thing to do, I suppose.  However, while
> playing around to test this, I found what looks like a bug (see
> below).
> 
> BUG 1:
> However, this test exposed what looks like a bug: if I set a
> CLOCK_REALTIME clock to expire in the past, with a very small
> interval, then the maximum number of expirations that can be
> returned via read seems to be limited to 32 bits, even though
> we have a 64-bit value for returning this information.
> I haven't checked the kernel source to determine where this
> bug is.

Yes, true. Right now hrtimer_forward() (that we use to get the "missed" 
ticks) returns an unsigned long, that on 32 bit is (duh!) 32 bit :)
But hrtimer_forward() has all in place to just return an u64. So, Thomas, 
would it be OK to have hrtimer_forward() (and the new hrtimer_forward_now())
to return a u64?




> BUG 2:
> The last sentence does not match the implementation.
> (Nor is it consistent with the behavior of POSIX timers.
> And I *think* things did work correctly in the original
> timerfd() implementation, but I have not gone back to check.)
> 
> Suppose that we set an absolute timer to expire 100 seconds
> in the future.  Then according to this sentence of the man
> page then each subsequent call to timerfd_gettime() should
> retrun an itimerspec structure whose it_value steadily
> decreases from 100 to 0 (when the timer expires).  (This
> is the behavior in the analogous situation with POSIX timers
> and with setitimer()/getitimer().)
> 
> However, the implementation of timerfd_gettime() always
> returns the "time when the timer would next expire", and
> this value depends on whether TFD_TIMER_ABSTIME was specified
> when setting the timer.

This is been like that from the beginning of the new API. So no, the 
previous was behaving exactly the same WRT this feature.
Is this something really needed?



- Davide


