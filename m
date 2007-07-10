Return-Path: <linux-kernel-owner+w=401wt.eu-S1763343AbXGJKKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763343AbXGJKKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 06:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759021AbXGJKKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 06:10:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758403AbXGJKKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 06:10:15 -0400
Subject: Re: [PATCH] [GFS2] Remove i_mode passing from NFS File Handle
From: Steven Whitehouse <swhiteho@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
       Wendy Cheng <wcheng@redhat.com>
In-Reply-To: <20070710090639.GA28029@infradead.org>
References: <11839970793713-git-send-email-swhiteho@redhat.com>
	 <11839970813260-git-send-email-swhiteho@redhat.com>
	 <11839970832750-git-send-email-swhiteho@redhat.com>
	 <11839970852076-git-send-email-swhiteho@redhat.com>
	 <11839970871671-git-send-email-swhiteho@redhat.com>
	 <1183997089710-git-send-email-swhiteho@redhat.com>
	 <11839970914023-git-send-email-swhiteho@redhat.com>
	 <11839970921764-git-send-email-swhiteho@redhat.com>
	 <11839970941232-git-send-email-swhiteho@redhat.com>
	 <11839970963525-git-send-email-swhiteho@redhat.com>
	 <20070710090639.GA28029@infradead.org>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 10 Jul 2007 11:01:55 +0100
Message-Id: <1184061715.8765.194.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2007-07-10 at 10:06 +0100, Christoph Hellwig wrote:
> > -#define GFS2_LARGE_FH_SIZE 10
> > -
> > -struct gfs2_fh_obj {
> > -	struct gfs2_inum_host this;
> > -	u32 imode;
> > -};
> > +#define GFS2_LARGE_FH_SIZE 8
> 
> Because gfs2_decode_fh only accepts file handles with GFS2_LARGE_FH_SIZE
> or GFS2_LARGE_FH_SIZE you don't accept filehandles sent out by and older
> gfs version anymore.  Stale filehandles because of a new kernel version
> are a big no-no, so please add back code to handle the old filehandles
> on the decode side.
> 

This should fix that problem I think since its only relating to end of
the fh we can just ignore that field in order to accept the older
format,

Steve.

diff --git a/fs/gfs2/ops_export.c b/fs/gfs2/ops_export.c
index e317db2..99ea565 100644
--- a/fs/gfs2/ops_export.c
+++ b/fs/gfs2/ops_export.c
@@ -28,6 +28,7 @@
 
 #define GFS2_SMALL_FH_SIZE 4
 #define GFS2_LARGE_FH_SIZE 8
+#define GFS2_OLD_FH_SIZE 10
 
 static struct dentry *gfs2_decode_fh(struct super_block *sb,
 				     __u32 *p,
@@ -44,6 +45,7 @@ static struct dentry *gfs2_decode_fh(struct super_block *sb,
 
 	switch (fh_len) {
 	case GFS2_LARGE_FH_SIZE:
+	case GFS2_OLD_FH_SIZE:
 		parent.no_formal_ino = ((u64)be32_to_cpu(fh[4])) << 32;
 		parent.no_formal_ino |= be32_to_cpu(fh[5]);
 		parent.no_addr = ((u64)be32_to_cpu(fh[6])) << 32;


