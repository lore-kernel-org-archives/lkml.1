Return-Path: <linux-kernel-owner+w=401wt.eu-S1758002AbXHVJe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbXHVJe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbXHVJew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 05:34:52 -0400
Received: from bay0-omc1-s20.bay0.hotmail.com ([65.54.246.92]:3416 "EHLO
	bay0-omc1-s20.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751060AbXHVJev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 05:34:51 -0400
Message-ID: <BAY105-F323FF3DC8E6C544A2BBE98FFD50@phx.gbl>
X-Originating-IP: [213.246.200.66]
X-Originating-Email: [lode_leroy@hotmail.com]
From: "lode leroy" <lode_leroy@hotmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] memchr (trivial) optimization
Date: Wed, 22 Aug 2007 11:34:49 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
X-OriginalArrivalTime: 22 Aug 2007 09:34:50.0645 (UTC) FILETIME=[AFF68450:01C7E49F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While profiling something completely unrelated, I noticed
that on the workloads I used memchr for, I saw a 30%-40% improvement
in performance, with the following trivial changes...
(basically, it saves 3 operations for each call)

$ diff -Nurp linux/lib/string.c{-old,}
--- linux/lib/string.c-old      2007-08-22 11:18:54.000000000 +0200
+++ linux/lib/string.c  2007-08-22 11:19:20.000000000 +0200
@@ -623,10 +623,12 @@ EXPORT_SYMBOL(strstr);
void *memchr(const void *s, int c, size_t n)
{
        const unsigned char *p = s;
-       while (n-- != 0) {
-               if ((unsigned char)c == *p++) {
-                       return (void *)(p - 1);
+       while (n != 0) {
+               if ((unsigned char)c == *p) {
+                       return (void *)p;
                }
+               n--;
+               p++;
        }
        return NULL;
}

_________________________________________________________________
A lot of passions?  Collect all your personal info on one central location , 
for free! http://get.live.com/live/features

