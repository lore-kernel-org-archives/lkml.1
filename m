Return-Path: <linux-kernel-owner+w=401wt.eu-S1031066AbXEPVIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031066AbXEPVIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 17:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbXEPVII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 17:08:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbXEPVIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 17:08:06 -0400
Date: Wed, 16 May 2007 17:07:16 -0400
From: Dave Jones <davej@redhat.com>
To: Bob Tracy <rct@gherkin.frus.com>, Chuck Ebbert <cebbert@redhat.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Joachim Deguara <joachim.deguara@amd.com>
Subject: Re: [BUG] (regression) AMD k6-III/450 won't boot w/2.6.22-rc1
Message-ID: <20070516210716.GB16810@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Bob Tracy <rct@gherkin.frus.com>, Chuck Ebbert <cebbert@redhat.com>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
	Joachim Deguara <joachim.deguara@amd.com>
References: <20070516163000.GE30166@redhat.com> <20070516191156.69576DBA1@gherkin.frus.com> <20070516192248.GA16810@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516192248.GA16810@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 03:22:48PM -0400, Dave Jones wrote:
 > On Wed, May 16, 2007 at 02:11:56PM -0500, Bob Tracy wrote:
 > 
 >  > flags		: fpu vme de pse tsc msr mce cx8 pge mmx syscall 3dnow k6_mtrr
 >  > bogomips	: 902.78
 >  > clflush size	: 32
 > 
 > Ah so it really does think it has mce.
 > I just dug out the datasheet for the K6-3, and true enough, it did have MCE, however,
 > it isn't intel compatible. It has two MSRs (MCAR at 0x0, and MCTR at 0x01).
 > Then the punchline..
 > 
 > "Because the processor does not support machine check exceptions, the contents of the
 > MCAR and MCTR are only affected by the WRMSR instruction and by RESET being sampled
 > asserted (where all bits in each register are reset to 0)."
 > 
 > In short, it's useless.
 > We could clear the capability bit and pretend it isn't there, at no loss of
 > functionality, or we could revert back to doing model checks instead of cpuid flag checks.

Bob, does this patch make it boot again for you?

	Dave

Some AMD K6's advertise machine check capability, but don't actually
have an Intel compatible implementation. It also doesn't actually work,
so don't advertise it as being present.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/i386/kernel/cpu/amd.c b/arch/i386/kernel/cpu/amd.c
index 4fec702..3a75c5b 100644
--- a/arch/i386/kernel/cpu/amd.c
+++ b/arch/i386/kernel/cpu/amd.c
@@ -197,7 +197,14 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 				/* placeholder for any needed mods */
 				break;
 			}
+
+			/*
+			 * Some K6's advertise MCE, but it's incompatible
+			 * to Intel style MCE, and also non-functional.
+			 */
+			clear_bit(X86_FEATURE_MCE, c->x86_capability);
 			break;
+
 		case 6: /* An Athlon/Duron */
  
 			/* Bit 15 of Athlon specific MSR 15, needs to be 0
-- 
http://www.codemonkey.org.uk
