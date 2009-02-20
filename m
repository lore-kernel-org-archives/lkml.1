Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbZBTSXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbZBTSXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 13:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbZBTSXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 13:23:22 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:56279 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838AbZBTSXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 13:23:21 -0500
Subject: Re: x86, vmi: TSC going backwards check in vmi clocksource
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Zach Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090220175841.GQ24538@elte.hu>
References: <1234989235.7991.2.camel@alok-dev1>
	 <20090220175841.GQ24538@elte.hu>
Content-Type: text/plain
Organization: VMware INC.
Date: Fri, 20 Feb 2009 10:23:18 -0800
Message-Id: <1235154198.1547.3.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-20 at 09:58 -0800, Ingo Molnar wrote:
> * Alok Kataria <akataria@vmware.com> wrote:
> 
> >  static cycle_t read_real_cycles(void)
> >  {
> > -	return vmi_timer_ops.get_cycle_counter(VMI_CYCLES_REAL);
> > +	cycle_t ret = (cycle_t)vmi_timer_ops.get_cycle_counter(VMI_CYCLES_REAL);
> > +	return ret >= clocksource_vmi.cycle_last ?
> > +		ret : clocksource_vmi.cycle_last;
> 
> btw., could you please clean this up to use max()?

Please find it below, on top of current tip/master.

--

cleanup vmi_read_cycles to use max()

Signed-off-by: Alok N Kataria <akataria@vmware.com>

---

 arch/x86/kernel/vmiclock_32.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)


diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
index 9cd28c0..b77ad57 100644
--- a/arch/x86/kernel/vmiclock_32.c
+++ b/arch/x86/kernel/vmiclock_32.c
@@ -288,8 +288,7 @@ static struct clocksource clocksource_vmi;
 static cycle_t read_real_cycles(void)
 {
 	cycle_t ret = (cycle_t)vmi_timer_ops.get_cycle_counter(VMI_CYCLES_REAL);
-	return ret >= clocksource_vmi.cycle_last ?
-		ret : clocksource_vmi.cycle_last;
+	return max(ret, clocksource_vmi.cycle_last);
 }
 
 static struct clocksource clocksource_vmi = {


