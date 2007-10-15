Return-Path: <linux-kernel-owner+w=401wt.eu-S1762601AbXJOA4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762601AbXJOA4i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 20:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbXJOA43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 20:56:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40991 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbXJOA43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 20:56:29 -0400
Date: Mon, 15 Oct 2007 01:56:23 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: WTF is HIDIOCGRDESC supposed to do (aside of being a roothole)?
Message-ID: <20071015005623.GB8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This

+                               if (get_user(len, (int __user *)arg))
+                                       return -EFAULT;
+                               if (copy_to_user(*((__u8 **)(user_arg +
+                                                       sizeof(__u32))),
+                                                       dev->hid->rdesc, len))

is an instant trouble - you dereference userland-supplied address and
expect it to be OK; then you take the obtained value and use it as
address to shove the data into.

Now,
	a) dereference is Not Safe(tm), even if you have get_user()
succeeded just before (and it might be completely unrelated to userland
data at that address).
	b) copying arbitrary amount of data?  Without any sanity checks on
len, when we'd just got it from userland?
	c) just WTF is that thing supposed to do?
