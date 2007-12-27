Return-Path: <linux-kernel-owner+w=401wt.eu-S1752215AbXL0Lms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbXL0Lms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 06:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbXL0Lmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 06:42:39 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:16917 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbXL0Lmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 06:42:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qRcIMX6p1tEFGKCBgCM7OrsBYXcIaN2RMuZdp5WfKsUtOwe0b2s/zQr35zX/zoJIpucSKyb9YRgdbSoUjPFtoWseF5gRSNphiwHS3qmAA+CCGCTdlxhwyco5f1f4gJQrK6OdTOA6x2Ee/WIQkAiWEysW7NPVdfw3TcJMNpMXA/c=
Message-ID: <64bb37e0712270342v751e9a63n20da68a621c07647@mail.gmail.com>
Date: Thu, 27 Dec 2007 12:42:35 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc6-mm1
Cc: linux-kernel@vger.kernel.org, "Alasdair G Kergon" <agk@redhat.com>,
       "Greg KH" <greg@kroah.com>
In-Reply-To: <20071223123930.27f46d24.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071222233056.d652743e.akpm@linux-foundation.org>
	 <64bb37e0712230827m7d368e2l3174f3b4396d09c1@mail.gmail.com>
	 <20071223123930.27f46d24.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 23, 2007 9:39 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Sun, 23 Dec 2007 17:27:12 +0100 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
>
> > On Dec 23, 2007 8:30 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/
> > [snip]
> > > +md-support-external-metadata-for-md-arrays.patch
> > > +md-give-userspace-control-over-removing-failed-devices-when-external-metdata-in-use.patch
> > > +md-allow-a-maximum-extent-to-be-set-for-resyncing.patch
> > > +md-allow-devices-to-be-shared-between-md-arrays.patch
> > > +md-lock-address-when-changing-attributes-of-component-devices.patch
> > > +md-allow-an-md-array-to-appear-with-0-drives-if-it-has-external-metadata.patch
> > >
> > >  RAID updates
> > Should I blame the raid1 changes or the kobject changes?
> >
>
> I don't know.  It could even be that both patch series are OK but when they
> are combined, things fail.

OK, I debugged this some more. It looks like two bugs meshed together.

One new bug: "do_md_run() returned -22"
I can't seem to start my raid anymore.
The following part of md-allow-devices-to-be-shared-between-md-arrays
adds a new check to do_md_run() (drivers/md/md.c) that fails for my system:
@@ -3213,8 +3283,11 @@ static int do_md_run(mddev_t * mddev)
        /*
         * Analyze all RAID superblock(s)
         */
-       if (!mddev->raid_disks)
+       if (!mddev->raid_disks) {
+               if (!mddev->persistent)
+                       return -EINVAL;
                analyze_sbs(mddev);
+       }

        chunk_size = mddev->chunk_size;

The raid gets started normally with any other kernel I tried.
I did not investigate the cause of this failure further, because I was
looking why a failure to start a raid was causing event/3 to oops.

This looks like a secound, but rather old bug.
do_md_stop (from drivers/md/md.c) does the following:
  3691                  /* make sure all delayed_delete calls have finished */
  3692                  flush_scheduled_work();
  3693
  3694                  export_array(mddev);
  3695
But: Only the callchain export_array -> kick_rdev_from_array ->
unbind_rdev_from_array schedules the delayed_delete's!

After adding a second flush_scheduled_work() below the export_array()
the resulting kernel no longer oopses and my initrd normally asks for
an alternative root-fs, because of the first bug the raid still does
not get started.

I don't know if this flush_scheduled_work() is misplaced since is was
introduced, or if it really even was only trying to flush delayed
deletes from previously stopped arrays.

