Return-Path: <linux-kernel-owner+w=401wt.eu-S1760741AbYGaAJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741AbYGaAJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760660AbYGaAI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:08:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36259 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761434AbYGaAI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:08:28 -0400
Date: Wed, 30 Jul 2008 16:58:17 -0700
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
       alan@lxorguk.ukuu.org.uk, Avi Kivity <avi@qumranet.com>
Subject: [patch 14/62] KVM: MMU: Fix potential race setting upper shadow
	ptes on nonpae hosts
Message-ID: <20080730235817.GN12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-mmu-fix-potential-race-setting-upper-shadow-ptes-on-nonpae-hosts.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Avi Kivity <avi@qumranet.com>

Original-Commit-Hash: c23a6fe17abf8562e675465f8d55ba1a551d314d

The direct mapped shadow code (used for real mode and two dimensional paging)
sets upper-level ptes using direct assignment rather than calling
set_shadow_pte().  A nonpae host will split this into two writes, which opens
up a race if another vcpu accesses the same memory area.

Fix by calling set_shadow_pte() instead of assigning directly.

Noticed by Izik Eidus.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 arch/x86/kvm/mmu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1171,9 +1171,10 @@ static int __direct_map(struct kvm_vcpu 
 				return -ENOMEM;
 			}
 
-			table[index] = __pa(new_table->spt)
-				| PT_PRESENT_MASK | PT_WRITABLE_MASK
-				| shadow_user_mask | shadow_x_mask;
+			set_shadow_pte(&table[index],
+				       __pa(new_table->spt)
+				       | PT_PRESENT_MASK | PT_WRITABLE_MASK
+				       | shadow_user_mask | shadow_x_mask);
 		}
 		table_addr = table[index] & PT64_BASE_ADDR_MASK;
 	}

-- 
