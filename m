Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbYGZJ7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbYGZJ7S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 05:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754902AbYGZJ64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 05:58:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754832AbYGZJ6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 05:58:54 -0400
Date: Sat, 26 Jul 2008 02:58:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] hugetlbfs: fix build failure on 64-bit x86
Message-Id: <20080726025839.39a11b66.akpm@linux-foundation.org>
In-Reply-To: <20080726091654.GA18341@elte.hu>
References: <20080726091654.GA18341@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jul 2008 11:16:54 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> [resend, still relevant to -git]
> 
> >From 5215af24a20e5f448ee45cd1d97c4118b876c0f6 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri, 25 Jul 2008 20:45:52 +0200
> Subject: [PATCH] hugetlbfs: fix build failure on 64-bit x86
> 
> fix:
> 
>  arch/x86/mm/built-in.o: In function `setup_hugepagesz':
>  hugetlbpage.c:(.init.text+0xb49): undefined reference to `hugetlb_add_hstate'
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/mm/hugetlbpage.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
> index 8f307d9..977d185 100644
> --- a/arch/x86/mm/hugetlbpage.c
> +++ b/arch/x86/mm/hugetlbpage.c
> @@ -425,7 +425,7 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
>  
>  #endif /*HAVE_ARCH_HUGETLB_UNMAPPED_AREA*/
>  
> -#ifdef CONFIG_X86_64
> +#if defined(CONFIG_X86_64) && defined(CONFIG_SYSCTL)
>  static __init int setup_hugepagesz(char *opt)
>  {
>  	unsigned long ps = memparse(opt, &opt);

Seems wrong that a __setup handler would vanish if CONFIG_SYSCTL=n.

I think Nishanth's patch (sent to Linus a few hours ago) fixes this
correctly, by making hugetlb_add_hstate available if CONFIG_SYSCTL=n:


From: Nishanth Aravamudan <nacc@us.ibm.com>

Fixes a build failure reported by Alan Cox:

mm/hugetlb.c: In function `hugetlb_acct_memory': mm/hugetlb.c:1507:
error: implicit declaration of function `cpuset_mems_nr'

Also reverts Ingo's

    commit e44d1b2998d62a1f2f4d7eb17b56ba396535509f
    Author: Ingo Molnar <mingo@elte.hu>
    Date:   Fri Jul 25 12:57:41 2008 +0200

        mm/hugetlb.c: fix build failure with !CONFIG_SYSCTL
    
which fixed the build error but added some unused-static-function warnings.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-fix-config_sysctl=n-build mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-config_sysctl=n-build
+++ a/mm/hugetlb.c
@@ -1026,18 +1026,6 @@ static void __init report_hugepages(void
 	}
 }
 
-static unsigned int cpuset_mems_nr(unsigned int *array)
-{
-	int node;
-	unsigned int nr = 0;
-
-	for_each_node_mask(node, cpuset_current_mems_allowed)
-		nr += array[node];
-
-	return nr;
-}
-
-#ifdef CONFIG_SYSCTL
 #ifdef CONFIG_HIGHMEM
 static void try_to_free_low(struct hstate *h, unsigned long count)
 {
@@ -1386,6 +1374,18 @@ static int __init hugetlb_default_setup(
 }
 __setup("default_hugepagesz=", hugetlb_default_setup);
 
+static unsigned int cpuset_mems_nr(unsigned int *array)
+{
+	int node;
+	unsigned int nr = 0;
+
+	for_each_node_mask(node, cpuset_current_mems_allowed)
+		nr += array[node];
+
+	return nr;
+}
+
+#ifdef CONFIG_SYSCTL
 int hugetlb_sysctl_handler(struct ctl_table *table, int write,
 			   struct file *file, void __user *buffer,
 			   size_t *length, loff_t *ppos)
_

