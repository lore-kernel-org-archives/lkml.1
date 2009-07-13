Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbZGMRAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbZGMRAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 13:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbZGMRAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 13:00:18 -0400
Received: from www17.your-server.de ([213.133.104.17]:55554 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbZGMRAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 13:00:16 -0400
Subject: Re: 2.6.31-rc2: BUG: unable to handle kernel NULL pointer
 dereference
From: Thomas Meyer <thomas@m3y3r.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Parag Warudkar <parag.warudkar@gmail.com>, linux-kernel@vger.kernel.org,
       sds@tycho.nsa.gov, jmorris@namei.org, eparis@parisplace.org
In-Reply-To: <4A5A46ED.7010907@gmail.com>
References: <1247410030.1095.1.camel@localhost>
	 <loom.20090712T172408-520@post.gmane.org>  <4A5A46ED.7010907@gmail.com>
Content-Type: text/plain
Date: Mon, 13 Jul 2009 19:00:06 +0200
Message-Id: <1247504406.5437.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 12.07.2009, 22:26 +0200 schrieb Jiri Slaby:
> On 07/12/2009 07:30 PM, Parag Warudkar wrote:
> > static void selinux_write_opts(struct seq_file *m,
> > 1012                                struct security_mnt_opts *opts)
> > 1013 {
> > 1014         int i;
> > 1015         char *prefix;
> > 1016
> > 1017         for (i = 0; i < opts->num_mnt_opts; i++) {
> > 1018                 char *has_comma;
> > 1019
> > 1020                 if (opts->mnt_opts[i])
> > 1021                         has_comma = strchr(opts->mnt_opts[i], ',');
> >                                          ^^^^^^^^^^^^^^^^^^^^^^^^^
> > And that is a NULL pointer dereference - but we just checked for
> > opts->mnt_opts[i] for not NULL. 
> 
> Note, that there is not a NULL dereference. It dereferences 0x40 which
> came in as %rdi. Looks like somebody assigned garbage in there.
> 
> Or a single bit mem error. Is memtest OK with this machine?

Will schedule a memtest run.

> 
> What warning tainted the kernel before this oops is still interesting...

There seems to be no OOPS before that BUG. Does a WARNING also set the G
flag? Something like that:

Jul 12 16:42:34 localhost kernel: [ 6179.647004] ------------[ cut here ]------------
Jul 12 16:42:34 localhost kernel: [ 6179.647004] WARNING: at lib/kref.c:43 kref_get+0x2f/0x4c()
Jul 12 16:42:34 localhost kernel: [ 6179.647004] Hardware name: MS-7250
Jul 12 16:42:34 localhost kernel: [ 6179.647004] Modules linked in: rndis_wlan floppy olympic forcedeth [last unloaded: scsi_wait_scan]
Jul 12 16:42:34 localhost kernel: [ 6179.647004] Pid: 27483, comm: pm-suspend Tainted: G        W  2.6.31-rc2 #79
Jul 12 16:42:34 localhost kernel: [ 6179.647004] Call Trace:
Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff8106c1c6>] ? warn_slowpath_common+0x84/0xb2
Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff8134876b>] ? kref_get+0x2f/0x4c
Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff813476b2>] ? kobject_get+0x26/0x44
Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff815a344f>] ? cpufreq_cpu_get+0x74/0xca
Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff815a3675>] ? cpufreq_suspend+0x5f/0x16f
Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff81044a4f>] ? disable_local_APIC+0x2d/0x6d
Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff81449b54>] ? sysdev_suspend+0xa7/0x28d
Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff810a1229>] ? suspend_devices_and_enter+0x11c/0x1e6
Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff810a13d8>] ? enter_state+0xe5/0x14c
Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff810a0841>] ? state_store+0xc1/0xf6
Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff81178bb8>] ? sysfs_write_file+0xe6/0x137
Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff81117d03>] ? vfs_write+0xb4/0x126
Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff81117e5d>] ? sys_write+0x55/0x90
Jul 12 16:42:34 localhost kernel: [ 6179.647004]  [<ffffffff8102bf2b>] ? system_call_fastpath+0x16/0x1b
Jul 12 16:42:34 localhost kernel: [ 6179.647004] ---[ end trace f7a4d612974b9b3e ]---

