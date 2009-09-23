Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbZIWAvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbZIWAvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 20:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbZIWAvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 20:51:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753595AbZIWAvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 20:51:23 -0400
Date: Tue, 22 Sep 2009 17:50:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH] kmemcheck: clean up kmemcheck_annotate_bitfield
Message-Id: <20090922175008.422945e5.akpm@linux-foundation.org>
In-Reply-To: <20090923001301.3ED5922@magilla.sf.frob.com>
References: <20090923001301.3ED5922@magilla.sf.frob.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009 17:13:01 -0700 (PDT) Roland McGrath <roland@redhat.com> wrote:

> The commit 181f7c5dd3832763bdf2756b6d2d8a49bdf12791 change traded a
> style warning from sparse for a syntax warning from the real compiler
> (and perhaps an error with compilers old enough).  The use of a local
> variable inside BUILD_BUG_ON() is pretty questionable too, though it
> works with the compiler's constant-folding in practice.
> 
> This change cleans it all up a little more sanely.
> The details are self-explanatory.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> CC: Johannes Berg <johannes@sipsolutions.net>
> CC: Vegard Nossum <vegard.nossum@gmail.com>
> ---
>  include/linux/kmemcheck.h |   14 ++++++--------
>  1 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/kmemcheck.h b/include/linux/kmemcheck.h
> index c800660..9e2c5f4 100644
> --- a/include/linux/kmemcheck.h
> +++ b/include/linux/kmemcheck.h
> @@ -143,16 +143,14 @@ static inline bool kmemcheck_is_obj_initialized(unsigned long addr, size_t size)
>  #define kmemcheck_bitfield_end(name)	\
>  	int name##_end[0];
>  
> +#define kmemcheck_bitfield_stretch(ptr, name)	\
> +	((long) &(ptr)->name##_end - (long) &(ptr)->name##_begin)
> +
>  #define kmemcheck_annotate_bitfield(ptr, name)				\
>  	do {								\
> -		if (!ptr)						\
> -			break;						\
> -									\
> -		int _n = (long) &((ptr)->name##_end)			\
> -			- (long) &((ptr)->name##_begin);		\
> -		BUILD_BUG_ON(_n < 0);					\
> -									\
> -		kmemcheck_mark_initialized(&((ptr)->name##_begin), _n);	\
> +		BUILD_BUG_ON(kmemcheck_bitfield_stretch(ptr, name) < 0);\
> +		kmemcheck_mark_initialized(&(ptr)->name##_begin,	\
> +			kmemcheck_bitfield_stretch(ptr, name));		\
>  	} while (0)
>  
>  #define kmemcheck_annotate_variable(var)				\

I just sent Linus the simple version:

--- a/include/linux/kmemcheck.h~include-linux-kmemcheckh-fix-a-trillion-warnings
+++ a/include/linux/kmemcheck.h
@@ -145,10 +145,12 @@ static inline bool kmemcheck_is_obj_init
 
 #define kmemcheck_annotate_bitfield(ptr, name)				\
 	do {								\
+		int _n;							\
+									\
 		if (!ptr)						\
 			break;						\
 									\
-		int _n = (long) &((ptr)->name##_end)			\
+		_n = (long) &((ptr)->name##_end)			\
 			- (long) &((ptr)->name##_begin);		\
 		BUILD_BUG_ON(_n < 0);					\
 									\
_

That BUILD_BUG_ON() is just wrong, but nobody knew that because the
present version of BUILD_BUG_ON() silently does nothing if passed an
expression which isn't a compile-time constant.  This was all fixed in
the just-sent
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it.patch:


From: "Jan Beulich" <JBeulich@novell.com>

gcc permitting variable length arrays makes the current construct used for
BUILD_BUG_ON() useless, as that doesn't produce any diagnostic if the
controlling expression isn't really constant.  Instead, this patch makes
it so that a bit field gets used here.  Consequently, those uses where the
condition isn't really constant now also need fixing.

Note that in the gfp.h, kmemcheck.h, and virtio_config.h cases
MAYBE_BUILD_BUG_ON() really just serves documentation purposes - even if
the expression is compile time constant (__builtin_constant_p() yields
true), the array is still deemed of variable length by gcc, and hence the
whole expression doesn't have the intended effect.

[akpm@linux-foundation.org: make arch/sparc/include/asm/vio.h compile]
[akpm@linux-foundation.org: more nonsensical assertions in tpm.c..]
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@us.ibm.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/vio.h  |    2 +-
 drivers/char/tpm/tpm.c        |    4 ++--
 drivers/net/niu.c             |    2 +-
 include/linux/gfp.h           |    2 +-
 include/linux/kernel.h        |    8 ++++++--
 include/linux/kmemcheck.h     |    2 +-
 include/linux/virtio_config.h |    3 +--
 7 files changed, 13 insertions(+), 10 deletions(-)

diff -puN arch/sparc/include/asm/vio.h~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it arch/sparc/include/asm/vio.h
--- a/arch/sparc/include/asm/vio.h~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it
+++ a/arch/sparc/include/asm/vio.h
@@ -258,7 +258,7 @@ static inline void *vio_dring_entry(stru
 static inline u32 vio_dring_avail(struct vio_dring_state *dr,
 				  unsigned int ring_size)
 {
-	BUILD_BUG_ON(!is_power_of_2(ring_size));
+	MAYBE_BUILD_BUG_ON(!is_power_of_2(ring_size));
 
 	return (dr->pending -
 		((dr->prod - dr->cons) & (ring_size - 1)));
diff -puN drivers/char/tpm/tpm.c~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it
+++ a/drivers/char/tpm/tpm.c
@@ -696,7 +696,7 @@ int __tpm_pcr_read(struct tpm_chip *chip
 
 	cmd.header.in = pcrread_header;
 	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
-	BUILD_BUG_ON(cmd.header.in.length > READ_PCR_RESULT_SIZE);
+	BUG_ON(cmd.header.in.length > READ_PCR_RESULT_SIZE);
 	rc = transmit_cmd(chip, &cmd, cmd.header.in.length,
 			  "attempting to read a pcr value");
 
@@ -760,7 +760,7 @@ int tpm_pcr_extend(u32 chip_num, int pcr
 		return -ENODEV;
 
 	cmd.header.in = pcrextend_header;
-	BUILD_BUG_ON(be32_to_cpu(cmd.header.in.length) > EXTEND_PCR_SIZE);
+	BUG_ON(be32_to_cpu(cmd.header.in.length) > EXTEND_PCR_SIZE);
 	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
 	memcpy(cmd.params.pcrextend_in.hash, hash, TPM_DIGEST_SIZE);
 	rc = transmit_cmd(chip, &cmd, cmd.header.in.length,
diff -puN drivers/net/niu.c~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it drivers/net/niu.c
--- a/drivers/net/niu.c~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it
+++ a/drivers/net/niu.c
@@ -5615,7 +5615,7 @@ static void niu_init_tx_mac(struct niu *
 	/* The XMAC_MIN register only accepts values for TX min which
 	 * have the low 3 bits cleared.
 	 */
-	BUILD_BUG_ON(min & 0x7);
+	BUG_ON(min & 0x7);
 
 	if (np->flags & NIU_FLAGS_XMAC)
 		niu_init_tx_xmac(np, min, max);
diff -puN include/linux/gfp.h~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it include/linux/gfp.h
--- a/include/linux/gfp.h~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it
+++ a/include/linux/gfp.h
@@ -220,7 +220,7 @@ static inline enum zone_type gfp_zone(gf
 					 ((1 << ZONES_SHIFT) - 1);
 
 	if (__builtin_constant_p(bit))
-		BUILD_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
+		MAYBE_BUILD_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
 	else {
 #ifdef CONFIG_DEBUG_VM
 		BUG_ON((GFP_ZONE_BAD >> bit) & 1);
diff -puN include/linux/kernel.h~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it include/linux/kernel.h
--- a/include/linux/kernel.h~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it
+++ a/include/linux/kernel.h
@@ -678,13 +678,17 @@ struct sysinfo {
 };
 
 /* Force a compilation error if condition is true */
-#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
+#define BUILD_BUG_ON(condition) ((void)BUILD_BUG_ON_ZERO(condition))
+
+/* Force a compilation error if condition is constant and true */
+#define MAYBE_BUILD_BUG_ON(cond) ((void)sizeof(char[1 - 2 * !!(cond)]))
 
 /* Force a compilation error if condition is true, but also produce a
    result (of value 0 and type size_t), so the expression can be used
    e.g. in a structure initializer (or where-ever else comma expressions
    aren't permitted). */
-#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
+#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
+#define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
 
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)
diff -puN include/linux/kmemcheck.h~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it include/linux/kmemcheck.h
--- a/include/linux/kmemcheck.h~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it
+++ a/include/linux/kmemcheck.h
@@ -152,7 +152,7 @@ static inline bool kmemcheck_is_obj_init
 									\
 		_n = (long) &((ptr)->name##_end)			\
 			- (long) &((ptr)->name##_begin);		\
-		BUILD_BUG_ON(_n < 0);					\
+		MAYBE_BUILD_BUG_ON(_n < 0);				\
 									\
 		kmemcheck_mark_initialized(&((ptr)->name##_begin), _n);	\
 	} while (0)
diff -puN include/linux/virtio_config.h~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it include/linux/virtio_config.h
--- a/include/linux/virtio_config.h~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it
+++ a/include/linux/virtio_config.h
@@ -109,8 +109,7 @@ static inline bool virtio_has_feature(co
 				      unsigned int fbit)
 {
 	/* Did you forget to fix assumptions on max features? */
-	if (__builtin_constant_p(fbit))
-		BUILD_BUG_ON(fbit >= 32);
+	MAYBE_BUILD_BUG_ON(fbit >= 32);
 
 	if (fbit < VIRTIO_TRANSPORT_F_START)
 		virtio_check_driver_offered_feature(vdev, fbit);
_

