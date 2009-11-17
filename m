Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbZKQHGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbZKQHGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 02:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbZKQHGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 02:06:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:38631 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbZKQHGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 02:06:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FCHPYbZicVVDO7OoTaJNzrJtLhR/1Dbn8P184d8sjYQgg1jLLUJJnbLa0UuAZS+Dra
         FGVGK3MtuKaYWRuUM9ZG9Y13wz9f5jhvVvGkqr7RoE2mlt33TvQjOPbi95z41Z9xG5eL
         fQzjx+CkxcsCAqnjU5PA7SrRi45/fDjzhvkxo=
Date: Tue, 17 Nov 2009 08:06:38 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Travis <travis@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Borislav Petkov <borislav.petkov@amd.com>, Andreas Mohr <andi@lisas.de>,
       Jack Steiner <steiner@sgi.com>
Subject: [PATCH] x86, ucode-amd: Move family check to microcde_amd.c's init
 function
Message-ID: <20091117070638.GA27691@alberich.amd.com>
References: <1257192496.5941.8.camel@dimm>
 <20091105153742.GA18592@alberich.amd.com>
 <b647ffbd0911051040r3987f63es1279c87bf349bcf6@mail.gmail.com>
 <20091106123403.GB18592@alberich.amd.com>
 <b647ffbd0911060456x5c37ebfapdb2ece392428f66@mail.gmail.com>
 <20091106194626.GC18592@alberich.amd.com>
 <b647ffbd0911070422g154c63bbo2fec62ba63c3c106@mail.gmail.com>
 <b647ffbd0911110807n17933102g39c124a6eff74a44@mail.gmail.com>
 <20091111193832.GG18592@alberich.amd.com>
 <20091112113343.GA1386@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112113343.GA1386@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... to avoid useless trial to load firmware on systems with
unsupported AMD CPUs.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/microcode_amd.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

Patch is against tip/master.

Regards,
Andreas


diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 26e33bd..d0bb5ad 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -34,6 +34,7 @@ MODULE_LICENSE("GPL v2");
 #define UCODE_UCODE_TYPE           0x00000001
 
 const struct firmware *firmware;
+static int supported_cpu;
 
 struct equiv_cpu_entry {
 	u32	installed_cpu;
@@ -73,15 +74,12 @@ static struct equiv_cpu_entry *equiv_cpu_table;
 
 static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 {
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	u32 dummy;
 
-	memset(csig, 0, sizeof(*csig));
-	if (c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10) {
-		pr_warning("microcode: CPU%d: AMD CPU family 0x%x not "
-			   "supported\n", cpu, c->x86);
+	if (!supported_cpu)
 		return -1;
-	}
+
+	memset(csig, 0, sizeof(*csig));
 	rdmsr(MSR_AMD64_PATCH_LEVEL, csig->rev, dummy);
 	pr_info("microcode: CPU%d: patch_level=0x%x\n", cpu, csig->rev);
 	return 0;
@@ -331,6 +329,17 @@ static void microcode_fini_cpu_amd(int cpu)
 void init_microcode_amd(struct device *device)
 {
 	const char *fw_name = "amd-ucode/microcode_amd.bin";
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+
+	BUG_ON(c->x86_vendor != X86_VENDOR_AMD);
+
+	if (c->x86 < 0x10) {
+		pr_warning("microcode: AMD CPU family 0x%x not supported\n",
+			   c->x86);
+		return;
+	}
+	supported_cpu = 1;
+
 	if (request_firmware(&firmware, fw_name, device))
 		pr_err("microcode: failed to load file %s\n", fw_name);
 }
-- 
1.6.5.2

