Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbZGCHNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbZGCHNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 03:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbZGCHMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 03:12:55 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:49012 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbZGCHMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 03:12:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=sGx41djtVKI+g3M/E+3TeXKbM5sryRfO+tcFgUP8vjI0W8TYYJ+htfGoafGwozAgwD
         CYXYef9dvGaa71+EJ7jg0P9e5e6oJoLjuKpVBzt/EnQlNBp3v2ts2yszZOPDg3+PTlTo
         nuu8WvLbCsbTBbaRay3nHHDQVFY0onrog1h+k=
Date: Fri, 3 Jul 2009 15:15:04 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
Message-ID: <20090703071504.GG5880@cr0.nay.redhat.com>
References: <20090702094620.GE6372@cr0.nay.redhat.com> <412e6f7f0907020304u166b6d17id1bcf5d334b45c53@mail.gmail.com> <20090702102138.GF6372@cr0.nay.redhat.com> <412e6f7f0907021743m6ed8ae10uecd13c4fc4ec7cbb@mail.gmail.com> <20090703015554.GB5880@cr0.nay.redhat.com> <412e6f7f0907021910w64af0525h17afb518f0e18f97@mail.gmail.com> <20090703030008.GD5880@cr0.nay.redhat.com> <412e6f7f0907022108p7c533ed2wd16fceb0f282ed62@mail.gmail.com> <20090703051917.GE5880@cr0.nay.redhat.com> <412e6f7f0907022242r52ad981fyd51c2a55f41ab228@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <412e6f7f0907022242r52ad981fyd51c2a55f41ab228@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 01:42:12PM +0800, Changli Gao wrote:
>On Fri, Jul 3, 2009 at 1:19 PM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
>>
>>
>> Yes, exactly.
>> Inventing a new API is better than modifying pipe(2), IMO.
>>
>> BUT I still don't agree that you really need this... I think you
>> can add a flag or something like that to an fd to do this, e.g.
>>
>>   fcntl(fd, F_SETFD, FD_PIPERW);
>>
>> Isn't this better?
>You don't understand my need. I don't want to change a RDONLY or
>WRONLY pipe to a RW one, but I want to pipe() return just one RW pipe
>instead.

This is exacly what I meant by that example.

>It seems you prefer pipe0() to pipe(NULL).

pipefd() seems better.

>>>You don't know my meaning. As a proxy server, there maybe lots of
>>>connections to maintain, and these connections will keep open for a
>>>long time. If the data received can be sent in a relay cycle, the
>>>kernel buffer can be reused. If not, the kernel buffer must be
>>>reserved. When there are lots of these kinds of connections, lots of
>>>kernel buffers must be reserved. At this time, whether two fds per
>>>kernel buffer or one fds per kernel buffer matters.
>>
>> SHow us the code, please.
>>
>If you don't know my need after reading my words, I don't think you
>can understand the fake code.

No, code is *much* better than any of your words.

>The fake code:
>
>main thread:
>
>while (1) {
>   fd = accept();
>   pthread_create(worker, fd);
>}
>
>worker thread(assume data is transfered just from client to server for
>simplification):
>
>serv_fd = connect();
>while (1) {
>  select(fd, RD);
>  pipe = get_pipe_from_poll();
>  n = splice(fd, pipe);
>  while (n > 0) {
>     n -= splice(pipe, serv_fd);
>  }
>  put_pipe_to_poll();
>}
>close(serv_fd);
>close(fd);

If saving one fd really helps here, probably you want to
save more, you will need a syscall like:

  int splice_without_new_fd(int infd, int outfd);

But splice(2) is designed to be as it is. You need to increase
your fd limit, instead of saving one by pipe().
