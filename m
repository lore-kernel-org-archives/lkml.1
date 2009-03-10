Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbZCJNi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbZCJNi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 09:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbZCJNir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 09:38:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:41537 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbZCJNip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 09:38:45 -0400
Subject: Re: Keymap 0: Permission denied
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Willy Tarreau <w@1wt.eu>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090308181056.GM26043@1wt.eu>
References: <1236533626.1479.8.camel@rh9.satnam>
	 <20090308181056.GM26043@1wt.eu>
Content-Type: multipart/mixed; boundary="=-Oz7QE3EaeGGKjjWOWz4m"
Organization: 
Message-Id: <1236692166.1582.5.camel@rh9.satnam>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.2.2 (1.2.2-4) 
Date: 10 Mar 2009 19:06:06 +0530
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Oz7QE3EaeGGKjjWOWz4m
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sun, 2009-03-08 at 23:40, Willy Tarreau wrote:
> Hi,
> 
> On Sun, Mar 08, 2009 at 11:03:46PM +0530, Jaswinder Singh Rajput wrote:
> > Hello Willy,
> > 
> > On Red Hat 9 With latest 2.4-git kernel, when I log in as a regular user
> > on a TTY, I get the following error:
> > 
> > Keymap 0: Permission denied
> > Keymap 1: Permission denied
> > Keymap 2: Permission denied
> > KDSKBENT: Operation not permitted
> > loadkeys: could not deallocate keymap 3
> > 
> > How to fix this error.
> 
> No idea yet. Could you please try "loadkey us" for instance, to ensure
> it is the program which fails ? If so, please send me the output of
> "strace loadkeys us".
> 

I am attaching the strace for your reference.

This patch solves above problem, Is this a correct way ?

Subject: [PATCH] x86: fix Keymap : Permission denied

On Red Hat 9, login in as a regular user on a TTY, leads to:

