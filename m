Return-Path: <linux-kernel-owner+w=401wt.eu-S1759667AbZELMcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667AbZELMcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 08:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757701AbZELMck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 08:32:40 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:48294 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757173AbZELMcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 08:32:39 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: linux-kernel@vger.kernel.org
Subject: mmap vs mtime in 2.6.26 and up
References: <874ovws94s.fsf@tac.ki.iif.hu>
Date: Tue, 12 May 2009 14:32:38 +0200
In-Reply-To: <874ovws94s.fsf@tac.ki.iif.hu> (Ferenc Wagner's message of "Fri,
	08 May 2009 02:58:43 +0200")
Message-ID: <87ljp2v6vt.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've noticed that the last modification times of our RRD files got
stuck after upgrading from 2.6.24 to 2.6.26 (Debian Etch -> Lenny; I
also tested with 2.6.30-rc5, they are still stuck).  It has some
literature, most notably kernel bug #2645, but that's closed long ago
and the resulting patch http://lkml.org/lkml/2008/1/22/370 is present
in my kernels.  Still, the test program (version 3 from the bug report)
gives failures:

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
(I couldn't test this part with 2.6.30-rc5, but again, this may be
totally unrelated.)

This bug is quite serious in our environment, as it thwarts the backup
software.  The file system is xfs; rw,nosuid,nodev,nobarrier,noquota.
-- 
Regards,
Feri.
