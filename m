Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426AbYIQOJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbYIQOJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 10:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbYIQOJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 10:09:27 -0400
Received: from easi.embeddedalley.com ([71.6.201.124]:58177 "HELO
	easi.embeddedalley.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751634AbYIQOJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 10:09:26 -0400
Message-ID: <48D10F8F.5090703@embeddedalley.com>
Date: Wed, 17 Sep 2008 10:09:19 -0400
From: Matthew Ranostay <mranostay@embeddedalley.com>
Organization: Embedded Alley Solutions Inc
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
Subject: Re: hda_intel (sigmatel) defunct in mmotm 2008-09-13-03-09
References: <48CE6A90.1070309@gmail.com> <48CFC601.9050608@embeddedalley.com> <48D0C69D.4090105@gmail.com>
In-Reply-To: <48D0C69D.4090105@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jiri Slaby wrote:
> On 09/16/2008 04:43 PM, Matthew Ranostay wrote:
>> Bug fix patch at:
>>
>> http://mailman.alsa-project.org/pipermail/alsa-devel/2008-September/010767.html
> 
> It works, thanks.
> 
> Another problem is when I switch IEC958 in alsamixer, I get:
> 

Ok, the problem was that codec->slave_dig_outs getting a dereference when NULL.
This has been already fixed in Takashi's sound-2.6.git tree, with the commit id
06efc354f735d5dbbdf4653fc6a8acd489ac5a18.

Thanks,

Matt Ranostay

- ---

# git log pci/hda/hda_codec.c
...
commit 06efc354f735d5dbbdf4653fc6a8acd489ac5a18
Author: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Date:   Sat Sep 13 16:44:29 2008 +0200

    ALSA: hda: fix oopses in snd-hda-intel after digital slave support additions

    Many places fail to check if codec has slave_dig_outs entries (the most common
    case is not having any entry), leading to various possible oopses in hda_codec
    code.

    Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
    Signed-off-by: Takashi Iwai <tiwai@suse.de>
...
# git diff af41e1693fdaa7a3e25cc8dd1ff3180f83487e5a 06efc354f735d5dbbdf4653fc6a8acd489ac5a18 pci/hda/hda_codec.c

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index c4fc0d4..0707a8e 100644
- --- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -1457,14 +1457,15 @@ static int snd_hda_spdif_default_put(struct snd_kcontrol *kcontrol,
 					  AC_VERB_SET_DIGI_CONVERT_2,
 					  val >> 8);

- -		for (d = codec->slave_dig_outs; *d; d++) {
- -			snd_hda_codec_write_cache(codec, *d, 0,
+		if (codec->slave_dig_outs)
+			for (d = codec->slave_dig_outs; *d; d++) {
+				snd_hda_codec_write_cache(codec, *d, 0,
 					  AC_VERB_SET_DIGI_CONVERT_1,
 					  val & 0xff);
- -			snd_hda_codec_write_cache(codec, *d, 0,
+				snd_hda_codec_write_cache(codec, *d, 0,
 					  AC_VERB_SET_DIGI_CONVERT_2,
 					  val >> 8);
- -		}
+			}
 	}

 	mutex_unlock(&codec->spdif_mutex);
@@ -1502,8 +1503,9 @@ static int snd_hda_spdif_out_switch_put(struct snd_kcontrol *kcontrol,
 					  AC_VERB_SET_DIGI_CONVERT_1,
 					  val & 0xff);

- -		for (d = codec->slave_dig_outs; *d; d++)
- -			snd_hda_codec_write_cache(codec, *d, 0,
+		if (codec->slave_dig_outs)
+			for (d = codec->slave_dig_outs; *d; d++)
+				snd_hda_codec_write_cache(codec, *d, 0,
 					  AC_VERB_SET_DIGI_CONVERT_1,
 					  val & 0xff);
 		/* unmute amp switch (if any) */
@@ -1659,8 +1661,9 @@ static int snd_hda_spdif_in_switch_put(struct snd_kcontrol *kcontrol,
 		snd_hda_codec_write_cache(codec, nid, 0,
 					  AC_VERB_SET_DIGI_CONVERT_1, val);

- -		for (d = codec->slave_dig_outs; *d; d++)
- -			snd_hda_codec_write_cache(codec, *d, 0,
+		if (codec->slave_dig_outs)
+			for (d = codec->slave_dig_outs; *d; d++)
+				snd_hda_codec_write_cache(codec, *d, 0,
 					  AC_VERB_SET_DIGI_CONVERT_1, val);
 	}
 	mutex_unlock(&codec->spdif_mutex);
@@ -2610,9 +2613,10 @@ static void setup_dig_out_stream(struct hda_codec *codec, hda_nid_t nid,
 		snd_hda_codec_write(codec, nid, 0, AC_VERB_SET_DIGI_CONVERT_1,
 			    codec->spdif_ctls & ~AC_DIG1_ENABLE & 0xff);

- -		for (d = codec->slave_dig_outs; *d; d++)
- -			snd_hda_codec_write(codec, *d, 0,
- -					AC_VERB_SET_DIGI_CONVERT_1,
+		if (codec->slave_dig_outs)
+			for (d = codec->slave_dig_outs; *d; d++)
+				snd_hda_codec_write(codec, *d, 0,
+				    AC_VERB_SET_DIGI_CONVERT_1,
 				    codec->spdif_ctls & ~AC_DIG1_ENABLE & 0xff);
 	}
 	snd_hda_codec_setup_stream(codec, nid, stream_tag, 0, format);
@@ -2621,9 +2625,10 @@ static void setup_dig_out_stream(struct hda_codec *codec, hda_nid_t nid,
 		snd_hda_codec_write(codec, nid, 0, AC_VERB_SET_DIGI_CONVERT_1,
 				    codec->spdif_ctls & 0xff);

- -		for (d = codec->slave_dig_outs; *d; d++)
- -			snd_hda_codec_write(codec, *d, 0,
- -					AC_VERB_SET_DIGI_CONVERT_1,
+		if (codec->slave_dig_outs)
+			for (d = codec->slave_dig_outs; *d; d++)
+				snd_hda_codec_write(codec, *d, 0,
+				    AC_VERB_SET_DIGI_CONVERT_1,
 				    codec->spdif_ctls & 0xff);
 	}





> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> IP: [<ffffffffa0057d8a>] snd_hda_spdif_out_switch_put+0xca/0x170 [snd_hda_intel]
> PGD 7a3ea067 PUD 7a378067 PMD 0
> Oops: 0000 [1] SMP
> last sysfs file: /sys/devices/virtual/net/tun0/type
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> CPU 0
> Modules linked in: arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi ath5k
> mac80211 hid_microsoft led_class usbhid rtc_cmos snd_hda_intel hid ohci1394
> ieee1394 evdev cfg80211 ff_memless [last unloaded: freq_table]
> Pid: 3831, comm: alsamixer Tainted: G        W 2.6.27-rc6-mm1_64 #452
> RIP: 0010:[<ffffffffa0057d8a>]  [<ffffffffa0057d8a>]
> snd_hda_spdif_out_switch_put+0xca/0x170 [snd_hda_intel]
> RSP: 0018:ffff88007a3d5c68  EFLAGS: 00010202
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000000000f
> RDX: ffff88007b410be0 RSI: 0000000000070d1e RDI: ffff88007bda9bb0
> RBP: ffff88007a3d5ca8 R08: 0000000000000001 R09: 0000000000000001
> R10: ffffffff8049083f R11: ffff880078cd4240 R12: ffff88007bd2f398
> R13: 0000000000000001 R14: 0000000000000001 R15: 000000000000001e
> FS:  00007fb6b40476f0(0000) GS:ffffffff806f2400(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000007a3cc000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process alsamixer (pid: 3831, threadinfo ffff88007a3d4000, task ffff88007a35b300)
> Stack:  0000000101e33400 ffff88007bd2f568 001e88007a3d5cc8 ffff88007b51d1f0
>  ffff880078cd4240 ffff88007bd2d5a0 ffff88007bd2d708 ffff88007b7720c8
>  ffff88007a3d5cc8 ffffffff80493097 ffff88007b51d1f0 ffff880078cd4240
> Call Trace:
>  [<ffffffff80493097>] slave_put_val+0x37/0xc0
>  [<ffffffff804933bc>] slave_put+0x5c/0x70
>  [<ffffffff8048fdf9>] snd_ctl_elem_write+0x119/0x160
>  [<ffffffff804908a5>] snd_ctl_ioctl+0x295/0x940
>  [<ffffffff80258934>] ? up+0x34/0x50
>  [<ffffffff80254502>] ? remove_wait_queue+0x52/0x60
>  [<ffffffff803a198c>] ? read_chan+0x3ac/0x8b0
>  [<ffffffff8023193e>] ? __wake_up+0x4e/0x70
>  [<ffffffff80242b32>] ? current_fs_time+0x22/0x30
>  [<ffffffff802c9d01>] vfs_ioctl+0x31/0xa0
>  [<ffffffff802c9ff3>] do_vfs_ioctl+0x283/0x2f0
>  [<ffffffff802ca0aa>] sys_ioctl+0x4a/0x80
>  [<ffffffff8020c4cb>] system_call_fastpath+0x16/0x1b
> Code: 00 4c 89 e7 0f b7 c9 44 0f b7 7d d6 44 0f b6 e9 89 4d c4 45 89 e8 b9 0d 07
> 00 00 44 89 fe e8 8e f6 ff ff 49 8b 9c 24 f8 01 00 00 <0f> b7 03 66 85 c0 74 27
> 66 0f 1f 44 00 00 31 d2 48 83 c3 02 0f
> RIP  [<ffffffffa0057d8a>] snd_hda_spdif_out_switch_put+0xca/0x170 [snd_hda_intel]
>  RSP <ffff88007a3d5c68>
> CR2: 0000000000000000
> ---[ end trace 4eaa2a86a8e2da22 ]---
> 
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkjRD48ACgkQ7s2wy7nhBHWlwwCgn3aWMATxTWYnMnnAhAE8NjzE
sEoAn0GIFSiv2Y0RugBFyi00MVYHNmu5
=DLwd
-----END PGP SIGNATURE-----
