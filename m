Return-Path: <linux-kernel-owner+w=401wt.eu-S935094AbXKPULx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935094AbXKPULx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 15:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935023AbXKPULj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 15:11:39 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:42472 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935018AbXKPULg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 15:11:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y0NRQfSHszGCT6ZaLlUlS16SoDKjDCKgHyobq/ZaCLzeHJO7O1t8/syMJP1Su2neRttsb7Hc9dtw5AZ9JfOPoZzSfIlp/ICGuZuSndL+KaJYyCgUhgHMFsRe+ApZ14yPxKAHqxYeoBMj4WwT6uwdRHCYLPXZOMWKH/xv5qou/Uc=
Message-ID: <64bb37e0711161211l74e40d97je28e13b1160f8a0@mail.gmail.com>
Date: Fri, 16 Nov 2007 21:11:34 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Jan Blunck" <jblunck@suse.de>
Subject: Re: 2.6.24-rc2-mm1
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>
In-Reply-To: <20071116140341.GK25521@hasse.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	 <64bb37e0711141116h5ea9ed8cs7f2afbabe73f07bb@mail.gmail.com>
	 <20071114122939.7b4ee194.akpm@linux-foundation.org>
	 <64bb37e0711141448h15c667dbn4496870dd64a0457@mail.gmail.com>
	 <20071115173627.GG25521@hasse.suse.de>
	 <64bb37e0711151324k2a10e683k506c50126ad1978f@mail.gmail.com>
	 <20071116140341.GK25521@hasse.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 16, 2007 3:03 PM, Jan Blunck <jblunck@suse.de> wrote:
> On Thu, Nov 15, Torsten Kaiser wrote:
> > The only thing that looks suspicious to me in that patch is the
> > following change in nfs4_atomic_open(), nfs4_open_revalidate() and
> > nfs4_proc_create()
> >
> > -     struct path path = {
> > -             .mnt = nd->mnt,
> > -             .dentry = dentry,
> > -     };
> > +     struct path path = nd->path;
> >
> > This changes the path.dentry from the explizit parameter 'dentry' to
> > the embedded dentry from the parameter 'nd'.
>
> Ouch! You are totally right. This really looks wrong and I even don't remember
> how that went into the patch. Can you test if the following patch fixes the
> problem? (BTW: thanks for the detailed analysis)
>
> Thanks,
> Jan

This patch fixes the above nfs problem, I can create files again.

But shortly after starting to use the nfs share my system locked up
nearly completely.

I was using emerge (Gentoos package manager) to upgrade a package,
according to its output it just was finished downloading it (via wget
onto the nfs share) and the next step should normally be a
checksumming of the new file. emerge did not print anything out, so it
hang either at the end of the download, or during the checksumming.

The desktop froze completely, I was no longer able to move the mouse.
The system still responded to SysRq and ping, but logging in via ssh
was not possible.

