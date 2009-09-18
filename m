Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbZIRT03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbZIRT03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757995AbZIRT00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:26:26 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:50590 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757985AbZIRT0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:26:24 -0400
Message-ID: <4AB3DEE2.3030600@telenet.be>
Date: Fri, 18 Sep 2009 21:26:26 +0200
From: Ian Schram <ischram@telenet.be>
User-Agent: Thunderbird 2.0.0.23 (X11/20090913)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: xiaoguangrong@cn.fujitsu.com
Subject: perf_copy_attr pointer arithmetic weirdness
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is some -to me at least- weird code in per_copy_attr. Which supposedly
checks that all bytes trailing a struct are zero.

It doesn't seem to get pointer arithmetic right. Since it increments
an iterating pointer by sizeof(unsigned long) rather than 1.

I believe this has an impact on the exploitability of the recent buffer overflow
in the perf_copy_attr function. I'm pretty sure I'm not the only one who noticed
this, but i couldn't find it being mentioned. For some reason people prefer
mmaping something at zero these days?

I have appended a patch locating the issue. The PTR_ALIGN stuff right above it
doesn't seem to take any boundary conditions into account which is probably not
a good thing either.

(I'm not subscribed, please add me in CC.)

signed-of-by Ian Schram <ischram@telenet.be>
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 8cb94a5..9c7590e 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -4208,7 +4208,7 @@ static int perf_copy_attr(struct perf_counter_attr __user *uattr,
 		end  = PTR_ALIGN((void __user *)uattr + size,
 				sizeof(unsigned long));

-		for (; addr < end; addr += sizeof(unsigned long)) {
+		for (; addr < end; ++addr) {
 			ret = get_user(val, addr);
 			if (ret)
 				return ret;
