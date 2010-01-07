Return-Path: <linux-kernel-owner+w=401wt.eu-S932341Ab0AGC63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab0AGC63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 21:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932301Ab0AGC62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 21:58:28 -0500
Received: from smtp-out.google.com ([216.239.44.51]:48426 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab0AGC61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 21:58:27 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=McTVaY695c+VLm+W851Ri7+Ce/uP0q/XsL8esSEW3UFOSKvFdjOx5Kb7/Yv8FbW/W
	nTNM+CARd+vN7D/uUY1Xg==
From: Divyesh Shah <dpshah@google.com>
Subject: [PATCH] cfq-iosched: Respect ioprio_class when preempting
To: jens.axboe@oracle.com, czoccolo@gmail.com, linux-kernel@vger.kernel.org
Cc: nauman@google.com, mikew@google.com, ctalbott@google.com
Date: Wed, 06 Jan 2010 18:58:20 -0800
Message-ID: <20100107025413.27610.48801.stgit@austin.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In cfq_should_preempt(), we currently allow some cases where a non-RT request
can preempt an ongoing RT cfqq timeslice. This should not happen.
Examples include:

o A sync_noidle wl type non-RT request pre-empting a sync_noidle wl type cfqq
  on which we are idling.
o Once we have per-cgroup async queues, a non-RT sync request pre-empting a RT
  async cfqq.

Signed-off-by: Divyesh Shah<dpshah@google.com>
---

 block/cfq-iosched.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 7d6cef9..e9e6610 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3104,6 +3104,12 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 		return true;
 
 	/*
+	 * Don't allow a non-RT request to preempt an ongoing RT cfqq timeslice.
+	 */
+	if (cfq_class_rt(cfqq) && !cfq_class_rt(new_cfqq))
+		return false;
+
+	/*
 	 * if the new request is sync, but the currently running queue is
 	 * not, let the sync request have priority.
 	 */

