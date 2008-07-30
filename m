Return-Path: <linux-kernel-owner+w=401wt.eu-S1761293AbYGaAGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761293AbYGaAGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbYGaAG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:06:28 -0400
Received: from ns2.suse.de ([195.135.220.15]:36015 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758224AbYGaAG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:06:27 -0400
Date: Wed, 30 Jul 2008 16:58:05 -0700
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
       alan@lxorguk.ukuu.org.uk, Joerg Roedel <joerg.roedel@amd.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 09/62] KVM: SVM: fix suspend/resume support
Message-ID: <20080730235805.GI12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-svm-fix-suspend-resume-support.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Joerg Roedel <joerg.roedel@amd.com>

Original-Commit-Hash: ab6267b708bec563891294488f2e854be404bdaf

On suspend the svm_hardware_disable function is called which frees all svm_data
variables. On resume they are not re-allocated. This patch removes the
deallocation of svm_data from the hardware_disable function to the
hardware_unsetup function which is not called on suspend.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 arch/x86/kvm/svm.c |   34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -270,19 +270,11 @@ static int has_svm(void)
 
 static void svm_hardware_disable(void *garbage)
 {
-	struct svm_cpu_data *svm_data
-		= per_cpu(svm_data, raw_smp_processor_id());
-
-	if (svm_data) {
-		uint64_t efer;
+	uint64_t efer;
 
-		wrmsrl(MSR_VM_HSAVE_PA, 0);
-		rdmsrl(MSR_EFER, efer);
-		wrmsrl(MSR_EFER, efer & ~MSR_EFER_SVME_MASK);
-		per_cpu(svm_data, raw_smp_processor_id()) = NULL;
-		__free_page(svm_data->save_area);
-		kfree(svm_data);
-	}
+	wrmsrl(MSR_VM_HSAVE_PA, 0);
+	rdmsrl(MSR_EFER, efer);
+	wrmsrl(MSR_EFER, efer & ~MSR_EFER_SVME_MASK);
 }
 
 static void svm_hardware_enable(void *garbage)
@@ -321,6 +313,19 @@ static void svm_hardware_enable(void *ga
 	       page_to_pfn(svm_data->save_area) << PAGE_SHIFT);
 }
 
+static void svm_cpu_uninit(int cpu)
+{
+	struct svm_cpu_data *svm_data
+		= per_cpu(svm_data, raw_smp_processor_id());
+
+	if (!svm_data)
+		return;
+
+	per_cpu(svm_data, raw_smp_processor_id()) = NULL;
+	__free_page(svm_data->save_area);
+	kfree(svm_data);
+}
+
 static int svm_cpu_init(int cpu)
 {
 	struct svm_cpu_data *svm_data;
@@ -458,6 +463,11 @@ err:
 
 static __exit void svm_hardware_unsetup(void)
 {
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		svm_cpu_uninit(cpu);
+
 	__free_pages(pfn_to_page(iopm_base >> PAGE_SHIFT), IOPM_ALLOC_ORDER);
 	iopm_base = 0;
 }

-- 
