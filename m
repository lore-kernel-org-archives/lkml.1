Return-Path: <linux-kernel-owner+w=401wt.eu-S1759673AbXH1N27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759673AbXH1N27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 09:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757795AbXH1N2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 09:28:50 -0400
Received: from pat.uio.no ([129.240.10.15]:52452 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839AbXH1N2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 09:28:49 -0400
Subject: Re: NFS woes again
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Florin Iucha <florin@iucha.net>
Cc: Bret Towe <magnade@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <20070828013541.GA10422@iucha.net>
References: <Pine.LNX.4.64.0708211502330.2460@twin.jikos.cz>
	 <20070821131759.GI10422@iucha.net> <20070821132704.GJ10422@iucha.net>
	 <Pine.LNX.4.64.0708211536560.2460@twin.jikos.cz>
	 <20070822132200.GO10422@iucha.net> <20070823125210.GQ10422@iucha.net>
	 <dda83e780708231014x66093dafj83263a2a1c8203bb@mail.gmail.com>
	 <20070823173637.GS10422@iucha.net>
	 <1188220651.6701.32.camel@heimdal.trondhjem.org>
	 <dda83e780708271819x247ac49dx981c49a80ed6a999@mail.gmail.com>
	 <20070828013541.GA10422@iucha.net>
Content-Type: multipart/mixed; boundary="=-S0fUemMWXsV5ojbdDW/n"
Date: Tue, 28 Aug 2007 09:28:43 -0400
Message-Id: <1188307723.6701.138.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.0, required=12.0, autolearn=disabled, AWL=-0.043)
X-UiO-Scanned: 59AC993BAC4E8C79028C2DE9E0709F8BC82A9A95
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 864 total 3515065 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-S0fUemMWXsV5ojbdDW/n
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2007-08-27 at 20:35 -0500, Florin Iucha wrote:
> On Mon, Aug 27, 2007 at 06:19:29PM -0700, Bret Towe wrote:
> > On 8/27/07, Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > > > > this sounds alot like the post i did yesterday titled 'nfs4 hang regression'
> > > > > i tracked it down to commit 3d39c691ff486142dd9aaeac12f553f4476b7a6
> > > >
> > > > Yes, it certainly does -- all the symptoms match!
> > >
> > > Could you and Bret please check if the attached patch fixes the hang?
> >
> > no good for me still hangs after ~30minutes
> 
> I just booted into the new kernel
> (3d39c691ff486142dd9aaeac12f553f4476b7a6 + Trond's patch) and it hangs
> in 10-15 minutes.
> 
> Process traces available at http://iucha.net/nfs/23-rc2-nfs-fix-1/kernel.log.gz
> 
> Regards,
> florin

Doh! I see the problem: cancel_delayed_work_sync() shouldn't ever be
called recursively.

The following patch should be correct. Please just discard the previous
one...

Trond


--=-S0fUemMWXsV5ojbdDW/n
Content-Disposition: inline; filename=linux-2.6.23-001-fix_cancel_work_hang.dif
Content-Type: message/rfc822; name=linux-2.6.23-001-fix_cancel_work_hang.dif

From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Mon, 27 Aug 2007 09:14:56 -0400
NFS: Fix use of cancel_delayed_work_sync in nfs_release_automount_timer
Subject: No Subject
Message-Id: <1188307723.6701.139.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

Doh! We can't use cancel_delayed_work_sync because we may have been called
from an unmount that was being performed by nfs_automount_task.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/namespace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index aea76d0..acfc56f 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -176,7 +176,7 @@ static void nfs_expire_automounts(struct work_struct *work)
 void nfs_release_automount_timer(void)
 {
 	if (list_empty(&nfs_automount_list))
-		cancel_delayed_work_sync(&nfs_automount_task);
+		cancel_delayed_work(&nfs_automount_task);
 }
 
 /*

--=-S0fUemMWXsV5ojbdDW/n--

