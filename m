Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbXEZC2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbXEZC2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 22:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbXEZC2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 22:28:08 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:45240 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbXEZC2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 22:28:06 -0400
Date: Fri, 25 May 2007 19:27:42 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix oprofile double free (was Re: Multiple free
	during oprofile unload)
Message-ID: <20070526022741.GD3390@sequoia.sous-sol.org>
References: <4656FA04.5000403@redhat.com> <200705251913.53097.ak@suse.de> <20070525173813.GA2875@redhat.com> <200705252002.58967.ak@suse.de> <20070525193737.34609de2@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525193737.34609de2@the-village.bc.nu>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> I'd agree entirely with Dave - if you are applying a fix to something
> that is currently totally broken which may make it work and which doesn't
> affect any other bit of code then it goes into the stable tree.

And, in this case we're in luck.  It's not released in any -stable tree
yet (it's queued for the next release).  So there's plenty of time to
fix it up before next -stable release.

Something like below should fix it.

thanks,
-chris
--

Subject: [PATCH] x86: fix oprofile double free

From: Chris Wright <chrisw@sous-sol.org>

Chuck reports that the recent fix from Andi to oprofile
6c977aad03a18019015035958c65b6729cd0574c introduces a double
free.  Each cpu's cpu_msrs is setup to point to cpu 0's, which
causes free_msrs to free cpu 0's pointers for_each_possible_cpu.
Rather than copy the pointers, do a deep copy instead.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 arch/i386/oprofile/nmi_int.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/i386/oprofile/nmi_int.c b/arch/i386/oprofile/nmi_int.c
index a7c0783..0c39443 100644
--- a/arch/i386/oprofile/nmi_int.c
+++ b/arch/i386/oprofile/nmi_int.c
@@ -211,8 +211,14 @@ static int nmi_setup(void)
 	/* Assume saved/restored counters are the same on all CPUs */
 	model->fill_in_addresses(&cpu_msrs[0]);
 	for_each_possible_cpu (cpu) {
-		if (cpu != 0)
-			cpu_msrs[cpu] = cpu_msrs[0];
+		if (cpu != 0) {
+			memcpy(cpu_msrs[cpu].counters, cpu_msrs[0].counters,
+				sizeof(struct op_msr) * model->num_counters);
+				
+			memcpy(cpu_msrs[cpu].controls, cpu_msrs[0].controls,
+				sizeof(struct op_msr) * model->num_controls);
+		}
+
 	}
 	on_each_cpu(nmi_save_registers, NULL, 0, 1);
 	on_each_cpu(nmi_cpu_setup, NULL, 0, 1);
