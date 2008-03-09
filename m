Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbYCIKWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbYCIKWr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 06:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbYCIKWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 06:22:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:32747 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbYCIKWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 06:22:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=WjV4KbVn0P75sfogDbeqbYKulYo9ykQigT9GhJQNIBqfBMa7im4AM6WUOBTOUXVveithVV5YHS6XYCM1DFCcoJWq5j3f9qb2TAMgEzSwUZYpn3bPp/FwkpVcWL2VQhe8ieqxvbvy6ibZe9pgX2Q2oZRT5Fm6EvOiY9RR8SaR6R0=
Date: Sun, 9 Mar 2008 11:21:50 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Evgeniy Dushistov <dushistov@mail.ru>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roel Kluin <12o3l@tiscali.nl>
Subject: Re: [PATCH] ufs: [bl]e*_add_cpu conversion
Message-ID: <20080309102143.GA6309@joi>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com> <1202857582-15450-18-git-send-email-marcin.slusarz@gmail.com> <47B2BB58.5040401@tiscali.nl> <20080215212815.26117a19.akpm@linux-foundation.org> <47BA132B.4050005@tiscali.nl> <20080219174524.GA6096@joi> <20080219191621.GA10986@rain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219191621.GA10986@rain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 10:16:21PM +0300, Evgeniy Dushistov wrote:
> On Tue, Feb 19, 2008 at 06:45:42PM +0100, Marcin Slusarz wrote:
> > On Tue, Feb 19, 2008 at 12:22:19AM +0100, Roel Kluin wrote:
> > > Andrew Morton wrote:
> > > > On Wed, 13 Feb 2008 10:41:44 +0100 Roel Kluin <12o3l@tiscali.nl> wrote:
> > > > 
> > > >> you may also want these:
> > > >> ---
> > > >> [bl]e_add_cpu conversion in return
> > > 
> > > > upsets powerpc (at least):
> > > > 
> > > > fs/ufs/swab.h: In function `fs64_add':
> > > > fs/ufs/swab.h:47: warning: passing arg 1 of `le64_add_cpu' from incompatible pointer type
> > > > fs/ufs/swab.h:49: warning: passing arg 1 of `be64_add_cpu' from incompatible pointer type
> > > > fs/ufs/swab.h: In function `fs64_sub':
> > > > fs/ufs/swab.h:58: warning: passing arg 1 of `le64_add_cpu' from incompatible pointer type
> > > > fs/ufs/swab.h:60: warning: passing arg 1 of `be64_add_cpu' from incompatible pointer type
> > > 
> > > sorry for this. Is it correct to cast like the patch below does?
> > I don't think so. Their prototypes are wrong. We can:
> > a) remove fs64_add and fs64_sub as nobody use them
> > b) fix them - change second parameter do __fs64 (and convert to [bl]e64_add_cpu)
> > 
> > Evgeniy?
> > 
> 
> I vote for removing unused code.
ok, patch below:

---
ufs: remove unused fs64_add and fs64_sub

remove fs64_add and fs64_sub - they probably weren't ever
used because their prototypes used u32 instead of __fs64

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
---
 fs/ufs/swab.h |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/fs/ufs/swab.h b/fs/ufs/swab.h
index a4340d0..c89e6ad 100644
--- a/fs/ufs/swab.h
+++ b/fs/ufs/swab.h
@@ -41,24 +41,6 @@ cpu_to_fs64(struct super_block *sbp, u64 n)
 }
 
 static __inline u32
-fs64_add(struct super_block *sbp, u32 *n, int d)
-{
-	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
-		return *n = cpu_to_le64(le64_to_cpu(*n)+d);
-	else
-		return *n = cpu_to_be64(be64_to_cpu(*n)+d);
-}
-
-static __inline u32
-fs64_sub(struct super_block *sbp, u32 *n, int d)
-{
-	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
-		return *n = cpu_to_le64(le64_to_cpu(*n)-d);
-	else
-		return *n = cpu_to_be64(be64_to_cpu(*n)-d);
-}
-
-static __inline u32
 fs32_to_cpu(struct super_block *sbp, __fs32 n)
 {
 	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
-- 
1.5.3.7

