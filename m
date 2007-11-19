Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbXKSSb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbXKSSb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbXKSSYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:24:24 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:2680 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbXKSSYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:24:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cVzCJ429soYNL/7RxhbqiZHbEmxdZl3DROUOUe6X43zftZEqSuB5nNdnTCswS0D9uWEg8RFCZGLCOvdD0AgjyXWG2I5BnqgGryhv9ujH0PdjAUa/rkXJ3gUX0POB7Fu36K0UIRVPKvpLNH+00E45+uHnKbuahcXQOgrh7N0PzNw=
Message-ID: <64bb37e0711191024m426e8c2cqe1fb968ac3a9dff0@mail.gmail.com>
Date: Mon, 19 Nov 2007 19:24:19 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [BUG] 2.6.24-rc2-mm1 - kernel bug on nfs v4
Cc: "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       nfs@lists.sourceforge.net, "Andy Whitcroft" <apw@shadowen.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Jan Blunck" <jblunck@suse.de>, steved@redhat.com
In-Reply-To: <20071119010002.9387d36b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <473DA608.1020804@linux.vnet.ibm.com>
	 <64bb37e0711170953p67d1be49lf4eaa190d662e2b4@mail.gmail.com>
	 <20071117180946.GA14055@elte.hu>
	 <20071117101957.7562639d.akpm@linux-foundation.org>
	 <64bb37e0711171140w5f1451e0qea081a4fbc7a45f7@mail.gmail.com>
	 <20071117230508.GB25905@dyad>
	 <64bb37e0711181044s75fd1081sdf44dac2e060d49a@mail.gmail.com>
	 <1195413486.7893.16.camel@heimdal.trondhjem.org>
	 <64bb37e0711182315s1d159c80h11811acb07566f03@mail.gmail.com>
	 <20071119010002.9387d36b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 19, 2007 10:00 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 19 Nov 2007 08:15:48 +0100 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
> > On Nov 18, 2007 8:18 PM, Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > > I had already fixed that one in my own stack. Attached are the 3 patches
> > > that I've got. 1 from SteveD, 2 fixes.
> >
> > Moving the init_waitqueue_head() like patch
> > linux-2.6.24-006-fix_to_fix_sillyrename_bug_on_umount.dif and applying
> > linux-2.6.24-007-fix_nfs_free_unlinkdata.dif lets my testcase work.
> > Also lockdep no longer complains about the non-static key.
>
> Thanks.
>
> To avoid goofups, could you please send the full fix against 2.6.24-rc2-mm1?

Umm... As I applied this changes manually there is a not insignificant
change of goofups on my part...

For the hang problem I think Tronds suggestion with replacing the
patches from -mm with fresh versions would be the best.


Anyway, currently I have the patch from
http://lkml.org/lkml/2007/11/16/74 to fix the can't-create-files-bug.

To fix the hang bug I used Tronds
linux-2.6.24-007-fix_nfs_free_unlinkdata.dif and the first two hunks
from linux-2.6.24-006-fix_to_fix_sillyrename_bug_on_umount.dif.

Torsten

The needed 2 hunks for reference:

--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -594,9 +594,6 @@ static int nfs_init_server(struct nfs_server *server,
 	/* Create a client RPC handle for the NFSv3 ACL management interface */
 	nfs_init_server_aclclient(server);

-	init_waitqueue_head(&server->active_wq);
-	atomic_set(&server->active, 0);
-
 	dprintk("<-- nfs_init_server() = 0 [new %p]\n", clp);
 	return 0;

@@ -736,6 +733,9 @@ static struct nfs_server *nfs_alloc_server(void)
 	INIT_LIST_HEAD(&server->client_link);
 	INIT_LIST_HEAD(&server->master_link);

+	init_waitqueue_head(&server->active_wq);
+	atomic_set(&server->active, 0);
+
 	server->io_stats = nfs_alloc_iostats();
 	if (!server->io_stats) {
 		kfree(server);
