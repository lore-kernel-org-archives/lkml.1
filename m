Return-Path: <linux-kernel-owner+w=401wt.eu-S1764166AbYEMUZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764166AbYEMUZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932334AbYEMUQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:16:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38908 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932326AbYEMUQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:16:45 -0400
Date: Tue, 13 May 2008 13:12:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 34/37] SCSI: aha152x: Fix oops on module removal
Message-ID: <20080513201249.GI31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-aha152x-fix-oops-on-module-removal.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 64976a0387835a7ac61bbe2a99b27ccae34eac5d upstream

Reported-by: Frank de Jong <frapex@xs4all.nl>
> after trying to unload the module:
> BUG: unable to handle kernel paging request at 00100100
> IP: [<fb9ff667>] :aha152x:aha152x_exit+0x47/0x6a
> *pde = 00000000
> Oops: 0000 [#1] PREEMPT SMP
> Modules linked in: aha152x(-) w83781d hwmon_vid tun ne 8390 bonding
> usb_storage snd_usb_audio snd_usb_lib snd_rawmidi pwc snd_seq_device
> compat_ioctl32 snd_hwdep videodev v4l1_compat 3c59x mii intel_agp
> agpgart snd_pcm_oss snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd
>
> Pid: 2837, comm: rmmod Not tainted (2.6.25.3 #1)
> EIP: 0060:[<fb9ff667>] EFLAGS: 00210212 CPU: 0
> EIP is at aha152x_exit+0x47/0x6a [aha152x]
> EAX: 00000001 EBX: 000ffdc4 ECX: f7c517a8 EDX: 00000001
> ESI: 00000000 EDI: 00000003 EBP: e7880000 ESP: e7881f58
>   DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process rmmod (pid: 2837, ti=e7880000 task=f27eb580 task.ti=e7880000)
> Stack: fba03700 c01419d2 31616861 00783235 e795ee70 c0157709 b7f24000 e79ae000
>         c0158271 ffffffff b7f25000 e79ae004 e795e370 b7f25000 e795e37c e795e370
>         009ae000 fba03700 00000880 e7881fa8 00000000 bf93ec20 bf93ec20 c0102faa
> Call Trace:
>   [<c01419d2>] sys_delete_module+0x112/0x1a0
>   [<c0157709>] remove_vma+0x39/0x50
>   [<c0158271>] do_munmap+0x181/0x1f0
>   [<c0102faa>] sysenter_past_esp+0x5f/0x85
>   [<c0490000>] rsc_parse+0x0/0x3c0

The problem is that the driver calls aha152x_release() under a
list_for_each_entry().  Unfortunately, aha152x_release() deletes from
the list in question.  Fix this by using list_for_each_entry_safe().

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/aha152x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -3919,9 +3919,9 @@ static int __init aha152x_init(void)
 
 static void __exit aha152x_exit(void)
 {
-	struct aha152x_hostdata *hd;
+	struct aha152x_hostdata *hd, *tmp;
 
-	list_for_each_entry(hd, &aha152x_host_list, host_list) {
+	list_for_each_entry_safe(hd, tmp, &aha152x_host_list, host_list) {
 		struct Scsi_Host *shost = container_of((void *)hd, struct Scsi_Host, hostdata);
 
 		aha152x_release(shost);

-- 
