Return-Path: <linux-kernel-owner+w=401wt.eu-S1759075AbYC1XFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075AbYC1XFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 19:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758159AbYC1XFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 19:05:30 -0400
Received: from rtr.ca ([76.10.145.34]:1819 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758154AbYC1XF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 19:05:28 -0400
Message-ID: <47ED79B5.6040205@rtr.ca>
Date: Fri, 28 Mar 2008 19:05:25 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: [PATCH 2.6.25-rc7] fix uevent action-string regression
References: <47ED3DDE.3030201@rtr.ca>
In-Reply-To: <47ED3DDE.3030201@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> 
> On boot, syslog is flooded with "uevent: unsupported action-string;" messages.
..
> Mar 28 14:43:29 shrimp kernel: tty ptyqd: uevent: unsupported 
> action-string; this will be ignored in a future kernel version
> Mar 28 14:43:29 shrimp kernel: tty ptyqe: uevent: unsupported 
> action-string; this will be ignored in a future kernel version
> Mar 28 14:43:29 shrimp kernel: tty ptyqf: uevent: unsupported 
> action-string; this will be ignored in a future kernel version
> Mar 28 14:43:29 shrimp kernel: tty ptyr0: uevent: unsupported 
> action-string; this will be ignored in a future kernel version
..

These messages are a regression compared with 2.6.24,
which did not flood the syslog with them.

The actual underlying problem was introduced in 2.6.23,
when somebody made the string parsing no longer accept nul-terminated
strings as a valid input to store_uevent().

Eg. "add\0" was valid prior to 2.6.23, where the code regressed
to require "add" without the '\0'.

This patch fixes the 2.6.23 / 2.6.24 regressions, by having the code
once again tolerate the trailing '\0', if present.

According to GregKH, this mainly affects older Ubuntu systems,
such as the one I have here that requires this fix.

Signed-off-by: Mark Lord <mlord@pobox.com>

--- old/lib/kobject_uevent.c	2008-03-28 14:03:46.000000000 -0400
+++ linux/lib/kobject_uevent.c	2008-03-28 18:53:11.000000000 -0400
@@ -55,7 +55,7 @@
 	enum kobject_action action;
 	int ret = -EINVAL;
 
-	if (count && buf[count-1] == '\n')
+	if (count && (buf[count-1] == '\n' || buf[count-1] == '\0'))
 		count--;
 
 	if (!count)
