Return-Path: <linux-kernel-owner+w=401wt.eu-S1758568AbZCJQye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568AbZCJQye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757830AbZCJQtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:49:24 -0400
Received: from alcalazamora.dti2.net ([81.24.162.8]:1873 "EHLO
	alcalazamora.dti2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757827AbZCJQtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:49:22 -0400
X-Spam-Processed: alcalazamora.dti2.net, Tue, 10 Mar 2009 17:49:18 +0100
	(not processed: message from valid local sender)
X-MDOP-RefID: str=0001.0A0B0204.49B69A0A.0311,ss=1,fgs=0 (_st=1 _vt=0 _iwf=0)
X-Authenticated-Sender: jorge@dti2.net
X-MDRemoteIP: 81.24.161.20
X-Return-Path: jorge@dti2.net
X-Envelope-From: jorge@dti2.net
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <49B69A09.3080408@dti2.net>
Date: Tue, 10 Mar 2009 17:49:13 +0100
From: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: npiggin@suse.de
CC: ext-adrian.hunter@nokia.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Error testing ext3 on brd ramdisk
References: <491D7C4C.3090907@nokia.com> <49A82C2E.4030903@dti2.net> <20090228055809.GC28496@wotan.suse.de> <49AC1A7A.1070108@dti2.net> <20090305065529.GB11916@wotan.suse.de> <49AF9932.2040301@dti2.net> <20090305094623.GA17815@wotan.suse.de> <49AFAFD9.9050805@dti2.net> <49AFC1A9.90501@dti2.net> <20090310161247.GA19352@wotan.suse.de> <20090310163002.GC19352@wotan.suse.de>
In-Reply-To: <20090310163002.GC19352@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Reply-To: jorge@dti2.net
X-MDAV-Processed: alcalazamora.dti2.net, Tue, 10 Mar 2009 17:49:19 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin escribió:
> On Tue, Mar 10, 2009 at 05:12:47PM +0100, Nick Piggin wrote:
>> On Thu, Mar 05, 2009 at 01:12:25PM +0100, Jorge Boncompte [DTI2] wrote:
>>> Jorge Boncompte [DTI2] escribió:
>>>> Ok. I have modified the script to do...
>>>> ------------
>>>> mount -no remount,ro /dev/ram0
>>>> dd if=/dev/ram0 of=/tmp/config.bin bs=1k count=1000
>>>> fsck.minix -fv /tmp/config.bin
>>>> if [ $? != 0 ]; then
>>>>    echo "FATAL: Filesystem is corrupted"
>>>>    exit 2
>>>> fi
>>>> mount -no remount,rw /dev/ram0
>>>> md5sum config.bin
>>>> dd if=config.bin of=/dev/hda1
>>>> echo $md5sum | dd of=/dev/hda1 bs=1k seek=1100 count=32
>>>> ------------
>>>> ... after some cycles of modifying files on the filesystem and trying to 
>>>> save it to disk...
>>>> ------------------
>>>> fsck.minix: BusyBox v1.8.2 (2008-12-03 14:24:56 CET)
>>>> Forcing filesystem check on /tmp/config.bin
>>>> Unused inode 198 is marked as 'used' in the bitmap.
>>>> Zone 393 is marked 'in use', but no file uses it.
>>>> Zone 394 is marked 'in use', but no file uses it.
>>>>
>>>>   198 inodes used (58%)
>>>>   395 zones used (39%)
>>>>
>>>>   163 regular files
>>>>    24 directories
>>>>     0 character device files
>>>>     0 block device files
>>>>     0 links
>>>>    10 symbolic links
>>>> ------
>>>>   197 files
>>>> FATAL: Filesystem is corrupted
>>>> -------------------
>>>>
>>> 	If after getting the "FATAL: Filesystem is corrupted" message I do 
>>> "echo 3 > /proc/sys/vm/drop_caches" and rerun the script the filesystem 
>>> somehow got magically fixed (I mean fsck.minix does not report errors 
>>> and the image gets written to disk well ;-)
>> OK, I can reproduce this. It really does seem to be due to buffercache
>> going out of coherency for some reason, so the trick is that you have
>> to fsck it while you have it mounted ro before remounting rw then modifying
>> it then remounting ro and fscking again (the first fsck must bring in
>> uptodate buffercache, and something is not being correctly invalidated).
>>
>> It is also not brd or minix specific -- I reproduced it with loop driver
>> and ext2 too, and probably regular disk driver will have the same problem
>> (ie. it is something in the buffercache).
>>
>> I don't know if this is the same problem as the ext3 issue -- the recipe
>> for reproducing ext3 problem includes umount, which will invalidate all
>> the buffercache unless something is holding the bdev open. But anyway I
>> am making some progress with this problem so I will try solve it first.
>>
>> I can't think of any good reason why buffercache should be going out of
>> sync here...
> 
> Ah, of course, it would be due to directory-in-pagecache. You need
> the following patch if you expect this to work.
> 
> And that confirms the ext3 problem is a different one because it
> doesn't use directory in pagecache I think. Well, I'll look at
> that one tomorrow.
> 
> Thanks,
> Nick
> 
> ---
>  fs/super.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6/fs/super.c
> ===================================================================
> --- linux-2.6.orig/fs/super.c
> +++ linux-2.6/fs/super.c
> @@ -644,6 +644,8 @@ int do_remount_sb(struct super_block *sb
>  		acct_auto_close(sb);
>  	shrink_dcache_sb(sb);
>  	fsync_super(sb);
> +	if (flags & MS_RDONLY)
> +		invalidate_bdev(sb->s_bdev);
>  
>  	/* If we are remounting RDONLY and current sb is read/write,
>  	   make sure there are no rw files opened */
> 
> 
> 
> 

	With this applied it seems I cannot reproduce the corruption, I have to 
do more tests, but the box oopses on reboot after doing "umount -na -r".

[  193.073856] BUG: unable to handle kernel NULL pointer dereference at 
00000004
[  193.075762] IP: [<c018baa7>] invalidate_bdev+0x4/0x27
[  193.078748] *pde = 00000000
[  193.080306] Oops: 0000 [#1] SMP
[  193.082066] last sysfs file: 
/sys/devices/pci0000:00/0000:00:01.3/i2c-adapter/i2c-0/name
[  193.082066] Modules linked in: atmtcp ipt_REJECT nf_conntrack_ipv4 
nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables 
i2c_piix4 i2c_core ata_piix libata ppp_async ppp_synctty sha1_generic 
arc4 ecb ppp_mppe pppol2tp pppoatm pppoe pppox ppp_generic slhc 8021q 
garp tun softdog usbcore
[  193.082066]
[  193.082066] Pid: 1500, comm: busybox Not tainted (2.6.29-rc7 #122)
[  193.082066] EIP: 0060:[<c018baa7>] EFLAGS: 00010202 CPU: 3
[  193.082066] EIP is at invalidate_bdev+0x4/0x27
[  193.082066] EAX: 00000000 EBX: 00000001 ECX: 00000000 EDX: 00000001
[  193.082066] ESI: ce82dc00 EDI: 00000000 EBP: ce861f30 ESP: ce861f2c
[  193.082066]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  193.082066] Process busybox (pid: 1500, ti=ce860000 task=ce8c0530 
task.ti=ce860000)
[  193.082066] Stack:
[  193.082066]  00000001 ce861f48 c017408a 00000001 00000001 ce861f78 
ce82dc00 ce861f64
[  193.082066]  c0184cd8 00000000 00000040 ce251000 00000001 00000040 
ce861f8c c01853d5
[  193.082066]  00000000 00000000 ce518000 cf81f140 cf401f20 00000000 
ce251000 00000000
[  193.082066] Call Trace:
[  193.082066]  [<c017408a>] ? do_remount_sb+0x4b/0xc2
[  193.082066]  [<c0184cd8>] ? do_remount+0x70/0xb5
[  193.082066]  [<c01853d5>] ? do_mount+0x107/0x181
[  193.082066]  [<c0185665>] ? sys_mount+0x6a/0xa6
[  193.082066]  [<c0102ce2>] ? syscall_call+0x7/0xb
[  193.082066] Code: 43 c0 e8 d2 74 f9 ff 58 5a 8b 45 ec 83 c0 74 e8 d8 
fb 1c 00 8b 45 e4 e8 f9 e1 fc ff 8b 45 e8 8d 65 f4 5b 5e 5f 5d c3 55 89 
e5 53 <8b> 40 04 8b 98 14 01 00 00 83 7b 60 00 74 11 e8 36 0f 00 00 83
[  193.082066] EIP: [<c018baa7>] invalidate_bdev+0x4/0x27 SS:ESP 
0068:ce861f2c
[  193.132444] ---[ end trace 47b1cfc0707471fd ]---
[  193.133287] Kernel panic - not syncing: Fatal exception
[  193.134372] Rebooting in 40 seconds.. 


-- 
==============================================================
Jorge Boncompte - Ingenieria y Gestion de RED
DTI2 - Desarrollo de la Tecnologia de las Comunicaciones
--------------------------------------------------------------
C/ Abogado Enriquez Barrios, 5   14004 CORDOBA (SPAIN)
Tlf: +34 957 761395 / FAX: +34 957 450380
==============================================================
- Sin pistachos no hay Rock & Roll...
- Without wicker a basket cannot be made.
==============================================================

