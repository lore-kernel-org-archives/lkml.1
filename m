Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbZCAKfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbZCAKfO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 05:35:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbZCAKe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 05:34:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:16106 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbZCAKe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 05:34:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gkRlPZC9F3RvJzqcxaF+Ca/hos41zQGXTAw79zFYkPI39FletpMcUHh91NYoU1Z+UW
         DtuGpwT8iHydnzqxPYTJH1SJMtZX3iC/QU5uhG1FlyXLCtBtlXgzsv6D+vdVbaUVj7bJ
         UGEcKkKAKuZEdoNoJYVJEL0/JBI0ecemHwqdI=
Date: Sun, 1 Mar 2009 13:41:38 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org
Subject: Re: No more Intel HDA soundcard
Message-ID: <20090301104138.GA2341@x200.localdomain>
References: <20090228184412.GA2333@x200.localdomain> <s5hwsb9r29o.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hwsb9r29o.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 01, 2009 at 11:00:35AM +0100, Takashi Iwai wrote:
> At Sat, 28 Feb 2009 21:44:12 +0300,
> Alexey Dobriyan wrote:
> > 
> > The following commit results in soundcard detection failing with -EBUSY
> > 
> > commit 34c25350acfc792747e861d1e36874abf7e73255
> > Author: Takashi Iwai <tiwai@suse.de>
> > Date:   Tue Oct 28 11:38:58 2008 +0100
> > 
> >     ALSA: hda - Remove old codec-probe limitation
> >     
> >     Removed the old workaround to avoid the non-existing codec slot.
> >     The current code should work without that workaround.  If any,
> >     we can add a quirk table.
> >     
> >     Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > 
> > I fixed up this (and got sound back) but suspect the following is not right.
> > 
> > --- a/sound/pci/hda/hda_intel.c
> > +++ b/sound/pci/hda/hda_intel.c
> > @@ -1224,6 +1224,7 @@ static void azx_stop_chip(struct azx *chip);
> >  
> >  /* number of codec slots for each chipset: 0 = default slots (i.e. 4) */
> >  static unsigned int azx_max_codecs[AZX_NUM_DRIVERS] __devinitdata = {
> > +	[AZX_DRIVER_ICH] = 3,
> >  	[AZX_DRIVER_TERA] = 1,
> >  };
> 
> Right, it's no good solution as you expected ;)
> The problem is that your patch will disable the all HDMI devices that are
> newly supported on 2.6.29.
> 
> Is your machine Toshiba X200, found in bug 12735 ??
> 	http://bugzilla.kernel.org/show_bug.cgi?id=12735
> 
> If yes, could you try the patch below?
> 
> Also, it'd be helpful if you can try sound git tree (master branch):
>     git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git
> that contains the very latest driver.  This should work as is.

Sound works as is, alsamixer refuses to start with

	ALSA lib simple_none.c:1491:(simple_add1) helem (MIXER,'Beep Playback Switch',0,3,0) appears twice or more
	alsamixer: function snd_mixer_load failed: Invalid argument

