Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbZJLJmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbZJLJmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbZJLJmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:42:45 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:50110
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755528AbZJLJmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:42:44 -0400
X-SpamScore: -15
X-BigFish: VPS-15(z21eWzzz1202hzzz32i2a8I6bh2bah61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KREAXS-02-3PC-02
X-M-MSG: 
Date: Mon, 12 Oct 2009 11:41:51 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       stable@kernel.org
Subject: Re: patch
 kvm-svm-fix-tsc-offset-adjustment-when-running-nested.patch added to
 2.6.31-stable tree
Message-ID: <20091012094151.GA32228@amd.com>
References: <20091009223815.20569488DB@coco.kroah.org>
 <200910101540.06686.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <200910101540.06686.s.L-H@gmx.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 12 Oct 2009 09:41:51.0796 (UTC) FILETIME=[3A058F40:01CA4B20]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the nested stuff was moved into its own sub-struct in 2.6.32. Here
is a version that works with 2.6.31.3:

>From 4505a73070f341674e0d22a8c9ee51b2beeb843e Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Mon, 12 Oct 2009 11:19:07 +0200
Subject: [PATCH 1/2] KVM: SVM: Fix tsc offset adjustment when running nested

When svm_vcpu_load is called while the vcpu is running in
guest mode the tsc adjustment made there is lost on the next
emulated #vmexit. This causes the tsc running backwards in
the guest. This patch fixes the issue by also adjusting the
tsc_offset in the emulated hsave area so that it will not
get lost.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b1f658a..aafd8bf 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -709,6 +709,8 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		rdtscll(tsc_this);
 		delta = vcpu->arch.host_tsc - tsc_this;
 		svm->vmcb->control.tsc_offset += delta;
+		if (is_nested(svm))
+			svm->hsave->control.tsc_offset += delta;
 		vcpu->cpu = cpu;
 		kvm_migrate_timers(vcpu);
 		svm->asid_generation = 0;
-- 
1.6.4.3


