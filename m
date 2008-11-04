Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbYKDWuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbYKDWuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbYKDWu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:50:26 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38163 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755470AbYKDWuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:50:24 -0500
Subject: Re: [PATCH] drm: fix leak of uninitialized data to userspace
From: Dave Airlie <airlied@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegardno@ifi.uio.no>,
       Sitsofe Wheeler <sitsofe@yahoo.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
In-Reply-To: <20081104222326.GA16460@kroah.com>
References: <20081010100200.GA752@thuin.ifi.uio.no>
	 <20081010101753.GE15139@elte.hu> <20081104213859.GA3516@kroah.com>
	 <20081104221730.GA27635@elte.hu>  <20081104222326.GA16460@kroah.com>
Content-Type: text/plain
Date: Wed, 05 Nov 2008 08:50:04 +1000
Message-Id: <1225839005.3757.0.camel@clockmaker.usersys.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-04 at 14:23 -0800, Greg KH wrote:
> On Tue, Nov 04, 2008 at 11:17:30PM +0100, Ingo Molnar wrote:
> > 
> > * Greg KH <greg@kroah.com> wrote:
> > 
> > > On Fri, Oct 10, 2008 at 12:17:53PM +0200, Ingo Molnar wrote:
> > > > 
> > > > * Vegard Nossum <vegardno@ifi.uio.no> wrote:
> > > > 
> > > > > >From f2e1569413900fa3ce5dad571e1a24d31307ab75 Mon Sep 17 00:00:00 2001
> > > > > From: Vegard Nossum <vegardno@thuin.ifi.uio.no>
> > > > > Date: Fri, 10 Oct 2008 11:50:57 +0200
> > > > > Subject: [PATCH] drm: fix leak of uninitialized data to userspace
> > > > > 
> > > > > On Fri, Oct 10, 2008 at 10:54 AM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> > > > > >
> > > > > > [  175.375036] WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f65d2294)
> > > > > > [  175.375049] 7063693a303030303a30303a30322e3000a76c080800000000a76c080e000000
> > > > > > [  175.375096]  i i i i i i i i i i i i i i i i i u u u u u u u u u u u u u u u
> > > > > > [  175.375137]                                          ^
> > > > > > [  175.375142]
> > > > > > [  175.375148] Pid: 2288, comm: Xorg Not tainted (2.6.27-tipskw-00069-g37cb0b7-dirty #81) 900
> > > > > > [  175.375155] EIP: 0060:[<c020d283>] EFLAGS: 00003246 CPU: 0
> > > > > > [  175.375169] EIP is at __copy_to_user_ll+0x43/0x60
> > > > > > [  175.375174] EAX: 00000000 EBX: 00000028 ECX: 00000005 EDX: f65d2280
> > > > > > [  175.375180] ESI: f65d2294 EDI: 086cb6b4 EBP: f631bef4 ESP: c055bd68
> > > > > > [  175.375186]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> > > > > > [  175.375191] CR0: 8005003b CR2: f67c1c44 CR3: 36368000 CR4: 000006c0
> > > > > > [  175.375197] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> > > > > > [  175.375202] DR6: ffff4ff0 DR7: 00000400
> > > > > > [  175.375206]  [<c020d6f3>] copy_to_user+0x43/0x60
> > > > > > [  175.375214]  [<c028df28>] drm_getunique+0x38/0x50
> > > > > > [  175.375224]  [<c028d329>] drm_ioctl+0x1b9/0x2f0
> > > > > > [  175.375231]  [<c0188a07>] vfs_ioctl+0x67/0x70
> > > > > > [  175.375239]  [<c0188a6c>] do_vfs_ioctl+0x5c/0x270
> > > > > > [  175.375246]  [<c0188cbe>] sys_ioctl+0x3e/0x60
> > > > > > [  175.375253]  [<c010336d>] sysenter_do_call+0x12/0x35
> > > > > > [  175.375261]  [<ffffffff>] 0xffffffff
> > > > > 
> > > > > The hexdump decodes to:
> > > > > 
> > > > > vegardno@thuin ~ $ ./a.out 7063693a303030303a30303a30322e3000a76c080800000000a76c080e000000
> > > > > pci:0000:00:02.0<0><167>l<8><8><0><0><0><0><167>l<8><14><0><0><0>
> > > > > 
> > > > > ...so drm_getunique() is trying to copy some uninitialized data to
> > > > > userspace. The ECX register contains the number of words that are
> > > > > left to copy -- so there are 5 * 4 = 20 bytes left. The offset of the
> > > > > first uninitialized byte (counting from the start of the string) is
> > > > > also 20 (i.e. 0xf65d2294&((1 << 5)-1) == 20). So somebody tried to
> > > > > copy 40 bytes when the string was only 19 long.
> > > > > 
> > > > > In drm_set_busid() we have this code:
> > > > > 
> > > > >         dev->unique_len = 40;
> > > > >         dev->unique = drm_alloc(dev->unique_len + 1, DRM_MEM_DRIVER);
> > > > > 	...
> > > > >         len = snprintf(dev->unique, dev->unique_len, "pci:%04x:%02x:%02x.%d",
> > > > > 
> > > > > ...so it seems that dev->unique is never updated to reflect the
> > > > > actual length of the string. The remaining bytes (20 in this case)
> > > > > are random uninitialized bytes that are copied into userspace.
> > > > > 
> > > > > This patch fixes the problem by setting dev->unique_len after the
> > > > > snprintf().
> > > > > 
> > > > > Completely untested.
> > > > > 
> > > > > Reported-by: Sitsofe Wheeler <sitsofe@yahoo.com>
> > > > > Signed-off-by: Vegard Nossum <vegardno@thuin.ifi.uio.no>
> > > > 
> > > > i've stuck it into the tip/out-of-tree quick-fixes branch.
> > > > 
> > > > Sitsofe, could you please check very latest tip/master with 
> > > > CONFIG_KMEMCHECK=y, does it find any other uninitialized memory 
> > > > access?
> > > 
> > > What ever happened to this patch?  Did it go into Linus's tree?  If 
> > > so, I can't seem to find it :(
> > 
> > i'm not doing DRM patches - tip/out-of-tree is for pure out-of-tree 
> > hotfixes.
> 
> So it goes no where?
> 
> Dave, any plan to pick this up and get it to Linus?
> 

Oops just fell off my radar, will stick it the next set of drm-fixes.

Dave.