Btw this seems also to be new in 2.6.31-rc2:
Jul 12 16:42:34 localhost kernel: [ 6187.256748] sd 2:0:0:0: [sdb] Starting disk
Jul 12 16:42:34 localhost kernel: [ 6190.318012] 
Jul 12 16:42:34 localhost kernel: [ 6190.318128] floppy driver state
Jul 12 16:42:34 localhost kernel: [ 6190.318244] -------------------
Jul 12 16:42:34 localhost kernel: [ 6190.320684] now=4300857616 last interrupt=4294760495 diff=6097121 last called handler=ffffffffa00263ea
Jul 12 16:42:34 localhost kernel: [ 6190.320896] timeout_message=lock fdc
Jul 12 16:42:34 localhost kernel: [ 6190.321018] last output bytes:
Jul 12 16:42:34 localhost kernel: [ 6190.321135]  f 80 4294754488
Jul 12 16:42:34 localhost kernel: [ 6190.321251]  0 90 4294754489
Jul 12 16:42:34 localhost kernel: [ 6190.321367]  1 91 4294754489
Jul 12 16:42:34 localhost kernel: [ 6190.321484]  8 81 4294754493
Jul 12 16:42:34 localhost kernel: [ 6190.321600]  4 80 4294756489
Jul 12 16:42:34 localhost kernel: [ 6190.321717]  0 90 4294756489
Jul 12 16:42:34 localhost kernel: [ 6190.321833]  f 80 4294756489
Jul 12 16:42:34 localhost kernel: [ 6190.321949]  0 90 4294756489
Jul 12 16:42:34 localhost kernel: [ 6190.322073]  0 91 4294756490
Jul 12 16:42:34 localhost kernel: [ 6190.322189]  8 81 4294756494
Jul 12 16:42:34 localhost kernel: [ 6190.322305]  f 80 4294758491
Jul 12 16:42:34 localhost kernel: [ 6190.322421]  0 90 4294758491
Jul 12 16:42:34 localhost kernel: [ 6190.322538]  1 91 4294758491
Jul 12 16:42:34 localhost kernel: [ 6190.322654]  8 81 4294758496
Jul 12 16:42:34 localhost kernel: [ 6190.322770]  4 80 4294760491
Jul 12 16:42:34 localhost kernel: [ 6190.322886]  0 90 4294760491
Jul 12 16:42:34 localhost kernel: [ 6190.323010]  f 80 4294760491
Jul 12 16:42:34 localhost kernel: [ 6190.323126]  0 90 4294760491
Jul 12 16:42:34 localhost kernel: [ 6190.323243]  0 91 4294760491
Jul 12 16:42:34 localhost kernel: [ 6190.323359]  8 81 4294760495
Jul 12 16:42:34 localhost kernel: [ 6190.323475] last result at 4294760495
Jul 12 16:42:34 localhost kernel: [ 6190.323591] last redo_fd_request at 4296147775
Jul 12 16:42:34 localhost kernel: [ 6190.323708] 20  0 
Jul 12 16:42:34 localhost kernel: [ 6190.323869] status=4e
Jul 12 16:42:34 localhost kernel: [ 6190.323984] fdc_busy=1
Jul 12 16:42:34 localhost kernel: [ 6190.324107] do_floppy=ffffffffa0022263
Jul 12 16:42:34 localhost kernel: [ 6190.324224] cont=ffffffffa002d190
Jul 12 16:42:34 localhost kernel: [ 6190.324340] current_req=(null)
Jul 12 16:42:34 localhost kernel: [ 6190.324456] command_status=-1
Jul 12 16:42:34 localhost kernel: [ 6190.324572] 
Jul 12 16:42:34 localhost kernel: [ 6190.324689] floppy0: floppy timeout called
Jul 12 16:42:34 localhost kernel: [ 6190.365498] PM: resume devices took 10.626 seconds

greets
thomas


