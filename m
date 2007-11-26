Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbXKZS7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbXKZS7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 13:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbXKZS7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 13:59:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550AbXKZS7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 13:59:06 -0500
Date: Mon, 26 Nov 2007 13:58:43 -0500
From: Dave Jones <davej@redhat.com>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Michael Buesch <mb@bu3sch.de>,
       folkert van Heusden <folkert@vanheusden.com>
Subject: Re: enable dual rng on VIA C7
Message-ID: <20071126185843.GD15764@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Udo van den Heuvel <udovdh@xs4all.nl>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	folkert van Heusden <folkert@vanheusden.com>
References: <47374EA4.1060009@xs4all.nl> <20071125233949.f64b2ecd.akpm@linux-foundation.org> <474AFC2F.1040309@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474AFC2F.1040309@xs4all.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 06:02:39PM +0100, Udo van den Heuvel wrote:

 > I did not know we are already that far ;-)
 > I mean: can this patch be aplied without hurting C3/C7 CPU's with just
 > one RNG? Maybe an expert needs to test/answer?
 > Maybe some logic needs to be applied around the extra bit?
 
>From the padlock spec..

"SRC Bits[9:8] Noise source select (I): These bits control the two noise
 sources on the processor that input bits to the accumulation buffers.
 On Nehemiah processors prior to stepping 8, these bits are reserved
 and undefined. The default RESET state is both bits = 0." 

Something like this perhaps ?

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/char/hw_random/via-rng.c b/drivers/char/hw_random/via-rng.c
index ec435cb..95aac0f 100644
--- a/drivers/char/hw_random/via-rng.c
+++ b/drivers/char/hw_random/via-rng.c
@@ -41,6 +41,8 @@ enum {
 	VIA_STRFILT_ENABLE	= (1 << 14),
 	VIA_RAWBITS_ENABLE	= (1 << 13),
 	VIA_RNG_ENABLE		= (1 << 6),
+	VIA_NOISESRC1		= (1 << 8),
+	VIA_NOISESRC2		= (1 << 9),
 	VIA_XSTORE_CNT_MASK	= 0x0F,
 
 	VIA_RNG_CHUNK_8		= 0x00,	/* 64 rand bits, 64 stored bits */
@@ -114,6 +116,7 @@ static int via_rng_data_read(struct hwrng *rng, u32 *data)
 
 static int via_rng_init(struct hwrng *rng)
 {
+	struct cpuinfo_x86 *c = &cpu_data(0);
 	u32 lo, hi, old_lo;
 
 	/* Control the RNG via MSR.  Tread lightly and pay very close
@@ -129,6 +132,17 @@ static int via_rng_init(struct hwrng *rng)
 	lo &= ~VIA_XSTORE_CNT_MASK;
 	lo &= ~(VIA_STRFILT_ENABLE | VIA_STRFILT_FAIL | VIA_RAWBITS_ENABLE);
 	lo |= VIA_RNG_ENABLE;
+	lo |= VIA_NOISESRC1;
+
+	/* Enable secondary noise source on CPUs where it is present. */
+
+	/* Nehemiah stepping 8 and higher */
+	if ((c->x86_model == 9) && (c->x86_mask > 7))
+		lo |= VIA_NOISESRC2;
+
+	/* Esther */
+	if (c->x86_model >= 10)
+		lo |= VIA_NOISESRC2;
 
 	if (lo != old_lo)
 		wrmsr(MSR_VIA_RNG, lo, hi);
-- 
http://www.codemonkey.org.uk
