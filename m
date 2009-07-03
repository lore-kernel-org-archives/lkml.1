Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbZGCFmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbZGCFmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 01:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbZGCFmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 01:42:10 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:26718 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbZGCFmJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 01:42:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BgRZmrxAEICtX1UNCH0WW70BZfWGypPhRtZaHLkIZKz0PjB8HraFabQrbDxHYacJN8
         JvBom2TQ8nZ2qeqfLNjVTm7k4PGM60nTjykApAQpSX/i4U2Wm5UE6FNYHUEy1Zrszs6D
         0itkIRZwzFfNp+eNk7unrwajkG+IQUbnVg7bU=
MIME-Version: 1.0
In-Reply-To: <20090703051917.GE5880@cr0.nay.redhat.com>
References: <20090702091309.GB6372@cr0.nay.redhat.com>
	 <20090702094620.GE6372@cr0.nay.redhat.com>
	 <412e6f7f0907020304u166b6d17id1bcf5d334b45c53@mail.gmail.com>
	 <20090702102138.GF6372@cr0.nay.redhat.com>
	 <412e6f7f0907021743m6ed8ae10uecd13c4fc4ec7cbb@mail.gmail.com>
	 <20090703015554.GB5880@cr0.nay.redhat.com>
	 <412e6f7f0907021910w64af0525h17afb518f0e18f97@mail.gmail.com>
	 <20090703030008.GD5880@cr0.nay.redhat.com>
	 <412e6f7f0907022108p7c533ed2wd16fceb0f282ed62@mail.gmail.com>
	 <20090703051917.GE5880@cr0.nay.redhat.com>
Date: Fri, 3 Jul 2009 13:42:12 +0800
Message-ID: <412e6f7f0907022242r52ad981fyd51c2a55f41ab228@mail.gmail.com>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
From: Changli Gao <xiaosuo@gmail.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 3, 2009 at 1:19 PM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
>
>
> Yes, exactly.
> Inventing a new API is better than modifying pipe(2), IMO.
>
> BUT I still don't agree that you really need this... I think you
> can add a flag or something like that to an fd to do this, e.g.
>
>   fcntl(fd, F_SETFD, FD_PIPERW);
>
> Isn't this better?
You don't understand my need. I don't want to change a RDONLY or
WRONLY pipe to a RW one, but I want to pipe() return just one RW pipe
instead. It seems you prefer pipe0() to pipe(NULL).

>
>>
>>You don't know my meaning. As a proxy server, there maybe lots of
>>connections to maintain, and these connections will keep open for a
>>long time. If the data received can be sent in a relay cycle, the
>>kernel buffer can be reused. If not, the kernel buffer must be
>>reserved. When there are lots of these kinds of connections, lots of
>>kernel buffers must be reserved. At this time, whether two fds per
>>kernel buffer or one fds per kernel buffer matters.
>
> SHow us the code, please.
>
If you don't know my need after reading my words, I don't think you
can understand the fake code. The fake code:

main thread:

while (1) {
   fd = accept();
   pthread_create(worker, fd);
}

worker thread(assume data is transfered just from client to server for
simplification):

serv_fd = connect();
while (1) {
  select(fd, RD);
  pipe = get_pipe_from_poll();
  n = splice(fd, pipe);
  while (n > 0) {
     n -= splice(pipe, serv_fd);
  }
  put_pipe_to_poll();
}
close(serv_fd);
close(fd);

If there are lots of threads blocked on splice(pipe, serv_fd), there
will be lots of kernel buffers.

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
