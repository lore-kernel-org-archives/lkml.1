Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbZFGFTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbZFGFTd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 01:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZFGFTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 01:19:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:8094 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZFGFTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 01:19:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=dzL/MvAYyURvHU/ZKVqvV8XtVIBQGBfz+FoYgY9rjonv4RSjs6ABHaRswR+mfdDOPZ
         a+1DkdesEAS+IpUfNF9NKnbLMLoC+pKCDftEF36LGlwHbsT+VL2eGXA6xC9uQKfl+yTZ
         N72UWcvaC9Z3YjGtPJbnQDUwNHE+mMrCE1TMU=
Subject: [PATCH]X86:microcode: fix vfree()
From: "Figo.zhang" <figo1802@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@osdl.org>, Tigran Aivazian <tigran@veritas.com>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 13:18:48 +0800
Message-Id: <1244351929.3355.13.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
vfree() does it's own 'NULL' check,so no need for check before
calling it.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
---  
arch/x86/kernel/microcode_amd.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 453b579..fe577fd 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -257,10 +257,9 @@ static int install_equiv_cpu_table(const u8 *buf)
 
 static void free_equiv_cpu_table(void)
 {
-	if (equiv_cpu_table) {
-		vfree(equiv_cpu_table);
-		equiv_cpu_table = NULL;
-	}
+	vfree(equiv_cpu_table);
+	equiv_cpu_table = NULL;
+	
 }
 
 static int generic_load_microcode(int cpu, const u8 *data, size_t size)
@@ -293,8 +292,7 @@ static int generic_load_microcode(int cpu, const u8 *data, size_t size)
 
 		mc_header = (struct microcode_header_amd *)mc;
 		if (get_matching_microcode(cpu, mc, new_rev)) {
-			if (new_mc)
-				vfree(new_mc);
+			vfree(new_mc);
 			new_rev = mc_header->patch_id;
 			new_mc  = mc;
 		} else
@@ -306,8 +304,7 @@ static int generic_load_microcode(int cpu, const u8 *data, size_t size)
 
 	if (new_mc) {
 		if (!leftover) {
-			if (uci->mc)
-				vfree(uci->mc);
+			vfree(uci->mc);
 			uci->mc = new_mc;
 			pr_debug("microcode: CPU%d found a matching microcode "
 				 "update with version 0x%x (current=0x%x)\n",


