Return-Path: <linux-kernel-owner+w=401wt.eu-S1764089AbZEAT5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764089AbZEAT5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 15:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762349AbZEAT4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 15:56:43 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:59879 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764940AbZEAT4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 15:56:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=BCI7l3+5aT1tV+JrGUM33MDAACHcA/9D/yVKAe8WxeuClxJS5iZXVbxgFuh3n6BmmY
         KwYIsH9WlbzQrFAoo4yGtzdU6jcertaXIt+Ufktk0v9z/8lDrcXmpt8df2AagTSL+nQy
         V1Raax8dmTcIJCJbYvL803L6pkCwuRchRDFko=
Date: Fri, 1 May 2009 23:56:38 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Jack Steiner <steiner@sgi.com>
Subject: [PATCH -tip] x86: uv - prevent NULL dereference in uv_system_init
Message-ID: <20090501195638.GC4633@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We may reach NULL dereference oops if kmalloc failed.
Lets do panic better with sensible message.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Actually there is a dubious place as well at early_get_nodeid.
Is there a guarantee that we _never_ fail in early_ioremap?

 arch/x86/kernel/apic/x2apic_uv_x.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6.git/arch/x86/kernel/apic/x2apic_uv_x.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux-2.6.git/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -584,15 +584,21 @@ void __init uv_system_init(void)
 
 	bytes = sizeof(struct uv_blade_info) * uv_num_possible_blades();
 	uv_blade_info = kmalloc(bytes, GFP_KERNEL);
+	if (!uv_blade_info)
+		goto err_nomem;
 
 	get_lowmem_redirect(&lowmem_redir_base, &lowmem_redir_size);
 
 	bytes = sizeof(uv_node_to_blade[0]) * num_possible_nodes();
 	uv_node_to_blade = kmalloc(bytes, GFP_KERNEL);
+	if (!uv_node_to_blade)
+		goto err_nomem;
 	memset(uv_node_to_blade, 255, bytes);
 
 	bytes = sizeof(uv_cpu_to_blade[0]) * num_possible_cpus();
 	uv_cpu_to_blade = kmalloc(bytes, GFP_KERNEL);
+	if (!uv_cpu_to_blade)
+		goto err_nomem;
 	memset(uv_cpu_to_blade, 255, bytes);
 
 	blade = 0;
@@ -667,4 +673,7 @@ void __init uv_system_init(void)
 	uv_cpu_init();
 	uv_scir_register_cpu_notifier();
 	proc_mkdir("sgi_uv", NULL);
+
+err_nomem:
+	panic("UV: Out of memory\n");
 }
