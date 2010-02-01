Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab0BAQoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:44:54 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:55355 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab0BAQow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:44:52 -0500
From: Darren Hart <dvhltc@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/3] trace-cmd: Handle empty CPUs without crashing
Date: Mon,  1 Feb 2010 08:44:04 -0800
Message-Id: <1265042646-24573-2-git-send-email-dvhltc@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265042646-24573-1-git-send-email-dvhltc@us.ibm.com>
References: <1265042646-24573-1-git-send-email-dvhltc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The get_page() needs to return -1 on reading a CPU that has no
data.

Also added checks of get_page() return status that was missing
from some callers.

Have tracecmd_set_cpu_to_timestamp() also return -1 when reading an
empty CPU.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-input.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/trace-input.c b/trace-input.c
index 0c7f9ad..69c2ce7 100644
--- a/trace-input.c
+++ b/trace-input.c
@@ -678,6 +678,10 @@ static int get_page(struct tracecmd_input *handle, int cpu,
 	    handle->cpu_data[cpu].page)
 		return 1;
 
+	/* Do not map no data for CPU */
+	if (!handle->cpu_data[cpu].size)
+		return -1;
+
 	if (offset & (handle->page_size - 1)) {
 		errno = -EINVAL;
 		die("bad page offset %llx", offset);
@@ -941,7 +945,7 @@ int tracecmd_refresh_record(struct tracecmd_input *handle,
 	page_offset = record->offset & ~(handle->page_size - 1);
 	index = record->offset & (handle->page_size - 1);
 
-	ret = get_page(handle, record->cpu, page_offset) < 0;
+	ret =get_page(handle, record->cpu, page_offset);
 	if (ret < 0)
 		return -1;
 
@@ -976,7 +980,9 @@ int tracecmd_refresh_record(struct tracecmd_input *handle,
 struct record *
 tracecmd_read_cpu_first(struct tracecmd_input *handle, int cpu)
 {
-	get_page(handle, cpu, handle->cpu_data[cpu].file_offset);
+	if (get_page(handle, cpu, handle->cpu_data[cpu].file_offset) < 0)
+		return NULL;
+
 	handle->cpu_data[cpu].index = 0;
 	if (handle->cpu_data[cpu].next) {
 		free_record(handle->cpu_data[cpu].next);
@@ -1009,7 +1015,8 @@ tracecmd_read_cpu_last(struct tracecmd_input *handle, int cpu)
 	else
 		offset -= handle->page_size;
 
-	get_page(handle, cpu, offset);
+	if (get_page(handle, cpu, offset) < 0)
+		return NULL;
 
 	do {
 		free_record(record);
@@ -1048,6 +1055,9 @@ tracecmd_set_cpu_to_timestamp(struct tracecmd_input *handle, int cpu,
 		return -1;
 	}
 
+	if (!cpu_data->size)
+		return -1;
+
 	if (!cpu_data->page) {
 		if (init_cpu(handle, cpu))
 		    return -1;
-- 
1.6.3.3

