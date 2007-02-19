Return-Path: <linux-kernel-owner+w=401wt.eu-S932685AbXBSVGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685AbXBSVGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 16:06:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932686AbXBSVGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 16:06:37 -0500
Received: from terminus.zytor.com ([192.83.249.54]:37952 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685AbXBSVGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 16:06:36 -0500
Message-ID: <45DA1154.9020601@zytor.com>
Date: Mon, 19 Feb 2007 13:06:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Mike Frysinger <vapier.adi@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>
Subject: <linux/socket.h>, <linux/stat.h> breakage: AF_* constants are part
 of ABI definition
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In the current git tree, commit 57a87bb0720a5cf7a9ece49a8c8ed288398fd1bb 
removes any way to automatically extracting a whole lot of ABI constants 
from the kernel headers, especially AF_* and the various S_* constants.

Furthermore, the patch breaks <linux/in.h> which uses sa_family_t, which 
is now defined under __KERNEL__.

The comment that is included:

     [PATCH] scrub non-__GLIBC__ checks in linux/socket.h and
  	     linux/stat.h

     Userspace should be worrying about userspace, so having the socket.h
     and stat.h pollute the namespace in the non-glibc case is wrong and
     pretty much prevents any other libc from utilizing these headers
     sanely unless they set up the __GLIBC__ define themselves (which
     sucks)

... seems to imply that virtually nothing out of these files should be 
"sanely" utilized, but why, pray tell, include them at all?  The balance 
of these files is about 10 lines.

This patch breaks klibc in ways that are painfully hard to fix, and 
*definitely* cannot be fixed by anything less than replication of all 
these definitions, which is exactly the Wrong Thing[TM].

A much better solution (or complement) would be something like:

#if defined(__KERNEL__) || defined(__KHDR_CONSTANTS)

We could have __KHDR_CONSTANTS for the AF_* constants and __KHDR_MACROS 
for the various macros (cmsg et al).  That way the userspace library can 
ask for what it wants.

	-hpa

