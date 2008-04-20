Return-Path: <linux-kernel-owner+w=401wt.eu-S1759962AbYDTSZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962AbYDTSZA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 14:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbYDTSYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 14:24:36 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45907 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbYDTSYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 14:24:34 -0400
Subject: [PATCH 7/9] Add balance_dirty_pages_ratelimited() to cont_expand_zero() 
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 21 Apr 2008 03:13:28 +0900
Message-ID: <cef36f873e8480b87c875695.ps@mail.parknet.co.jp>
References: <60d0156a3e8480b87c215695.ps@mail.parknet.co.jp>
	<5cb1b5773e8480b87c425695.ps@mail.parknet.co.jp>
	<954304cc3e8480b87c535695.ps@mail.parknet.co.jp>
	<f6f833103e8480b87c645695.ps@mail.parknet.co.jp>
	<89121f633e8480b87c755695.ps@mail.parknet.co.jp>
	<dedb5bd83e8480b87c765695.ps@mail.parknet.co.jp>
In-Reply-To: <dedb5bd83e8480b87c765695.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On the systems, ftruncate() which expand size for FAT became the cause
of OOM.  The cont_expand_zero() filled all memory with dirty pages,
and since disk is very slow, limit of page scanning was exceeded, then
it triggered OOM.

This adds balance_dirty_pages_ratelimited() to avoid filling memory
with dirty pages.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/buffer.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/buffer.c~cont_expand_zero-fix fs/buffer.c
--- linux-2.6/fs/buffer.c~cont_expand_zero-fix	2008-04-05 18:22:57.000000000 +0900
+++ linux-2.6-hirofumi/fs/buffer.c	2008-04-05 18:22:57.000000000 +0900
@@ -2251,6 +2251,8 @@ int cont_expand_zero(struct file *file, 
 			goto out;
 		BUG_ON(err != len);
 		err = 0;
+
+		balance_dirty_pages_ratelimited(mapping);
 	}
 
 	/* page covers the boundary, find the boundary offset */
_
