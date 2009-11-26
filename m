Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbZKZQPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbZKZQPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbZKZQPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:15:38 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:61122 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbZKZQPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:15:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KA9z7RkJycjqd+200KNMdkVGSyKCnniCFFMwf88RFm1f8Wv9EaqRWwW4HNKNoPe3xo
         jFJs6Giw2Oz35klVp01tnD2AkhCPOeG/FNUSnQXZ0N+772xWKYzbcDLUIQdN0icvlGoB
         qsvym+wYrD3guV2mYS6jQiTUUrLHyuXTHtjtg=
Date: Fri, 27 Nov 2009 00:16:31 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Programs die when max_map_count is too large
Message-ID: <20091126161631.GB3246@hack>
References: <alpine.LSU.2.00.0911261600070.7313@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0911261600070.7313@obet.zrqbmnf.qr>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 04:01:08PM +0100, Jan Engelhardt wrote:
>Hi,
>
>
>setting max_map_count to a value large enough results in programs dying 
>at first try.
>This is on 2.6.31.6.
>
>15:59 borg:/proc/sys/vm # echo $[1<<31-1] >max_map_count 
>15:59 borg:/proc/sys/vm # cat max_map_count
>1073741824
>15:59 borg:/proc/sys/vm # echo $[1<<31] >max_map_count 
>15:59 borg:/proc/sys/vm # cat max_map_count
>Killed
>

Hmm, a quick patch from me is below.

IMO, the problem is 'sysctl_max_map_count' is actually signed int,
while when writing to it, the value is treated as unsigned.

A better fix which I could imagine is to fix sysctl to understand
signed int's.

Just have a try, totally untested.


--------------->



Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 84a524a..4161887 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -214,7 +214,7 @@ struct mm_struct {
 	pgd_t * pgd;
 	atomic_t mm_users;			/* How many users with user space? */
 	atomic_t mm_count;			/* How many references to "struct mm_struct" (users count as 1) */
-	int map_count;				/* number of VMAs */
+	unsigned int map_count;			/* number of VMAs */
 	struct rw_semaphore mmap_sem;
 	spinlock_t page_table_lock;		/* Protects page tables and some counters */
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 73f5e4b..3adf2e7 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -85,7 +85,7 @@ EXPORT_SYMBOL(vm_get_page_prot);
 
 int sysctl_overcommit_memory = OVERCOMMIT_GUESS;  /* heuristic overcommit */
 int sysctl_overcommit_ratio = 50;	/* default is 50% */
-int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
+unsigned int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
 struct percpu_counter vm_committed_as;
 
 /*
diff --git a/mm/nommu.c b/mm/nommu.c
index 9876fa0..bf9ae62 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -65,7 +65,7 @@ unsigned long highest_memmap_pfn;
 struct percpu_counter vm_committed_as;
 int sysctl_overcommit_memory = OVERCOMMIT_GUESS; /* heuristic overcommit */
 int sysctl_overcommit_ratio = 50; /* default is 50% */
-int sysctl_max_map_count = DEFAULT_MAX_MAP_COUNT;
+unsigned int sysctl_max_map_count = DEFAULT_MAX_MAP_COUNT;
 int sysctl_nr_trim_pages = CONFIG_NOMMU_INITIAL_TRIM_EXCESS;
 int heap_stack_gap = 0;
 
