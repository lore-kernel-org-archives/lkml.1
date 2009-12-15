Return-Path: <linux-kernel-owner+w=401wt.eu-S1761125AbZLOV2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761125AbZLOV2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 16:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761114AbZLOV2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 16:28:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51926 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761113AbZLOV2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 16:28:11 -0500
Date: Tue, 15 Dec 2009 22:28:05 +0100
From: Jan Kara <jack@suse.cz>
To: Jerry Leo <jerryleo860202@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] quota: integer =?utf-8?Q?const?=
	=?utf-8?Q?ant_is_too_large_for_=E2=80=98long=E2=80=99?= type in
Message-ID: <20091215212805.GA9554@quack.suse.cz>
References: <6304b52b0912150527v48056ccam8d1c318bcd7e085b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6304b52b0912150527v48056ccam8d1c318bcd7e085b@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 15-12-09 21:27:50, Jerry Leo wrote:
> Hi, Jan Kara,
> 
> the Patch is for this:
> 
> CC      fs/quota/quota_v2.o
> fs/quota/quota_v2.c: In function ‘v2_read_file_info’:
> fs/quota/quota_v2.c:123: warning: integer constant is too large for ‘long’ type
> fs/quota/quota_v2.c:124: warning: integer constant is too large for ‘long’ type
> 
> 
> Can this patch be fixed?
  Ops, yes. I didn't see these warnings because I'm using 64-bit
machines... Thanks for the fix. You actually have to use ULL as Joe pointed
out. So I've merged the patch below:

>From 0ec834cacfc98633133b5a90c951f2d02e341048 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 15 Dec 2009 22:24:36 +0100
Subject: [PATCH] quota: Fix 64-bit limits setting on 32-bit archs
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Fix warnings:
fs/quota/quota_v2.c: In function ‘v2_read_file_info’:
fs/quota/quota_v2.c:123: warning: integer constant is too large for ‘long’ type
fs/quota/quota_v2.c:124: warning: integer constant is too large for ‘long’ type

Reported-by: Jerry Leo <jerryleo860202@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/quota_v2.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/quota/quota_v2.c b/fs/quota/quota_v2.c
index 3dfc23e..669855c 100644
--- a/fs/quota/quota_v2.c
+++ b/fs/quota/quota_v2.c
@@ -120,8 +120,8 @@ static int v2_read_file_info(struct super_block *sb, int type)
 		info->dqi_maxilimit = 0xffffffff;
 	} else {
 		/* used space is stored as unsigned 64-bit value */
-		info->dqi_maxblimit = 0xffffffffffffffff;	/* 2^64-1 */
-		info->dqi_maxilimit = 0xffffffffffffffff;
+		info->dqi_maxblimit = 0xffffffffffffffffULL;	/* 2^64-1 */
+		info->dqi_maxilimit = 0xffffffffffffffffULL;
 	}
 	info->dqi_bgrace = le32_to_cpu(dinfo.dqi_bgrace);
 	info->dqi_igrace = le32_to_cpu(dinfo.dqi_igrace);
-- 
1.6.4.2

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
