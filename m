Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266Ab0BPTxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 14:53:25 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62610 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090Ab0BPTxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 14:53:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=mmch2TRNeQa37DcumYxcpr6sVQO4xeWwbfw1d2nEqmwKp55/4YUM0PQ7SKyOwJuegQ
         SYtHcxiyiuYSzHltIxig0jLYwCgoutDApOsR8XmQ52YaLPtEvqP2+6vezLsc8RE+V4CF
         zjwkmGYSaOP90yuxhiWCIfL1oU+1A+BSXA06k=
MIME-Version: 1.0
Date: Tue, 16 Feb 2010 11:53:20 -0800
Message-ID: <23986fd91002161153y516bb5e3i9e85f11469b9160e@mail.gmail.com>
Subject: sendfile() expert advice sought
From: "Patrick J. LoPresti" <lopresti@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Executive summary:  Can I get the benefits of sendfile() for anonymous pages?

I have an application that generates hundreds of gigabytes of data per
hour.  I want to push that data out over a TCP socket.  (The network
connection will be fast; multiple bonded GigE lines or 10GigE.)

I gather that sendfile() is pretty efficient, so I would like to use
it.  But I do not want to write all of my data to disk first.  So I am
considering an approach like this:

  int fd = shm_open("/foo", O_RDWR|O_TRUNC);
  ftruncate(fd, length);
  void *p = mmap (0, length, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
  // (fill memory block at p with some data)
  sendfile(fd, sock, 0, length);

Questions:

1) Will this work at all?  (Some on-line sources suggest sendfile()
does not work with tmpfs files.  But I think this was fixed at some
point...)

2) Will it provide zero-copy behavior, or does the fact that the pages
are mapped in my process cause sendfile() to copy them?

3) If it is zero-copy, what happens if I overwrite the memory block
after sendfile() returns?  Do I risk corrupting my data?  (In
particular, suppose I have TCP_CORK set on the socket.  Will
sendfile() return before all of the data has actually been sent,
giving me a window to corrupt my data?  If so, how do I know when it
is "safe" to re-use the memory?)

4) If sendfile() is not zero-copy in this example, would I expect a
performance boost anyway, because sendfile() does not need to crawl
page tables or something?

Any responses or references will be appreciated.

Thanks!

 - Pat

P.S.  I know I could also try mmap()'ing "/dev/zero" and using
vmsplice().  Same set of questions, though.
