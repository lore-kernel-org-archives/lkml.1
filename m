Return-Path: <linux-kernel-owner+w=401wt.eu-S964881AbXA2XWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964881AbXA2XWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 18:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964894AbXA2XWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 18:22:34 -0500
Received: from smtp.osdl.org ([65.172.181.24]:33238 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964881AbXA2XWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 18:22:34 -0500
Date: Mon, 29 Jan 2007 15:22:27 -0800
From: Andrew Morton <akpm@osdl.org>
To: "Matthew Kirk" <mkirk01@rcn.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: fsync occasionally very slow
Message-Id: <20070129152227.cb417f69.akpm@osdl.org>
In-Reply-To: <002701c743f1$2271c850$6600a8c0@charm>
References: <001a01c74136$0028ecf0$6600a8c0@charm>
	<20070126031654.a41fe374.akpm@osdl.org>
	<002701c743f1$2271c850$6600a8c0@charm>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007 17:02:14 -0500
"Matthew Kirk" <mkirk01@rcn.com> wrote:

> Regarding the long fsyncs, here's a trace...
> 
> I upgraded to a more recent kernel - 2.6.18.6 - and ran it on a workstation.
> This particular box has In this case the elevator is CFQ.
> 
> This sample came from a stall that lasted about 2.5 minutes(!) - the longest
> one I've seen yet.  The box is a bit more memory constrained than the
> original system but exhibits similar behavior.  It doesn't page.  Also,
> there is no raid card - simply striped PATA drives.

Using your little test app, the longest fsync() stall I can demonstrate on
2.6.20-rc4-mm1 on plain-old-sata-disk is 1.2 seconds.

What's the max stall you're able to see with the test app?

Perhaps the file is just super-fragmented.  If your production app does
something like: 

	for (a lot) {
		fd = open(name);
		write(fd, a little bit);
		close(fd);
	}

in multiple threads, or against a lot of different files then you might be
fragmenting the files a lot.  This is because ext3 discards its in-core
anti-fragmentation data structures on close().  So

- Please check your app, see whether or not it is frequently opening and
  closing the output files.

- Using `bmap' from
  http://www.zip.com.au/~akpm/linux/patches/stuff/ext3-tools.tar.gz,
  determine whether the offending files are highly fragmented.

- Tell us how much dirty data is being written out by these fsyncs?

- Try mounting the filesystem with `-o data=writeback'.  Probably won't
  help much if it's also demonstrable on ext2.

- Can you reproduce the stalls on a plain-old-disk?  Get RAID out of the
  picture?

- You've seen the stalls with both CFQ and AS.  I guess you could try
  deadline and no-op, but it sounds like that won't help.


