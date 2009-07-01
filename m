Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbZGAMf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbZGAMf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 08:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZGAMfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 08:35:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36244 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbZGAMfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 08:35:14 -0400
Subject: Re: linux-next: boot failure
From: Eric Paris <eparis@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090701160014.595e1338.sfr@canb.auug.org.au>
References: <20090701160014.595e1338.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 08:35:12 -0400
Message-Id: <1246451712.22562.38.camel@dhcp235-23.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-01 at 16:00 +1000, Stephen Rothwell wrote:
> Hi Eric,
> 
> next-20090630 failed to boot (on PowerPC Power5/6 machines):
> 
> calling  .audit_watch_init+0x0/0x80 @ 1
> Unable to handle kernel paging request for data at address 0xffffffffffffffff
> Faulting instruction address: 0xc00000000008b440
> cpu 0x0: Vector: 300 (Data Access) at [c0000000be683990]
>     pc: c00000000008b440: .srcu_read_lock+0x20/0x40
>     lr: c0000000001607cc: .fsnotify_recalc_global_mask+0x2c/0xa0
>     sp: c0000000be683c10
>    msr: 8000000000009032
>    dar: ffffffffffffffff
>  dsisr: 40010000
>   current = 0xc0000000be67e000
>   paca    = 0xc00000000093b200
>     pid   = 1, comm = swapper
> enter ? for help
> [link register   ] c0000000001607cc .fsnotify_recalc_global_mask+0x2c/0xa0
> [c0000000be683c10] c0000000be683ca0 (unreliable)
> [c0000000be683ca0] c000000000160bc0 .fsnotify_obtain_group+0x1e0/0x260
> [c0000000be683d60] c0000000007879e4 .audit_watch_init+0x34/0x80
> [c0000000be683de0] c00000000000947c .do_one_initcall+0x6c/0x1e0
> [c0000000be683ee0] c00000000076fd6c .kernel_init+0x23c/0x2c0
> [c0000000be683f90] c00000000002a9bc .kernel_thread+0x54/0x70

Hmmmm, I'm looking.  The best I can guess is that the srcu struct in
fsnotify_recalc_global_mask hasn't been initialized.  Both
audit_watch_init() (where you are having problems) and fsnotify_init()
(where we initialize the srcu struct) use subsys_initcall()

I will check the makefiles to see if kernel/built-in.o is linked in
before fs/buildin-in.o.  I don't see a reason why audit watches need to
be that early in the kernel init process.  This isn't happening on my
system so I'm asking if anyone hitting it can apply this patch and test?

Audit: audit watch init should not be before fsnotify init

From: Eric Paris <eparis@redhat.com>

Audit watch init and fsnotify init both use subsys_initcall() but since the
audit watch code is linked in before the fsnotify code the audit watch code
would be using the fsnotify srcu struct before it was initialized.  This
patch fixes that problem by moving audit watch init to device_initcall() so
it happens after fsnotify is ready.

---

 kernel/audit_watch.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index 177e4b8..1295120 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -584,4 +584,4 @@ static int __init audit_watch_init(void)
 	}
 	return 0;
 }
-subsys_initcall(audit_watch_init);
+device_initcall(audit_watch_init);


