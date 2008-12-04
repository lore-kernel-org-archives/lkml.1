Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbYLDKKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbYLDKKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 05:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbYLDKKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 05:10:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57063 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbYLDKKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 05:10:45 -0500
Date: Thu, 4 Dec 2008 11:10:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jianjun Kong <jianjun@zeuux.org>
Cc: mingo@redhat.com, Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86: fix warning of uninitialized variable
Message-ID: <20081204101023.GA18708@elte.hu>
References: <20081204010013.GA17445@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081204010013.GA17445@ubuntu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jianjun Kong <jianjun@zeuux.org> wrote:

> fix warning of uninitialized 'base' in arch/x86/kernel/scx200_32.c
> 
> arch/x86/kernel/scx200_32.c: In function ‘scx200_probe’:
> arch/x86/kernel/scx200_32.c:82: warning: ‘base’ may be used
> uninitialized in this function
> 
> Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
> ---
>  arch/x86/kernel/scx200_32.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

this patch is wrong, and your analysis-free commit log is wrong as well!

i fixed this a few weeks ago, and GCC pinpointed a _real_ bug - which you 
hacked around instead of fixing. See the real fix below.

	Ingo

---------------------->
>From 6f9fecb3d70400c5f99c1a1d09ffcce84483f611 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 18 Oct 2008 17:37:39 +0200
Subject: [PATCH] fix warning in arch/x86/kernel/scx200_32.c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

fix this warning:

  arch/x86/kernel/scx200_32.c: In function ‘scx200_probe’:
  arch/x86/kernel/scx200_32.c:82: warning: ‘base’ may be used uninitialized in this function

gcc is right: pci_read_config_dword() can fail, and this code did not
handle it.

Add proper error handling.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/scx200_32.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/scx200_32.c b/arch/x86/kernel/scx200_32.c
index 7e004ac..1b6e3d1 100644
--- a/arch/x86/kernel/scx200_32.c
+++ b/arch/x86/kernel/scx200_32.c
@@ -78,8 +78,10 @@ static int __devinit scx200_probe(struct pci_dev *pdev, const struct pci_device_
 		if (scx200_cb_probe(SCx200_CB_BASE_FIXED)) {
 			scx200_cb_base = SCx200_CB_BASE_FIXED;
 		} else {
-			pci_read_config_dword(pdev, SCx200_CBA_SCRATCH, &base);
-			if (scx200_cb_probe(base)) {
+			int err;
+
+			err = pci_read_config_dword(pdev, SCx200_CBA_SCRATCH, &base);
+			if (!err && scx200_cb_probe(base)) {
 				scx200_cb_base = base;
 			} else {
 				printk(KERN_WARNING NAME ": Configuration Block not found\n");

