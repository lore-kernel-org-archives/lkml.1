Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbZLAT0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbZLAT0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 14:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbZLAT0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 14:26:32 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:18434 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999AbZLAT0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 14:26:32 -0500
X-Trace: 296582275/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.56.48/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.56.48
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhoBANL8FEtPRTgw/2dsb2JhbAAIkFIByACEMQQ
X-IronPort-AV: E=Sophos;i="4.47,322,1257120000"; 
   d="scan'208";a="296582275"
Date: Tue, 1 Dec 2009 19:26:32 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Chris Wilson <chris@chris-wilson.co.uk>
cc: Matt Mackall <mpm@selenic.com>, Mateusz Kaduk <mateusz.kaduk@gmail.com>,
       Eric Anholt <eric@anholt.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Subject: [Bug 14662] drm/i915: Select CONFIG_SHMEM
Message-ID: <Pine.LNX.4.64.0912011906290.8058@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

I'm slightly worried by this patch which went into Linus's git yesterday.

Thank you for looking into the issue, and coming up with what Mateusz
has found to be a good workaround.

But is it the right fix?

drm/i915 ought to be working without CONFIG_SHMEM: it then falls back
to using ramfs instead of shmem.  So why isn't that working here?

I'd take the NULL function pointer in read_cache_page_async() to be a
NULL filler function; but that should be pointing to simple_readpage(),
as specified in ramfs_aops.

You don't go into more detail in the comments: do you have any more
info on how this came about?  I don't get it.

I'd prefer not to "select SHMEM" there, because it shouldn't be
necessary; and will put CONFIG_SHMEM=y into the .configs of users
who chose not to have it before, and who will forget to reverse it
if we come up with a better fix letter.

If there is a better fix: I just don't understand what happened here.

Thanks,
Hugh

From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Sun, 22 Nov 2009 15:40:31 +0000 (+0000)
Subject: drm/i915: Select CONFIG_SHMEM
X-Git-Url: http://git.kernel.org/gitweb.cgi?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git;a=commitdiff_plain;h=ca9ab10033d190c1ede85fdf456307bdfdabf079

drm/i915: Select CONFIG_SHMEM

The driver requires shmfs as the backing filesystem to handle the buffer
objects, so ensure it is selected if the user chooses to build our
driver.

Fixes: Bug 14662 - Dell E5500 kernel panic with KMS
http://bugzilla.kernel.org/show_bug.cgi?id=14662

The revealing nature of the panic is the NULL function pointer
dereference in read_cache_page_async().

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reported-and-tested-by: Mateusz Kaduk <mateusz.kaduk@gmail.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Cc: stable@kernel.org
---

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index f831ea1..96eddd1 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -92,6 +92,7 @@ config DRM_I830
 config DRM_I915
 	tristate "i915 driver"
 	depends on AGP_INTEL
+	select SHMEM
 	select DRM_KMS_HELPER
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
