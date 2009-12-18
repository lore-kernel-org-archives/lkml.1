Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbZLRCrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbZLRCrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 21:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbZLRCrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 21:47:21 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:55554 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbZLRCrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 21:47:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Riu+AhRDgJVnWlvbq6sMNVaEz6jTho1OsHX98NgGO77m3KM0YBiXDGft/34Ba2epse
         Aorw27jG8tODazR1ik3aZC+503K+HkxV8BjbwiHBK6pq81+3KchhVNrkHwszGHTJPsRq
         TnQpFl0si3CwoF4BqOdAi6U/6FSu6ivdQxBr4=
MIME-Version: 1.0
Date: Thu, 17 Dec 2009 18:47:19 -0800
Message-ID: <23986fd90912171847w6d46ba2bx9d8763a63fc758c3@mail.gmail.com>
Subject: Is splice() useful without page stealing?
From: "Patrick J. LoPresti" <lopresti@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just spent a couple of hours tracking down documentation and
discussion on splice().  I apologize in advance if I missed something.

As near as I can tell, SPLICE_F_MOVE (aka. "page stealing") was
removed in 2.6.21
(http://lkml.indiana.edu/hypermail/linux/kernel/0703.1/2592.html) and
never reinstated.

My question is, doesn't this make splice() nearly useless from a
performance perspective?

For example, consider implementing a simple file copy.  You might
argue that even without SPLICE_F_MOVE, splice() can be used to avoid
one copy of the data:  The standard/portable "read() into a user
buffer and write() from that buffer" is two copies, whereas splice()
to and from a pipe would be one copy.

But that argument is bogus, because modern processors have sizable
caches.  If you simply write the portable code to read() into a small
buffer (16K or so) and write() from that buffer, and you use the same
buffer over and over, the data in the buffer should get overwritten in
the L1 cache before it ever gets flushed to the RAM behind it.  In
effect, this simple loop would move data into the L1 cache (on read())
and then back into the page cache (on write()), for a net of ONE
round-trip to physical memory.

Similarly for copying data from a socket to a file in an attempt to
implement "recvfile()".

Now, if splice() actually let you do things like flip pages from the
network stack into the page cache with zero copies, then I could see
the point.  As it is, I am curious to know:

1) Does anybody have any actual benchmarks showing performance
advantages for splice() over read()/write()?   If so, can I obtain the
benchmark code?

2) Are there any plans to reinstate SPLICE_F_MOVE or something equivalent?

Thank you.

 - Pat
