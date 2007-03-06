Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbXCFFNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbXCFFNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 00:13:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbXCFFNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 00:13:10 -0500
Received: from mx1.suse.de ([195.135.220.2]:56045 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbXCFFNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 00:13:09 -0500
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 6 Mar 2007 16:11:50 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17900.63510.307044.43948@notabene.brown>
Cc: Greg Banks <gnb@melbourne.sgi.com>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 004 of 4] knfsd: Provide sunrpc pool_mode module option
In-Reply-To: message from Andrew Morton on Monday March 5
References: <20070306131103.26638.patches@notabene>
	<1070306021520.26937@suse.de>
	<20070305205757.2d5db738.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday March 5, akpm@linux-foundation.org wrote:
> On Tue, 6 Mar 2007 13:15:20 +1100 NeilBrown <neilb@suse.de> wrote:
> 
> > Provide a module param "pool_mode" for sunrpc.ko which allows a
> > sysadmin to choose the mode for mapping NFS thread service pools
> > to CPUs.  Values are:
> > 
> > auto	    choose a mapping mode heuristically
> > global	    (default, same as the pre-2.6.19 code) a single global pool
> > percpu	    one pool per CPU
> > pernode	    one pool per NUMA node
> > 
> > Note that since 2.6.19 the hardcoded behaviour has been "auto",
> > this patch makes the default "global".
> > 
> > The pool mode can be changed after boot/modprobe using /sys, if the
> > NFS and lockd services have been shut down.  A useful side effect of
> > this change is to fix a small memory leak when unloading the module.
> 
> Mutter.  Is this really suitable and needed for 2.6.21 at this stage in
> its life?

Something is definitely needed.  Currently on a 4-way SMP machine,
nfsd might only use 1 CPU (depends a bit on irq routing I think).

If that patch is too big, maybe this one?

NeilBrown

--------------------------------
Avoid using nfsd process pools on SMP machines.

From: Neil Brown <neilb@suse.de>

process-pools have real benefits for NUMA, but on SMP
machines they only work if network interface interrupts
go to all CPUs (via round-robin or multiple nics).  This is
not always the case, so disable the pools in this case until
a better solution is developped.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./net/sunrpc/svc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff .prev/net/sunrpc/svc.c ./net/sunrpc/svc.c
--- .prev/net/sunrpc/svc.c	2007-03-06 16:07:19.000000000 +1100
+++ ./net/sunrpc/svc.c	2007-03-06 16:08:53.000000000 +1100
@@ -79,7 +79,11 @@ svc_pool_map_choose_mode(void)
 		 * x86_64 kernel on Xeons.  In this case we
 		 * want to divide the pools on cpu boundaries.
 		 */
-		return SVC_POOL_PERCPU;
+		/* actually, unless your IRQs round-robin nicely,
+		 * this turns out to be really bad, so just
+		 * go GLOBAL for now until a better fix can be developped
+		 */
+		return SVC_POOL_GLOBAL;
 	}
 
 	/* default: one global pool */
