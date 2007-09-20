Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbXITVCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbXITVCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 17:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbXITVCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 17:02:24 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:37850 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbXITVCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 17:02:23 -0400
Date: Thu, 20 Sep 2007 15:02:22 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-serial@vger.kernel.org
Subject: Don't cross the (tty) streams
Message-ID: <20070920210221.GC10625@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Connect two machines with a serial cable.  On the victim:

willy@rowlf:~$ cat </dev/ttyS1

Now, let's find out which ttyS on the other machine is connected ...

willy@teeth:~$ echo foo >/dev/ttyS1
-bash: echo: write error: Input/output error

Oops, that's not a serial port.  No output on rowlf, as expected.
OK, carrying on ...

willy@teeth:~$ echo bar >/dev/ttyS0

And yet on rowlf, we now see:

foo
bar

Looks like there's an error path that doesn't throw away data on -EIO.

This bug exists on at least these two kernels (because I tested it in
both directions:
Linux rowlf 2.6.19-rc6-g70d6673f #1 SMP Thu Nov 16 20:49:15 EST 2006 ia64 GNU/Linux
Linux teeth 2.6.23-rc3-g68dba7a9-dirty #209 SMP PREEMPT Thu Sep 20 15:57:42 EDT 2007 i686 GNU/Linux

Neither kernel has any modifications to its serial code.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
