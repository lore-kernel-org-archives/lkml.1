Return-Path: <linux-kernel-owner+w=401wt.eu-S1757501AbZHGKud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbZHGKud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 06:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757491AbZHGKuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 06:50:32 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:35722 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479AbZHGKua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 06:50:30 -0400
Message-ID: <4A7C06B9.2090302@gmail.com>
Date: Fri, 07 Aug 2009 12:49:29 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: [PATCH] ring-buffer: Fix memleak in ring_buffer_free()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 07 Aug 2009 12:49:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed oprofile memleaked in linux-2.6 current tree,
and tracked this ring-buffer leak.

This is a stable candidate.

[PATCH] ring-buffer: Fix memleak in ring_buffer_free()

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index bf27bb7..c1d874e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -735,6 +735,7 @@ ring_buffer_free(struct ring_buffer *buffer)
 
 	put_online_cpus();
 
+	kfree(buffer->buffers);
 	free_cpumask_var(buffer->cpumask);
 
 	kfree(buffer);
