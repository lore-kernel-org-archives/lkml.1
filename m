Return-Path: <linux-kernel-owner+w=401wt.eu-S932968AbXA1XKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968AbXA1XKr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 18:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932960AbXA1XKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 18:10:47 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40983 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932957AbXA1XKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 18:10:46 -0500
Date: Sun, 28 Jan 2007 15:10:39 -0800
From: Andrew Morton <akpm@osdl.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.20-rc6-mm1
Message-Id: <20070128151039.636b3680.akpm@osdl.org>
In-Reply-To: <45BD2424.7020604@googlemail.com>
References: <20070127234928.64d8e437.akpm@osdl.org>
	<45BD2424.7020604@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jan 2007 23:31:00 +0100
Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Jan 28 22:58:29 euridica kernel: BUG: using smp_processor_id() in preemptible [00000001] code: yum-updatesd/2846
> Jan 28 22:58:29 euridica kernel: caller is nf_conntrack_in+0x363/0x47f [nf_conntrack]

I'll plug that with this:


diff -puN include/net/netfilter/nf_conntrack.h~netfilter-warning-fix include/net/netfilter/nf_conntrack.h
--- a/include/net/netfilter/nf_conntrack.h~netfilter-warning-fix
+++ a/include/net/netfilter/nf_conntrack.h
@@ -254,7 +254,12 @@ extern atomic_t nf_conntrack_count;
 extern int nf_conntrack_max;
 
 DECLARE_PER_CPU(struct ip_conntrack_stat, nf_conntrack_stat);
-#define NF_CT_STAT_INC(count) (__get_cpu_var(nf_conntrack_stat).count++)
+#define NF_CT_STAT_INC(count)						\
+	do {								\
+		preempt_disable();					\
+		__get_cpu_var(nf_conntrack_stat).count++;		\
+		preempt_enable();					\
+	} while (0);
 
 /* no helper, no nat */
 #define	NF_CT_F_BASIC	0
_

and will let others worry about what the real fix (for 2.6.20, please) is.
