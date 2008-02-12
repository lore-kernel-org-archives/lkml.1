Return-Path: <linux-kernel-owner+w=401wt.eu-S1762921AbYBLXMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762921AbYBLXMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:12:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761526AbYBLXK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:10:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:8053 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761506AbYBLXK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:10:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=DXHZMOQqLQ8Of0jUv6vDvxUMJpT7ZA26pZX5LBUb+oZiU5RX8XBgmCo7r0ZLsRInmKVFOsI22OahyMAdOmChTNYQLF5FwiwoZHXulM/hH0Oieeyiu41NSC5hSf4cSMxybEYRtbmV2JRe4BZiroBJ75w+Yq5as1bdSoVzkEEXNsc=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Anton Altaparmakov <aia21@cantab.net>,
       linux-ntfs-dev@lists.sourceforge.net
Subject: [PATCH] ntfs: le*_add_cpu conversion
Date: Wed, 13 Feb 2008 00:06:17 +0100
Message-Id: <1202857582-15450-13-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
					expression_in_cpu_byteorder);
with:
	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Anton Altaparmakov <aia21@cantab.net>
Cc: linux-ntfs-dev@lists.sourceforge.net
---
 fs/ntfs/upcase.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs/upcase.c b/fs/ntfs/upcase.c
index 9101807..e2f72ca 100644
--- a/fs/ntfs/upcase.c
+++ b/fs/ntfs/upcase.c
@@ -77,11 +77,10 @@ ntfschar *generate_default_upcase(void)
 		uc[i] = cpu_to_le16(i);
 	for (r = 0; uc_run_table[r][0]; r++)
 		for (i = uc_run_table[r][0]; i < uc_run_table[r][1]; i++)
-			uc[i] = cpu_to_le16(le16_to_cpu(uc[i]) +
-					uc_run_table[r][2]);
+			le16_add_cpu(&uc[i], uc_run_table[r][2]);
 	for (r = 0; uc_dup_table[r][0]; r++)
 		for (i = uc_dup_table[r][0]; i < uc_dup_table[r][1]; i += 2)
-			uc[i + 1] = cpu_to_le16(le16_to_cpu(uc[i + 1]) - 1);
+			le16_add_cpu(&uc[i + 1], -1);
 	for (r = 0; uc_word_table[r][0]; r++)
 		uc[uc_word_table[r][0]] = cpu_to_le16(uc_word_table[r][1]);
 	return uc;
-- 
1.5.3.7

