Return-Path: <linux-kernel-owner+w=401wt.eu-S1762929AbZDHHyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762929AbZDHHyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759128AbZDHHyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:54:10 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:29112 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbZDHHyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:54:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=owVZRDfhmSHySB9gxwhj9uay9opRgwJddNEBxwK2P9rdn5AJLQ+XWuJP7VDRy0oqRk
         VAhrytHG3Sl/iJcQG00Q0Xew0Rpj+zDRk6qZD4cN7BNNoO4oLIjqnKWtIWItpmp5Vga7
         /bOxbiZYBSI3gGGfMSQsaBYS0CpdO5psIULC4=
MIME-Version: 1.0
In-Reply-To: <19f34abd0904080020l4f013b58va37c452b91831f85@mail.gmail.com>
References: <b7997bdf0904071248t48fed168r7fa21b421c74358a@mail.gmail.com>
	 <19f34abd0904080020l4f013b58va37c452b91831f85@mail.gmail.com>
Date: Wed, 8 Apr 2009 15:54:07 +0800
Message-ID: <b7997bdf0904080054q6a0ed16ax28d23e040bb77e31@mail.gmail.com>
Subject: Re: splice lost data
From: xinglp <xinglp@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/8, Vegard Nossum <vegard.nossum@gmail.com>:
> 2009/4/7 xinglp <xinglp@gmail.com>:
>
> Don't know if this is related to the problem you report, but your code is buggy.
>
> You're checking errno before you know that splice() returned -1. Now,
> I don't know the actual implementation, but as with most system calls,
> the interface specifies only that errno is updated when the function
> returns -1:
>
>       "On error, splice() returns -1 and errno is set to indicate the
> error." (man 2 splice)
>
> You're also not checking explicitly for the return value 0, which
> would possibly also not set errno (i.e. you're using perror() in the
> case where splice() returned 0).
>
> Please let me know if this fixes your problem!
>
>
> Vegard
>

I see ,but that's not the point.
Now I knew the reason while data lost:

I use epoll(ET) and splice() to recv  data  and write it to DISK (
through pipe).
 And in the earlier time I use epoll(ET) and recv() to recv data  and
write it to DISK (through buffer).

But recv() and splice() is not the same when they were used with epoll(ET).

By 'man epoll' I got a QA.

Q9    Do  I need to continuously read/write a file descriptor until
EAGAIN when using
      the EPOLLET flag (edge-triggered behavior) ?

A9    No you don't.  Receiving an event from epoll_wait(2) should
suggest to you that
      such file descriptor is ready for the requested I/O operation.
You have simply
      to consider it ready until you will receive the next EAGAIN.
When and how  you
      will  use such file descriptor is entirely up to you.  Also, the
condition that
      the read/write I/O space is exhausted can be detected by
checking the amount of
      data  read  from  / written to the target file descriptor.  For
example, if you
      call read(2) by asking to read a certain amount of data and
read(2)  returns  a
      lower  number  of bytes, you can be sure of having exhausted the
read I/O space
      for such file descriptor.  The same is true when writing using
the write(2).

So I break the loop at "returns a lower number  of bytes" when I use
recv(), that works well.

But If I do the same "break" with splice(). epoll_wait won't return
new EPOLLIN until new data come in. So maybe lost few data at the
tail(in fact just lost events).

As <w@1wt.**>  said:
"splice() does not always forward all available data".
