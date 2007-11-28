Return-Path: <linux-kernel-owner+w=401wt.eu-S1756704AbXK1Ilw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbXK1Ilw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 03:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbXK1Ilm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 03:41:42 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43051 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751955AbXK1Ill (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 03:41:41 -0500
Date: Wed, 28 Nov 2007 00:41:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 06/25] elevate write count open()'d files
Message-Id: <20071128004108.671b96aa.akpm@linux-foundation.org>
In-Reply-To: <20070920195256.EDA48D0F@kernel>
References: <20070920195249.852667D5@kernel>
	<20070920195256.EDA48D0F@kernel>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 12:52:56 -0700 Dave Hansen <haveblue@us.ibm.com> wrote:

> This is the first really tricky patch in the series.  It
> elevates the writer count on a mount each time a
> non-special file is opened for write.
> 
> This is not completely apparent in the patch because the
> two if() conditions in may_open() above the
> mnt_want_write() call are, combined, equivalent to
> special_file().
> 
> There is also an elevated count around the vfs_create()
> call in open_namei().  The count needs to be kept elevated
> all the way into the may_open() call.  Otherwise, when the
> write is dropped, a ro->rw transisition could occur.  This
> would lead to having rw access on the newly created file,
> while the vfsmount is ro.  That is bad.
> 
> Some filesystems forego the use of normal vfs calls to create
> struct files.  Make sure that these users elevate the mnt writer
> count because they will get __fput(), and we need to make
> sure they're balanced.

For some reason this has started oopsing on me:

[   39.941273] audit(1196237507.111:5): audit_pid=1882 old=0 by auid=4294967295 subj=system_u:system_r:auditd_t:s0
[   35.037235] BUG: unable to handle kernel NULL pointer dereference at virtual address 0000006a
[   35.040536] printing eip: c017815c *pde = 00000000 
[   35.043913] Oops: 0000 [#1] PREEMPT 
[   35.047270] last sysfs file: /devices/platform/i8042/serio0/description
[   35.050679] Modules linked in: ipv6 autofs4 hidp l2cap bluetooth sunrpc nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack xt_tcpudp iptable_filter ip_tables x_tables acpi_cpufreq nvram ohci1394 ieee1394 ehci_hcd uhci_hcd sg joydev snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm sr_mod snd_timer snd i2c_i801 ipw2200 cdrom ieee80211 pcspkr piix soundcore ieee80211_crypt i2c_core snd_page_alloc button generic ext3 jbd ide_disk ide_core
[   35.071690] 
[   35.075612] Pid: 2277, comm: hald-addon-acpi Not tainted (2.6.24-rc3-mm2 #8)
[   35.080517] EIP: 0060:[<c017815c>] EFLAGS: 00010296 CPU: 0
[   35.084585] EIP is at open_pathname+0x37b/0x6a5
[   35.088631] EAX: 00000000 EBX: fffffff0 ECX: f61fc000 EDX: c01a02c1
[   35.092747] ESI: f61fdf20 EDI: 00000008 EBP: f61fdf84 ESP: f61fdefc
[   35.098762]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   35.102847] Process hald-addon-acpi (pid: 2277, ti=F61FC000 task=F61FEEB0 task.ti=F61FC000)
[   35.103028] Stack: 00008000 f6589000 00000000 00000004 00000000 00008001 00000000 00000246 
[   35.107359]        0000023a f5a9f908 f780cbc0 00000000 00000000 00000000 00000101 00000001 
[   35.111671]        00000000 f61fdf5c 00000246 c016cdd9 00000246 f782b6a4 00000004 f782b6a4 
[   35.115978] Call Trace:
[   35.124180]  [<c0104a74>] show_trace_log_lvl+0x12/0x25
[   35.128422]  [<c0104b13>] show_stack_log_lvl+0x8c/0x97
[   35.132646]  [<c0104ba8>] show_registers+0x8a/0x1c0
[   35.136900]  [<c0104dcc>] die+0xee/0x1c4
[   35.141165]  [<c011683c>] do_page_fault+0x405/0x4e1
[   35.145486]  [<c031db7a>] error_code+0x6a/0x70
[   35.149672]  [<c016e02b>] do_sys_open+0x42/0xb8
[   35.153714]  [<c016e0cd>] sys_open+0x16/0x18
[   35.157763]  [<c0103b2a>] syscall_call+0x7/0xb
[   35.161831]  =======================
[   35.165899] Code: 7d 80 00 0f 84 a9 00 00 00 8b 45 a0 e8 9e 94 00 00 e9 9c 00 00 00 8b 95 78 ff ff ff 89 f0 e8 23 4f ff ff 89 c3 8b 45 9c 8b 40 28 <0f> b7 40 6a 25 00 f0 00 00 3d 00 20 00 00 0f 84 0c 03 00 00 3d 
[   35.175160] EIP: [<c017815c>] open_pathname+0x37b/0x6a5 SS:ESP 0068:f61fdefc


I debugged it a bit.  hald-addon-acpi is opening /proc/acpi/event and we're
getting here:

	error = may_open(&nd, acc_mode, flag);
	if (error) {
		if (open_will_write_to_fs(flag, nd.dentry->d_inode))
			mnt_drop_write(nd.mnt);
		goto exit;
	}
	filp = nameidata_to_filp(&nd, sys_open_flag);
	/*
	 * It is now safe to drop the mnt write
	 * because the filp has had a write taken
	 * on its behalf.
	 */
	if (open_will_write_to_fs(flag, nd.dentry->d_inode))
		mnt_drop_write(nd.mnt);
	return filp;

the final call to open_will_write_to_fs() is oopsing over null
nd.dentry->d_inode.

Given that nameidata_to_filp() can call path_release() which "destroys the
original nameidata", it looks like this was always buggy?

This:

--- a/fs/namei.c~b
+++ a/fs/namei.c
@@ -1722,7 +1722,7 @@ static inline int sys_open_flags_to_name
 	return flag;
 }
 
-static inline int open_will_write_to_fs(int flag, struct inode *inode)
+static int open_will_write_to_fs(int flag, struct inode *inode)
 {
 	/*
 	 * We'll never write to the fs underlying
@@ -1752,6 +1752,7 @@ struct file *open_pathname(int dfd, cons
 	struct path path;
 	struct dentry *dir;
 	int count = 0;
+	int will_write;
 	int flag = sys_open_flags_to_namei_flags(sys_open_flag);
 
 	acc_mode = ACC_MODE(flag);
@@ -1870,14 +1871,15 @@ ok:
 	 * be avoided. Taking this mnt write here
 	 * ensures that (2) can not occur.
 	 */
-	if (open_will_write_to_fs(flag, nd.dentry->d_inode)) {
+	will_write = open_will_write_to_fs(flag, nd.dentry->d_inode);
+	if (will_write) {
 		error = mnt_want_write(nd.mnt);
 		if (error)
 			goto exit;
 	}
 	error = may_open(&nd, acc_mode, flag);
 	if (error) {
-		if (open_will_write_to_fs(flag, nd.dentry->d_inode))
+		if (will_write)
 			mnt_drop_write(nd.mnt);
 		goto exit;
 	}
@@ -1887,7 +1889,7 @@ ok:
 	 * because the filp has had a write taken
 	 * on its behalf.
 	 */
-	if (open_will_write_to_fs(flag, nd.dentry->d_inode))
+	if (will_write)
 		mnt_drop_write(nd.mnt);
 	return filp;
 
_


seems a fairly obvious fix and is more efficient anyway.

I hate this patch series.
