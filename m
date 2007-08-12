Return-Path: <linux-kernel-owner+w=401wt.eu-S933931AbXHLQei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933931AbXHLQei (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 12:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbXHLQeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 12:34:31 -0400
Received: from smtpserver.stunet.se ([85.194.0.110]:41321 "EHLO mail.visit.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbXHLQea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 12:34:30 -0400
In-Reply-To: <20070812161337.3828381c@the-village.bc.nu>
References: <70E19A0A-2728-4ADA-B984-A36182C1F575@nocrew.org> <20070812161337.3828381c@the-village.bc.nu>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <A94120FD-315A-45B7-A8F4-8DC8DC21279E@nocrew.org>
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Fredrik Noring <noring@nocrew.org>
Subject: Re: Improving read/write/close system call reliability when used with pthreads
Date: Sun, 12 Aug 2007 18:33:31 +0200
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

Alan Cox wrote:
> The reader still has the fd open so the fd is not yet closed. This  
> seems
> completely sane to me. Closing the *writer* fd would create an EOF  
> which
> is the proper response.

The fd is removed from the file descriptor table, but sure the file  
(as in the kernel struct file * pointer) is still valid. The problem  
is that the fd used when entering the system call, as an alias for  
the file pointer, is no longer valid. As a consequence, -ERESTARTSYS  
no longer works reliably.

Second problem is that a process may not always have access to the  
writer fd and therefore may not be able to close it. So when closing  
the reader fd the process has to rely on the following:

- Having a signal such as SIGALRM wake up the reader (in case the  
writer misbehaves indefinitely). This results in -EBADF returned,  
provided:

- Hope that the fd has not been reused meanwhile (in which case the  
reader likely will begin reading the wrong file when it wakes up).

Applications can take either of two approaches:

1) Never close reader fd, but wouldn't it be practical to be able to  
make things like a threaded watchdog?

2) Do close reader fd, but what results can then applications  
reliably expect? What would be the sane intention of applications  
closing reader fd? Do programmers expect all of the current results?

POSIX appears to leave it "implementation-defined" provided I  
interpret this correctly, of course. So wouldn't it be great to make  
one of the current results a reliable feature?

(A "reader" could be a "writer" above for similar cases.)

All the best,
Fredrik

