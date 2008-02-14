Return-Path: <linux-kernel-owner+w=401wt.eu-S1759874AbYBNS0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759874AbYBNS0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754983AbYBNS01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:26:27 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:41767 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbYBNS00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:26:26 -0500
Message-ID: <47B487D0.5010104@ct.jp.nec.com>
Date: Thu, 14 Feb 2008 10:26:24 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] latencytop: fix kernel panic while reading latency proc file
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Reading /proc/<pid>/latency or /proc/<pid>/task/<tid>/latency could cause
NULL pointer dereference.

In lstats_open(), get_proc_task() can return NULL, in which case the kernel
will oops at lstats_show_proc() because m->private is NULL.

When get_proc_task() returns NULL, the kernel should return -ENOENT.

This can be reproduced by the following script.
while :
do
        date
        bash -c 'ls > ls.$$' &
        pid=$!
        cat /proc/$pid/latency &
        cat /proc/$pid/latency &
        cat /proc/$pid/latency &
        cat /proc/$pid/latency
done

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 fs/proc/base.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 7c6b4ec..1710b03 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -350,6 +350,8 @@ static int lstats_open(struct inode *inode, struct file *file)
 	struct seq_file *m;
 	struct task_struct *task = get_proc_task(inode);
 
+	if (!task)
+		return -ENOENT;
 	ret = single_open(file, lstats_show_proc, NULL);
 	if (!ret) {
 		m = file->private_data;
-- 
1.5.3.8

