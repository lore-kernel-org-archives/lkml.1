Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110AbXFCSwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbXFCSwr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 14:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbXFCSw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 14:52:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:8108 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbXFCSwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 14:52:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=lHp/IAnkO4rkIp3qCf8n7ci73AZFcNzri9+zQGd6hVx0PwvBM31oMxJFbKE9svGX9WDQiICx/rQy+2avvVxbUusSoA/uolrxQGooMFxageRsWgNiYGJ75fiN6ZJpJe6lE2DsORovecy1Or//jR0rMs1DzfHyK8OqUjjT7SweY94=
Message-ID: <e7ca40f70706031152q4e9630aq3c29623bd56fe0e5@mail.gmail.com>
Date: Sun, 3 Jun 2007 14:52:24 -0400
From: "Aaron Wiebe" <epiphani@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: slow open() calls and o_nonblock
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all.  I'm not on this list, so I apologize if this subject
has been covered before.  (Also, please cc me in the response.)

I've spent the last several months trying to work around the lack of a
decent disk AIO interface.  I'm starting to wonder if one exists
anywhere.  The short version:

I have written a daemon that needs to open several thousand files a
minute and write a small amount of data to each file.  After extensive
research, I ended up going with the POSIX AIO kludgy pthreads wrapper
in glibc to handle my writes due to the time constraints of writing my
own pthreads handler into the application.

The problem with this equation is that opens, closes and non-readwrite
operations (fchmod, fcntl, etc) have no interface in posix aio.  Now I
was under the assumption that given open and close operations are
comparatively less common than the write operations, this wouldn't be
a huge problem.  My tests seemed to reflect that.

I went to production with this yesterday to discover that under
production load, our filesystems (nfs on netapps) were substantially
slower than I was expecting.  open() calls are taking upwards of 2
seconds on occation, and usually ~20ms.

Now, Netapp speed aside, O_NONBLOCK and O_DIRECT seem to make zero
difference to my open times.  Example:

open("/somefile", O_WRONLY|O_NONBLOCK|O_CREAT, 0644) = 1621 <0.415147>

Now, I'm a userspace guy so I can be pretty dense, but shouldn't a
call with a nonblocking flag return EAGAIN if its going to take
anywhere near 415ms?  Is there a way I can force opens to EAGAIN if
they take more than 10ms?

Thanks for any help you folks can offer.

-Aaron Wiebe

(ps.  having come from the socket side of the fence, its incredibly
frustrating to be unable to poll() or epoll regular file FDs --
Especially knowing that the kernel is translating them into a TCP
socket to do NFS anyway.  Please add regular files to epoll and give
me a way to do the opens in the same fasion as connects!)
