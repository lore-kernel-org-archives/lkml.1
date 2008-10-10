Return-Path: <linux-kernel-owner+w=401wt.eu-S1760765AbYJJQnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765AbYJJQnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758412AbYJJQnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:43:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:46398 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758159AbYJJQnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:43:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=niyYMziu6NJvrvlzG9/biONGvW8YeQmq3qsoZFLhcf66U/UpQbZM/tvuPkGcW1OWan
         ijFtQocmi4BrRgtlm2zqIJza6nBdFw1ckTkbl+KBaMeP25TlIFxcikIBVbZkbqSNGiQ6
         MhSAqjUp6hCm3UlLJKuR/j05aJl1KG48tO5v4=
Message-ID: <23165e010810100943ua84228cn2faa03a5eb59255@mail.gmail.com>
Date: Fri, 10 Oct 2008 18:43:21 +0200
From: "Nicolas Cannasse" <ncannasse@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: recv() hangs until SIGCHLD ?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We've been tracking a bug in our server application for some time now,
and now that we could isolate it we're stuck without a meaningful
explanation. Hope somehow would be able to give use some answers.

We run a multithread application which is using pthreads and sockets.
A thread uses accept() then dispatch the socket to one of the workers
threads that process it. Sockets are then not used simultaneously by
several threads.

In some rare cases, one (or several) threads are hanging in recv().
Both lsof and ls /proc/<pid>/fd show that the socket used is in
ESTABLISHED mode but when checking on the host on which it's connected
(a mysql DB) we can't find the corresponding client socket (as it's
been closed already on the other side).

We are using the Boehm GC which uses the signals SIGXCPU and SIGPWR to
pause+restart the threads when running a GC cycle. We are correctly
handling EINTR in send() and recv() by restarting the call in case
they get interrupted this way.

However, when attaching GDB to our locked thread it seems that even
when the GC runs, recv() does not exit (the breakpoint after it is not
reached). If we send SIGCHLD to the hanging thread with GDB, recv()
does exit and the thread is correctly unlocked. If we don't, it will
hang forever.

Additional details : recv() is using MSG_NOSIGNAL and we have enabled
TCP_NODELAY on the socket by using setsockopt. Some other
not-multithreaded apps are using the same Databases and this behavior
does not occur for them.

Any idea how we can stop this from happening or what additional things
we can check to get more informations on what's occurring ?

Thanks a lot,
Nicolas
