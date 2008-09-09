Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbYIINAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbYIINAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 09:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbYIINAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 09:00:40 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:49822 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbYIINAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 09:00:40 -0400
Message-ID: <48C67374.1000108@skyrush.com>
Date: Tue, 09 Sep 2008 07:00:36 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080727)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY: Fix loss of echoed characters (2nd follow-on PATCH
 attached)
References: <200807252257.m6PMvieO003213@imap1.linux-foundation.org>	<48AC3A16.4080209@skyrush.com>	<48B3F9F7.2050503@skyrush.com>	<48C54EC2.4060901@skyrush.com> <20080908173250.2452c5b8.akpm@linux-foundation.org>
In-Reply-To: <20080908173250.2452c5b8.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 08 Sep 2008 10:11:46 -0600
> Joe Peterson <joe@skyrush.com> wrote:
> 
>> +	spin_lock_irqsave(&tty->echo_lock, flags);
>>  	lock_kernel();
> 
> Taking a spinlock outside lock_kernel() isn't good, and is quite unusual.
> - It might be ab/ba deadlockable (I didn't check) (I trust you always
>   test with lockdep enabled?)

Indeed - and, as Alan said, lock_kernel() can sleep (a nuance I had not
realized until looking more into the kernel locking mechanisms just
now).  Although I have seen no issues during testing (and I do have
lockdep in the kernel), you are 100% right.

I had wanted to keep from disturbing the locking situation in n_tty, but
maybe it is time to get rid of the BKL there.

My echo buffer patches actually isolate the tty column state stuff to
the output processing functions now anyway, so the BLK may not really be
necessary at this point.  This inspires me to look into this.

> swapping the above two lines would presumably be an easy fix, but one
> wonders whether we still need lock_kernel() in there once you've added
> this lock.

I don't think this is a good idea either, since I don't want to spinlock
during the output processing, which calls the driver output func.  I
think a mutex is more appropriate anyway (and there are some already
defined and in use for tty write locking, etc.) - let me know if you
think otherwise.  I will play around with this and re-post a patch for
review soon.

						-Thanks, Joe
