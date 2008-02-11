Return-Path: <linux-kernel-owner+w=401wt.eu-S1751387AbYBKS1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387AbYBKS1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbYBKS1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:27:41 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:17031 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761AbYBKS1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:27:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=i1ICiOnu+QtC+gF6uB5zOemKAtduY+R5wHyJDHKDaPk9AITN098nt2rI/b0E6/nHm2PqhritB0RHwTs5vcfLMENjLRUMh+Hx+7IRwnwwEpPiLjHHlTS+WqCPXwjkWacaT0s/hbMpm0FIiU7IMQSmLvGtngMss+dXsfs3y6BscA8=
Message-ID: <15577be70802111027s59bc16f7q7c0be42cc44f9ad7@mail.gmail.com>
Date: Mon, 11 Feb 2008 19:27:35 +0100
From: "Abel Bernabeu" <abelbg@m2grp.com>
Reply-To: abelbg@m2grp.com
To: linux-kernel@vger.kernel.org
Subject: [Patch] Elf loader crash while zero-filling .bss
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 2d685cdddebcb3f6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've finally found a solution for the crash in load_binary_elf I
reported last week:

http://lkml.org/lkml/2008/1/30/171

The attached patch solves my problem, but please test it yourself...

set_brk(start, end) allocs just page aligned regions (by "colapsing"
both extremes to the start of the page in which they lay)... That
means than even if both pointers are not equal there are still some
chances that set_brk has allocated no space at all because
ELF_PAGEALIGN(elf_bss) != ELF_PAGEALIGN(elf_brk).

So the condition was not correct.


--- linux-2.6.22.10.orig/fs/binfmt_elf.c	2008-02-11 18:58:29.000000000 +0100
+++ linux-2.6.22.10.hacked/fs/binfmt_elf.c	2008-02-11 16:09:41.000000000 +0100
@@ -939,3 +939,3 @@ static int load_elf_binary(struct linux_
 	}
-	if (likely(elf_bss != elf_brk) && unlikely(padzero(elf_bss))) {
+	if (likely(ELF_PAGEALIGN(elf_bss) != ELF_PAGEALIGN(elf_brk)) &&
unlikely(padzero(elf_bss))) {
 		send_sig(SIGSEGV, current, 0);
