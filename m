Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbYGZMaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbYGZMaW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 08:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbYGZMaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 08:30:07 -0400
Received: from smtp-out5.tpgi.com.au ([220.244.226.115]:37376 "EHLO
	mail5.tpgi.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751307AbYGZMaF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 08:30:05 -0400
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Jul 2008 08:30:05 EDT
X-TPG-Antivirus: Passed
From: Kel Modderman <kel@otaku42.de>
To: linux-kernel@vger.kernel.org
Subject: tmpfs: kernel BUG at mm/shmem.c:814
Date: Sat, 26 Jul 2008 22:10:11 +1000
User-Agent: KMail/1.9.9
Cc: linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807262210.11502.kel@otaku42.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am able to reproduce the triggering of BUG_ON() in shmem_delete_inode
function of mm/shmem.c, line 814, while testing the insserv program in a dir
on a tmpfs mount point with Linux 2.6.25.x and 2.6.26.

insserv is the suse sysv initscript ordering program. It creates, removes
and overwrites many files, directories and symlinks in a specific directory
hierachy, and tries to do so as quickly and efficiently as possible. It's
test suite is self contained, and hopefully runs on Linux systems other
than Debian and suse, however I have not used it on a non-Debian system before.

Below are the commands to reproduce, followed by the kernel output. The test
script segfaults as it exits, as the trap function is attempting to remove
the temporary directory that the insserv test suite operated in.

# mount -t tmpfs -o mode=1777 tmpfs /var/tmp/
# exit
$ cd /var/tmp/
$ wget -q http://users.tpg.com.au/sigm/misc/insserv-1.11.10-shmem.tar.gz
$ tar xzf insserv-1.11.10-shmem.tar.gz
$ cd insserv-1.11.10/
$ make
gcc -W -Wall -g -O2   -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64  -DINITDIR=\"/etc/init.d\" -DINSCONF=\"/etc/insserv.conf\" -pipe -falign-loops=0 -c insserv.c
gcc -W -Wall -g -O2   -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64  -DINITDIR=\"/etc/init.d\" -DINSCONF=\"/etc/insserv.conf\" -pipe -falign-loops=0 -c listing.c
gcc -W -Wall -g -O2   -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64  -DINITDIR=\"/etc/init.d\" -DINSCONF=\"/etc/insserv.conf\" -pipe -Wl,-O,3,--relax -o insserv insserv.o listing.o
sed -r '\!@@BEGIN_SUSE@@!,\!@@(ELSE|END)_SUSE@@!d;\!@@(NOT|END)_SUSE@@!d' < insserv.8.in > insserv.8
$ chmod +x tests/run-testsuite
$ ./tests/run-testsuite

info: test normal boot sequence scripts, and their order

insserv: warning: script 'nolsbheader' missing LSB tags and overrides
insserv.conf

init.d:
beforenfs     halt        ifupdown-clean  mountall.sh       mountnfs.sh  needlocalfs  reboot    umountfs
checkfs.sh    hwclock.sh  kexec           mountdevsubfs.sh  needallfs    networking   single    umountnfs
checkroot.sh  ifupdown    killprocs       mountkernfs.sh    needallfs2   nolsbheader  sysklogd  umountroot

rc0.d:
K01hwclock.sh  K01needlocalfs  K02needallfs2  K03umountnfs   K05ifupdown  K07umountroot
K01needallfs   K01nolsbheader  K02sysklogd    K04networking  K06umountfs  K08halt

rc1.d:
K01needallfs  K01needlocalfs  K01nolsbheader  K02needallfs2  K02sysklogd  S01killprocs  S02single

rc2.d:
S01needallfs2  S01needlocalfs  S01sysklogd  S02needallfs  S02nolsbheader

rc3.d:
S01needallfs2  S01needlocalfs  S01sysklogd  S02needallfs  S02nolsbheader

rc4.d:
S01needallfs2  S01needlocalfs  S01sysklogd  S02needallfs  S02nolsbheader

rc5.d:
S01needallfs2  S01needlocalfs  S01sysklogd  S02needallfs  S02nolsbheader

rc6.d:
K01hwclock.sh  K01needlocalfs  K02needallfs2  K03umountnfs   K05ifupdown  K07umountroot  K09reboot
K01needallfs   K01nolsbheader  K02sysklogd    K04networking  K06umountfs  K08kexec

rcS.d:
S01mountkernfs.sh    S03checkroot.sh  S05hwclock.sh      S05mountall.sh  S06ifupdown    S08mountnfs.sh
S02mountdevsubfs.sh  S04checkfs.sh    S05ifupdown-clean  S06beforenfs    S07networking
success: 23 test executed, 0 nonfatal tests failed.
/var/tmp/insserv-1.11.10/tests/suite: line 22:  3658 Segmentation fault      return $ret
$
------------[ cut here ]------------
kernel BUG at mm/shmem.c:814!
invalid opcode: 0000 [1] PREEMPT SMP
CPU 1
Modules linked in: radeon drm michael_mic arc4 ecb crypto_blkcipher ieee80211_crypt_tkip video output ac battery ipv6 af_packet powernow_k8 cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_performance cpufreq_conservative vboxdrv xt_state xt_length xt_conntrack ipt_LOG xt_limit xt_tcpudp iptable_mangle iptable_nat nf_nat iptable_filter ip_tables x_tables nf_conntrack_ipv4 nf_conntrack fuse dvb_pll mt352 cx88_dvb cx88_vp3054_i2c videobuf_dvb dvb_core snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_hwdep snd parport_pc snd_page_alloc cx8800 cx8802 cx88xx rtc_cmos parport rtc_core rtc_lib usbhid ir_common i2c_algo_bit pcspkr hid evdev ipw2200 k8temp ff_memless soundcore tveeprom compat_ioctl32 videodev v4l1_compat v4l2_common videobuf_dma_sg videobuf_core btcx_risc ieee80211 ieee80211_crypt i2c_piix4 i2c_core button ext3 jbd mbcache sg sr_mod cdrom pata_acpi sd_mod pata_atiixp r8169 ata_generic ehci_hcd ohci_hcd usbcore ahci ssb pcmcia pcmcia_core firmware_class libata scsi_mod dock thermal processor fan
Pid: 3661, comm: rm Not tainted 2.6.26-0.slh.3-sidux-amd64 #1
RIP: 0010:[<ffffffff802b7125>]  [<ffffffff802b7125>] shmem_delete_inode+0xd5/0xe0
RSP: 0018:ffff81011802be48  EFLAGS: 00010202
RAX: ffffffff804ce860 RBX: ffff81011b0f1360 RCX: ffff81011b0f1380
RDX: ffff81011b0f3bb8 RSI: 0000000000000001 RDI: ffff81011b0f1360
RBP: ffff81011b0f1360 R08: 0000000000000000 R09: ffff810114c126e0
R10: 0000000000000000 R11: ffffffff80336910 R12: 0000000000000000
R13: 0000000001bbf060 R14: 0000000000000004 R15: 0000000000000002
FS:  00007f6a469fd6e0(0000) GS:ffff810127c02780(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000040a072 CR3: 000000011b16f000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rm (pid: 3661, threadinfo ffff81011802a000, task ffff81012524dbe0)
Stack:  0000000001bbf060 ffffffff802b7050 ffff81011b0f1360 ffffffff802dd674
 ffff810114c12688 ffff810114c12680 ffff810114c12688 ffffffff802d99ac
 0000000001bbf060 ffff810114c12680 0000000000000000 ffffffff802da0b7
Call Trace:
 [<ffffffff802b7050>] ? shmem_delete_inode+0x0/0xe0
 [<ffffffff802dd674>] ? generic_delete_inode+0xa4/0x170
 [<ffffffff802d99ac>] ? d_kill+0x3c/0x70
 [<ffffffff802da0b7>] ? dput+0x77/0x140
 [<ffffffff802d1e72>] ? do_rmdir+0x122/0x150
 [<ffffffff8020c59a>] ? system_call_after_swapgs+0x8a/0x8f


Code: 89 6b f8 48 89 6b f0 e8 8a 05 1f 00 e9 5f ff ff ff 0f 1f 44 00 00 48 8d b8 ff 0f 00 00 48 c1 ef 0c 48 f7 df e8 bd f8 fd ff eb 95 <0f> 0b eb fe 0f 1f 80 00 00 00 00 48 83 ec 18 48 89 5c 24 08 48
RIP  [<ffffffff802b7125>] shmem_delete_inode+0xd5/0xe0
 RSP <ffff81011802be48>
---[ end trace 451818791e935002 ]---

Thanks, Kel.
