Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbZCDGOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbZCDGOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 01:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbZCDGOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 01:14:42 -0500
Received: from mail.gmx.net ([213.165.64.20]:49923 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751491AbZCDGOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 01:14:42 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/9oWphBXP9bVmopuNRdm8wZn6xq0IztvK8+3QB0Q
	tJpI1a+IKHIwFa
Subject: Re: x86-tip: cpufreq breakage - bisection
	fingers	89c9215165ca609096e845926d9a18f1306176a4
From: Mike Galbraith <efault@gmx.de>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1236138205.6119.12.camel@marge.simson.net>
References: <1236085632.5958.8.camel@marge.simson.net>
	 <20090303143106.GA12248@elte.hu> <1236098338.5926.0.camel@marge.simson.net>
	 <49ADE077.1060606@kernel.org>  <1236138205.6119.12.camel@marge.simson.net>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 07:14:37 +0100
Message-Id: <1236147277.6049.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 04:43 +0100, Mike Galbraith wrote:
> On Wed, 2009-03-04 at 10:59 +0900, Tejun Heo wrote:
> 
> > I can't reproduce the problem here.
> 
> Guess I'll have to sharpen a stick or two then.

With monkey-see-monkey-do-stick, box becomes happy camper again.

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index c29f301..bc9972a 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -256,6 +256,11 @@ static struct page * __init pcpue_get_page(unsigned int cpu, int pageno)
 			    + ((size_t)pageno << PAGE_SHIFT));
 }
 
+static void __init embed_populate_pte(unsigned long addr)
+{
+	populate_extra_pte(addr);
+}
+
 static ssize_t __init setup_pcpu_embed(size_t static_size)
 {
 	unsigned int cpu;
@@ -284,10 +289,15 @@ static ssize_t __init setup_pcpu_embed(size_t static_size)
 	pr_info("PERCPU: Embedded %zu pages at %p, static data %zu bytes\n",
 		pcpue_unit_size >> PAGE_SHIFT, pcpue_ptr, static_size);
 
+#if 0
 	return pcpu_setup_first_chunk(pcpue_get_page, static_size,
 				      pcpue_unit_size,
 				      pcpue_unit_size - static_size, pcpue_ptr,
 				      NULL);
+#else
+	return pcpu_setup_first_chunk(pcpue_get_page, static_size,
+				      0, 0, NULL, embed_populate_pte);
+#endif
 }
 
 /*