When investigation this, I got these debug-outputs:
first try, with my second flush_scheduled_work removed again:
[   34.290576] md: Autodetecting RAID arrays.
[   34.125649] md: Scanned 5 and added 5 devices.
[   34.125649] md: autorun ...
[   34.125649] md: considering sdc2 ...
[   34.125658] md:  adding sdc2 ...
[   34.126914] md:  adding sdb2 ...
[   34.128170] md: sdb1 has different UUID to sdc2
[   34.135654] md:  adding sda2 ...
[   34.137168] md: sda1 has different UUID to sdc2
[   34.145669] md: created md1
[   34.146755] md: bind<sda2>
[   34.147879] md: bind<sdb2>
[   34.155665] md: bind<sdc2>
[   34.156730] md: running: <sdc2><sdb2><sda2>
[   34.158427] mddev not persistent ???
[   34.165651] md: do_md_run() returned -22
[   34.167171] md: md1 stopped.
[   34.168292] 1:flush_scheduled_work()
-> this is the original flush_scheduled_work()-call
[   34.175675] md: unbind<sdc2>
[   34.176795] md: remove sysfs-link 'block', schedule delayed_delete...
following output is from unbind_rdev_from_array:
[   34.185662] XXX:unb:rdev == ffff81011ede4800
<3>XXX:unb:rdev->bdev == ffff81011f86b600
<3>XXX:unb:rdev->kobj == ffff81011ede4860
<6>md: export_rdev(sdc2)
[   34.196600] md: unbind<sdb2>
[   34.197720] md: remove sysfs-link 'block', schedule delayed_delete...
[   34.205654] XXX:unb:rdev == ffff81011ede4600
<3>XXX:unb:rdev->bdev == ffff81011f86b080
<3>XXX:unb:rdev->kobj == ffff81011ede4660
<6>md: export_rdev(sdb2)
[   34.217942] md: unbind<sda2>
[   34.225651] md: remove sysfs-link 'block', schedule delayed_delete...
[   34.228140] XXX:unb:rdev == ffff81011ede4400
<3>XXX:unb:rdev->bdev == ffff81011f86a000
<3>XXX:unb:rdev->kobj == ffff81011ede4460
<6>md: export_rdev(sda2)
[   34.245664] 2:!flush_scheduled_work()
-> my second call is disabled for this run
[   34.247101] md: considering sdb1 ...
[   34.248492] md:  adding sdb1 ...
[   34.255654] md:  adding sda1 ...
following output is from delayed_delete:
[   34.257024] XXX:dd:rdev == ffff81011ede4800
<3>XXX:dd:rdev->kobj == ffff81011ede4860
-> sdc2 seems to get deleted normally
<3>XXX:dd:rdev == ffff81011ede4600
<3>XXX:dd:rdev->kobj == ffff81011ede4660
-> sdb2 too
<3>XXX:dd:rdev == ffff81011ede4400
<3>XXX:dd:rdev->bdev == 5441505645440064
-> but here is something strange, the other devices did not get a
bdev-line, because that value was zero
<6>md: created md0
[   34.654554] md: bind<sda1>
[   34.654554] md: bind<sdb1>
[   34.654554] md: running: <sdb1><sda1>
[   34.654554] mddev not persistent ???
[   34.654554] md: do_md_run() returned -22
[   34.654554] md: md0 stopped.
[   34.654554] 1:flush_scheduled_work()
-> the flush from the second failed raid forces the delayed_deletes
from the first raid to finish
[   34.285652] XXX:dd:rdev->kobj == ffff81011ede4460
-> the pointer itself looks still the same, but the kobject seems to be gone:
<1>Unable to handle kernel paging request at 0000000034333545 RIP:
[   34.288794]  [<ffffffff803b49a1>] kref_put+0x31/0x80
[   34.291688] PGD 7e427067 PUD 7ed22067 PMD 0
[   34.293394] Oops: 0002 [1] SMP
[   34.294651] last sysfs file: /sys/devices/virtual/block/md0/dev
[   34.295649] CPU 3
[   34.295649] Modules linked in:
[   34.295649] Pid: 18, comm: events/3 Not tainted 2.6.24-rc6-mm1 #9
[   34.295649] RIP: 0010:[<ffffffff803b49a1>]  [<ffffffff803b49a1>]
kref_put+0x31/0x80
[   34.295649] RSP: 0000:ffff81007ffe5df0  EFLAGS: 00010202
[   34.295649] RAX: 0000000000000000 RBX: 0000000034333545 RCX: ffffffff80606270
[   34.295649] RDX: 0000000000000040 RSI: ffffffff803b38b0 RDI: 0000000034333545
[   34.295649] RBP: ffff81007ffe5e00 R08: 0000000000000001 R09: 0000000000000000
[   34.295649] R10: ffffffff8094c430 R11: 0000000000000000 R12: ffffffff803b38b0
[   34.295650] R13: ffff81011ede44d8 R14: ffffffff804d7d50 R15: ffff81011ff210f0
[   34.295650] FS:  0000000002024870(0000) GS:ffff81011ff0dd00(0000)
knlGS:0000000000000000
[   34.295650] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   34.295650] CR2: 0000000034333545 CR3: 000000007e535000 CR4: 00000000000006e0
[   34.295650] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   34.295650] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   34.295650] Process events/3 (pid: 18, threadinfo ffff81007ffe4000,
task ffff81007ffe2000)
[   34.295650] Stack:  ffff81011ede4460 ffff81011ede4400
ffff81007ffe5e10 ffffffff803b37e9
[   34.295650]  ffff81007ffe5e30 ffffffff803b389b ffffffff804d7d50
ffff81011ede4460
[   34.295650]  ffff81007ffe5e50 ffffffff804d7db9 ffff81011ede44e0
ffff81011ff210c0
[   34.295650] Call Trace:
[   34.295650]  [<ffffffff803b37e9>] kobject_put+0x19/0x20
[   34.295650]  [<ffffffff803b389b>] kobject_del+0x2b/0x40
[   34.295650]  [<ffffffff804d7d50>] delayed_delete+0x0/0xb0
[   34.295650]  [<ffffffff804d7db9>] delayed_delete+0x69/0xb0
[   34.295650]  [<ffffffff80249775>] run_workqueue+0x175/0x210
[   34.295650]  [<ffffffff8024a411>] worker_thread+0x71/0xb0
[   34.295650]  [<ffffffff8024d9e0>] autoremove_wake_function+0x0/0x40
[   34.295650]  [<ffffffff8024a3a0>] worker_thread+0x0/0xb0
[   34.295650]  [<ffffffff8024d5fd>] kthread+0x4d/0x80
[   34.295650]  [<ffffffff8020c4b8>] child_rip+0xa/0x12
[   34.295650]  [<ffffffff8020bbcf>] restore_args+0x0/0x30
[   34.295650]  [<ffffffff8024d5b0>] kthread+0x0/0x80
[   34.295650]  [<ffffffff8020c4ae>] child_rip+0x0/0x12
[   34.295650]
[   34.295650]
[   34.295650] Code: f0 ff 0b 0f 94 c0 31 d2 84 c0 74 0b 48 89 df 41
ff d4 ba 01
[   34.295650] RIP  [<ffffffff803b49a1>] kref_put+0x31/0x80
[   34.295650]  RSP <ffff81007ffe5df0>
[   34.295650] CR2: 0000000034333545
[   34.295653] ---[ end trace 60425fedd4d3ef22 ]---
Here the system hangs, the initrd does not prompt for an alternative root-fs

