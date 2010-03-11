Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab0CKLaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 06:30:08 -0500
Received: from lo.gmane.org ([80.91.229.12]:46191 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755278Ab0CKLaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 06:30:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jef Driesen <jefdriesen@hotmail.com>
Subject: Low latency mode and performance of pty's?
Date: Thu, 11 Mar 2010 12:24:24 +0100
Message-ID: <hnajtd$1sg$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 143.169.49.29
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Lightning/1.0b1 Thunderbird/3.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have an application that uses a pair of pseudo terminals (using socat 
to link them together) to simulate a serial nullmodem cable. I use this 
setup to simulate the serial communication with an external device in my 
test environment. It works fine, but I noticed the performance is quite bad.

You can reproduce the problem by running these commands in three 
different terminals:

# Terminal 1: Setup the pty's.
socat PTY,link=/tmp/ttyS0 PTY,link=/tmp/ttyS1

# Terminal 2: Send some data.
dd if=/dev/urandom of=input.bin bs=538368 count=1
sx input.bin >>/tmp/ttyS0 </tmp/ttyS0

# Terminal 2: Receive the data data.
time rx output.bin >/tmp/ttyS1 </tmp/ttyS1

On my system, this takes about 2m49s, which is much longer than it 
should be. After some discussion in the comp.unix.programmer [1] and 
comp.os.linux.development.apps [2] newsgroups, I learned pty's have a 
low latency flag, which is disabled by default. When patching my kernel 
to enable this flag (patch included at the end of this post), the 
transfer time goes down to about 30s. When running my own applications, 
it's get even better and the transfer is almost instantly.

Now, the reason why I'm reporting this on LKML is that the patch I 
applied is almost identical to a commit [3] that got reverted again [4]. 
Based on the comment in that last commit, the slow performance was 
addressed in another way, but according to my measurements it isn't. Or 
at least it's not as good as setting the low latency flag directly. 
Unfortunately I don't have any experience with kernel development and I 
have no idea how to fix this properly.

[1] 
http://groups.google.com/group/comp.unix.programmer/browse_thread/thread/503d529448f045e5
[2] 
http://groups.google.be/group/comp.os.linux.development.apps/browse_thread/thread/e6041109eb91aaf7/fccf3946dce9c4b1
[3] 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3a54297478e6578f96fd54bf4daa1751130aca86
[4] 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e043e42bdb66885b3ac10d27a01ccb9972e2b0a3

Thanks,

Jef

--- drivers/char/pty.c.orig	2010-01-11 13:00:58.000000000 +0100
+++ drivers/char/pty.c	2010-01-11 13:01:04.000000000 +0100
@@ -200,6 +200,8 @@ static int pty_open(struct tty_struct *t
   	if (tty->link->count != 1)
   		goto out;

+	tty->low_latency = 1;
+
   	clear_bit(TTY_OTHER_CLOSED, &tty->link->flags);
   	set_bit(TTY_THROTTLED, &tty->flags);
   	retval = 0;


