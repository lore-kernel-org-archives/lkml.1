Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbYL1XjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbYL1XjG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 18:39:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbYL1Xiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 18:38:54 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39947 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178AbYL1Xix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 18:38:53 -0500
Date: Mon, 29 Dec 2008 10:38:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steve French <smfrench@gmail.com>, <linux-cifs-client@lists.samba.org>,
       "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: origin tree build failure
Message-Id: <20081229103849.1cb1eb54.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve, Dave,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

fs/cifs/cifsfs.c: In function 'cifs_show_options':
fs/cifs/cifsfs.c:364: error: 'NIP6_FMT' undeclared (first use in this function)
fs/cifs/cifsfs.c:364: error: (Each undeclared identifier is reported only once
fs/cifs/cifsfs.c:364: error: for each function it appears in.)
fs/cifs/cifsfs.c:365: error: implicit declaration of function 'NIP6'

Maybe someone should have warned Linus about the below known interaction
between the net tree and the cifs tree ...

I have applied the patch to today's linux-next tree.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

Date: Wed, 3 Dec 2008 13:53:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steve French <smfrench@gmail.com>, <linux-cifs-client@lists.samba.org>
Cc: linux-next@vger.kernel.org, Harvey Harrison <harvey.harrison@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Jeff Layton <jlayton@redhat.com>
Subject: Re: linux-next: cifs tree build failure
Message-Id: <20081203135312.60d4518d.sfr@canb.auug.org.au>
In-Reply-To: <20081202132318.7e1581db.sfr@canb.auug.org.au>
References: <20081202132318.7e1581db.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Steve, Dave,

On Tue, 2 Dec 2008 13:23:18 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> 
> fs/cifs/cifsfs.c: In function 'cifs_show_options':
> fs/cifs/cifsfs.c:363: error: 'NIP6_FMT' undeclared (first use in this function)
> fs/cifs/cifsfs.c:363: error: (Each undeclared identifier is reported only once
> fs/cifs/cifsfs.c:363: error: for each function it appears in.)
> fs/cifs/cifsfs.c:364: error: implicit declaration of function 'NIP6'
> 
> Caused by the interaction of commits
> b189db5d299c6824780af5590564ff608adb3dea ("net: remove NIP6(), NIP6_FMT,
> NIP6_SEQFMT and final users") from the net tree and
> 20c4eef4f817ff65337e2fb3f1f5df52eeca09eb ("cifs: display addr and
> prefixpath options in /proc/mounts") from the cifs tree.

Today I have fixed this by applying a merge fix patch (see below) and
will carry this as necessary.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 3 Dec 2008 13:49:23 +1100
Subject: [PATCH] cifs: update for new IP4/6 address printing

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/cifs/cifsfs.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 061a1dc..1b09330 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -362,12 +362,12 @@ cifs_show_options(struct seq_file *s, struct vfsmount *m)
 					switch (server->addr.sockAddr6.
 						sin6_family) {
 					case AF_INET6:
-						seq_printf(s, NIP6_FMT,
-							   NIP6(server->addr.sockAddr6.sin6_addr));
+						seq_printf(s, "%pI6",
+							   &server->addr.sockAddr6.sin6_addr);
 						break;
 					case AF_INET:
-						seq_printf(s, NIPQUAD_FMT,
-							   NIPQUAD(server->addr.sockAddr.sin_addr.s_addr));
+						seq_printf(s, "%pI4",
+							   &server->addr.sockAddr.sin_addr.s_addr);
 						break;
 					}
 				}
-- 
1.5.6.5