second try with the newly added flush:
[   34.267403] md: Autodetecting RAID arrays.
[   34.188217] md: Scanned 5 and added 5 devices.
[   34.188220] md: autorun ...
[   34.189306] md: considering sdc2 ...
[   34.190699] md:  adding sdc2 ...
[   34.198224] md:  adding sdb2 ...
[   34.199480] md: sdb1 has different UUID to sdc2
[   34.201237] md:  adding sda2 ...
[   34.208220] md: sda1 has different UUID to sdc2
[   34.209993] md: created md1
[   34.218220] md: bind<sda2>
[   34.219341] md: bind<sdb2>
[   34.220410] md: bind<sdc2>
[   34.221476] md: running: <sdc2><sdb2><sda2>
[   34.228963] mddev not persistent ???
[   34.230350] md: do_md_run() returned -22
[   34.238219] md: md1 stopped.
[   34.239339] 1:flush_scheduled_work()
-> old call to flush_scheduled_work()
[   34.240749] md: unbind<sdc2>
[   34.248219] md: remove sysfs-link 'block', schedule delayed_delete...
[   34.250716] XXX:unb:rdev == ffff81011ed6d800
<3>XXX:unb:rdev->bdev == ffff81011f86b600
<3>XXX:unb:rdev->kobj == ffff81011ed6d860
<6>md: export_rdev(sdc2)
[   34.268262] md: unbind<sdb2>
[   34.269382] md: remove sysfs-link 'block', schedule delayed_delete...
[   34.278221] XXX:unb:rdev == ffff81011ed6de00
<3>XXX:unb:rdev->bdev == ffff81011f86b080
<3>XXX:unb:rdev->kobj == ffff81011ed6de60
<6>md: export_rdev(sdb2)
[   34.289123] md: unbind<sda2>
[   34.290244] md: remove sysfs-link 'block', schedule delayed_delete...
[   34.298221] XXX:unb:rdev == ffff81011ed6da00
<3>XXX:unb:rdev->bdev == ffff81011f86a000
<3>XXX:unb:rdev->kobj == ffff81011ed6da60
<6>md: export_rdev(sda2)
[   34.310502] 2:flush_scheduled_work()
-> newly added call to flush_scheduled_work()
[   34.318253] XXX:dd:rdev == ffff81011ed6d800
<3>XXX:dd:rdev->kobj == ffff81011ed6d860
<3>XXX:dd:rdev == ffff81011ed6de00
<3>XXX:dd:rdev->kobj == ffff81011ed6de60
-> this time, rdev->bdev/rdev->kobj from sda2 seem to be still ok.
<3>XXX:dd:rdev == ffff81011ed6da00
<3>XXX:dd:rdev->kobj == ffff81011ed6da60
<6>md: considering sdb1 ...
[   34.339255] md:  adding sdb1 ...
[   34.340511] md:  adding sda1 ...
[   34.348520] md: created md0
[   34.349608] md: bind<sda1>
[   34.350676] md: bind<sdb1>
[   34.351741] md: running: <sdb1><sda1>
[   34.358743] mddev not persistent ???
[   34.360131] md: do_md_run() returned -22
-> same failure to start the second raid, but...
[   34.368219] md: md0 stopped.
[   34.369340] 1:flush_scheduled_work()
-> ... this time the work is already done and no oops happend
[   34.370733] md: unbind<sdb1>
[   34.378219] md: remove sysfs-link 'block', schedule delayed_delete...
[   34.380705] XXX:unb:rdev == ffff81011ed6dc00
<3>XXX:unb:rdev->bdev == ffff81011f86a580
<3>XXX:unb:rdev->kobj == ffff81011ed6dc60
<6>md: export_rdev(sdb1)
[   34.398254] md: unbind<sda1>
[   34.399373] md: remove sysfs-link 'block', schedule delayed_delete...
[   34.408221] XXX:unb:rdev == ffff81007ff51800
<3>XXX:unb:rdev->bdev == ffff81007f8a0580
<3>XXX:unb:rdev->kobj == ffff81007ff51860
<6>md: export_rdev(sda1)
[   34.419120] 2:flush_scheduled_work()
[   34.420510] XXX:dd:rdev == ffff81011ed6dc00
<3>XXX:dd:rdev->kobj == ffff81011ed6dc60
<3>XXX:dd:rdev == ffff81007ff51800
<3>XXX:dd:rdev->kobj == ffff81007ff51860
<6>md: ... autorun DONE.
Here the system now asks for a root-fs as the normal root /dev/md1 was
not started.

I hope these outputs help, if more are needed, just ask.

Torsten
