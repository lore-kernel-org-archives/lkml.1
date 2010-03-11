Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab0CKNml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 08:42:41 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:45528 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757873Ab0CKNmj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 08:42:39 -0500
X-Greylist: delayed 615 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Mar 2010 08:42:38 EST
Date: Thu, 11 Mar 2010 14:32:22 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Subject: Race condition in TTY ldisc layer in 2.6.33
Message-ID: <20100311133222.GA19884@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like there's some race contition in switching ldiscs on USB serial
ports. The following warnings trigger sometimes after killing and restarting
process that changes ldisc and waits forever. In case you want to look at
the code, there it is: http://rere.qmqm.pl/~mirq/sermmc/

The connected USB device is an Actel IGLOO starter kit board with CP2102
usb-to-serial chip.

$ lsusb|grep CP210
Bus 002 Device 004: ID 10c4:ea60 Cygnal Integrated Products, Inc. CP210x Composite Device

Best Regards,
Micha³ Miros³aw

Mar 11 03:25:41 rechot kernel: [  715.018168] PM: Removing info for No Bus:mmc1
Mar 11 03:25:52 rechot kernel: [  725.999013] ------------[ cut here ]------------
Mar 11 03:25:52 rechot kernel: [  725.999078] WARNING: at drivers/usb/serial/usb-serial.c:376 serial_write_room+0x4f/0x63 [usbserial]()
Mar 11 03:25:52 rechot kernel: [  725.999127] Hardware name: hp compaq nx9500(PF031UA#ABA) 
Mar 11 03:25:52 rechot kernel: [  725.999162] Modules linked in: sermmc crc7 sha256_generic nsc_ircc nfsd exportfs sit tunnel4 nfs lockd nfs_acl auth_rpcgss sunrpc tun ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack_ipv6 nf_defrag_ipv4 xt_state iptable_filter ipt_addrtype ip6table_filter xt_dscp xt_string xt_owner xt_multiport xt_iprange xt_mark xt_conntrack xt_DSCP xt_connmark xt_NFQUEUE xt_MARK xt_CONNMARK nf_conntrack ip_tables irlan irnet ircomm_tty ip6_tables ircomm x_tables fuse snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_usb_audio snd_hwdep snd_usb_lib snd_rawmidi snd_seq_device aes_i586 aes_generic cfg80211 rfkill i2c_dev loop kqemu ppp_generic slhc cp210x usbserial usbhid nvidia(P) tulip snd_intel8x0 snd_intel8x0m snd_ac97_codec cb710_mmc mmc_core pcmcia ac97_bus snd_pcm firewire_ohci i2c_i801 irda sr_mod snd_timer snd firewire_core ehci_hcd cb710 i2c_core sg video uhci_hcd pcspkr ppdev backlight output parport_pc parport yenta_socket rsrc_nonstatic cdrom pcmcia_core intel_agp crc_ccitt agpgart joydev iTCO_wdt usbcore soundcore crc_itu_t snd_page_alloc [last unloaded: nsc_ircc]
Mar 11 03:25:52 rechot kernel: [  726.000575] Pid: 9, comm: events/0 Tainted: P       A   2.6.33 #1
Mar 11 03:25:52 rechot kernel: [  726.000578] Call Trace:
Mar 11 03:25:52 rechot kernel: [  726.000593]  [<c013270a>] warn_slowpath_common+0x65/0x95
Mar 11 03:25:52 rechot kernel: [  726.000600]  [<c013274c>] warn_slowpath_null+0x12/0x15
Mar 11 03:25:52 rechot kernel: [  726.000618]  [<e1ad4643>] serial_write_room+0x4f/0x63 [usbserial]
Mar 11 03:25:52 rechot kernel: [  726.000629]  [<c02a08e5>] tty_write_room+0x1d/0x1f
Mar 11 03:25:52 rechot kernel: [  726.000634]  [<c029e5c8>] process_echoes+0x42/0x24b
Mar 11 03:25:52 rechot kernel: [  726.000641]  [<c029e38b>] ? echo_char+0x74/0x79
Mar 11 03:25:52 rechot kernel: [  726.000648]  [<c029fb58>] n_tty_receive_buf+0x3c9/0xfcf
Mar 11 03:25:52 rechot kernel: [  726.000659]  [<c03a79a9>] ? _raw_spin_unlock_irq+0x1f/0x2a
Mar 11 03:25:52 rechot kernel: [  726.000668]  [<c012969d>] ? finish_task_switch+0x3f/0x6a
Mar 11 03:25:52 rechot kernel: [  726.000674]  [<c0122e26>] ? need_resched+0x19/0x23
Mar 11 03:25:52 rechot kernel: [  726.000682]  [<c03a62f1>] ? schedule+0x7d3/0x7ff
Mar 11 03:25:52 rechot kernel: [  726.000692]  [<c013dacd>] ? lock_timer_base+0x24/0x43
Mar 11 03:25:52 rechot kernel: [  726.000700]  [<c03a79d4>] ? _raw_spin_unlock_irqrestore+0x20/0x2b
Mar 11 03:25:52 rechot kernel: [  726.000707]  [<c02a1a28>] ? tty_ldisc_try+0x3b/0x41
Mar 11 03:25:52 rechot kernel: [  726.000714]  [<c02a269c>] flush_to_ldisc+0xd4/0x168
Mar 11 03:25:52 rechot kernel: [  726.000721]  [<c0145481>] worker_thread+0x15f/0x1e8
Mar 11 03:25:52 rechot kernel: [  726.000726]  [<c02a25c8>] ? flush_to_ldisc+0x0/0x168
Mar 11 03:25:52 rechot kernel: [  726.000737]  [<c0148803>] ? autoremove_wake_function+0x0/0x38
Mar 11 03:25:52 rechot kernel: [  726.000745]  [<c0145322>] ? worker_thread+0x0/0x1e8
Mar 11 03:25:52 rechot kernel: [  726.000751]  [<c014843b>] kthread+0x66/0x6b
Mar 11 03:25:52 rechot kernel: [  726.000757]  [<c01483d5>] ? kthread+0x0/0x6b
Mar 11 03:25:52 rechot kernel: [  726.000767]  [<c0102e36>] kernel_thread_helper+0x6/0x10
Mar 11 03:25:52 rechot kernel: [  726.000775] ---[ end trace f9f795998259dd46 ]---
Mar 11 03:25:52 rechot kernel: [  726.000779] ------------[ cut here ]------------
Mar 11 03:25:52 rechot kernel: [  726.000790] WARNING: at drivers/usb/serial/usb-serial.c:363 serial_write+0x69/0x8a [usbserial]()
Mar 11 03:25:52 rechot kernel: [  726.000798] Hardware name: hp compaq nx9500(PF031UA#ABA) 
Mar 11 03:25:52 rechot kernel: [  726.000800] Modules linked in: sermmc crc7 sha256_generic nsc_ircc nfsd exportfs sit tunnel4 nfs lockd nfs_acl auth_rpcgss sunrpc tun ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack_ipv6 nf_defrag_ipv4 xt_state iptable_filter ipt_addrtype ip6table_filter xt_dscp xt_string xt_owner xt_multiport xt_iprange xt_mark xt_conntrack xt_DSCP xt_connmark xt_NFQUEUE xt_MARK xt_CONNMARK nf_conntrack ip_tables irlan irnet ircomm_tty ip6_tables ircomm x_tables fuse snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_usb_audio snd_hwdep snd_usb_lib snd_rawmidi snd_seq_device aes_i586 aes_generic cfg80211 rfkill i2c_dev loop kqemu ppp_generic slhc cp210x usbserial usbhid nvidia(P) tulip snd_intel8x0 snd_intel8x0m snd_ac97_codec cb710_mmc mmc_core pcmcia ac97_bus snd_pcm firewire_ohci i2c_i801 irda sr_mod snd_timer snd firewire_core ehci_hcd cb710 i2c_core sg video uhci_hcd pcspkr ppdev backlight output parport_pc parport yenta_socket rsrc_nonstatic cdrom pcmcia_core intel_agp crc_ccitt agpgart joydev iTCO_wdt usbcore soundcore crc_itu_t snd_page_alloc [last unloaded: nsc_ircc]
Mar 11 03:25:52 rechot kernel: [  726.000924] Pid: 9, comm: events/0 Tainted: P       AW  2.6.33 #1
Mar 11 03:25:52 rechot kernel: [  726.000928] Call Trace:
Mar 11 03:25:52 rechot kernel: [  726.000939]  [<c013270a>] warn_slowpath_common+0x65/0x95
Mar 11 03:25:52 rechot kernel: [  726.000950]  [<c013274c>] warn_slowpath_null+0x12/0x15
Mar 11 03:25:52 rechot kernel: [  726.000963]  [<e1ad46c0>] serial_write+0x69/0x8a [usbserial]
Mar 11 03:25:52 rechot kernel: [  726.000979]  [<c029b122>] tty_put_char+0x2b/0x2f
Mar 11 03:25:52 rechot kernel: [  726.000985]  [<c029e528>] do_output_char+0x198/0x1b2
Mar 11 03:25:52 rechot kernel: [  726.000991]  [<c029e72d>] process_echoes+0x1a7/0x24b
Mar 11 03:25:52 rechot kernel: [  726.000997]  [<c029e38b>] ? echo_char+0x74/0x79
Mar 11 03:25:52 rechot kernel: [  726.001028]  [<c029fb58>] n_tty_receive_buf+0x3c9/0xfcf
Mar 11 03:25:52 rechot kernel: [  726.001041]  [<c03a79a9>] ? _raw_spin_unlock_irq+0x1f/0x2a
Mar 11 03:25:52 rechot kernel: [  726.001046]  [<c012969d>] ? finish_task_switch+0x3f/0x6a
Mar 11 03:25:52 rechot kernel: [  726.001053]  [<c0122e26>] ? need_resched+0x19/0x23
Mar 11 03:25:52 rechot kernel: [  726.001060]  [<c03a62f1>] ? schedule+0x7d3/0x7ff
Mar 11 03:25:52 rechot kernel: [  726.001067]  [<c013dacd>] ? lock_timer_base+0x24/0x43
Mar 11 03:25:52 rechot kernel: [  726.001079]  [<c03a79d4>] ? _raw_spin_unlock_irqrestore+0x20/0x2b
Mar 11 03:25:52 rechot kernel: [  726.001084]  [<c02a1a28>] ? tty_ldisc_try+0x3b/0x41
Mar 11 03:25:52 rechot kernel: [  726.001092]  [<c02a269c>] flush_to_ldisc+0xd4/0x168
Mar 11 03:25:52 rechot kernel: [  726.001098]  [<c0145481>] worker_thread+0x15f/0x1e8
Mar 11 03:25:52 rechot kernel: [  726.001108]  [<c02a25c8>] ? flush_to_ldisc+0x0/0x168
Mar 11 03:25:52 rechot kernel: [  726.001114]  [<c0148803>] ? autoremove_wake_function+0x0/0x38
Mar 11 03:25:52 rechot kernel: [  726.001122]  [<c0145322>] ? worker_thread+0x0/0x1e8
Mar 11 03:25:52 rechot kernel: [  726.001130]  [<c014843b>] kthread+0x66/0x6b
Mar 11 03:25:52 rechot kernel: [  726.001136]  [<c01483d5>] ? kthread+0x0/0x6b
Mar 11 03:25:52 rechot kernel: [  726.001146]  [<c0102e36>] kernel_thread_helper+0x6/0x10
Mar 11 03:25:52 rechot kernel: [  726.001150] ---[ end trace f9f795998259dd47 ]---
Mar 11 03:25:52 rechot kernel: [  726.003363] PM: Adding info for No Bus:mmc1
