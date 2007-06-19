Return-Path: <linux-kernel-owner+w=401wt.eu-S1764509AbXFSDsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764509AbXFSDsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 23:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932379AbXFSDr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 23:47:59 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:46869 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbXFSDr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 23:47:57 -0400
Message-ID: <467750E9.4090808@hitachi.com>
Date: Tue, 19 Jun 2007 12:43:37 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: David Wilder <dwilder@us.ibm.com>, Tom Zanussi <zanussi@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, systemtap@sources.redhat.com,
       Yumiko Sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi Oshima <soshima@redhat.com>, Hideo Aoki <haoki@redhat.com>
Subject: Re: [PATCH] relay-file-read-start-pos-fix.patch
References: <4676109F.8020202@us.ibm.com>
In-Reply-To: <4676109F.8020202@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David and Tom,

David Wilder wrote:
> This patch fixes a bug in the relay read interface causing the number
> of consumed bytes to be set incorrectly. 

Thank you. Your patch fixes one of my concerns.
However there is another bug I found.
When I use relayfs with "overwrite" mode, read() still set incorrect
number of consumed bytes.
I tried to fix that. Please review it.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

---
 kernel/relay.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc4-mm2/kernel/relay.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/kernel/relay.c	2007-06-13 20:22:02.000000000 +0900
+++ linux-2.6.22-rc4-mm2/kernel/relay.c	2007-06-18 23:00:54.000000000 +0900
@@ -812,7 +812,10 @@
 	}

 	buf->bytes_consumed += bytes_consumed;
-	read_subbuf = read_pos / buf->chan->subbuf_size;
+	if (!read_pos)
+		read_subbuf = buf->subbufs_consumed;
+	else
+		read_subbuf = read_pos / buf->chan->subbuf_size;
 	if (buf->bytes_consumed + buf->padding[read_subbuf] == subbuf_size) {
 		if ((read_subbuf == buf->subbufs_produced % n_subbufs) &&
 		    (buf->offset == subbuf_size))
@@ -841,8 +844,9 @@
 	}

 	if (unlikely(produced - consumed >= n_subbufs)) {
-		consumed = (produced / n_subbufs) * n_subbufs;
+		consumed = produced - n_subbufs + 1;
 		buf->subbufs_consumed = consumed;
+		buf->bytes_consumed = 0;
 	}
 	
 	produced = (produced % n_subbufs) * subbuf_size + buf->offset;



