Return-Path: <linux-kernel-owner+w=401wt.eu-S1762392AbZATSvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762392AbZATSvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 13:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbZATSvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 13:51:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48080 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423AbZATSvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 13:51:14 -0500
Date: Tue, 20 Jan 2009 13:50:51 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Bernhard Schmidt <berni@birkenwald.de>, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-cifs-client] BUG: Possible cifs+IPv6-Regression 2.6.27.4
 -> 2.6.27.9
Message-ID: <20090120135051.5558af34@tleilax.poochiereds.net>
In-Reply-To: <20090120072516.10f24425@tleilax.poochiereds.net>
References: <20090118221329.GA12742@pest>
	<20090118210314.30832598@tleilax.poochiereds.net>
	<20090119103248.GA28699@schleppi.birkenwald.de>
	<20090119160725.34124637@tleilax.poochiereds.net>
	<20090119213819.GA6532@pest>
	<20090120072516.10f24425@tleilax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2009 07:25:16 -0500
Jeff Layton <jlayton@redhat.com> wrote:

> On Mon, 19 Jan 2009 22:38:20 +0100
> Bernhard Schmidt <berni@birkenwald.de> wrote:
> 
> > On Mon, Jan 19, 2009 at 04:07:25PM -0500, Jeff Layton wrote:
> > 
> > > That said, there's a lot of jumping around in this assembly code and
> > > it's not completely clear to me how it got to the point where it crashed.
> > > We'll probably need to see if this can be independently reproduced. Can
> > > you email along the details of how you're reproducing this? In
> > > particular:
> > > 
> > > 1) all mount options being used
> > 
> > Not more than the ones shown in my original mail. The exact mount
> > command is *checkingfirewall*
> > 
> > mount -t cifs -o user=berni,ip=2001:a60:f001:1::69 //fileserv/pub /pub
> > 
> > > 2) details on the server (what OS, what version of samba, etc)
> > > 3) version of mount.cifs being used
> > 
> > The server is a Debian Lenny based i386 system running a self-compiled
> > vanilla 2.6.28 kernel and Debian packaged Samba 3.2.5-3.
> > 
> > The client is Ubuntu Intrepid (8.10) with intrepid-security,
> > intrepid-updates and intrepid-proposed enabled. mount.cifs -V does not
> > work misteriously (displays the usage instruction), the package version
> > is 3.2.3-1ubuntu3.4.
> > 
> > All those programs are not changed. After booting into kernel
> > 2.6.27-7.14 (intrepid release) or 2.6.27-9.19 (intrepid-security,
> > intrepid-updates) the above noted mount command works fine, after
> > booting 2.6.27-11.23 (intrepid-proposed) it's broken. I can change
> > between those client kernel versions and reproduce it.
> > 
> > The changes between the working and the non-working version should
> > be as noted in
> > 
> > https://launchpad.net/ubuntu/intrepid/+source/linux/2.6.27-10.20
> > https://launchpad.net/ubuntu/intrepid/+source/linux/2.6.27-11.23
> > 
> > And I've just discovered something. Remind you, I'm trying to mount
> > 2001:a60:f001:1::69. However, after entering the password the system
> > tries to reach another address
> > 
> > 22:31:24.336790 IP6 2001:a60:f001:1:219:66ff:fe8b:a6e > ff02::1:ff00:69:
> > ICMP6, neighbor solicitation, who has 2001:a60:f001:1:55:abe3:0:69,
> > length 32
> > 
> > The (wrong) address changes slightly between consecutive tries, I've seen 
> > 2001:a60:f001:1:4f:abe3:0:69
> > 2001:a60:f001:1:58:abe3:0:69
> > as well.
> > 
> > Also, when I try some other (legal, but unused) address it bails out at
> > another code location, e.g.
> > 
> > mount -t cifs -o user=berni,ip=2001:a60:f001:1:cc::69 //fileserv/pub
> > /pub
> > 
> > results in an immediate (!)
> > 
> > [  486.470983] BUG: unable to handle kernel paging request at 0000cc0c
> > [  486.470992] IP: [<f9c0a3d6>] :cifs:ipv6_connect+0x46/0x1a0
> > [  486.471008] *pde = 00000000
> > [  486.471012] Oops: 0000 [#13] SMP
> > [  486.471016] Modules linked in: nls_cp437 cifs af_packet binfmt_misc rfcomm bridge stp bnep sco l2cap bluetooth kvm_amd kvm ppdev tun ipv6 pci_slot container sbs sbshc video output battery
> > iptable_filter ip_tables x_tables ac parport_pc lp parport serio_raw pcspkr psmouse snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi k8temp snd_rawmidi
> > snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore snd_page_alloc i2c_piix4 i2c_core evdev dm_multipath scsi_dh pl2303 usbserial fglrx(P) agpgart wmi button shpchp pci_hotplug ext3 jbd
> > mbcache sr_mod cdrom pata_acpi sd_mod crc_t10dif pata_atiixp sg usbhid hid usb_storage libusual ata_generic ahci ohci_hcd ehci_hcd libata usbcore scsi_mod dock r8169 mii dm_mirror dm_log dm_snapshot
> > dm_mod thermal processor fan fbcon tileblit font bitblit softcursor fuse
> > [  486.471076]
> > [  486.471079] Pid: 6607, comm: mount.cifs Tainted: P      D   (2.6.27-11-generic #1)
> > [  486.471082] EIP: 0060:[<f9c0a3d6>] EFLAGS: 00010246 CPU: 0
> > [  486.471092] EIP is at ipv6_connect+0x46/0x1a0 [cifs]
> > [  486.471095] EAX: 0000cc00 EBX: f9c3b094 ECX: 0000001c EDX: c4ecfe44
> > [  486.471097] ESI: c4ecfe44 EDI: c4ecfe54 EBP: c4ecfd94 ESP: c4ecfd7c
> > [  486.471100]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > [  486.471103] Process mount.cifs (pid: 6607, ti=c4ece000 task=ce5abed0 task.ti=c4ece000)
> > [  486.471105] Stack: c4ecfd94 f9c1708b 00000000 f9c3b094 c4eaa000 f9c3b094 c4ecfe64 f9c0bf5c
> > [  486.471112]        c10b1030 c4eac000 c4ecfdcc c0189c8d c4eab000 000280d0 f9c3b094 000a100c
> > [  486.471118]        00000001 caa0e3c0 dbf3e200 0000000c 00000000 00000020 c4ecfe4c c4ecfe0c
> > [  486.471124] Call Trace:
> > [  486.471127]  [<f9c1708b>] ? cifs_inet_pton+0x7b/0x80 [cifs]
> > [  486.471141]  [<f9c0bf5c>] ? cifs_mount+0x46c/0xda0 [cifs]
> > [  486.471151]  [<c0189c8d>] ? prep_new_page+0xdd/0x160
> > [  486.471161]  [<c024e132>] ? idr_get_empty_slot+0xe2/0x270
> > [  486.471167]  [<f9bfddf3>] ? cifs_read_super+0x93/0x1e0 [cifs]
> > [  486.471176]  [<c01b38f0>] ? set_anon_super+0x0/0xd0
> > [  486.471181]  [<f9bfdfa9>] ? cifs_get_sb+0x69/0xc0 [cifs]
> > [  486.471192]  [<c01b468e>] ? vfs_kern_mount+0x5e/0x130
> > [  486.471197]  [<c01b47be>] ? do_kern_mount+0x3e/0xe0
> > [  486.471201]  [<c01cccff>] ? do_new_mount+0x6f/0x90
> > [  486.471206]  [<c01cd242>] ? do_mount+0x1d2/0x1f0
> > [  486.471210]  [<c01ca95d>] ? exact_copy_from_user+0x4d/0xa0
> > [  486.471214]  [<c01caf6e>] ? copy_mount_options+0x6e/0xd0
> > [  486.471218]  [<c01cd2f1>] ? sys_mount+0x91/0xc0
> > [  486.471222]  [<c0103f7b>] ? sysenter_do_call+0x12/0x2f
> > [  486.471227]  =======================
> > [  486.471228] Code: 8b 02 85 c0 0f 84 eb 00 00 00 66 83 7e 02 00 66 c7 06 0a 00 66 c7 45 f2 00 00 75 59 66 c7 46 02 01 bd 8b 07 b9 1c 00 00 00 89 f2 <8b> 58 0c c7 04 24 00 00 00 00 ff 53 10 85 c0 89
> > c3 78 67 8b 07
> > [  486.471257] EIP: [<f9c0a3d6>] ipv6_connect+0x46/0x1a0 [cifs] SS:ESP 0068:c4ecfd7c
> > [  486.471269] ---[ end trace cbe7d886432a8981 ]---#
> > 
> > This looks like an address corruption in the memory, maybe the original
> > BUG was there before and did not trigger because the server was reachable.
> > 
> > Bernhard
> > 
> 
> I've still not been able to reproduce this here though I don't have any
> test boxes with kernels this old and I don't have any 32-bit x86 boxes
> handy. Here's something that may be helpful though. Could you turn up
> cifsFYI, reproduce this and then send along the log messages?
> 
> # echo 7 > /proc/fs/cifs/cifsFYI
> # mount -t cifs -o user=berni,ip=2001:a60:f001:1:cc::69 //fileserv/pub /pub
> 
> ...then send along all of the cifs debug messages and the oops message.
> I suspect either the parsing of the ip= option is falling down somehow, or
> in6_pton is failing to translate the address.
> 

FWIW, I went ahead and built a fedora 10 i686 xen guest and tried to
reproduce this there (kernel 2.6.27.9-159.fc10.i686). I assigned the
guest the same IPv6 address that your client is using and tried the
exact same mount string.

Everything seems to work as expected, and I don't see any neighbor
solicitations for bogus IPv6 addrs.

The best thing I can suggest at this point is to try inserting some
debug printk's at various points where the IPv6 address is parsed and
see if you can determine at what point the address becomes corrupted.

-- 
Jeff Layton <jlayton@redhat.com>
