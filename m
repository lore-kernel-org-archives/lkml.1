Return-Path: <linux-kernel-owner+w=401wt.eu-S1751208AbXBMIxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbXBMIxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 03:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbXBMIxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 03:53:34 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37235 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbXBMIxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 03:53:33 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [PATCH] nanosecond filesystem support???
Date: Tue, 13 Feb 2007 09:52:25 +0100
User-Agent: KMail/1.9.5
Cc: lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Miquel van Smoorenburg <miquels@cistron.nl>,
       Linus Torvalds <torvalds@osdl.org>
References: <Pine.LNX.4.64.0702131627210.5124@boston.corp.fedex.com>
In-Reply-To: <Pine.LNX.4.64.0702131627210.5124@boston.corp.fedex.com>
Organization: -
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200702130952.26048.andi@firstfloor.org>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> It seems that the part that's not returning nanosecond is in the code 
> below. I've modified it, and now stat() is returning st_mtim.tv_nsec 
> correctly.
> 
> I've tested it on ext2 and reiserfs, and both seems to be working.
> 
> 
> I don't know why "t.tv_nsec = 0;" was set in the code. Any idea?

The first hunk doesn't make any sense. stime() will never know anything about
nanoseconds. You're just putting uninitialized memory in there.

The truncation you removed in the second was deliberately added for the old file
systems that don't support higher granuality *times. Otherwise
the time can jump backwards between a inode that is still cached
in memory and one that is saved/restored from disk. Several programs
(including make) assume this cannot happen, so the kernel prevents it
by always rounding.

If you want ns resolution you need a file system that supports it:
that's currently XFS, JFS, NTFS/CIFS (resolution is lower, but < 1s), NFSv[34], UDF, 
with suitable servers,  tmpfs/ramfs/hugetlbfs. ext4 ns support is being worked on,

BTW the real max resolution supported in the kernel right now is jiffies.

-Andi


