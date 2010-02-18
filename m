Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539Ab0BRCTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 21:19:51 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:54023 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259Ab0BRCTs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 21:19:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=vkoAAhEw51xw9WOEVhMs4yQaG79iuV2ARr9n9Ep7HfyUbbtBrDvVskRBYaECoFxybG
         RD9ZLCF2kQ9+D0ObGBUfwwJz3x/GnivLJblyvNlb9eOTcGHz85QiPyaImhznMFeqCe+D
         zp8Y1Z4kkyjJsWHQnIGmKQwM5e6ynplRbYvwA=
MIME-Version: 1.0
In-Reply-To: <23986fd91002161153y516bb5e3i9e85f11469b9160e@mail.gmail.com>
References: <23986fd91002161153y516bb5e3i9e85f11469b9160e@mail.gmail.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Wed, 17 Feb 2010 21:19:25 -0500
Message-ID: <3e8340491002171819h4d63d592ube70f327eb92d798@mail.gmail.com>
Subject: Re: sendfile() expert advice sought
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 2:53 PM, Patrick J. LoPresti <lopresti@gmail.com> wrote:
> Executive summary:  Can I get the benefits of sendfile() for anonymous pages?
>
> I have an application that generates hundreds of gigabytes of data per
> hour.  I want to push that data out over a TCP socket.  (The network
> connection will be fast; multiple bonded GigE lines or 10GigE.)
>
> I gather that sendfile() is pretty efficient, so I would like to use
> it.  But I do not want to write all of my data to disk first.  So I am
> considering an approach like this:
>
>  int fd = shm_open("/foo", O_RDWR|O_TRUNC);
>  ftruncate(fd, length);
>  void *p = mmap (0, length, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
>  // (fill memory block at p with some data)
>  sendfile(fd, sock, 0, length);
>
> Questions:
>
> 1) Will this work at all?  (Some on-line sources suggest sendfile()
> does not work with tmpfs files.  But I think this was fixed at some
> point...)

If you add a msync() call in there it should work (it might work
without it, but this is only an implementation detail :).

> 2) Will it provide zero-copy behavior, or does the fact that the pages
> are mapped in my process cause sendfile() to copy them?

sendfile() always copies pages; the performance benefit on regular
files comes from the fact that you don't need to copy _twice_ - once
to userspace from DMA buffers, then once back into the kernel network
buffers. Of course, in this case you only need one copy either way...

>
> 3) If it is zero-copy, what happens if I overwrite the memory block
> after sendfile() returns?  Do I risk corrupting my data?  (In
> particular, suppose I have TCP_CORK set on the socket.  Will
> sendfile() return before all of the data has actually been sent,
> giving me a window to corrupt my data?  If so, how do I know when it
> is "safe" to re-use the memory?)

sendfile() copies the data it needs, so it's fine to re-use the data
immediately.

>
> 4) If sendfile() is not zero-copy in this example, would I expect a
> performance boost anyway, because sendfile() does not need to crawl
> page tables or something?

Doubtful - user-to-kernel copies using write() and friends generally
use the CPU's builtin page translation circuitry anyway, which is
probably faster than any software, in-kernel mechanism. You'll
probably only get a benefit if you're sendfile()ing from a disk file
(and this is likely to be on the same order as from mmap()ing the file
and using write() from the mmap'd buffer).
