Return-Path: <linux-kernel-owner+w=401wt.eu-S933027AbYEVAMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933027AbYEVAMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 20:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759997AbYEVALz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 20:11:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44487 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757717AbYEVALy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 20:11:54 -0400
Date: Thu, 22 May 2008 10:11:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       netfilter-devel@vger.kernel.org, apw@shadowen.org,
       Franck Bui-Huu <fbuihuu@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] linux-next: Tree for May 21 - build failure with
 netfilter on __nf_ct_helper_find()
Message-Id: <20080522101148.fbabee96.sfr@canb.auug.org.au>
In-Reply-To: <4834239D.90500@linux.vnet.ibm.com>
References: <20080521155936.466bbe86.sfr@canb.auug.org.au>
	<20080521113230.GA10830@linux.vnet.ibm.com>
	<20080521225214.507eb400.sfr@canb.auug.org.au>
	<4834239D.90500@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Wed, 21 May 2008 18:59:01 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>
> Stephen Rothwell wrote:
> > 
> > Thanks for the report and patch.  This looks like it is probably broken in
> > Linus' kernel.  What config did you use to get the error?
> 
> Please find the .config file used to reproduce this build failure attached.

Actually this is caused by the splitting out of the rcu stuff from list.h
that is in linux-next, sorry.

Your patch looks good to me (reproduced below for new cc's).

Ingo, this should probably go into the rcu tree.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

Date: Wed, 21 May 2008 17:02:30 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: [PATCH] linux-next: Tree for May 21 - build failure with netfilter on __nf_ct_helper_find()

The next-20080521 kernel build fails, on x86_64 machine 

CC net/netfilter/nf_conntrack_helper.o
net/netfilter/nf_conntrack_helper.c: In function ‘__nf_ct_helper_find’:
net/netfilter/nf_conntrack_helper.c:58: error: implicit declaration of function ‘hlist_for_each_entry_rcu’
net/netfilter/nf_conntrack_helper.c:58: error: ‘hnode’ undeclared (first use in this function)
net/netfilter/nf_conntrack_helper.c:58: error: (Each undeclared identifier is reported only once
net/netfilter/nf_conntrack_helper.c:58: error: for each function it appears in.)
net/netfilter/nf_conntrack_helper.c:58: error: expected ‘;’ before ‘{’ token
net/netfilter/nf_conntrack_helper.c:50: warning: unused variable ‘mask’
net/netfilter/nf_conntrack_helper.c: In function ‘__nf_conntrack_helper_find_byname’:
net/netfilter/nf_conntrack_helper.c:74: error: ‘hnode’ undeclared (first use in this function)
net/netfilter/nf_conntrack_helper.c:74: error: expected ‘;’ before ‘{’ token
net/netfilter/nf_conntrack_helper.c: In function ‘nf_conntrack_helper_register’:
net/netfilter/nf_conntrack_helper.c:117: error: implicit declaration of function ‘hlist_add_head_rcu’
net/netfilter/nf_conntrack_helper.c: In function ‘nf_conntrack_helper_unregister’:
net/netfilter/nf_conntrack_helper.c:133: error: implicit declaration of function ‘hlist_del_rcu’
make[2]: *** [net/netfilter/nf_conntrack_helper.o] Error 1
make[1]: *** [net/netfilter] Error 2
make: *** [net] Error 2

This build error is because of the missing include file.I have tested
the patch for the build failure only.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
--- linux-2.6.26-rc3/net/netfilter/nf_conntrack_helper.c	2008-05-20 20:24:14.000000000 +0530
+++ linux-2.6.26-rc3/net/netfilter/~nf_conntrack_helper.c	2008-05-22 00:17:32.000000000 +0530
@@ -20,6 +20,7 @@
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/rculist.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
