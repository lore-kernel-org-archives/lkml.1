Return-Path: <linux-kernel-owner+w=401wt.eu-S1760904AbYDVV2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904AbYDVV2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 17:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbYDVV2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 17:28:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:64830 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbYDVV2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 17:28:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=j1dFR9eZTO/1WEdGKtfEUJ2JeiAMo/9zyIANrOshl/Xlw6091XGAPlJQLjzd9y6vP2AV6SBfQ6n9NQcYHWY1JWaoOS0GKDc88DXQwczbzXkAlujdlcRN5wHkneQ8lPPSdRkbAtagV9h1BcvZeTD3J73j+Pkpqzf0exQe+kD9y34=
Date: Tue, 22 Apr 2008 23:28:12 +0200 (CEST)
To: Roman Zippel <zippel@linux-m68k.org>
cc: linux-kernel@vger.kernel.org, Ardis Technologies <roman@ardistech.com>,
       Brad Boyer <flar@allandria.com>, Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH] hfsplus: in case match_strdup() fails to alloc mem in
 hfsplus_parse_options(), don't blow up.
Message-ID: <alpine.LNX.1.00.0804222325350.14359@dragon.funnycrock.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Jesper Juhl <jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jesper.juhl@gmail.com>

The Coverity checker spotted that we do not check the return value of
match_strdup() in fs/hfsplus/options.c::hfsplus_parse_options().
This is bad since match_strdup() does a memory allocation internally
which can fail. If it does fail it will return NULL and in that case
we will pass the NULL pointer on to load_nls() which will eventually
dereference it --> BOOM!
Much better to check the return value, fail gracefully and log an
error message in case this happens.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 options.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/hfsplus/options.c b/fs/hfsplus/options.c
index dc64fac..c9c2f86 100644
--- a/fs/hfsplus/options.c
+++ b/fs/hfsplus/options.c
@@ -132,6 +132,10 @@ int hfsplus_parse_options(char *input, struct hfsplus_sb_info *sbi)
 				return 0;
 			}
 			p = match_strdup(&args[0]);
+			if (!p) {
+				printk(KERN_ERR "hfs: match_strdup() memory allocation failed\n");
+				return 0;
+			}
 			sbi->nls = load_nls(p);
 			if (!sbi->nls) {
 				printk(KERN_ERR "hfs: unable to load nls mapping \"%s\"\n", p);


