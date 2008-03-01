Return-Path: <linux-kernel-owner+w=401wt.eu-S1758651AbYCAMrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651AbYCAMrd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 07:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbYCAMrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 07:47:25 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55966 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbYCAMrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 07:47:24 -0500
Date: Sat, 01 Mar 2008 21:46:52 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [patch 06/21] split LRU lists into anon & file sets
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org
In-Reply-To: <20080228192928.412991306@redhat.com>
References: <20080228192908.126720629@redhat.com> <20080228192928.412991306@redhat.com>
Message-Id: <20080301214315.529B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> @@ -153,43 +153,47 @@ static int meminfo_read_proc(char *page,
>  	 * Tagged format, for easy grepping and expansion.
>  	 */
>  	len = sprintf(page,
> -		"MemTotal:     %8lu kB\n"
> -		"MemFree:      %8lu kB\n"
> -		"Buffers:      %8lu kB\n"
> -		"Cached:       %8lu kB\n"
> -		"SwapCached:   %8lu kB\n"
> -		"Active:       %8lu kB\n"
> -		"Inactive:     %8lu kB\n"
> +		"MemTotal:       %8lu kB\n"
> +		"MemFree:        %8lu kB\n"
> +		"Buffers:        %8lu kB\n"
> +		"Cached:         %8lu kB\n"
> +		"SwapCached:     %8lu kB\n"
> +		"Active(anon):   %8lu kB\n"
> +		"Inactive(anon): %8lu kB\n"
> +		"Active(file):   %8lu kB\n"
> +		"Inactive(file): %8lu kB\n"

Unfortunately this change corrupt "vmstat -a".
could we add field instead replace it?

-kosaki


---
 fs/proc/proc_misc.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

Index: b/fs/proc/proc_misc.c
===================================================================
--- a/fs/proc/proc_misc.c       2008-03-01 21:32:13.000000000 +0900
+++ b/fs/proc/proc_misc.c       2008-03-01 21:39:04.000000000 +0900
@@ -131,6 +131,10 @@ static int meminfo_read_proc(char *page,
        unsigned long allowed;
        struct vmalloc_info vmi;
        long cached;
+       unsigned long active_anon;
+       unsigned long inactive_anon;
+       unsigned long active_file;
+       unsigned long inactive_file;

 /*
  * display in kilobytes.
@@ -149,6 +153,11 @@ static int meminfo_read_proc(char *page,

        get_vmalloc_info(&vmi);

+       active_anon   = global_page_state(NR_ACTIVE_ANON);
+       inactive_anon = global_page_state(NR_INACTIVE_ANON);
+       active_file   = global_page_state(NR_ACTIVE_FILE);
+       inactive_file = global_page_state(NR_INACTIVE_FILE);
+
        /*
         * Tagged format, for easy grepping and expansion.
         */
@@ -158,6 +167,8 @@ static int meminfo_read_proc(char *page,
                "Buffers:        %8lu kB\n"
                "Cached:         %8lu kB\n"
                "SwapCached:     %8lu kB\n"
+               "Active:         %8lu kB\n"
+               "Inactive:       %8lu kB\n"
                "Active(anon):   %8lu kB\n"
                "Inactive(anon): %8lu kB\n"
                "Active(file):   %8lu kB\n"
@@ -190,10 +201,12 @@ static int meminfo_read_proc(char *page,
                K(i.bufferram),
                K(cached),
                K(total_swapcache_pages),
-               K(global_page_state(NR_ACTIVE_ANON)),
-               K(global_page_state(NR_INACTIVE_ANON)),
-               K(global_page_state(NR_ACTIVE_FILE)),
-               K(global_page_state(NR_INACTIVE_FILE)),
+               K(active_anon   + active_file),
+               K(inactive_anon + inactive_file),
+               K(active_anon),
+               K(inactive_anon),
+               K(active_file),
+               K(inactive_file),
 #ifdef CONFIG_HIGHMEM
                K(i.totalhigh),
                K(i.freehigh),




