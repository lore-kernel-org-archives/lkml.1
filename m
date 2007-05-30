Return-Path: <linux-kernel-owner+w=401wt.eu-S1758642AbXE3T5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642AbXE3T5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbXE3T5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:57:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755009AbXE3T5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:57:09 -0400
Message-ID: <465DD6C3.6080102@redhat.com>
Date: Wed, 30 May 2007 12:55:47 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com> <20070530084252.GA15708@elte.hu> <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Davide Libenzi wrote:
> An application 
> linking to glibc can break glibc in thousand ways, indipendently from fds 
> or not fds.

It's not (only/mainly) about breaking.  File descriptors are a resources
which has to be used under the control of the program.  The runtime
cannot just steal some for itself.  This indirectly leads to breaking
code.  We've seen this many times and I keep repeating the same issue
over and over again: why do we have MAP_ANON instead of keeping a file
descriptor with /dev/null open?  Why is mmap made more complicated by
allowing the file descriptor to be closed after the mmap() call is done?

Take a look at a process running your favorite shell.  Ever wonder why
there is this stray file descriptor with a high number?

$ cat /proc/3754/cmdline
bash
$ ll /proc/3754/fd/
total 0
lrwx------ 1 drepper drepper 64 2007-05-30 12:50 0 -> /dev/pts/19
lrwx------ 1 drepper drepper 64 2007-05-30 12:50 1 -> /dev/pts/19
lrwx------ 1 drepper drepper 64 2007-05-30 12:49 2 -> /dev/pts/19
lrwx------ 1 drepper drepper 64 2007-05-30 12:50 255 -> /dev/pts/19

File descriptors must be requested explicitly and cannot be implicitly
consumed.

All that and the other problem I mentioned earlier today about auxiliary
data.  File descriptors are not the ideal interface.  Elegant: yes,
ideal: no.  Fro physics and math you might have learned that not every
result that looks clean and beautiful is correct.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGXdbC2ijCOnn/RHQRAgBbAJ0RoNsQr4L6Bm5hLy7somAKeTqCcQCbBHmx
8hzG+1w0rYMTqXxNmi/QQ7o=
=O7Xm
-----END PGP SIGNATURE-----
