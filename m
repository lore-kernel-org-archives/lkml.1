Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbZIGOWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbZIGOWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 10:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbZIGOWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 10:22:17 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:48001 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752282AbZIGOWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 10:22:17 -0400
Date: Mon, 7 Sep 2009 10:21:50 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Greg Ungerer <gerg@snapgear.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Greg Ungerer <gerg@uclinux.org>
Subject: Re: [PATCH] m68knommu: Clean up linker script using new linker script
 macros.
In-Reply-To: <4AA4B104.7040507@snapgear.com>
Message-ID: <alpine.DEB.1.10.0909071017001.17860@dr-wily.mit.edu>
References: <1252293044-13102-1-git-send-email-tabbott@ksplice.com> <4AA49946.2000804@snapgear.com> <alpine.DEB.1.10.0909070135040.17860@dr-wily.mit.edu> <4AA4B104.7040507@snapgear.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Sep 2009, Greg Ungerer wrote:

> Now, back to the original patch. Now fails with another syntax error
> at the last line in this:
> 
>  .init : {
>   . = ALIGN((1 << (12)));
>   __init_begin = .;
>   . = ALIGN((1 << (12))); .init.text : AT(ADDR(.init.text) - 0) { _sinittext =
> .; *(.init.text) *(.devinit.text) *(.cpuinit.text) *(.meminit.text) _einittext
> = .; }

Oops.  The ".init : { }" wrapping the new macros there should have been 
removed.

The following patch should fix this issue (obviously, you'll want to 
squash it with the original patch, but I figure sending the diff will be 
easier to review).

	-Tim Abbott

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
---
 arch/m68knommu/kernel/vmlinux.lds.S |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
index 979acb5..c380040 100644
--- a/arch/m68knommu/kernel/vmlinux.lds.S
+++ b/arch/m68knommu/kernel/vmlinux.lds.S
@@ -154,14 +154,12 @@ SECTIONS {
 		_edata = . ;
 	} > DATA
 
-	.init : {
-		. = ALIGN(PAGE_SIZE);
-		__init_begin = .;
-		INIT_TEXT_SECTION(PAGE_SIZE)
-		INIT_DATA_SECTION(16)
-		. = ALIGN(PAGE_SIZE);
-		__init_end = .;
-	} > INIT
+	. = ALIGN(PAGE_SIZE);
+	__init_begin = .;
+	INIT_TEXT_SECTION(PAGE_SIZE) > INIT
+	INIT_DATA_SECTION(16) > INIT
+	. = ALIGN(PAGE_SIZE);
+	__init_end = .;
 
 	/DISCARD/ : {
 		EXIT_TEXT
-- 
1.6.3.3

