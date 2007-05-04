Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbXEECMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbXEECMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 22:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755437AbXEECMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 22:12:55 -0400
Received: from thunk.org ([69.25.196.29]:35056 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435AbXEECMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 22:12:54 -0400
Date: Fri, 4 May 2007 14:41:34 -0400
From: Theodore Tso <tytso@mit.edu>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Christoph Hellwig <hch@infradead.org>,
       Anton Altaparmakov <aia21@cam.ac.uk>,
       Bernd Eckenfels <ecki@lina.inka.de>, linux-kernel@vger.kernel.org
Subject: Re: Ext3 vs NTFS performance
Message-ID: <20070504184134.GB25339@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Michael Tokarev <mjt@tls.msk.ru>,
	Christoph Hellwig <hch@infradead.org>,
	Anton Altaparmakov <aia21@cam.ac.uk>,
	Bernd Eckenfels <ecki@lina.inka.de>, linux-kernel@vger.kernel.org
References: <E1HjjyF-00022D-00@calista.eckenfels.net> <0733FB88-3E6E-47B7-A55D-704B5C0DB239@cam.ac.uk> <20070504094610.GA31607@infradead.org> <463B55F9.4070606@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463B55F9.4070606@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 07:49:13PM +0400, Michael Tokarev wrote:
> 
> How about providing a way to stop kernel (or filesystem) to make gaps
> in files instead?  Like some ioctl(fd, FS_NOGAPS, 1) -- pretty much
> like 'doze has, just the opposite (on windows, this flag is "on" by
> default).

This is being worked on already.  XFS has a per-filesystem ioctl, but
we want to create a filesystem-independent system call,
sys_fallocate(), that would wired into the already existing
posix_fallocate() function exported by glibc.

> It's even worse: imagine samba transforms this into write(zeros) (as
> preallocate isn't available yet), and at the same time, another process
> is writing there... Which will be perfectly valid in current case, but
> will go wrong way (overwriting just-written data with zeros) in this
> new scenario.

Samba can just use the posix_fallocate() system call.  Note that if
you have two processes are writing to the same file without proper
locking, you're probably going to run into potential problems anyway.
What if one process is writing whole blockfuls of data, while some
brain-damaged Windows client is writing a byte of zero every 128k, and
thus subtly corrupting the data written by the first process?  We
can't fix brain-damaged applications that aren't doing proper
application level locking....

(Aside, of course, from convincing people to switch away from Vista to
Linux. :-)

						- Ted
