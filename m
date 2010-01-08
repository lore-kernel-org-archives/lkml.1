Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523Ab0AHAyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab0AHAyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 19:54:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506Ab0AHAyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 19:54:01 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:60918 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab0AHAyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 19:54:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=FGFsOMnazunY2+cHqjV0hgS6RQHeUwmJ7I9zz4U6Yqdm7eTqQIznr6G51l9MR/if03
         +UOuzwbtM/4zw9QABdVw18UvObu5EbU3ryorR/yRPgaaFmYnqftZff9hWdB/bL8ATyWj
         yumGHfY1eEZHRlnWqwPFy6crpG8RDxLOgjIRo=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Dmitry Monakhov <rjevskiy@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Thomas Voegtle <tv@lio96.de>,
       Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: [PATCH] quota: fix reserved space management for ordinary fs
References: <20100106234533.GC1960@kroah.com>
	<alpine.LNX.2.00.1001071522480.5426@er-systems.de>
	<20100107180449.GA17495@suse.de>
	<alpine.LNX.2.00.1001072033301.26784@er-systems.de>
	<20100107194131.GA22983@suse.de>
	<alpine.LNX.2.00.1001072125040.26784@er-systems.de>
	<alpine.LNX.2.00.1001072141340.26784@er-systems.de>
	<20100107220213.GA24882@suse.de>
	<c18d6aa21001071603hbe4935clf78984fc837e4bd@mail.gmail.com>
Date: Fri, 08 Jan 2010 03:53:54 +0300
In-Reply-To: <c18d6aa21001071603hbe4935clf78984fc837e4bd@mail.gmail.com>
	(Dmitry Monakhov's message of "Fri, 8 Jan 2010 03:03:30 +0300")
Message-ID: <87wrztpgbh.fsf_-_@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In fact inode_get_rsv_space() function is special in comparison
with inode_{add,sub,claim}_rsv_space() functions, because
it may return correct result even for fs without reserved space
support(correct val == 0). Add trivial check for that case.
The patch fix regression(BUG at fs/quota/dquot.c:1350) introduced
in following commit: fd8fbfc1709822bd94247c5b2ab15a5f5041e103

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/quota/dquot.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index dea86ab..d9f06cf 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1377,6 +1377,8 @@ static void inode_sub_rsv_space(struct inode *inode, qsize_t number)
 static qsize_t inode_get_rsv_space(struct inode *inode)
 {
 	qsize_t ret;
+	if (!inode->i_sb->dq_op->get_reserved_space)
+		return 0;
 	spin_lock(&inode->i_lock);
 	ret = *inode_reserved_space(inode);
 	spin_unlock(&inode->i_lock);
-- 
1.6.3.3



