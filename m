Return-Path: <linux-kernel-owner+w=401wt.eu-S1757787AbYKQHbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787AbYKQHbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYKQHVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:34 -0500
Received: from kroah.org ([198.145.64.141]:38484 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754848AbYKQHVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:21:17 -0500
Date: Sun, 16 Nov 2008 23:15:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Mauro Carvalho Chehab <mchehab@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 25/46] V4L/DVB (9624): CVE-2008-5033: fix OOPS on tvaudio
	when controlling bass/treble
Message-ID: <20081117071551.GZ29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-dvb-cve-2008-5033-fix-oops-on-tvaudio-when-controlling-bass-treble.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 01a1a3cc1e3fbe718bd06a2a5d4d1a2d0fb4d7d9 upstream.

This bug were supposed to be fixed by 5ba2f67afb02c5302b2898949ed6fc3b3d37dcf1,
where a call to NULL happens.

Not all tvaudio chips allow controlling bass/treble. So, the driver
has a table with a flag to indicate if the chip does support it.

Unfortunately, the handling of this logic were broken for a very long
time (probably since the first module version). Due to that, an OOPS
were generated for devices that don't support bass/treble.

This were the resulting OOPS message before the patch, with debug messages
enabled:

tvaudio' 1-005b: VIDIOC_S_CTRL
BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<00000000>]
*pde = 22fda067 *pte = 00000000
Oops: 0000 [#1] SMP
Modules linked in: snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_hwdep snd soundcore tuner_simple tuner_types tea5767 tuner
tvaudio bttv bridgebnep rfcomm l2cap bluetooth it87 hwmon_vid hwmon fuse sunrpc ipt_REJECT
nf_conntrack_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack
ip6table_filter ip6_tables x_tables ipv6 dm_mirrordm_multipath dm_mod configfs videodev v4l1_compat
ir_common 8139cp compat_ioctl32 v4l2_common 8139too videobuf_dma_sg videobuf_core mii btcx_risc tveeprom
i915 button snd_page_alloc serio_raw drm pcspkr i2c_algo_bit i2c_i801 i2c_core iTCO_wdt
iTCO_vendor_support sr_mod cdrom sg ata_generic pata_acpi ata_piix libata sd_mod scsi_mod ext3 jbdmbcache
uhci_hcd ohci_hcd ehci_hcd [last unloaded: soundcore]

Pid: 15413, comm: qv4l2 Not tainted (2.6.25.14-108.fc9.i686 #1)
EIP: 0060:[<00000000>] EFLAGS: 00210246 CPU: 0
EIP is at 0x0
EAX: 00008000 EBX: ebd21600 ECX: e2fd9ec4 EDX: 00200046
ESI: f8c0f0c4 EDI: f8c0f0c4 EBP: e2fd9d50 ESP: e2fd9d2c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process qv4l2 (pid: 15413, ti=e2fd9000 task=ebe44000 task.ti=e2fd9000)
Stack: f8c0c6ae e2ff2a00 00000d00 e2fd9ec4 ebc4e000 e2fd9d5c f8c0c448 00000000
       f899c12a e2fd9d5c f899c154 e2fd9d68 e2fd9d80 c0560185 e2fd9d88 f8f3e1d8
       f8f3e1dc ebc4e034 f8f3e18c e2fd9ec4 00000000 e2fd9d90 f899c286 c008561c
Call Trace:
 [<f8c0c6ae>] ? chip_command+0x266/0x4b6 [tvaudio]
 [<f8c0c448>] ? chip_command+0x0/0x4b6 [tvaudio]
 [<f899c12a>] ? i2c_cmd+0x0/0x2f [i2c_core]
 [<f899c154>] ? i2c_cmd+0x2a/0x2f [i2c_core]
 [<c0560185>] ? device_for_each_child+0x21/0x49
 [<f899c286>] ? i2c_clients_command+0x1c/0x1e [i2c_core]
 [<f8f283d8>] ? bttv_call_i2c_clients+0x14/0x16 [bttv]
 [<f8f23601>] ? bttv_s_ctrl+0x1bc/0x313 [bttv]
 [<f8f23445>] ? bttv_s_ctrl+0x0/0x313 [bttv]
 [<f8b6096d>] ? __video_do_ioctl+0x1f84/0x3726 [videodev]
 [<c05abb4e>] ? sock_aio_write+0x100/0x10d
 [<c041b23e>] ? kmap_atomic_prot+0x1dd/0x1df
 [<c043a0c9>] ? enqueue_hrtimer+0xc2/0xcd
 [<c04f4fa4>] ? copy_from_user+0x39/0x121
 [<f8b622b9>] ? __video_ioctl2+0x1aa/0x24a [videodev]
 [<c04054fd>] ? do_notify_resume+0x768/0x795
 [<c043c0f7>] ? getnstimeofday+0x34/0xd1
 [<c0437b77>] ? autoremove_wake_function+0x0/0x33
 [<f8b62368>] ? video_ioctl2+0xf/0x13 [videodev]
 [<c048c6f0>] ? vfs_ioctl+0x50/0x69
 [<c048c942>] ? do_vfs_ioctl+0x239/0x24c
 [<c048c995>] ? sys_ioctl+0x40/0x5b
 [<c0405bf2>] ? syscall_call+0x7/0xb
 [<c0620000>] ? cpuid4_cache_sysfs_exit+0x3d/0x69
 =======================
Code:  Bad EIP value.
EIP: [<00000000>] 0x0 SS:ESP 0068:e2fd9d2c

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/tvaudio.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/media/video/tvaudio.c
+++ b/drivers/media/video/tvaudio.c
@@ -1576,13 +1576,13 @@ static int tvaudio_get_ctrl(struct CHIPS
 		return 0;
 	}
 	case V4L2_CID_AUDIO_BASS:
-		if (desc->flags & CHIP_HAS_BASSTREBLE)
+		if (!(desc->flags & CHIP_HAS_BASSTREBLE))
 			break;
 		ctrl->value = chip->bass;
 		return 0;
 	case V4L2_CID_AUDIO_TREBLE:
-		if (desc->flags & CHIP_HAS_BASSTREBLE)
-			return -EINVAL;
+		if (!(desc->flags & CHIP_HAS_BASSTREBLE))
+			break;
 		ctrl->value = chip->treble;
 		return 0;
 	}
@@ -1642,16 +1642,15 @@ static int tvaudio_set_ctrl(struct CHIPS
 		return 0;
 	}
 	case V4L2_CID_AUDIO_BASS:
-		if (desc->flags & CHIP_HAS_BASSTREBLE)
+		if (!(desc->flags & CHIP_HAS_BASSTREBLE))
 			break;
 		chip->bass = ctrl->value;
 		chip_write(chip,desc->bassreg,desc->bassfunc(chip->bass));
 
 		return 0;
 	case V4L2_CID_AUDIO_TREBLE:
-		if (desc->flags & CHIP_HAS_BASSTREBLE)
-			return -EINVAL;
-
+		if (!(desc->flags & CHIP_HAS_BASSTREBLE))
+			break;
 		chip->treble = ctrl->value;
 		chip_write(chip,desc->treblereg,desc->treblefunc(chip->treble));
 
@@ -1695,7 +1694,7 @@ static int chip_command(struct i2c_clien
 				break;
 			case V4L2_CID_AUDIO_BASS:
 			case V4L2_CID_AUDIO_TREBLE:
-				if (desc->flags & CHIP_HAS_BASSTREBLE)
+				if (!(desc->flags & CHIP_HAS_BASSTREBLE))
 					return -EINVAL;
 				break;
 			default:

-- 
