Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbYDGEqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbYDGEqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 00:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbYDGEpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 00:45:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:37098 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbYDGEov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 00:44:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=ApFWpEf27I2Bc8SEzlev2NsLuNtSEVm7G6TOx0qgtOp1rqr/QfNQ0Q7OAcVPXUMxSLsniOP9tJnmEdATgig//FXFP8u3r0PX7KjQkvq3ngd8RH3a1IIeMIB+IizrLZNylHm6j8MiGWST0/DvswA5ZcL30bIrp8qUFqWnNJ8L3xA=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 6/6] ide-tape: fix mem leak
Date: Mon,  7 Apr 2008 06:45:04 +0200
Message-Id: <1207543504-27888-7-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1207543504-27888-1-git-send-email-petkovbb@gmail.com>
References: <1207543504-27888-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On failed struct idetape_bh allocation the logic frees only one buffer page
which was the old page-wise strategy. Doing that now would probably leak
2^order-1 pages so fix it to free all and not only the first buffer page.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 78a76a0..29870c4 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1348,7 +1348,7 @@ static struct idetape_bh *ide_tape_kmalloc_buffer(idetape_tape_t *tape,
 		prev_bh = bh;
 		bh = kmalloc(sizeof(struct idetape_bh), GFP_KERNEL);
 		if (!bh) {
-			free_page((unsigned long) b_data);
+			free_pages((unsigned long) b_data, order);
 			goto abort;
 		}
 		bh->b_reqnext = NULL;
-- 
1.5.4.1

