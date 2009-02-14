Return-Path: <linux-kernel-owner+w=401wt.eu-S1764377AbZBNBry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764377AbZBNBry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762554AbZBNBQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:59 -0500
Received: from kroah.org ([198.145.64.141]:50709 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762741AbZBNBQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:47 -0500
Date: Fri, 13 Feb 2009 17:13:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Andreas Herrmann <andreas.herrmann3@amd.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 47/48] x86: microcode_amd: fix wrong handling of equivalent
	CPU id
Message-ID: <20090214011356.GV17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-microcode_amd-fix-wrong-handling-of-equivalent-cpu-id.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit 3c763fd77e66e55d029052da31df0abd9920cb1e upstream.

Impact: fix bug resulting in non-loaded AMD microcode

mc_header->processor_rev_id is a 2 byte value. Similar is true for
equiv_cpu in an equiv_cpu_entry -- only 2 bytes are of interest.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/microcode_amd.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -62,7 +62,7 @@ struct microcode_header_amd {
 	unsigned int  mc_patch_data_checksum;
 	unsigned int  nb_dev_id;
 	unsigned int  sb_dev_id;
-	unsigned char processor_rev_id[2];
+	u16 processor_rev_id;
 	unsigned char nb_rev_id;
 	unsigned char sb_rev_id;
 	unsigned char bios_api_rev;
@@ -125,7 +125,7 @@ static int get_matching_microcode(int cp
 
 	while (equiv_cpu_table[i].installed_cpu != 0) {
 		if (current_cpu_id == equiv_cpu_table[i].installed_cpu) {
-			equiv_cpu_id = equiv_cpu_table[i].equiv_cpu;
+			equiv_cpu_id = equiv_cpu_table[i].equiv_cpu & 0xffff;
 			break;
 		}
 		i++;
@@ -137,21 +137,10 @@ static int get_matching_microcode(int cp
 		return 0;
 	}
 
-	if ((mc_header->processor_rev_id[0]) != (equiv_cpu_id & 0xff)) {
-		printk(KERN_ERR
-			"microcode: CPU%d patch does not match "
-			"(patch is %x, cpu extended is %x) \n",
-			cpu, mc_header->processor_rev_id[0],
-			(equiv_cpu_id & 0xff));
-		return 0;
-	}
-
-	if ((mc_header->processor_rev_id[1]) != ((equiv_cpu_id >> 16) & 0xff)) {
-		printk(KERN_ERR "microcode: CPU%d patch does not match "
-			"(patch is %x, cpu base id is %x) \n",
-			cpu, mc_header->processor_rev_id[1],
-			((equiv_cpu_id >> 16) & 0xff));
-
+	if (mc_header->processor_rev_id != equiv_cpu_id) {
+		printk(KERN_ERR	"microcode: CPU%d patch does not match "
+		       "(processor_rev_id: %x, eqiv_cpu_id: %x)\n",
+		       cpu, mc_header->processor_rev_id, equiv_cpu_id);
 		return 0;
 	}
 

