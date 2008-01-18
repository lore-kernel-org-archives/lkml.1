Return-Path: <linux-kernel-owner+w=401wt.eu-S1763429AbYARQrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763429AbYARQrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757800AbYARQrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:47:35 -0500
Received: from mopniei1.ch.govorit.ru ([89.221.56.130]:34818 "EHLO
	d-fens.mopniei.ru" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752292AbYARQre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:47:34 -0500
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jan 2008 11:47:33 EST
To: linux-kernel@vger.kernel.org
Subject: mount: can not restrict mode of iso9660 files
From: "Ilya N. Golubev" <gin@mo.msk.ru>
Date: Fri, 18 Jan 2008 19:47:32 +0300
Message-ID: <497ii79j2z.fsf@mo.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Versions: `2.6.17-1.2142_FC4' (fedora core) for x86_64;
`2.6.22.5-31' (opensuse 10.3) for i586.

File system may contain data not to let any logged in user read.  Wish
to specify more restrictive mode of files in it - files of all types,
including not only regular ones, but also directories, even root one
of the file system.  This certainly must occur on mount itself, not in
subsequent `chmod' calls.  There is at least one obvious reason to
avoid explicit `chmod', just as many other uses of it: possible race
condition between it and other process opening the file.

When mounting read- only iso9660 file system, `mount' ignores
`mode=0400' file system option, at least for directories.  More
precisely,

mount -nv -t iso9660 -o ro,norock,mode=0400,uid=ID_OF_REGULAR_USER DEVICE DIR

completes without error messages and leaves DIR mounted, but with mode
`r-xr-xr-x'.  DIR uid is as specified.

Also ran that command in `strace -emount'.  Its outputs:

mount("DEVICE", "DIR", "iso9660", MS_RDONLY|MS_POSIXACL|MS_ACTIVE|MS_NOUSER|0xec0000, 0x50fe60) = 0

suggesting that data converted from `-o' argument are actually passed
to the kernel.  Permissions of regular files in mounted file system
are `0400', that is, restricted properly.  This suggests that the
request to restrict permissions, or at least part of it, is passed to
kernel.  However, kernel does not honor the request wrt directories in
mounted file system - or at best needs a separate request for
permissions of directories, which `mount' program does not make.
