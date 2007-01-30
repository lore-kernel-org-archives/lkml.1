Return-Path: <linux-kernel-owner+w=401wt.eu-S965405AbXA3N6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965405AbXA3N6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 08:58:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965388AbXA3N6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 08:58:13 -0500
Received: from mail.screens.ru ([213.234.233.54]:38620 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965364AbXA3N6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 08:58:13 -0500
Date: Tue, 30 Jan 2007 17:00:15 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@osdl.org>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: bug reading /proc/sys/kernel/*: only first byte read.
Message-ID: <20070130140015.GA123@tv-sign.ru>
References: <4538C47B.9060808@tls.msk.ru> <20070130022457.d0159eba.akpm@osdl.org> <20070130132559.GA315@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070130132559.GA315@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30, Oleg Nesterov wrote:
>
> On 01/30, Andrew Morton wrote:
> >
> > +			if (len + pos < maxlen) {
>                         ^^^^^^^^^^^^^^^^^^^^^^^
> Shouldn't this be
> 			if (len < *lenp)
> 
> ?

On the other hand. If we may assume that original code was correct,
we can make a simpler patch?

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 6.19/kernel/sysctl.c~	2006-11-17 19:42:31.000000000 +0300
+++ 6.19/kernel/sysctl.c	2007-01-30 16:46:00.000000000 +0300
@@ -1683,13 +1683,12 @@ static int _proc_do_string(void* data, i
 	size_t len;
 	char __user *p;
 	char c;
-	
-	if (!data || !maxlen || !*lenp ||
-	    (*ppos && !write)) {
+
+	if (!data || !maxlen || !*lenp) {
 		*lenp = 0;
 		return 0;
 	}
-	
+
 	if (write) {
 		len = 0;
 		p = buffer;
@@ -1710,6 +1709,15 @@ static int _proc_do_string(void* data, i
 		len = strlen(data);
 		if (len > maxlen)
 			len = maxlen;
+
+		if (*ppos > len) {
+			*lenp = 0;
+			return 0;
+		}
+
+		data += *ppos;
+		len  -= *ppos;
+
 		if (len > *lenp)
 			len = *lenp;
 		if (len)

