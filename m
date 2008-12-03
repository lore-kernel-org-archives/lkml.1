Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbYLCAWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbYLCAWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 19:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYLCAWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 19:22:01 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:53974 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbYLCAWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 19:22:00 -0500
Subject: Re: NFS directory listing hang on write.
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Russell Miller <duskglow@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4eea36270812021605s58f27857pda48fa3c5542affa@mail.gmail.com>
References: <4eea36270812021605s58f27857pda48fa3c5542affa@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 02 Dec 2008 19:21:55 -0500
Message-Id: <1228263715.7852.80.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 24E324959518BADF68C9C9D457D8255199E1D915
X-UiO-SPAM-Test: remote_host: 68.40.183.129 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 232 max/h 9 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-02 at 16:05 -0800, Russell Miller wrote:
> Hi, all.  We're having some NFS problems here that I don't understand.
> 
> The arguments are standard.  wsize=32768,rsize=32768,tcp.  Nothing
> else out of the ordinary.  Test case is easy too:
> 
> mount a filesystem.
> cd into the directory.
> create a 1G file and background the creation, so 1G is being written
> into the directory.
> Then, try to ls the directory.
> 
> The ls will hang, sometimes for a few seconds, sometimes for the
> entire length of the write.  This happens on every NFS server I've
> tried, including an acopia, bluearc, onstor, and a generic linux box
> running on the other end.

That is known and expected behaviour. It is not a bug.

The reason is that your 'ls' is also trying to stat() the file, and so
the client has to flush out all those writes in order to ensure that the
mtime/ctime are posixly correct.
By this, I mean that POSIX requires the filesystem to update the
mtime/ctime every time you issue a write() call. In the case of NFS,
this update is actually done when the client sends the WRITE rpc call to
to the server. IOW: in order to ensure that your mtime/ctime doesn't
change after you've issued the stat() call, we actually need to flush
out those backgrounded writes and wait for them to complete.

Cheers
  Trond

