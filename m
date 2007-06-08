Return-Path: <linux-kernel-owner+w=401wt.eu-S966835AbXFHAVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966835AbXFHAVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 20:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765730AbXFHAVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 20:21:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33354 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764829AbXFHAVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 20:21:11 -0400
Date: Thu, 7 Jun 2007 17:20:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Message-Id: <20070607172050.ead923b4.akpm@linux-foundation.org>
In-Reply-To: <200706061229.24486.jesse.barnes@intel.com>
References: <200706061229.24486.jesse.barnes@intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007 12:29:23 -0700
Jesse Barnes <jesse.barnes@intel.com> wrote:

> --- a/arch/i386/kernel/cpu/mtrr/if.c
> +++ b/arch/i386/kernel/cpu/mtrr/if.c
> @@ -12,7 +12,7 @@
>  #include "mtrr.h"
>  
>  /* RED-PEN: this is accessed without any locking */
> -extern unsigned int *usage_table;
> +extern unsigned int usage_table[];
>  
>  
> --- a/arch/i386/kernel/cpu/mtrr/main.c
> +++ b/arch/i386/kernel/cpu/mtrr/main.c
> @@ -47,7 +47,7 @@
>  
>  u32 num_var_ranges = 0;
>  
> -unsigned int *usage_table;
> +unsigned int usage_table[NUM_VAR_RANGES];
>  static DEFINE_MUTEX(mtrr_mutex);

didn't it feel all dirty when you had to do that?



From: Andrew Morton <akpm@linux-foundation.org>

- Move the declaration into a header file

- "usage_table" is a dumb name for an mtrr-specific kernel-wide identifier.

  There appear to beseveral other poorly-chosen identifiers in mtrr.

Cc: Andi Kleen <ak@suse.de>
Cc: Jesse Barnes <jesse.barnes@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mtrr/if.c   |    8 ++------
 arch/i386/kernel/cpu/mtrr/main.c |   17 +++++++++--------
 arch/i386/kernel/cpu/mtrr/mtrr.h |    2 ++
 3 files changed, 13 insertions(+), 14 deletions(-)

diff -puN arch/i386/kernel/cpu/mtrr/if.c~i386-x86_64-trim-memory-not-covered-by-wb-mtrrs-fix arch/i386/kernel/cpu/mtrr/if.c
--- a/arch/i386/kernel/cpu/mtrr/if.c~i386-x86_64-trim-memory-not-covered-by-wb-mtrrs-fix
+++ a/arch/i386/kernel/cpu/mtrr/if.c
@@ -11,10 +11,6 @@
 #include <asm/mtrr.h>
 #include "mtrr.h"
 
-/* RED-PEN: this is accessed without any locking */
-extern unsigned int usage_table[];
-
-
 #define FILE_FCOUNT(f) (((struct seq_file *)((f)->private_data))->private)
 
 static const char *const mtrr_strings[MTRR_NUM_TYPES] =
@@ -396,7 +392,7 @@ static int mtrr_seq_show(struct seq_file
 	for (i = 0; i < max; i++) {
 		mtrr_if->get(i, &base, &size, &type);
 		if (size == 0)
-			usage_table[i] = 0;
+			mtrr_usage_table[i] = 0;
 		else {
 			if (size < (0x100000 >> PAGE_SHIFT)) {
 				/* less than 1MB */
@@ -410,7 +406,7 @@ static int mtrr_seq_show(struct seq_file
 			len += seq_printf(seq, 
 				   "reg%02i: base=0x%05lx000 (%4luMB), size=%4lu%cB: %s, count=%d\n",
 			     i, base, base >> (20 - PAGE_SHIFT), size, factor,
-			     mtrr_attrib_to_str(type), usage_table[i]);
+			     mtrr_attrib_to_str(type), mtrr_usage_table[i]);
 		}
 	}
 	return 0;
diff -puN arch/i386/kernel/cpu/mtrr/main.c~i386-x86_64-trim-memory-not-covered-by-wb-mtrrs-fix arch/i386/kernel/cpu/mtrr/main.c
--- a/arch/i386/kernel/cpu/mtrr/main.c~i386-x86_64-trim-memory-not-covered-by-wb-mtrrs-fix
+++ a/arch/i386/kernel/cpu/mtrr/main.c
@@ -47,7 +47,7 @@
 
 u32 num_var_ranges = 0;
 
-unsigned int usage_table[NUM_VAR_RANGES];
+unsigned int mtrr_usage_table[NUM_VAR_RANGES];
 static DEFINE_MUTEX(mtrr_mutex);
 
 u64 size_or_mask, size_and_mask;
@@ -127,7 +127,7 @@ static void __init init_table(void)
 
 	max = num_var_ranges;
 	for (i = 0; i < max; i++)
-		usage_table[i] = 1;
+		mtrr_usage_table[i] = 1;
 }
 
 struct set_mtrr_data {
@@ -381,7 +381,7 @@ int mtrr_add_page(unsigned long base, un
 			goto out;
 		}
 		if (increment)
-			++usage_table[i];
+			++mtrr_usage_table[i];
 		error = i;
 		goto out;
 	}
@@ -390,12 +390,13 @@ int mtrr_add_page(unsigned long base, un
 	if (i >= 0) {
 		set_mtrr(i, base, size, type);
 		if (likely(replace < 0))
-			usage_table[i] = 1;
+			mtrr_usage_table[i] = 1;
 		else {
-			usage_table[i] = usage_table[replace] + !!increment;
+			mtrr_usage_table[i] = mtrr_usage_table[replace] +
+						!!increment;
 			if (unlikely(replace != i)) {
 				set_mtrr(replace, 0, 0, 0);
-				usage_table[replace] = 0;
+				mtrr_usage_table[replace] = 0;
 			}
 		}
 	} else
@@ -525,11 +526,11 @@ int mtrr_del_page(int reg, unsigned long
 		printk(KERN_WARNING "mtrr: MTRR %d not used\n", reg);
 		goto out;
 	}
-	if (usage_table[reg] < 1) {
+	if (mtrr_usage_table[reg] < 1) {
 		printk(KERN_WARNING "mtrr: reg: %d has count=0\n", reg);
 		goto out;
 	}
-	if (--usage_table[reg] < 1)
+	if (--mtrr_usage_table[reg] < 1)
 		set_mtrr(reg, 0, 0, 0);
 	error = reg;
  out:
diff -puN arch/i386/kernel/cpu/mtrr/mtrr.h~i386-x86_64-trim-memory-not-covered-by-wb-mtrrs-fix arch/i386/kernel/cpu/mtrr/mtrr.h
--- a/arch/i386/kernel/cpu/mtrr/mtrr.h~i386-x86_64-trim-memory-not-covered-by-wb-mtrrs-fix
+++ a/arch/i386/kernel/cpu/mtrr/mtrr.h
@@ -97,3 +97,5 @@ void mtrr_state_warn(void);
 const char *mtrr_attrib_to_str(int x);
 void mtrr_wrmsr(unsigned, unsigned, unsigned);
 
+/* RED-PEN: this is accessed without any locking */
+extern unsigned int mtrr_usage_table[];
_