execve("/usr/bin/alsamixer", ["alsamixer"], [/* 28 vars */]) = 0
brk(0)                            = 0x9c47000
access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No such file or directory)
mmap2(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f70000
access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=42149, ...}) = 0
mmap2(NULL, 42149, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f65000
close(3)                          = 0
access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No such file or directory)
open("/lib/libncurses.so.5", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0p\243\0\0004\0\0\0\344"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=202188, ...}) = 0
mmap2(NULL, 202004, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7f33000
mmap2(0xb7f62000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2f) = 0xb7f62000
close(3)                          = 0
access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No such file or directory)
open("/usr/lib/libasound.so.2", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\200\3\2\0004\0\0\0\270"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=790768, ...}) = 0
mmap2(NULL, 793768, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7e71000
mmap2(0xb7f2e000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xbc) = 0xb7f2e000
close(3)                          = 0
access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No such file or directory)
open("/lib/i686/cmov/libm.so.6", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0@4\0\0004\0\0\0P"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=149328, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7e70000
mmap2(NULL, 151680, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7e4a000
mmap2(0xb7e6e000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x23) = 0xb7e6e000
close(3)                          = 0
access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No such file or directory)
open("/lib/i686/cmov/libdl.so.2", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0`\n\0\0004\0\0\0H"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=9680, ...}) = 0
mmap2(NULL, 12412, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7e46000
mmap2(0xb7e48000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1) = 0xb7e48000
close(3)                          = 0
access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No such file or directory)
open("/lib/i686/cmov/libpthread.so.0", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0000H\0\0004\0\0\0\330"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=116414, ...}) = 0
mmap2(NULL, 98784, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7e2d000
mmap2(0xb7e42000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x14) = 0xb7e42000
mmap2(0xb7e44000, 4576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7e44000
close(3)                          = 0
access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No such file or directory)
open("/lib/i686/cmov/libc.so.6", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\260e\1\0004\0\0\0\4"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1413540, ...}) = 0
mmap2(NULL, 1418864, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7cd2000
mmap2(0xb7e27000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x155) = 0xb7e27000
mmap2(0xb7e2a000, 9840, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7e2a000
close(3)                          = 0
access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No such file or directory)
open("/lib/i686/cmov/librt.so.1", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0`\31\0\0004\0\0\0\240"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=30624, ...}) = 0
mmap2(NULL, 33360, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7cc9000
mmap2(0xb7cd0000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x6) = 0xb7cd0000
close(3)                          = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7cc8000
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7cc7000
set_thread_area({entry_number:-1 -> 6, base_addr:0xb7cc76b0, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
mprotect(0xb7e27000, 4096, PROT_READ) = 0
munmap(0xb7f65000, 42149)         = 0
set_tid_address(0xb7cc76f8)       = 2322
set_robust_list(0xb7cc7700, 0xc)  = 0
futex(0xbf88b7e0, FUTEX_WAKE_PRIVATE, 1) = 0
rt_sigaction(SIGRTMIN, {0xb7e312e0, [], SA_SIGINFO}, NULL, 8) = 0
rt_sigaction(SIGRT_1, {0xb7e31720, [], SA_RESTART|SA_SIGINFO}, NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM_INFINITY}) = 0
uname({sys="Linux", node="x200", ...}) = 0
brk(0)                            = 0x9c47000
brk(0x9c68000)                    = 0x9c68000
stat64("/usr/share/alsa/alsa.conf", {st_mode=S_IFREG|0644, st_size=8617, ...}) = 0
open("/usr/share/alsa/alsa.conf", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=8617, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f6f000
read(3, "#\n#  ALSA library configuration f"..., 4096) = 4096
read(3, " refer\n\t\t\t\tname defaults.pcm.devi"..., 4096) = 4096
read(3, "fault {\n\t\t\t@func refer\n\t\t\tname de"..., 4096) = 425
read(3, ""..., 4096)              = 0
read(3, ""..., 4096)              = 0
close(3)                          = 0
munmap(0xb7f6f000, 4096)          = 0
futex(0xb7e49070, FUTEX_WAKE_PRIVATE, 2147483647) = 0
access("/etc/asound.conf", R_OK)  = -1 ENOENT (No such file or directory)
access("/home/ad/.asoundrc", R_OK) = -1 ENOENT (No such file or directory)
open("/dev/snd/controlC0", O_RDONLY) = 3
close(3)                          = 0
open("/dev/snd/controlC0", O_RDWR) = 3
ioctl(3, USBDEVFS_CONTROL, 0xbf88b468) = 0
ioctl(3, UI_DEV_CREATE, 0xbf88b560) = 0
close(3)                          = 0
stat64("/usr/share/alsa/alsa.conf", {st_mode=S_IFREG|0644, st_size=8617, ...}) = 0
open("/dev/snd/controlC0", O_RDONLY) = 3
close(3)                          = 0
open("/dev/snd/controlC0", O_RDWR) = 3
ioctl(3, USBDEVFS_CONTROL, 0xbf88b408) = 0
fcntl64(3, F_GETFL)               = 0x2 (flags O_RDWR)
fcntl64(3, F_SETFL, O_RDWR|O_NONBLOCK) = 0
ioctl(3, USBDEVFS_RELEASEINTERFACE, 0xbf88b4d4) = 0
ioctl(3, USBDEVFS_RELEASEINTERFACE, 0xbf88b4d4) = 0
ioctl(3, USBDEVFS_CONNECTINFO, 0xbf88b1d0) = 0
ioctl(3, USBDEVFS_IOCTL, 0xbf88ad50) = 0
ioctl(3, USBDEVFS_CONNECTINFO, 0xbf88b1d0) = 0
ioctl(3, USBDEVFS_IOCTL, 0xbf88ad40) = 0
ioctl(3, USBDEVFS_IOCTL, 0xbf88ad50) = 0
ioctl(3, USBDEVFS_CONNECTINFO, 0xbf88b1d0) = 0
ioctl(3, USBDEVFS_IOCTL, 0xbf88ad50) = 0
ioctl(3, USBDEVFS_CONNECTINFO, 0xbf88b1d0) = 0
ioctl(3, USBDEVFS_IOCTL, 0xbf88ad40) = 0
ioctl(3, USBDEVFS_IOCTL, 0xbf88ad50) = 0
ioctl(3, USBDEVFS_CONNECTINFO, 0xbf88b1d0) = 0
ioctl(3, USBDEVFS_IOCTL, 0xbf88ad40) = 0
ioctl(3, USBDEVFS_CONNECTINFO, 0xbf88b1d0) = 0
ioctl(3, USBDEVFS_IOCTL, 0xbf88ad40) = 0
ioctl(3, USBDEVFS_IOCTL, 0xbf88ad40) = 0
ioctl(3, USBDEVFS_CONNECTINFO, 0xbf88b1d0) = 0
ioctl(3, USBDEVFS_IOCTL, 0xbf88ad50) = 0
ioctl(3, USBDEVFS_CONNECTINFO, 0xbf88b1d0) = 0
ioctl(3, USBDEVFS_IOCTL, 0xbf88ad40) = 0
ioctl(3, USBDEVFS_IOCTL, 0xbf88ad50) = 0
ioctl(3, USBDEVFS_CONNECTINFO, 0xbf88b1d0) = 0
ioctl(3, USBDEVFS_IOCTL, 0xbf88ad40) = 0
ioctl(3, USBDEVFS_IOCTL, 0xbf88ad40) = 0
ioctl(3, USBDEVFS_CONNECTINFO, 0xbf88b1d0) = 0
ioctl(3, USBDEVFS_IOCTL, 0xbf88ad50) = 0
ioctl(3, USBDEVFS_CONNECTINFO, 0xbf88b1d0) = 0
ioctl(3, USBDEVFS_IOCTL, 0xbf88ad50) = 0
ioctl(3, USBDEVFS_CONNECTINFO, 0xbf88b1d0) = 0
ioctl(3, USBDEVFS_IOCTL, 0xbf88ad40) = 0
ioctl(3, USBDEVFS_IOCTL, 0xbf88ad50) = 0
ioctl(3, USBDEVFS_CONNECTINFO, 0xbf88b1d0) = 0
ioctl(3, USBDEVFS_IOCTL, 0xbf88ad40) = 0
ioctl(3, USBDEVFS_IOCTL, 0xbf88ad50) = 0
ioctl(3, USBDEVFS_CONNECTINFO, 0xbf88b1d0) = 0
ioctl(3, USBDEVFS_IOCTL, 0xbf88ad50) = 0
ioctl(3, USBDEVFS_CONNECTINFO, 0xbf88b1d0) = 0
ioctl(3, USBDEVFS_CONNECTINFO, 0xbf88b1d0) = 0
ioctl(3, USBDEVFS_CONNECTINFO, 0xbf88b1d0) = 0
ioctl(3, USBDEVFS_CONNECTINFO, 0xbf88b1d0) = 0
ioctl(3, USBDEVFS_CONNECTINFO, 0xbf88b1d0) = 0
ioctl(3, USBDEVFS_CONNECTINFO, 0xbf88b1d0) = 0
ioctl(3, USBDEVFS_CONNECTINFO, 0xbf88b1d0) = 0
ioctl(3, USBDEVFS_IOCTL, 0xbf88ad50) = 0
ioctl(3, USBDEVFS_CONNECTINFO, 0xbf88b1d0) = 0
ioctl(3, USBDEVFS_IOCTL, 0xbf88ad50) = 0
ioctl(3, USBDEVFS_CONNECTINFO, 0xbf88b1d0) = 0
ioctl(3, USBDEVFS_IOCTL, 0xbf88ad50) = 0
ioctl(3, USBDEVFS_CONNECTINFO, 0xbf88b1d0) = 0
write(2, "ALSA lib simple_none.c:1491:(simp"..., 42) = 42
write(2, "helem (MIXER,'Beep Playback Switc"..., 64) = 64
write(2, "\n"..., 1)              = 1
fstat64(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f6f000
write(1, "\n"..., 1)              = 1
write(2, "alsamixer: function snd_mixer_loa"..., 60) = 60
exit_group(2)                     = ?