I captured SysRq+W on a serial console, then used SysRq+P:
[  944.142371] SysRq : Show Regs
[  944.145415] CPU 3:
[  944.147500] Modules linked in: radeon drm nfsd exportfs ipv6
w83792d tuner tea5767 tda8290 tuner_xc2028 tda9887 tuner_simple mt20xx
tea5761 tvaudio msp3400 bttv ir_common compat_ioctl32 videobuf_dma_sg
videobuf_core btcx_risc tveeprom videodev usbhid v4l2_common
v4l1_compat hid sg i2c_nforce2 pata_amd
[  944.175225] Pid: 605, comm: rpciod/3 Not tainted 2.6.24-rc2-mm1 #4
[  944.181573] RIP: 0010:[<ffffffff805b0542>]  [<ffffffff805b0542>]
_spin_lock_irqsave+0x12/0x30
[  944.190342] RSP: 0018:ffff81007ef33e28  EFLAGS: 00000286
[  944.195801] RAX: 0000000000000286 RBX: ffff81007ef33e60 RCX: 0000000000000000
[  944.203115] RDX: 0000000000000001 RSI: 0000000000000003 RDI: ffff81011e107960
[  944.210440] RBP: ffff81011cc6c588 R08: ffff8100db918130 R09: ffff81011cc6c540
[  944.217774] R10: 0000000000000000 R11: ffffffff80266390 R12: ffff8100d2d693a8
[  944.225098] R13: ffff81011cc6c588 R14: ffff8100d2d693a8 R15: ffffffff80302726
[  944.232424] FS:  00007f9e739d96f0(0000) GS:ffff81011ff12700(0000)
knlGS:0000000000000000
[  944.240717] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  944.246625] CR2: 0000000001b691d0 CR3: 0000000069861000 CR4: 00000000000006e0
[  944.253948] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  944.261273] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  944.268606]
[  944.268607] Call Trace:
[  944.272646]  [<ffffffff8022cf4d>] __wake_up+0x2d/0x70
[  944.277827]  [<ffffffff802f5e6e>] nfs_free_unlinkdata+0x1e/0x50
[  944.283908]  [<ffffffff80593f66>] rpc_release_calldata+0x26/0x50
[  944.290098]  [<ffffffff80594930>] rpc_async_schedule+0x0/0x10
[  944.296015]  [<ffffffff80245cec>] run_workqueue+0xcc/0x170
[  944.301651]  [<ffffffff802467a0>] worker_thread+0x0/0xb0
[  944.307109]  [<ffffffff802467a0>] worker_thread+0x0/0xb0
[  944.312548]  [<ffffffff8024680d>] worker_thread+0x6d/0xb0
[  944.318092]  [<ffffffff8024a140>] autoremove_wake_function+0x0/0x30
[  944.324535]  [<ffffffff802467a0>] worker_thread+0x0/0xb0
[  944.329974]  [<ffffffff802467a0>] worker_thread+0x0/0xb0
[  944.335431]  [<ffffffff80249d5b>] kthread+0x4b/0x80
[  944.340421]  [<ffffffff8020ca28>] child_rip+0xa/0x12
[  944.345518]  [<ffffffff80249d10>] kthread+0x0/0x80
[  944.350428]  [<ffffffff8020ca1e>] child_rip+0x0/0x12
[  944.355522]

A short time after that the soft lockup detector kicked in serveral times:
[  966.712167] BUG: soft lockup - CPU#3 stuck for 11s! [rpciod/3:605]
[  966.718522] CPU 3:
[  966.720589] Modules linked in: radeon drm nfsd exportfs ipv6
w83792d tuner tea5767 tda8290 tuner_xc2028 tda9887 tuner_simple mt20xx
tea5761 tvaudio msp3400 bttv ir_common compat_ioctl32 videobuf_dma_sg
videobuf_core btcx_risc tveeprom videodev usbhid v4l2_common
v4l1_compat hid sg i2c_nforce2 pata_amd
[  966.748306] Pid: 605, comm: rpciod/3 Not tainted 2.6.24-rc2-mm1 #4
[  966.754653] RIP: 0010:[<ffffffff805b0542>]  [<ffffffff805b0542>]
_spin_lock_irqsave+0x12/0x30
[  966.763424] RSP: 0018:ffff81007ef33e28  EFLAGS: 00000286
[  966.768879] RAX: 0000000000000286 RBX: ffff81007ef33e60 RCX: 0000000000000000
[  966.776204] RDX: 0000000000000001 RSI: 0000000000000003 RDI: ffff81011e107960
[  966.783511] RBP: ffff81011cc6c588 R08: ffff8100db918130 R09: ffff81011cc6c540
[  966.790837] R10: 0000000000000000 R11: ffffffff80266390 R12: ffff8100d2d693a8
[  966.798170] R13: ffff81011cc6c588 R14: ffff8100d2d693a8 R15: ffffffff80302726
[  966.805505] FS:  00007f9e739d96f0(0000) GS:ffff81011ff12700(0000)
knlGS:0000000000000000
[  966.813805] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  966.819703] CR2: 0000000001b691d0 CR3: 0000000069861000 CR4: 00000000000006e0
[  966.827039] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  966.834362] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  966.841687]
[  966.841687] Call Trace:
[  966.845728]  [<ffffffff8022cf4d>] __wake_up+0x2d/0x70
[  966.850900]  [<ffffffff802f5e6e>] nfs_free_unlinkdata+0x1e/0x50
[  966.857004]  [<ffffffff80593f66>] rpc_release_calldata+0x26/0x50
[  966.863161]  [<ffffffff80594930>] rpc_async_schedule+0x0/0x10
[  966.869078]  [<ffffffff80245cec>] run_workqueue+0xcc/0x170
[  966.874705]  [<ffffffff802467a0>] worker_thread+0x0/0xb0
[  966.880163]  [<ffffffff802467a0>] worker_thread+0x0/0xb0
[  966.885610]  [<ffffffff8024680d>] worker_thread+0x6d/0xb0
[  966.891148]  [<ffffffff8024a140>] autoremove_wake_function+0x0/0x30
[  966.897606]  [<ffffffff802467a0>] worker_thread+0x0/0xb0
[  966.903045]  [<ffffffff802467a0>] worker_thread+0x0/0xb0
[  966.908485]  [<ffffffff80249d5b>] kthread+0x4b/0x80
[  966.913484]  [<ffffffff8020ca28>] child_rip+0xa/0x12
[  966.918579]  [<ffffffff80249d10>] kthread+0x0/0x80
[  966.923498]  [<ffffffff8020ca1e>] child_rip+0x0/0x12
[  966.928584]


