Return-Path: <linux-kernel-owner+w=401wt.eu-S1757686AbZBSQeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbZBSQeq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 11:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756850AbZBSQee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 11:34:34 -0500
Received: from mail.klingt.org ([86.59.21.178]:52143 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756767AbZBSQee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 11:34:34 -0500
Date: Thu, 19 Feb 2009 17:34:03 +0100
From: Tim Blechmann <tim@klingt.org>
To: oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org
Cc: Robert Richter <robert.richter@amd.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] oprofile: don't set counter width from cpuid on core2
Message-ID: <20090219173403.49871cac@thinkpad>
In-Reply-To: <20090216114010.GG25042@erda.amd.com>
References: <20090216114010.GG25042@erda.amd.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.1.8 (klingt.org [127.0.0.1]); Thu, 19 Feb 2009 17:34:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n1JGZBwM013219

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

resetting the counter width of the performance counters on intel's
core2, breaks the delivery of NMIs, when running in x86_64 mode.

this should fix bug #12395:
http://bugzilla.kernel.org/show_bug.cgi?id=12395

Signed-off-by: Tim Blechmann <tim@klingt.org>
- ---
 arch/x86/oprofile/op_model_ppro.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index e9f80c7..ecba9f2 100644
- --- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -78,10 +78,18 @@ static void ppro_setup_ctrs(struct op_msrs const * const msrs)
 	if (cpu_has_arch_perfmon) {
 		union cpuid10_eax eax;
 		eax.full = cpuid_eax(0xa);
+
+		/* For core2 (family 6, model 15), don't reset the counter width */
+		if (eax.split.version_id == 0 && current_cpu_data.x86 == 6 &&
+		      current_cpu_data.x86_model == 15)
+			goto clear_all_counters;
+
 		if (counter_width < eax.split.bit_width)
 			counter_width = eax.split.bit_width;
 	}
 
+clear_all_counters:
+
 	/* clear all counters */
 	for (i = 0 ; i < num_counters; ++i) {
 		if (unlikely(!CTRL_IS_RESERVED(msrs, i)))
- -- 
1.6.1.2
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmdifsACgkQdL+4qsZfVsu7uwCffznCNF7PKtaRw0Z28qy6PtO1
DP8AnjkSBNLvKGdG8ac90ayoO2L7GRjW
=xYgd
-----END PGP SIGNATURE-----
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
