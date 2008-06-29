Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbYF2S3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbYF2S3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 14:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbYF2S3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 14:29:04 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:42087 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540AbYF2S3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 14:29:01 -0400
Date: Sun, 29 Jun 2008 20:28:28 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Roedel, Joerg" <Joerg.Roedel@amd.com>
Subject: [PATCH] Re: kvm: unable to handle kernel NULL pointer dereference
Message-ID: <20080629182828.GA2575@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Roedel, Joerg" <Joerg.Roedel@amd.com>
References: <20080601084802.GA3146@yamamaya.is-a-geek.org> <4846716E.5000506@qumranet.com> <20080604181019.GB10897@yamamaya.is-a-geek.org> <20080605042535.GC30402@sequoia.sous-sol.org> <20080605060931.GA11704@yamamaya.is-a-geek.org> <20080605072728.GF30402@sequoia.sous-sol.org> <20080605182847.GA12176@yamamaya.is-a-geek.org> <20080605183447.GL30402@sequoia.sous-sol.org> <20080629180203.GA9356@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080629180203.GA9356@yamamaya.is-a-geek.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich wrote:
> Chris Wright wrote:
> > * Tobias Diedrich (ranma+kernel@tdiedrich.de) wrote:
> > > PM: Creating hibernation image: 
> > > PM: Need to copy 126181 pages
> > > PM: Normal pages needed: 126181 + 1024 + 38, available pages: 397721
> > > x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> > > svm_cpu_init: svm_data is NULL on 0
> > 
> > Yeah, this is broken.  What happens is:
> > 
> > suspend:
> >   hardware_disable
> >     svm_hardware_disable
> >       kfree(svm_data)
> >       per_cpu(svm_data) = NULL
> > 
> > resume:
> >   hardware_enable
> >     svm_hardware_enable
> >       if(!svm_data) printk("svm_cpu_init: svm_data is NULL on 0")
> > 
> > at this point it is broken.
> > 
> > Same would happen on an SMP box by simply doing offline/online of a CPU.
> > This is definitely busted, looking into a patch.
> 
> Any progress on this?

FWIW, it's still broken on 2.6.26-rc8, but the following patch works
for me (tm):

Index: linux-2.6.26-rc8.forcedwol/arch/x86/kvm/svm.c
===================================================================
--- linux-2.6.26-rc8.forcedwol.orig/arch/x86/kvm/svm.c	2008-06-29 20:04:20.000000000 +0200
+++ linux-2.6.26-rc8.forcedwol/arch/x86/kvm/svm.c	2008-06-29 20:12:15.000000000 +0200
@@ -268,6 +268,30 @@
 	return 1;
 }
 
+static int svm_cpu_init(int cpu)
+{
+	struct svm_cpu_data *svm_data;
+	int r;
+
+	svm_data = kzalloc(sizeof(struct svm_cpu_data), GFP_KERNEL);
+	if (!svm_data)
+		return -ENOMEM;
+	svm_data->cpu = cpu;
+	svm_data->save_area = alloc_page(GFP_KERNEL);
+	r = -ENOMEM;
+	if (!svm_data->save_area)
+		goto err_1;
+
+	per_cpu(svm_data, cpu) = svm_data;
+
+	return 0;
+
+err_1:
+	kfree(svm_data);
+	return r;
+
+}
+
 static void svm_hardware_disable(void *garbage)
 {
 	struct svm_cpu_data *svm_data
@@ -293,11 +317,17 @@
 	struct desc_ptr gdt_descr;
 	struct desc_struct *gdt;
 	int me = raw_smp_processor_id();
+	int ret;
 
 	if (!has_svm()) {
-		printk(KERN_ERR "svm_cpu_init: err EOPNOTSUPP on %d\n", me);
+		printk(KERN_ERR "svm_hardware_enable: err EOPNOTSUPP on %d\n", me);
+		return;
+	}
+	if ((ret = svm_cpu_init(me)) != 0) {
+		printk(KERN_ERR "svm_hardware_enable: svm_cpu_init failed on %d with status: %d\n", me, ret);
 		return;
 	}
+
 	svm_data = per_cpu(svm_data, me);
 
 	if (!svm_data) {
@@ -321,30 +351,6 @@
 	       page_to_pfn(svm_data->save_area) << PAGE_SHIFT);
 }
 
-static int svm_cpu_init(int cpu)
-{
-	struct svm_cpu_data *svm_data;
-	int r;
-
-	svm_data = kzalloc(sizeof(struct svm_cpu_data), GFP_KERNEL);
-	if (!svm_data)
-		return -ENOMEM;
-	svm_data->cpu = cpu;
-	svm_data->save_area = alloc_page(GFP_KERNEL);
-	r = -ENOMEM;
-	if (!svm_data->save_area)
-		goto err_1;
-
-	per_cpu(svm_data, cpu) = svm_data;
-
-	return 0;
-
-err_1:
-	kfree(svm_data);
-	return r;
-
-}
-
 static void set_msr_interception(u32 *msrpm, unsigned msr,
 				 int read, int write)
 {

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
