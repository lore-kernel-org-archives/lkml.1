Return-Path: <linux-kernel-owner+w=401wt.eu-S967737AbXEHD5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967737AbXEHD5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 23:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967721AbXEHD5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 23:57:17 -0400
Received: from smtpout.mac.com ([17.250.248.171]:59055 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967720AbXEHD5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 23:57:17 -0400
In-Reply-To: <a36005b50705071949r4f45194bhc0c0416db28d1560@mail.gmail.com>
References: <20070504225730.490334000@haxent.com.br> <463BC3CA.6050109@haxent.com.br> <Pine.LNX.4.64.0705051155210.19104@alien.or.mcafeemobile.com> <463CFA37.3020809@haxent.com.br> <a36005b50705071400p5302da05n7d27ec1995b9d4dc@mail.gmail.com> <463F9B68.305@haxent.com.br> <a36005b50705071519k40449ed2p7b9ece22cc19219a@mail.gmail.com> <Pine.LNX.4.64.0705071525200.29173@alien.or.mcafeemobile.com> <a36005b50705071949r4f45194bhc0c0416db28d1560@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <EDEE9581-CA5B-4DC3-99A0-C28780B1A747@mac.com>
Cc: Davide Libenzi <davidel@xmailserver.org>, Davi Arnaut <davi@haxent.com.br>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] rfc: threaded epoll_wait thundering herd
Date: Mon, 7 May 2007 23:56:40 -0400
To: Ulrich Drepper <drepper@gmail.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 07, 2007, at 22:49:04, Ulrich Drepper wrote:
> On 5/7/07, Davide Libenzi <davidel@xmailserver.org> wrote:
>> read(2) is a cancellation point too. So if the fine userspace code  
>> issues a random pthread_cancel() to a thread handling that, data  
>> is lost together with the session that thread was handling.
>
> This is absolutely not comparable.  When read/write is canceled no  
> data is lost.  Some other thread might have to pick up the slack  
> but that's it.

Uhh, how can you claim "no data is lost" in this scenario:

A bunch of threads shares a common fd and fpos, reading fixed-size  
records:

thread1: read(myfd, per_thread_buf, 512);
thread2: pthread_cancel(thread1);
thread3: read(myfd, per_thread_buf, 512);

This is *exactly* analogous to the epoll() scenario:  A bunch of  
threads are attempting to get data (either events or records) from a  
given object.  If thread1 gets cancelled after the completion of its  
read() syscall then the file position will have been advanced but the  
data in the per-thread buffer will be discarded.  The third thread  
won't (reliably) get the same data as thread1.  It might get it  
randomly on occasion if file position updates race, but you can't  
rely on that behavior.

Here's how you make both of those models safe against thread  
cancellation (assuming, of course, that process_one_buf has no  
cancellation points until after it saves the buffer state somewhere):

char per_thread_buf[512];
pthread_setcanceltype(PTHREAD_CANCEL_DEFERRED, NULL);
pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, NULL);
while (read(fd, per_thread_buf, 512) == 512) {
	pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, NULL);
	process_one_buffer(per_thread_buf);
	pthread_testcancel();
	pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, NULL);
}
pthread_exit(NULL);

Look how trivial that is!  Isn't it fun?  Of course, once you look at  
it this way you could do the same verbose crap that pthread_cancel/ 
pthread_setcancelstate/pthread_testcancel are doing with a simple int  
protected by a pthread_mutex.

Cheers,
Kyle Moffett