I will not include the output from SysRq+W, because it looks
uninteresting and broken, it no longer seems to print the names of the
blocke processed...
[  932.591037] SysRq : Show Blocked State
[  932.594896]  ffff81007e807df0 0000000000000086 00000000000081a4
0000000100000001
[  932.602539]  0000000000000000 00000000000008f7 ffffffff80816b00
ffffffff80816b00
[  932.610149]  ffffffff80812f00 ffffffff80816b00 0000000047336c47
000000001cca6e17
[  932.617595] Call Trace:
[  932.620307]  [<ffffffff805b03d7>] __down+0xa7/0x11e
[  932.625303]  [<ffffffff8022d480>] default_wake_function+0x0/0x10
[  932.631468]  [<ffffffff805b0055>] __down_failed+0x35/0x3a
[  932.637012]  [<ffffffff803870d0>] dummy_file_permission+0x0/0x10
[  932.643177]  [<ffffffff805b0715>] lock_kernel+0x25/0x30
[  932.648546]  [<ffffffff803f0d8c>] tty_write+0x18c/0x250
[  932.653910]  [<ffffffff803f3760>] write_chan+0x0/0x3b0
[  932.659184]  [<ffffffff80293469>] vfs_write+0xe9/0x170
[  932.664459]  [<ffffffff80293b03>] sys_write+0x53/0x90
[  932.669642]  [<ffffffff8020bc0e>] system_call+0x7e/0x83
[  932.675011]


> ---
>
> Subject: Embed a struct path into struct nameidata breakes NFSv4
>
> I accidently break NFSv4. Here is the original report by Torsten Kaiser:
>
>  > > Breaks nfsv4 in a rather funny way:
>  > >
>  > > treogen ~ # cd /usr/portage/x
>  > > treogen x # touch bla
>  > > touch: cannot touch `bla': File exists
>  > > treogen x # mkdir bla
>  > > treogen x # touch bla/bla
>  > > touch: cannot touch `bla/bla': File exists
>  > > treogen x # ls -lad *
>  > > drwxr-xr-x 2 root root 6 Nov 14 20:03 bla
>  > > treogen x # ls -la *
>  > > total 0
>  > > drwxr-xr-x 2 root root  6 Nov 14 20:03 .
>  > > drwxr-xr-x 3 root root 16 Nov 14 20:03 ..
>  > > treogen x #
>
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> ---
>  fs/nfs/nfs4proc.c |   15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>
> Index: b/fs/nfs/nfs4proc.c
> ===================================================================
> --- a/fs/nfs/nfs4proc.c
> +++ b/fs/nfs/nfs4proc.c
> @@ -1372,7 +1372,10 @@ out_close:
>  struct dentry *
>  nfs4_atomic_open(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
>  {
> -       struct path path = nd->path;
> +       struct path path = {
> +               .mnt = nd->path.mnt,
> +               .dentry = dentry,
> +       };
>         struct iattr attr;
>         struct rpc_cred *cred;
>         struct nfs4_state *state;
> @@ -1411,7 +1414,10 @@ nfs4_atomic_open(struct inode *dir, stru
>  int
>  nfs4_open_revalidate(struct inode *dir, struct dentry *dentry, int openflags, struct nameidata *nd)
>  {
> -       struct path path = nd->path;
> +       struct path path = {
> +               .mnt = nd->path.mnt,
> +               .dentry = dentry,
> +       };
>         struct rpc_cred *cred;
>         struct nfs4_state *state;
>
> @@ -1860,7 +1866,10 @@ static int
>  nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
>                   int flags, struct nameidata *nd)
>  {
> -       struct path path = nd->path;
> +       struct path path = {
> +               .mnt = nd->path.mnt,
> +               .dentry = dentry,
> +       };
>         struct nfs4_state *state;
>         struct rpc_cred *cred;
>         int status = 0;
>
