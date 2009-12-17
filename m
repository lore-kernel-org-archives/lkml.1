Return-Path: <linux-kernel-owner+w=401wt.eu-S1764016AbZLQEwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764016AbZLQEwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764010AbZLQEwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:52:12 -0500
Received: from kroah.org ([198.145.64.141]:55242 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762055AbZLQEDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:03:37 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:44 2009
Message-Id: <20091217035644.274392244@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       =?ISO-8859-15?q?Kristian=20H=C3=B8gsberg?= <krh@bitplanet.net>,
       "David S. Miller" <davem@davemloft.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [010/151] perf: Dont free perf_mmap_data until work has been done
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kristian Høgsberg <krh@bitplanet.net>

commit ec70ccd806111ba3caf596def91a8580138b12db upstream.

In the CONFIG_PERF_USE_VMALLOC case, perf_mmap_data_free() only
schedules the cleanup of the perf_mmap_data struct.  In that
case we have to wait until the work has been done before we free
data.

Signed-off-by: Kristian Høgsberg <krh@bitplanet.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1259697901-1747-1-git-send-email-krh@bitplanet.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_event.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2174,6 +2174,7 @@ static void perf_mmap_data_free(struct p
 	perf_mmap_free_page((unsigned long)data->user_page);
 	for (i = 0; i < data->nr_pages; i++)
 		perf_mmap_free_page((unsigned long)data->data_pages[i]);
+	kfree(data);
 }
 
 #else
@@ -2214,6 +2215,7 @@ static void perf_mmap_data_free_work(str
 		perf_mmap_unmark_page(base + (i * PAGE_SIZE));
 
 	vfree(base);
+	kfree(data);
 }
 
 static void perf_mmap_data_free(struct perf_mmap_data *data)
@@ -2319,7 +2321,6 @@ static void perf_mmap_data_free_rcu(stru
 
 	data = container_of(rcu_head, struct perf_mmap_data, rcu_head);
 	perf_mmap_data_free(data);
-	kfree(data);
 }
 
 static void perf_mmap_data_release(struct perf_event *event)


