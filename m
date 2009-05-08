Return-Path: <linux-kernel-owner+w=401wt.eu-S1757627AbZEHA6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbZEHA6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbZEHA6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:58:44 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:39807 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126AbZEHA6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:58:43 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: linux-kernel@vger.kernel.org
Subject: mmap vs mtime in 2.6.26
Date: Fri, 08 May 2009 02:58:43 +0200
Message-ID: <874ovws94s.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've noticed that the last modification times of our RRD files got
stuck after upgrading from 2.6.24 to 2.6.26 (Debian Etch -> Lenny).
It has some literature, most notably kernel bug #2645, but that's
closed long ago and the resulting patch
http://lkml.org/lkml/2008/1/22/370 is present in my kernel.  Still,
the test program (version 3 from the bug report) gives failures:

$ ./mmap_test junk
Modifying junk...
Flushing data using sync()...
Failure: time not changed.
Not modifying junk...
Flushing data using msync()...
Success: time not changed.
Not modifying junk...
Flushing data using fsync()...
Success: time not changed.
Modifying junk...
Flushing data using msync()...
Failure: time not changed.
Modifying junk...
Flushing data using fsync()...
Failure: time not changed.

Is this as expected?  I reckon the bug wasn't solved fully, but it
seems to be worse that that.

I don't know if it's related or not, but another anomaly appeared
after the upgrade: minutes-long remount times.  The machine always was
under a fair load (10), but mount /usr -oremount,rw never took
noticeable time.  The IO load pushes two other filesystems.  Now
strace -tt shows:

[...]
01:24:08.463813 stat64("/sbin/mount.xfs", 0xbfa40eb0) = -1 ENOENT (No such file or directory)
01:24:08.463904 mount("/dev/mapper/noc7-usr", "/usr", 0x894a2c8, MS_MGC_VAL|MS_NODEV|MS_REMOUNT, NULL) = 0
01:26:58.705387 readlink("/dev", 0xbfa3ef3b, 4096) = -1 EINVAL (Invalid argument)
[...]

After this, remount ro and rw again are quick for some time.

I can not easily test newer kernels in this setup, so thought to ask
around before delving into it further.  Is this a known problem
perhaps?  Does it ring any bells?  If already fixed, can the fix be
backported to 2.6.26 with reasonable effort?  If not, how can I best
help investigate this?
-- 
Thanks,
Feri.
