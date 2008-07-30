Return-Path: <linux-kernel-owner+w=401wt.eu-S1760887AbYGaAHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887AbYGaAHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbYGaAGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:06:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36064 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912AbYGaAGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:06:53 -0400
Date: Wed, 30 Jul 2008 16:58:07 -0700
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
       alan@lxorguk.ukuu.org.uk, Marcelo Tosatti <mtosatti@redhat.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 10/62] KVM: mmu_shrink: kvm_mmu_zap_page requires
	slots_lock to be held
Message-ID: <20080730235807.GJ12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-mmu_shrink-kvm_mmu_zap_page-requires-slots_lock-to-be-held.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Marcelo Tosatti <mtosatti@redhat.com>

Original-Commit-Hash: 64f6a0c041bd8fc100a0d655058bdbc31feda03c

kvm_mmu_zap_page() needs slots lock held (rmap_remove->gfn_to_memslot,
for example).

Since kvm_lock spinlock is held in mmu_shrink(), do a non-blocking
down_read_trylock().

Untested.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/mmu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1968,6 +1968,8 @@ static int mmu_shrink(int nr_to_scan, gf
 	list_for_each_entry(kvm, &vm_list, vm_list) {
 		int npages;
 
+		if (!down_read_trylock(&kvm->slots_lock))
+			continue;
 		spin_lock(&kvm->mmu_lock);
 		npages = kvm->arch.n_alloc_mmu_pages -
 			 kvm->arch.n_free_mmu_pages;
@@ -1980,6 +1982,7 @@ static int mmu_shrink(int nr_to_scan, gf
 		nr_to_scan--;
 
 		spin_unlock(&kvm->mmu_lock);
+		up_read(&kvm->slots_lock);
 	}
 	if (kvm_freed)
 		list_move_tail(&kvm_freed->vm_list, &vm_list);

-- 
