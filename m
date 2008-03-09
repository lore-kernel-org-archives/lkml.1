Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbYCIKn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbYCIKn7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 06:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbYCIKnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 06:43:47 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35343 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbYCIKnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 06:43:46 -0400
Date: Sun, 09 Mar 2008 19:42:56 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: quicklists confuse meminfo
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Lameter <clameter@sgi.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
In-Reply-To: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de>
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de>
Message-Id: <20080309193657.C6D8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

in general, I like this patch and I think this is very useful.
but I don't like #ifdef ;)

> +#ifdef CONFIG_QUICKLIST
> +		"QuickLists:   %8lu kB\n"
> +#endif
> +		,K(i.totalram),
>  		K(i.freeram),
>  		K(i.bufferram),
>  		K(cached),
> @@ -215,6 +220,9 @@ static int meminfo_read_proc(char *page,
>  		(unsigned long)VMALLOC_TOTAL >> 10,
>  		vmi.used >> 10,
>  		vmi.largest_chunk >> 10
> +#ifdef CONFIG_QUICKLIST
> +		,K(quicklist_total_size())
> +#endif

Do you dislike my following patch?

- kosaki



Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 fs/proc/proc_misc.c       |    6 ++++--
 include/linux/quicklist.h |    7 +++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

Index: b/fs/proc/proc_misc.c
===================================================================
--- a/fs/proc/proc_misc.c       2008-03-09 16:04:39.000000000 +0900
+++ b/fs/proc/proc_misc.c       2008-03-09 19:47:47.000000000 +0900
@@ -182,7 +182,8 @@ static int meminfo_read_proc(char *page,
                "Committed_AS: %8lu kB\n"
                "VmallocTotal: %8lu kB\n"
                "VmallocUsed:  %8lu kB\n"
-               "VmallocChunk: %8lu kB\n",
+               "VmallocChunk: %8lu kB\n"
+               "Quicklists:   %8lu kB\n",
                K(i.totalram),
                K(i.freeram),
                K(i.bufferram),
@@ -213,7 +214,8 @@ static int meminfo_read_proc(char *page,
                K(committed),
                (unsigned long)VMALLOC_TOTAL >> 10,
                vmi.used >> 10,
-               vmi.largest_chunk >> 10
+               vmi.largest_chunk >> 10,
+               K(quicklist_total_size())
                );

                len += hugetlb_report_meminfo(page + len);
Index: b/include/linux/quicklist.h
===================================================================
--- a/include/linux/quicklist.h 2008-03-09 16:02:28.000000000 +0900
+++ b/include/linux/quicklist.h 2008-03-09 19:45:58.000000000 +0900
@@ -80,6 +80,13 @@ void quicklist_trim(int nr, void (*dtor)

 unsigned long quicklist_total_size(void);

+#else
+
+static inline unsigned long quicklist_total_size(void)
+{
+       return 0;
+}
+
 #endif

 #endif /* LINUX_QUICKLIST_H */


