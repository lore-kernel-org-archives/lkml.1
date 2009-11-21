Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbZKUNBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbZKUNBp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZKUNBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:01:45 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:58754 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbZKUNBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:01:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=cktt5snYGD6EqBWg7XeTLS/3fpOrKV6N+LZGKFiEAWGOYqvhoTFiua4dlrcBqY9zfJ
         FrplLD10gyJ9g/us84Map1XMxzYMKfk3+WLREJQz0Gv/QKl05UZajrBOYg4xAewuZlBH
         OS8/QT+q0lrCbOwV4xejWBWq6CwzasKaKKOhM=
Date: Sat, 21 Nov 2009 14:01:45 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, cpu: mv display_cacheinfo ->
 cpu_detect_cache_sizes
Message-ID: <20091121130145.GA31357@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Rakib Mullick <rakib.mullick@gmail.com>, mingo@redhat.com,
	x86@kernel.org, linux-kernel@vger.kernel.org
References: <1258798699-631-1-git-send-email-petkovbb@gmail.com>
 <b9df5fa10911210405p2a1942abpbfdc7c6a367ab798@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b9df5fa10911210405p2a1942abpbfdc7c6a367ab798@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rakib,

On Sat, Nov 21, 2009 at 06:05:52PM +0600, Rakib Mullick wrote:
> > display_cacheinfo() doesn't display anything anymore and it is solely
> >  used to detect CPU cache sizes for /proc/cpuinfo. Rename it accordingly.
> If it is only displays cache sizes for /proc/cpuinfo, then we need to check
> #ifdef CONFIG_PROC_FS , isn't it?

well, I was grepping for all the places where c->x86_cache_size
and c->x86_tlbsize are being used and have missed the location
arch/x86/kernel/cpu/intel_cacheinfo.c:amd_cpuid4() where
current_cpu_data.x86_cache_size is being read so we can't make it
dependent on PROC_FS.

Sorry for misleading you, here's a corrected version:

--
From: Borislav Petkov <petkovbb@gmail.com>
Date: Wed, 18 Nov 2009 19:01:28 +0100
Subject: [PATCH] x86, cpu: mv display_cacheinfo -> cpu_detect_cache_sizes

display_cacheinfo() doesn't display anything anymore and it is used to
detect CPU cache sizes. Rename it accordingly.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 arch/x86/kernel/cpu/amd.c       |    2 +-
 arch/x86/kernel/cpu/centaur.c   |    2 +-
 arch/x86/kernel/cpu/common.c    |    4 ++--
 arch/x86/kernel/cpu/cpu.h       |    2 +-
 arch/x86/kernel/cpu/cyrix.c     |    2 +-
 arch/x86/kernel/cpu/transmeta.c |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index c910a71..7128b37 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -535,7 +535,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		}
 	}
 
-	display_cacheinfo(c);
+	cpu_detect_cache_sizes(c);
 
 	/* Multi core CPU? */
 	if (c->extended_cpuid_level >= 0x80000008) {
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index c95e831..e58d978 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -294,7 +294,7 @@ static void __cpuinit init_c3(struct cpuinfo_x86 *c)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 	}
 
-	display_cacheinfo(c);
+	cpu_detect_cache_sizes(c);
 }
 
 enum {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 61242a5..9bf845d 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -61,7 +61,7 @@ void __init setup_cpu_local_masks(void)
 static void __cpuinit default_init(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_64
-	display_cacheinfo(c);
+	cpu_detect_cache_sizes(c);
 #else
 	/* Not much we can do here... */
 	/* Check if at least it has cpuid */
@@ -383,7 +383,7 @@ static void __cpuinit get_model_name(struct cpuinfo_x86 *c)
 	}
 }
 
-void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
+void __cpuinit cpu_detect_cache_sizes(struct cpuinfo_x86 *c)
 {
 	unsigned int n, dummy, ebx, ecx, edx, l2size;
 
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 6de9a90..3624e8a 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -32,6 +32,6 @@ struct cpu_dev {
 extern const struct cpu_dev *const __x86_cpu_dev_start[],
 			    *const __x86_cpu_dev_end[];
 
-extern void display_cacheinfo(struct cpuinfo_x86 *c);
+extern void cpu_detect_cache_sizes(struct cpuinfo_x86 *c);
 
 #endif
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index 19807b8..4fbd384 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -373,7 +373,7 @@ static void __cpuinit init_nsc(struct cpuinfo_x86 *c)
 	/* Handle the GX (Formally known as the GX2) */
 
 	if (c->x86 == 5 && c->x86_model == 5)
-		display_cacheinfo(c);
+		cpu_detect_cache_sizes(c);
 	else
 		init_cyrix(c);
 }
diff --git a/arch/x86/kernel/cpu/transmeta.c b/arch/x86/kernel/cpu/transmeta.c
index bb62b3e..2800074 100644
--- a/arch/x86/kernel/cpu/transmeta.c
+++ b/arch/x86/kernel/cpu/transmeta.c
@@ -26,7 +26,7 @@ static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 
 	early_init_transmeta(c);
 
-	display_cacheinfo(c);
+	cpu_detect_cache_sizes(c);
 
 	/* Print CMS and CPU revision */
 	max = cpuid_eax(0x80860000);
-- 
1.6.5

-- 
Regards/Gruss,
    Boris.
