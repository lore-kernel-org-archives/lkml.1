Return-Path: <linux-kernel-owner+w=401wt.eu-S1757960AbZDKTsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960AbZDKTsq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 15:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755540AbZDKTsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 15:48:38 -0400
Received: from relay3.ptmail.sapo.pt ([212.55.154.23]:56284 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754741AbZDKTsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 15:48:37 -0400
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Sat, 11 Apr 2009 20:45:46 +0100
From: Luis Henriques <henrix@sapo.pt>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Problem with kvm on -tip
Message-ID: <20090411194546.GA12126@hades.domain.com>
References: <20090409210738.GA4566@hades.domain.com> <49E08857.2090503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E08857.2090503@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Apr 11, 2009 at 03:08:55PM +0300, Avi Kivity wrote:
>
> This might be fixed by the attached patch.

I confirm that the patch you sent removes the warnings but does it really solve
the issue? (Sorry, I really do not know this code so I might be saying something
really stupid.)

What I understand from your patch is that the only portion of code that needs
protection is the __get_cpu_var().  If this is true then a patch like the one
below would do a better job.  But I am not sure that nothing else needs
protection since the code immediately following the preempt_enable (in your
patch) is an invocation to local_irq_save()...

---
 arch/x86/kvm/x86.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8ca100a..cf918b5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -626,13 +626,17 @@ static void kvm_write_guest_time(struct kvm_vcpu *v)
 	unsigned long flags;
 	struct kvm_vcpu_arch *vcpu = &v->arch;
 	void *shared_kaddr;
+	uint32_t tsc_khz;
 
 	if ((!vcpu->time_page))
 		return;
 
-	if (unlikely(vcpu->hv_clock_tsc_khz != __get_cpu_var(cpu_tsc_khz))) {
-		kvm_set_time_scale(__get_cpu_var(cpu_tsc_khz), &vcpu->hv_clock);
-		vcpu->hv_clock_tsc_khz = __get_cpu_var(cpu_tsc_khz);
+	preempt_disable();
+	tsc_khz = __get_cpu_var(cpu_tsc_khz);
+	preempt_enable();
+	if (unlikely(vcpu->hv_clock_tsc_khz != tsc_khz)) {
+		kvm_set_time_scale(tsc_khz, &vcpu->hv_clock);
+		vcpu->hv_clock_tsc_khz = tsc_khz;
 	}

 	/* Keep irq disabled to prevent changes to the clock */
-- 
1.6.2.1

