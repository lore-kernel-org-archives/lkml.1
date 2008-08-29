Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbYH2PzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbYH2PzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 11:55:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbYH2Pyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 11:54:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:60855 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbYH2Pyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 11:54:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch 0/5] Nano/Microsecond resolution for select() and poll()
Date: Fri, 29 Aug 2008 17:54:27 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de,
       torvalds@linux-foundation.org, David Woodhouse <dwmw2@infradead.org>
References: <20080829080549.6906b744@infradead.org>
In-Reply-To: <20080829080549.6906b744@infradead.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808291754.28241.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX184W9hzpynBspuTKJT17gNCOEJ+hVnAHWFlF/L
 e069qL6DxSNW/eaYTEIL6HBquHm8N1vT0ZFQnNxCOeA1ZTHeO+
 OqxJ8kn0fYBTydSfoCnyw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 August 2008, Arjan van de Ven wrote:

> With this patch series, the internals of select() and poll() interfaces are
> changed such that they work on the nanosecond level (using hrtimers). The
> userspace interface for select() is in microseconds, for pselect() and
> ppoll() this is in nanoseconds.

Nice work, seems a lot better thought through than my previous attempt [1],
which unfortunately never saw any reactions.
 
> even though poll() (as opposed to ppoll()) only accepts milliseconds
> as userspace interface, the behavior will still improve because the current
> time no longer needs to be rounded up to the next jiffie, so on average
> a 500 milliseconds behavior improvement.

That would be 500 microseconds I think.

> I'd like to get rid of the jiffies timeout entirely over time, and
> only use hrtimers (makes the code a lot nicer) but that's for now
> a separate step, first I'd like to see how this change pans out. 

You mean entirely entirely getting rid of jiffies in the kernel, or just
with user facing interfaces like epoll_wait, rt_sigtimedwait etc?

I think if we want to replace more code with hr timers, we will need
something like dwmw2's range timers based on that in order to keep the
wakeup rate low. These are still jiffies based, which doesn't help
your case, but they should be easy to change to ktime or timespec.

	Arnd <><

[1] http://www.ussg.iu.edu/hypermail/linux/kernel/0703.0/1319.html
[2] http://lwn.net/Articles/291159/
