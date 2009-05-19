Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbZESIcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbZESIcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 04:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbZESIcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 04:32:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:60749 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476AbZESIcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 04:32:14 -0400
Date: Tue, 19 May 2009 08:31:23 GMT
From: tip-bot for Stefan Raspl <raspl@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       raspl@linux.vnet.ibm.com, lizf@cn.fujitsu.com, tglx@linutronix.de,
       stefan.raspl@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       raspl@linux.vnet.ibm.com, lizf@cn.fujitsu.com, tglx@linutronix.de,
       stefan.raspl@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <4A1266CC.5040801@linux.vnet.ibm.com>
References: <4A1266CC.5040801@linux.vnet.ibm.com>
Subject: [tip:tracing/core] blktrace: remove debugfs entries on bad path
Message-ID: <tip-fd51d251e4cdb21f68e9dbc4336514d64a105a79@git.kernel.org>
Git-Commit-ID: fd51d251e4cdb21f68e9dbc4336514d64a105a79
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 19 May 2009 08:31:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd51d251e4cdb21f68e9dbc4336514d64a105a79
Gitweb:     http://git.kernel.org/tip/fd51d251e4cdb21f68e9dbc4336514d64a105a79
Author:     Stefan Raspl <raspl@linux.vnet.ibm.com>
AuthorDate: Tue, 19 May 2009 09:59:08 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 19 May 2009 10:29:21 +0200

blktrace: remove debugfs entries on bad path

debugfs directory entries for devices are not removed on some
of the failure pathes in do_blk_trace_setup().
One way to reproduce is to start blktrace on multiple devices
with insufficient Vmalloc space: Devices will fail with
a message like this:

	BLKTRACESETUP(2) /dev/sdu failed: 5/Input/output error

If so, the respective entries in debugfs
(e.g. /sys/kernel/debug/block/sdu) will remain and subsequent
attempts to start blktrace on the respective devices will not
succeed due to existing directories.

[ Impact: fix /debug/tracing file cleanup corner case ]

Signed-off-by: Stefan Raspl <stefan.raspl@linux.vnet.ibm.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: schwidefsky@de.ibm.com
Cc: heiko.carstens@de.ibm.com
LKML-Reference: <4A1266CC.5040801@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/blktrace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 05b4747..e3abf55 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -262,6 +262,7 @@ static void blk_trace_free(struct blk_trace *bt)
 {
 	debugfs_remove(bt->msg_file);
 	debugfs_remove(bt->dropped_file);
+	debugfs_remove(bt->dir);
 	relay_close(bt->rchan);
 	free_percpu(bt->sequence);
 	free_percpu(bt->msg_data);
