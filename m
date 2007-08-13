Return-Path: <linux-kernel-owner+w=401wt.eu-S932246AbXHMOa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbXHMOa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939319AbXHMLap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:30:45 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:18339 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S942504AbXHMLam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:30:42 -0400
Date: Mon, 13 Aug 2007 15:29:07 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org, satyam@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc2-mm2: strtol_check_range patches
Message-ID: <20070813112907.GA6620@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew please drop
	introduce-strtol_check_range-fix.patch
	introduce-strtol_check_range.patch
from -mm.

strtol_check_range() semantics is broken, because caller can't distinguish
-E from valid negative number if he wants to negative integers. Comment
mentions this, but we don't want to such horrible and not well thought
out function to lib/ .

If anything it should be strtonum() with additional trailing '\n' check.

+ * Do not use this to convert numbers that are allowed to be negative.
+ */
+long strtol_check_range(const char *cp, long min, long max, unsigned int base)
+{
+       long ret;
+       char *p = (char *) cp;
+
+       WARN_ON(min < 0);
+       WARN_ON(max < min);
+
+       ret = simple_strtol(p, &p, base);
+
+       if (*p && (*p != '\n'))
+               return -EINVAL;
+       if ((ret < min) || (ret > max))
+               return -EINVAL;
+
+       return ret;
+}

