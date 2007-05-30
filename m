Return-Path: <linux-kernel-owner+w=401wt.eu-S1760672AbXE3Vt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760672AbXE3Vt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760177AbXE3Vs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:48:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760850AbXE3Vs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:48:58 -0400
Message-ID: <465DF0F5.6050000@redhat.com>
Date: Wed, 30 May 2007 14:47:33 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com> <20070530084252.GA15708@elte.hu> <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org> <465DE992.6070803@redhat.com> <alpine.LFD.0.98.0705301422230.26602@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705301422230.26602@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus Torvalds wrote:
> Well, don't think of it as a special case at all: think of bit 30 as a 
> "the user asked for a non-linear fd".

This sounds easy but doesn't really solve all the issues.  Let me repeat
your example and the solution currently in use:

problem: application wants to close all file descriptors except a select
few, cleaning up what is currently open.  It doesn't know all the
descriptors that are open.  Maybe all this in preparation of an exec call.

Today the best method to do this is to readdir() /proc/self/fd and
exclude the descriptors on the whitelist.

If the special, non-sequential descriptors are also listed in that
directory the runtimes still cannot use them since they are visible.

If you go ahead with this, then at the very least add a flag which
causes the descriptor to not show up in /proc/*/fd.


You also have to be aware that open() is just one piece of the puzzle.
What about socket()?  I've cursed this interface many times before and
now it's biting you: there is parameter to pass a flag.  What about
transferring file descriptors via Unix domain sockets?  How can I decide
the transferred descriptor should be in the private namespace?

There are likely many many more problems and cornercases like this.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGXfD12ijCOnn/RHQRAk4nAJ0Zjevd9Y0lQa/fLzKK+BshcLVbngCfSspI
ALNKu8VCKy7CvoIqJD3Xs/Y=
=+fM8
-----END PGP SIGNATURE-----
