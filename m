Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbZEKIYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbZEKIYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 04:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbZEKIYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 04:24:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40155 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbZEKIYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 04:24:00 -0400
Date: Mon, 11 May 2009 10:22:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 3/7] x86: fix alloc_mptable
Message-ID: <20090511082258.GC5636@elte.hu>
References: <4A01C35C.7060207@kernel.org> <4A01C3BB.1000609@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A01C3BB.1000609@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> fix the condition checking.
> 
> [ Impact: make alloc_mptable working ]
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/mpparse.c |   15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/mpparse.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/mpparse.c
> +++ linux-2.6/arch/x86/kernel/mpparse.c
> @@ -873,21 +873,24 @@ inline void __init check_irq_src(struct
>  static int check_slot(unsigned long mpc_new_phys, unsigned long mpc_new_length,
>  		      int count)
>  {
> +	int ret = 0;
> +
>  	if (!mpc_new_phys) {
> -		pr_info("No spare slots, try to append...take your risk, "
> +		pr_warning("No spare slots, try to append...take your risk, "
>  			"new mpc_length %x\n", count);
>  	} else {
> -		if (count <= mpc_new_length)
> +		if (count <= mpc_new_length) {
>  			pr_info("No spare slots, try to append..., "
>  				"new mpc_length %x\n", count);
> -		else {
> +			ret = 1;
> +		} else {
>  			pr_err("mpc_new_length %lx is too small\n",
>  				mpc_new_length);
> -			return -1;
> +			ret = -1;
>  		}
>  	}
>  
> -	return 0;
> +	return ret;
>  }
>  
>  static int  __init replace_intsrc_all(struct mpc_table *mpc,
> @@ -946,7 +949,7 @@ static int  __init replace_intsrc_all(st
>  		} else {
>  			struct mpc_intsrc *m = (struct mpc_intsrc *)mpt;
>  			count += sizeof(struct mpc_intsrc);
> -			if (!check_slot(mpc_new_phys, mpc_new_length, count))
> +			if (check_slot(mpc_new_phys, mpc_new_length, count) < 0)
>  				goto out;
>  			assign_to_mpc_intsrc(&mp_irqs[i], m);
>  			mpc->length = count;

hm, i modified this to the code attached below instead. Things like:

> -		pr_info("No spare slots, try to append...take your risk, "
> +		pr_warning("No spare slots, try to append...take your risk, "
>  			"new mpc_length %x\n", count);

are not acceptable at all. If there's _anything_ wrong with code 
like this, if we run out of a static pool of slots, we dont try to 
hack our way out of it... Instead we inform the user and bail out 
ASAP!

A predictable, well working way out of a resource shortage is _way_ 
more important than trying to clinge to some functionality and 
hoping that it will be all fine ...

So ... please describe under which conditions we can run out of 
slots, and what the options are in that situation.

	Ingo

------------------------------>
Subject: x86: fix alloc_mptable()
From: Yinghai Lu <yinghai@kernel.org>
Date: Wed, 06 May 2009 10:07:07 -0700

Fix the conditions when we stop updating the mptable due to
running out of slots.

[ Impact: fix memory corruption / non-working update_mptable boot parameter ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Len Brown <lenb@kernel.org>
LKML-Reference: <4A01C3BB.1000609@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/mpparse.c |   25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

Index: tip/arch/x86/kernel/mpparse.c
===================================================================
--- tip.orig/arch/x86/kernel/mpparse.c
+++ tip/arch/x86/kernel/mpparse.c
@@ -870,24 +870,17 @@ static
 inline void __init check_irq_src(struct mpc_intsrc *m, int *nr_m_spare) {}
 #endif /* CONFIG_X86_IO_APIC */
 
-static int check_slot(unsigned long mpc_new_phys, unsigned long mpc_new_length,
-		      int count)
+static int
+check_slot(unsigned long mpc_new_phys, unsigned long mpc_new_length, int count)
 {
-	if (!mpc_new_phys) {
-		pr_info("No spare slots, try to append...take your risk, "
-			"new mpc_length %x\n", count);
-	} else {
-		if (count <= mpc_new_length)
-			pr_info("No spare slots, try to append..., "
-				"new mpc_length %x\n", count);
-		else {
-			pr_err("mpc_new_length %lx is too small\n",
-				mpc_new_length);
-			return -1;
-		}
+	int ret = 0;
+
+	if (!mpc_new_phys || count <= mpc_new_length) {
+		WARN(1, "update_mptable: No spare slots (length: %x)\n", count);
+		return -1;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int  __init replace_intsrc_all(struct mpc_table *mpc,
@@ -946,7 +939,7 @@ static int  __init replace_intsrc_all(st
 		} else {
 			struct mpc_intsrc *m = (struct mpc_intsrc *)mpt;
 			count += sizeof(struct mpc_intsrc);
-			if (!check_slot(mpc_new_phys, mpc_new_length, count))
+			if (check_slot(mpc_new_phys, mpc_new_length, count) < 0)
 				goto out;
 			assign_to_mpc_intsrc(&mp_irqs[i], m);
 			mpc->length = count;
