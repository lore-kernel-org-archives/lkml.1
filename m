Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbZK0OST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbZK0OST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 09:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbZK0OST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 09:18:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40285 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbZK0OSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 09:18:18 -0500
To: Matthias Urlichs <matthias@urlichs.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Time nonlinearity (gettimeofday vs. mtime)
From: Andi Kleen <andi@firstfloor.org>
References: <1259328678.27675.539.camel@kiste>
Date: Fri, 27 Nov 2009 15:18:21 +0100
In-Reply-To: <1259328678.27675.539.camel@kiste> (Matthias Urlichs's message of "Fri, 27 Nov 2009 14:31:18 +0100")
Message-ID: <87y6ls3vbm.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Urlichs <matthias@urlichs.de> writes:

> Lately I've seen this ugliness:

You would probably see it more pronounced on a file system which supports
sub seconds time stamps.

> 13:39:06.000313 clock_gettime(CLOCK_REALTIME, {1259325546, 341196}) = 0 <0.000010>
> 13:39:06.000685 mkdir("/var/tmp/CP_FileTest_TempFolder_d0AOiP/tempFolder1", 0777) = 0 <0.000043>
> 13:39:06.000973 stat64("/var/tmp/CP_FileTest_TempFolder_d0AOiP/tempFolder1", {st_dev=makedev(252, 2), st_ino=1919104, st_mode=S_IFDIR|0755, st_nlink=2, st_uid=501, st_gid=501, st_blksize=4096, st_blocks=8, st_size=4096, st_atime=2009/11/27-13:39:05, st_mtime=2009/11/27-13:39:05, st_ctime=2009/11/27-13:39:05}) = 0 <0.000015>
>
> This strace says that st.st_mtime is smaller than time.tv_sec even though the time was acquired earlier.
> Apparently, the problem is that ext3 uses a cached time value for performance.
>
> Question: Is there a reason that the cached time is not updated every time somebody calls gettimeofday() or clock_gettime()?

At least on x86-64 gtod() and clock_gettime() run in user space and 
are unable to update anything in the kernel.

Also in general both calls are extremly time critical and making them
slower for anything else would be a bad idea.

Internally the file systems use the time from last timer tick (=
jiffies), rounded to their granuality. This is needed to avoid non
monotonicity which can break programs. 

In theory the file system could always get the current time, but it
would need to be rounded down anyways for the same reason, so you
would still see the same effect. Also it would be slower of course,
and not really help.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
