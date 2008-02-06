Return-Path: <linux-kernel-owner+w=401wt.eu-S1765107AbYBGAXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765107AbYBGAXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761009AbYBFX7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:59:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33021 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932513AbYBFX72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:59:28 -0500
Date: Wed, 6 Feb 2008 15:54:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>
Subject: [patch 57/73] security: protect from stack expantion into low vm
	addresses
Message-ID: <20080206235401.GF13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="security-protect-from-stack-expantion-into-low-vm-addresses.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Eric Paris <eparis@redhat.com>

patch 8869477a49c3e99def1fcdadd6bbc407fea14b45 in mainline.

Add security checks to make sure we are not attempting to expand the
stack into memory protected by mmap_min_addr

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/mmap.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1619,6 +1619,12 @@ static inline int expand_downwards(struc
 	 */
 	if (unlikely(anon_vma_prepare(vma)))
 		return -ENOMEM;
+
+	address &= PAGE_MASK;
+	error = security_file_mmap(0, 0, 0, 0, address, 1);
+	if (error)
+		return error;
+
 	anon_vma_lock(vma);
 
 	/*
@@ -1626,8 +1632,6 @@ static inline int expand_downwards(struc
 	 * is required to hold the mmap_sem in read mode.  We need the
 	 * anon_vma lock to serialize against concurrent expand_stacks.
 	 */
-	address &= PAGE_MASK;
-	error = 0;
 
 	/* Somebody else might have raced and expanded it already */
 	if (address < vma->vm_start) {

-- 
