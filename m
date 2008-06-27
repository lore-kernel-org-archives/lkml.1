Return-Path: <linux-kernel-owner+w=401wt.eu-S1759251AbYF0NkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251AbYF0NkB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 09:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbYF0Njw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 09:39:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40376 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbYF0Njv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 09:39:51 -0400
Subject: [PATCH] Fix a.out.h export to userspace with O= build.
From: David Woodhouse <dwmw2@infradead.org>
To: Adrian Bunk <bunk@kernel.org>, torvalds@linux-foundation.org
Cc: sam@ravnborg.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
In-Reply-To: <20080627131231.GF18644@cs181140183.pp.htv.fi>
References: <20080627130236.GD18644@cs181140183.pp.htv.fi>
	 <1214571984.10393.193.camel@pmac.infradead.org>
	 <20080627131231.GF18644@cs181140183.pp.htv.fi>
Content-Type: text/plain
Date: Fri, 27 Jun 2008 14:39:42 +0100
Message-Id: <1214573982.10393.204.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-27 at 16:12 +0300, Adrian Bunk wrote:
> On Fri, Jun 27, 2008 at 02:06:24PM +0100, David Woodhouse wrote:
> > On Fri, 2008-06-27 at 16:02 +0300, Adrian Bunk wrote:
> > > Commit e53d6a152793a38aa334d6f7a4850642ae45cedc
> > > (Export <linux/a.out.h> to userspace again.)
> > > does not work properly when using O= :
> > 
> > Hm, I copied the logic from the existing condition in
> > include/asm-generic/Kbuild.asm. Does that not work either?
> 
> It doesn't work:
> 
> linux-2.6.26-rc8$ make O=../out headers_install
> ...
> linux-2.6.26-rc8$ find ../out -name a.out.h

You're right; it doesn't work with O=, and hasn't since David Howells
first added that conditional export in commit 7fa30315. This fixes it:

---
From: David Woodhouse <david.woodhouse@intel.com>
Subject: Fix a.out.h export to userspace with O= build.

We need to check for existence of the a.out.h header in the source tree,
not the object tree, if we want it to get the right answer with O=.

Signed-off-by: David Woodhouse <david.woodhouse@intel.com>

diff --git a/include/asm-generic/Kbuild.asm b/include/asm-generic/Kbuild.asm
index 92a6d91..7cd25b8 100644
--- a/include/asm-generic/Kbuild.asm
+++ b/include/asm-generic/Kbuild.asm
@@ -1,6 +1,6 @@
 header-y  += kvm.h
 
-ifeq ($(wildcard include/asm-$(SRCARCH)/a.out.h),include/asm-$(SRCARCH)/a.out.h)
+ifneq ($(wildcard $(srctree)/include/asm-$(SRCARCH)/a.out.h),)
 unifdef-y += a.out.h
 endif
 unifdef-y += auxvec.h
diff --git a/include/asm-powerpc/Kbuild b/include/asm-powerpc/Kbuild
index 7381916..bca352e 100644
--- a/include/asm-powerpc/Kbuild
+++ b/include/asm-powerpc/Kbuild
@@ -1,6 +1,5 @@
 include include/asm-generic/Kbuild.asm
 
-header-y += a.out.h
 header-y += auxvec.h
 header-y += ioctls.h
 header-y += mman.h
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index b6fbb25..71d70d1 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -166,7 +166,7 @@ unifdef-y += acct.h
 unifdef-y += adb.h
 unifdef-y += adfs_fs.h
 unifdef-y += agpgart.h
-ifeq ($(wildcard include/asm-$(SRCARCH)/a.out.h),include/asm-$(SRCARCH)/a.out.h)
+ifneq ($(wildcard $(srctree)/include/asm-$(SRCARCH)/a.out.h),)
 unifdef-y += a.out.h
 endif
 unifdef-y += apm_bios.h


-- 
dwmw2

