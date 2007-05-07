Return-Path: <linux-kernel-owner+w=401wt.eu-S966906AbXEGVBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966906AbXEGVBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 17:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966630AbXEGVBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 17:01:00 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:10639 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966624AbXEGVA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 17:00:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K7dlYOXTkfY031qW7GI/XK438mZI1PsBICh5q7knSixkF01EY/j2hBnYWcSXOdFysQpFJVwtrNwrSJoiSh7KbiNFoREhWyN8JJvTRQ9oWcQmZu1Y4KPs7Mg3uMbzyTIKbklEUFy9eRKBJKs8AQ2f2jWhLHbT7BQXfGTFmzMdWeo=
Message-ID: <a36005b50705071400p5302da05n7d27ec1995b9d4dc@mail.gmail.com>
Date: Mon, 7 May 2007 14:00:58 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Davi Arnaut" <davi@haxent.com.br>
Subject: Re: [PATCH] rfc: threaded epoll_wait thundering herd
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <463CFA37.3020809@haxent.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070504225730.490334000@haxent.com.br>
	 <463BC3CA.6050109@haxent.com.br>
	 <Pine.LNX.4.64.0705051155210.19104@alien.or.mcafeemobile.com>
	 <463CFA37.3020809@haxent.com.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/07, Davi Arnaut <davi@haxent.com.br> wrote:
> A google search turns up a few users. It also addresses some complaints
> from Drepper.

There is a huge problem with this approach and we're back at the
inadequate interface.

select/poll/epoll are thread cancellation points.  I.e., the thread
can be canceled before returning to the user.  If this cancellation
happens between the kernel deciding to give this thread the event (and
no other thread) and the thread testing for cancellation in the libc
wrapper around the syscall, then the event is lost and the process(es)
might hang.

With kevent we in the end fixed the problem by requiring that part of
the cancellation handling the thread tries to wake up another thread
waiting for the event queue.  This is easily possible since the event
data is in the shared memory segment and it's just purely the thread
wakeup that is needed.

To make something like this work for poll you'd have to push back the
revents fields of the result back to the kernel which might then cause
another thread to be woken up.  I find this too ugly to consider.  You
guys will not believe this but I really thought all these things
through before writing the OLS paper.  poll cannot be salvaged.


There is another thing about this selective wakeup: do I assume it
correctly that if more than one file descriptor is reported ready more
than one thread is woken?  I think nothing else can be justified.
Will in this case both threads get the same set of descriptors
reported or will they see disjunct sets?
