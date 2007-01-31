Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbXAaCCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbXAaCCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 21:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932224AbXAaCCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 21:02:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113AbXAaCCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 21:02:51 -0500
Message-ID: <45BFF8A0.30907@redhat.com>
Date: Tue, 30 Jan 2007 21:02:08 -0500
From: Jeff Layton <jlayton@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Bodo Eggert <7eggert@gmx.de>, akpm@osdl.org, dev@sw.ru,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       torvalds@osdl.org
Subject: Re: [PATCH] pipefs unique inode numbers
References: <Pine.LNX.4.58.0701302314210.2203@be1.lrz> <45BFEE85.30203@redhat.com> <Pine.LNX.4.64.0701301726280.3611@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0701301726280.3611@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
 >
 > On Tue, 30 Jan 2007, Jeff Layton wrote:
 >> Also, that patch would break many 32-bit programs not compiled with large
 >> offsets when run in compatibility mode on a 64-bit kernel. If they were to
 >> do a stat on this inode, it would likely generate an EOVERFLOW error since
 >> the pointer address would probably not fit in a 32 bit field.
 >>
 >> That problem was the whole impetus for this set of patches.
 >
 > Well, we have that problem with the slowly incrementing "last_ino" too.
 >
 > Should we make "last_ino" be "static unsigned int" instead of "long"?
 >
 > Does anybody actually even use the old stat() with 32-bit interfaces? We
 > warn for it, and we've done so for a long time.. I dont' remember people
 > even complaining about the warning, so..
 >
 > 		Linus

I've actually sent Andrew a patch that does that and the same thing to
the counter in iunique as well. It's in -mm now, but I think it's pretty
safe and can probably go into your tree any time you're ready for it.

It's been quite a while since I looked at the original problem, but I
believe glibc actually uses stat64 to make the call, so it doesn't
throw the warning. The EOVERFLOW comes from glibc when it gets back an
st_ino value that won't fit in the 32 bit buffer provided by the program.

Obviously, we can't do anything for filesystems with permanent inodes larger
than 32 bits, but when generating them on the fly via new_inode or iunique,
we ought to try and have them fit in 32 bits if possible (at least as long
as we can).

-- Jeff
