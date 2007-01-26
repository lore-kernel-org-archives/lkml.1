Return-Path: <linux-kernel-owner+w=401wt.eu-S1161172AbXAZStg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161172AbXAZStg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161173AbXAZStg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:49:36 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37112 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161172AbXAZStf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:49:35 -0500
Date: Fri, 26 Jan 2007 19:49:42 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>,
       Mark Fasheh <mark.fasheh@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kurt.hackel@oracle.com, ocfs2-devel@oss.oracle.com
Subject: [2.6 patch] fix OCFS2 compile error
Message-ID: <20070126184942.GP17836@stusta.de>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org> <45B89008.9000809@eyal.emu.id.au> <45B965EA.20106@eyal.emu.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B965EA.20106@eyal.emu.id.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 01:22:34PM +1100, Eyal Lebedinsky wrote:
> I should have added that this is on Debian stable:
> 	$ gcc --version
> 	gcc (GCC) 3.3.5 (Debian 1:3.3.5-13)
> 
> Eyal Lebedinsky wrote:
> > i386
> > Practically all modules selected.
> > 
> >   Building modules, stage 2.
> >   MODPOST 1931 modules
>...
> > WARNING: "__udivdi3" [fs/ocfs2/ocfs2.ko] undefined!
> > make[1]: *** [__modpost] Error 1

Thanks for your report.

I don't know why gcc 3.3 generates this now since ocfs2_backup_super_blkno()
seems to be unused, but there is a bug for 32 bit systems that should be 
fixed:

Commit 50af94b14c98f5769860a282a397c6f3b135c8a8 adds:
  offset /= sb->s_blocksize;

That is:
  u64 = u64 / long

Not a problem on 64bit architectures, but obviously a problem on 32 bit 
architectures.

This patch fixes it by using sb->s_blocksize_bits instead of sb->s_blocksize.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -587,7 +587,7 @@ static inline u64 ocfs2_backup_super_blkno(struct super_block *sb, int index)
 
 	if (index >= 0 && index < OCFS2_MAX_BACKUP_SUPERBLOCKS) {
 		offset <<= (2 * index);
-		offset /= sb->s_blocksize;
+		offset >>= sb->s_blocksize_bits;
 		return offset;
 	}
 