Keymap 0: Permission denied
Keymap 1: Permission denied
Keymap 2: Permission denied
KDSKBENT: Operation not permitted
loadkeys: could not deallocate keymap 3

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/char/vt.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 8b8f95d..6206d3e 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -180,8 +180,6 @@ do_kdsk_ioctl(int cmd, struct kbentry *user_kbe, int perm, struct kbd_struct *kb
 		    val = (i ? K_HOLE : K_NOSUCHMAP);
 		return put_user(val, &user_kbe->kb_value);
 	case KDSKBENT:
-		if (!perm)
-			return -EPERM;
 		if (!i && v == K_NOSUCHMAP) {
 			/* disallocate map */
 			key_map = key_maps[s];
@@ -304,9 +302,6 @@ do_kdgkb_ioctl(int cmd, struct kbsentry *user_kdgkb, int perm)
 			return -EFAULT;
 		return ((p && *p) ? -EOVERFLOW : 0);
 	case KDSKBSENT:
-		if (!perm)
-			return -EPERM;
-
 		q = func_table[i];
 		first_free = funcbufptr + (funcbufsize - funcbufleft);
 		for (j = i+1; j < MAX_NR_FUNC && !func_table[j]; j++) 
-- 
1.6.1.GIT




--=-Oz7QE3EaeGGKjjWOWz4m
Content-Disposition: attachment; filename=loadkeys_us
Content-Type: text/plain; name=loadkeys_us; charset=UTF-8
Content-Transfer-Encoding: 7bit

execve("/bin/loadkeys", ["loadkeys", "us"], [/* 18 vars */]) = 0
uname({sys="Linux", node="rh9.satnam", ...}) = 0
brk(0)                                  = 0x805d7e0
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40016000
open("/etc/ld.so.preload", O_RDONLY)    = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=65674, ...}) = 0
old_mmap(NULL, 65674, PROT_READ, MAP_PRIVATE, 3, 0) = 0x40017000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\200Y\1"..., 1024) = 1024
fstat64(3, {st_mode=S_IFREG|0755, st_size=1566428, ...}) = 0
old_mmap(NULL, 1281508, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0x40028000
mprotect(0x4015b000, 24036, PROT_NONE)  = 0
old_mmap(0x4015b000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 3, 0x132000) = 0x4015b000
old_mmap(0x4015f000, 7652, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x4015f000
close(3)                                = 0
munmap(0x40017000, 65674)               = 0
brk(0)                                  = 0x805d7e0
brk(0x805e7e0)                          = 0x805e7e0
brk(0)                                  = 0x805e7e0
brk(0x805f000)                          = 0x805f000
open("us", O_RDONLY)                    = -1 ENOENT (No such file or directory)
open("/dev/null", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = -1 ENOTDIR (Not a directory)
open(".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 3
fstat64(3, {st_mode=S_IFDIR|0700, st_size=4096, ...}) = 0
fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
getdents64(3, /* 44 entries */, 4096)   = 1464
getdents64(3, /* 0 entries */, 4096)    = 0
close(3)                                = 0
open("//lib/kbd/keymaps", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 3
fstat64(3, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
getdents64(3, /* 9 entries */, 4096)    = 240
getdents64(3, /* 0 entries */, 4096)    = 0
close(3)                                = 0
open("//lib/kbd/keymaps", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 3
fstat64(3, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
getdents64(3, /* 9 entries */, 4096)    = 240
stat64("//lib/kbd/keymaps/amiga", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
open("//lib/kbd/keymaps/amiga", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 4
fstat64(4, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         = 0
brk(0)                                  = 0x805f000
brk(0x8060000)                          = 0x8060000
getdents64(4, /* 4 entries */, 4096)    = 128
getdents64(4, /* 0 entries */, 4096)    = 0
close(4)                                = 0
open("//lib/kbd/keymaps/amiga", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 4
fstat64(4, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         = 0
getdents64(4, /* 4 entries */, 4096)    = 128
stat64("//lib/kbd/keymaps/amiga/amiga-de.map.gz", {st_mode=S_IFREG|0644, st_size=2982, ...}) = 0
stat64("//lib/kbd/keymaps/amiga/amiga-us.map.gz", {st_mode=S_IFREG|0644, st_size=1900, ...}) = 0
getdents64(4, /* 0 entries */, 4096)    = 0
close(4)                                = 0
stat64("//lib/kbd/keymaps/atari", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
open("//lib/kbd/keymaps/atari", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 4
fstat64(4, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         = 0
getdents64(4, /* 6 entries */, 4096)    = 216
getdents64(4, /* 0 entries */, 4096)    = 0
close(4)                                = 0
open("//lib/kbd/keymaps/atari", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 4
fstat64(4, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         = 0
getdents64(4, /* 6 entries */, 4096)    = 216
stat64("//lib/kbd/keymaps/atari/atari-uk-falcon.map.gz", {st_mode=S_IFREG|0644, st_size=2785, ...}) = 0
stat64("//lib/kbd/keymaps/atari/atari-de.map.gz", {st_mode=S_IFREG|0644, st_size=2757, ...}) = 0
stat64("//lib/kbd/keymaps/atari/atari-se.map.gz", {st_mode=S_IFREG|0644, st_size=2938, ...}) = 0
stat64("//lib/kbd/keymaps/atari/atari-us.map.gz", {st_mode=S_IFREG|0644, st_size=2996, ...}) = 0
getdents64(4, /* 0 entries */, 4096)    = 0
close(4)                                = 0
stat64("//lib/kbd/keymaps/i386", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
open("//lib/kbd/keymaps/i386", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 4
fstat64(4, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         = 0
getdents64(4, /* 8 entries */, 4096)    = 240
getdents64(4, /* 0 entries */, 4096)    = 0
close(4)                                = 0
open("//lib/kbd/keymaps/i386", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 4
fstat64(4, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
fcntl64(4, F_SETFD, FD_CLOEXEC)         = 0
getdents64(4, /* 8 entries */, 4096)    = 240
stat64("//lib/kbd/keymaps/i386/azerty", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
open("//lib/kbd/keymaps/i386/azerty", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 5
fstat64(5, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
fcntl64(5, F_SETFD, FD_CLOEXEC)         = 0
brk(0)                                  = 0x8060000
brk(0x8061000)                          = 0x8061000
getdents64(5, /* 10 entries */, 4096)   = 352
getdents64(5, /* 0 entries */, 4096)    = 0
close(5)                                = 0
stat64("//lib/kbd/keymaps/i386/dvorak", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
open("//lib/kbd/keymaps/i386/dvorak", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 5
fstat64(5, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
fcntl64(5, F_SETFD, FD_CLOEXEC)         = 0
getdents64(5, /* 6 entries */, 4096)    = 208
getdents64(5, /* 0 entries */, 4096)    = 0
close(5)                                = 0
stat64("//lib/kbd/keymaps/i386/fgGIod", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
open("//lib/kbd/keymaps/i386/fgGIod", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 5
fstat64(5, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
fcntl64(5, F_SETFD, FD_CLOEXEC)         = 0
getdents64(5, /* 4 entries */, 4096)    = 120
getdents64(5, /* 0 entries */, 4096)    = 0
close(5)                                = 0
stat64("//lib/kbd/keymaps/i386/include", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
open("//lib/kbd/keymaps/i386/include", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 5
fstat64(5, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
fcntl64(5, F_SETFD, FD_CLOEXEC)         = 0
getdents64(5, /* 20 entries */, 4096)   = 760
getdents64(5, /* 0 entries */, 4096)    = 0
close(5)                                = 0
stat64("//lib/kbd/keymaps/i386/qwerty", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
open("//lib/kbd/keymaps/i386/qwerty", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 5
fstat64(5, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
fcntl64(5, F_SETFD, FD_CLOEXEC)         = 0
getdents64(5, /* 87 entries */, 4096)   = 3152
pipe([6, 7])                            = 0
vfork()                                 = 1362
--- SIGCHLD (Child exited) @ 0 (0) ---
close(7)                                = 0
write(2, "Loading //lib/kbd/keymaps/i386/q"..., 48Loading //lib/kbd/keymaps/i386/qwerty/us.map.gz
) = 48
brk(0)                                  = 0x8061000
brk(0x8065000)                          = 0x8065000
ioctl(6, SNDCTL_TMR_TIMEBASE, 0xbffff250) = -1 EINVAL (Invalid argument)
fstat64(6, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40017000
read(6, "# us.map\nkeymaps 0-2,4-6,8-9,12\n"..., 4096) = 1973
read(6, "", 4096)                       = 0
open("qwerty-layout", O_RDONLY)         = -1 ENOENT (No such file or directory)
open(".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 7
fstat64(7, {st_mode=S_IFDIR|0700, st_size=4096, ...}) = 0
fcntl64(7, F_SETFD, FD_CLOEXEC)         = 0
brk(0)                                  = 0x8065000
brk(0x8066000)                          = 0x8066000
getdents64(7, /* 44 entries */, 4096)   = 1464
getdents64(7, /* 0 entries */, 4096)    = 0
close(7)                                = 0
open("../include", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = -1 ENOENT (No such file or directory)
open("../../include", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = -1 ENOENT (No such file or directory)
open("qwerty-layout", O_RDONLY)         = -1 ENOENT (No such file or directory)
open("//lib/kbd/keymaps/i386/qwerty", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 7
fstat64(7, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
fcntl64(7, F_SETFD, FD_CLOEXEC)         = 0
getdents64(7, /* 87 entries */, 4096)   = 3152
getdents64(7, /* 0 entries */, 4096)    = 0
close(7)                                = 0
open("//lib/kbd/keymaps/i386/qwerty/../include", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 7
fstat64(7, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
fcntl64(7, F_SETFD, FD_CLOEXEC)         = 0
getdents64(7, /* 20 entries */, 4096)   = 760
open("//lib/kbd/keymaps/i386/qwerty/../include/qwerty-layout.inc", O_RDONLY) = 8
brk(0)                                  = 0x8066000
brk(0x806a000)                          = 0x806a000
ioctl(8, SNDCTL_TMR_TIMEBASE, 0xbffff230) = -1 ENOTTY (Inappropriate ioctl for device)
fstat64(8, {st_mode=S_IFREG|0644, st_size=430, ...}) = 0
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40018000
read(8, "# qwerty-layout\nkeycode 16 = q\nk"..., 8192) = 430
read(8, "", 4096)                       = 0
brk(0)                                  = 0x806a000
brk(0x806b000)                          = 0x806b000
open("compose", O_RDONLY)               = -1 ENOENT (No such file or directory)
open(".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
fstat64(9, {st_mode=S_IFDIR|0700, st_size=4096, ...}) = 0
fcntl64(9, F_SETFD, FD_CLOEXEC)         = 0
brk(0)                                  = 0x806b000
brk(0x806c000)                          = 0x806c000
getdents64(9, /* 44 entries */, 4096)   = 1464
getdents64(9, /* 0 entries */, 4096)    = 0
close(9)                                = 0
open("../include", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = -1 ENOENT (No such file or directory)
open("../../include", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = -1 ENOENT (No such file or directory)
open("compose", O_RDONLY)               = -1 ENOENT (No such file or directory)
open("//lib/kbd/keymaps/i386/qwerty/../include", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
fstat64(9, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
fcntl64(9, F_SETFD, FD_CLOEXEC)         = 0
getdents64(9, /* 20 entries */, 4096)   = 760
open("//lib/kbd/keymaps/i386/qwerty/../include/compose.inc", O_RDONLY) = 10
brk(0)                                  = 0x806c000
brk(0x8070000)                          = 0x8070000
ioctl(10, SNDCTL_TMR_TIMEBASE, 0xbffff230) = -1 ENOTTY (Inappropriate ioctl for device)
fstat64(10, {st_mode=S_IFREG|0644, st_size=278, ...}) = 0
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x40019000
read(10, "# We map the PrintScreen key (us"..., 8192) = 278
read(10, "", 4096)                      = 0
read(10, "", 8192)                      = 0
ioctl(10, SNDCTL_TMR_TIMEBASE, 0xbffff220) = -1 ENOTTY (Inappropriate ioctl for device)
read(8, "", 8192)                       = 0
ioctl(8, SNDCTL_TMR_TIMEBASE, 0xbffff220) = -1 ENOTTY (Inappropriate ioctl for device)
open("linux-with-alt-and-altgr", O_RDONLY) = -1 ENOENT (No such file or directory)
open(".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 11
fstat64(11, {st_mode=S_IFDIR|0700, st_size=4096, ...}) = 0
fcntl64(11, F_SETFD, FD_CLOEXEC)        = 0
getdents64(11, /* 44 entries */, 4096)  = 1464
getdents64(11, /* 0 entries */, 4096)   = 0
close(11)                               = 0
open("../include", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = -1 ENOENT (No such file or directory)
open("../../include", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = -1 ENOENT (No such file or directory)
open("linux-with-alt-and-altgr", O_RDONLY) = -1 ENOENT (No such file or directory)
open("//lib/kbd/keymaps/i386/qwerty", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 11
fstat64(11, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
fcntl64(11, F_SETFD, FD_CLOEXEC)        = 0
getdents64(11, /* 87 entries */, 4096)  = 3152
getdents64(11, /* 0 entries */, 4096)   = 0
close(11)                               = 0
open("//lib/kbd/keymaps/i386/qwerty/../include", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 11
fstat64(11, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
fcntl64(11, F_SETFD, FD_CLOEXEC)        = 0
getdents64(11, /* 20 entries */, 4096)  = 760
open("//lib/kbd/keymaps/i386/qwerty/../include/linux-with-alt-and-altgr.inc", O_RDONLY) = 12
ioctl(12, SNDCTL_TMR_TIMEBASE, 0xbffff230) = -1 ENOTTY (Inappropriate ioctl for device)
fstat64(12, {st_mode=S_IFREG|0644, st_size=743, ...}) = 0
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x4001a000
read(12, "include \"linux-keys-bare\"\n\nkeyco"..., 8192) = 743
read(12, "", 4096)                      = 0
open("linux-keys-bare", O_RDONLY)       = -1 ENOENT (No such file or directory)
open(".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 13
fstat64(13, {st_mode=S_IFDIR|0700, st_size=4096, ...}) = 0
fcntl64(13, F_SETFD, FD_CLOEXEC)        = 0
getdents64(13, /* 44 entries */, 4096)  = 1464
getdents64(13, /* 0 entries */, 4096)   = 0
close(13)                               = 0
open("../include", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = -1 ENOENT (No such file or directory)
open("../../include", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = -1 ENOENT (No such file or directory)
open("linux-keys-bare", O_RDONLY)       = -1 ENOENT (No such file or directory)
open("//lib/kbd/keymaps/i386/qwerty/../include", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 13
fstat64(13, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
fcntl64(13, F_SETFD, FD_CLOEXEC)        = 0
getdents64(13, /* 20 entries */, 4096)  = 760
open("//lib/kbd/keymaps/i386/qwerty/../include/linux-keys-bare.inc", O_RDONLY) = 14
brk(0)                                  = 0x8070000
brk(0x8074000)                          = 0x8074000
ioctl(14, SNDCTL_TMR_TIMEBASE, 0xbffff230) = -1 ENOTTY (Inappropriate ioctl for device)
fstat64(14, {st_mode=S_IFREG|0644, st_size=4346, ...}) = 0
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x4001b000
read(14, "# Linux-specific (and language-i"..., 8192) = 4346
read(14, "", 4096)                      = 0
read(14, "", 8192)                      = 0
ioctl(14, SNDCTL_TMR_TIMEBASE, 0xbffff220) = -1 ENOTTY (Inappropriate ioctl for device)
read(12, "", 8192)                      = 0
ioctl(12, SNDCTL_TMR_TIMEBASE, 0xbffff220) = -1 ENOTTY (Inappropriate ioctl for device)
open("compose.latin1", O_RDONLY)        = -1 ENOENT (No such file or directory)
open(".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 15
fstat64(15, {st_mode=S_IFDIR|0700, st_size=4096, ...}) = 0
fcntl64(15, F_SETFD, FD_CLOEXEC)        = 0
getdents64(15, /* 44 entries */, 4096)  = 1464
getdents64(15, /* 0 entries */, 4096)   = 0
close(15)                               = 0
open("../include", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = -1 ENOENT (No such file or directory)
open("../../include", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = -1 ENOENT (No such file or directory)
open("compose.latin1", O_RDONLY)        = -1 ENOENT (No such file or directory)
open("//lib/kbd/keymaps/i386/qwerty", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 15
fstat64(15, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
fcntl64(15, F_SETFD, FD_CLOEXEC)        = 0
getdents64(15, /* 87 entries */, 4096)  = 3152
getdents64(15, /* 0 entries */, 4096)   = 0
close(15)                               = 0
open("//lib/kbd/keymaps/i386/qwerty/../include", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 15
fstat64(15, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
fcntl64(15, F_SETFD, FD_CLOEXEC)        = 0
getdents64(15, /* 20 entries */, 4096)  = 760
getdents64(15, /* 0 entries */, 4096)   = 0
close(15)                               = 0
open("//lib/kbd/keymaps/i386/qwerty/../../include", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 15
fstat64(15, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
fcntl64(15, F_SETFD, FD_CLOEXEC)        = 0
getdents64(15, /* 10 entries */, 4096)  = 368
open("//lib/kbd/keymaps/i386/qwerty/../../include/compose.latin1", O_RDONLY) = 16
ioctl(16, SNDCTL_TMR_TIMEBASE, 0xbffff230) = -1 ENOTTY (Inappropriate ioctl for device)
fstat64(16, {st_mode=S_IFREG|0644, st_size=3889, ...}) = 0
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x4001c000
read(16, "compose \'`\' \'A\' to \'\300\'\ncompose \'"..., 8192) = 3889
read(16, "", 4096)                      = 0
read(16, "", 8192)                      = 0
ioctl(16, SNDCTL_TMR_TIMEBASE, 0xbffff220) = -1 ENOTTY (Inappropriate ioctl for device)
open("euro1.map", O_RDONLY)             = -1 ENOENT (No such file or directory)
open(".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 17
fstat64(17, {st_mode=S_IFDIR|0700, st_size=4096, ...}) = 0
fcntl64(17, F_SETFD, FD_CLOEXEC)        = 0
getdents64(17, /* 44 entries */, 4096)  = 1464
getdents64(17, /* 0 entries */, 4096)   = 0
close(17)                               = 0
open("../include", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = -1 ENOENT (No such file or directory)
open("../../include", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = -1 ENOENT (No such file or directory)
open("euro1.map", O_RDONLY)             = -1 ENOENT (No such file or directory)
open("//lib/kbd/keymaps/i386/qwerty", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 17
fstat64(17, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
fcntl64(17, F_SETFD, FD_CLOEXEC)        = 0
getdents64(17, /* 87 entries */, 4096)  = 3152
getdents64(17, /* 0 entries */, 4096)   = 0
close(17)                               = 0
open("//lib/kbd/keymaps/i386/qwerty/../include", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 17
fstat64(17, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
fcntl64(17, F_SETFD, FD_CLOEXEC)        = 0
getdents64(17, /* 20 entries */, 4096)  = 760
pipe([18, 19])                          = 0
vfork()                                 = 1363
--- SIGCHLD (Child exited) @ 0 (0) ---
close(19)                               = 0
ioctl(18, SNDCTL_TMR_TIMEBASE, 0xbffff230) = -1 EINVAL (Invalid argument)
fstat64(18, {st_mode=S_IFIFO|0600, st_size=0, ...}) = 0
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x4001d000
read(18, "# Euro and cent\n# [Say: \"loadkey"..., 4096) = 253
read(18, "", 4096)                      = 0
read(18, "", 4096)                      = 0
ioctl(18, SNDCTL_TMR_TIMEBASE, 0xbffff220) = -1 EINVAL (Invalid argument)
read(6, "", 4096)                       = 0
ioctl(6, SNDCTL_TMR_TIMEBASE, 0xbffff220) = -1 EINVAL (Invalid argument)
open("/dev/tty", O_RDONLY)              = 19
ioctl(19, 0x4b33, 0xbffffa03)           = 0
ioctl(19, 0x4b47, 0xbffffa34)           = -1 EPERM (Operation not permitted)
write(2, "Keymap 0: Permission denied\n", 28Keymap 0: Permission denied
) = 28
ioctl(19, 0x4b47, 0xbffffa34)           = -1 EPERM (Operation not permitted)
write(2, "Keymap 1: Permission denied\n", 28Keymap 1: Permission denied
) = 28
ioctl(19, 0x4b47, 0xbffffa34)           = -1 EPERM (Operation not permitted)
write(2, "Keymap 2: Permission denied\n", 28Keymap 2: Permission denied
) = 28
ioctl(19, 0x4b47, 0xbffffa34)           = -1 EPERM (Operation not permitted)
write(2, "KDSKBENT: Operation not permitte"..., 34KDSKBENT: Operation not permitted
) = 34
write(2, "loadkeys: could not deallocate k"..., 40loadkeys: could not deallocate keymap 3
) = 40
exit_group(1)                           = ?

--=-Oz7QE3EaeGGKjjWOWz4m--

