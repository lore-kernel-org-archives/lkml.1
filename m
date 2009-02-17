Return-Path: <linux-kernel-owner+w=401wt.eu-S1752272AbZBQFk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbZBQFk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 00:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbZBQFkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 00:40:17 -0500
Received: from qb-out-0506.google.com ([72.14.204.226]:5443 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbZBQFkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 00:40:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QA9SOXfFudPT4x0uBWo5XFu2SHFFtM+8wV9xmkdGKNU/5TIHrPmaU66cEyImWRbyDp
         No7iJZpqSw8f9suEqmt8aKqb5dDe9f3tBHlu/xFtt5yp2um8YNwLm8VMy4qo0qln0Uqj
         cC+3mAXUzZZKVNNugESHVkQ6d1UGpi/EEqkAY=
MIME-Version: 1.0
Date: Tue, 17 Feb 2009 11:10:14 +0530
Message-ID: <b4c3746e0902162140u25d79ba8gd1e4483e414e2d87@mail.gmail.com>
Subject: [PATCH] relay: fix for possible loss/corruption of produced subbufs
From: Aravind Srinivasan <raa.aars@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Tom Zanussi <zanussi@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

from: Aravind Srinivasan <raa.aars@gmail.com>

This patch fixes possible loss/corruption of produced subbufs in
relay_subbufs_consumed().

When buf->subbufs_produced wraps around after UINT_MAX and
buf->subbufs_consumed is still < UINT_MAX, the condition
	if (buf->subbufs_consumed > buf->subbufs_produced)
will be true even for certain valid values of subbufs_consumed. This may lead
to loss or corruption of produced subbufs.

	Signed-off-by: Aravind Srinivasan <raa.aars@gmail.com>
--------------------------------------------------------------------------------
--- linux-2.6.28/kernel/relay.c.orig	2009-02-17 07:53:55.000000000 +0530
+++ linux-2.6.28/kernel/relay.c	2009-02-17 07:54:14.000000000 +0530
@@ -795,13 +795,15 @@ void relay_subbufs_consumed(struct rchan
 	if (!chan)
 		return;

-	if (cpu >= NR_CPUS || !chan->buf[cpu])
+	if (cpu >= NR_CPUS || !chan->buf[cpu] ||
+					subbufs_consumed > chan->n_subbufs)
 		return;

 	buf = chan->buf[cpu];
-	buf->subbufs_consumed += subbufs_consumed;
-	if (buf->subbufs_consumed > buf->subbufs_produced)
+	if (subbufs_consumed > buf->subbufs_produced - buf->subbufs_consumed)
 		buf->subbufs_consumed = buf->subbufs_produced;
+	else
+		buf->subbufs_consumed += subbufs_consumed;
 }
 EXPORT_SYMBOL_GPL(relay_subbufs_consumed);
