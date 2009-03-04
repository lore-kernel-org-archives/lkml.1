Return-Path: <linux-kernel-owner+w=401wt.eu-S1755665AbZCDD7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbZCDD7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 22:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbZCDD7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 22:59:34 -0500
Received: from bilbo.ozlabs.org ([203.10.76.25]:58265 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbZCDD7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 22:59:33 -0500
Date: Wed, 4 Mar 2009 14:59:30 +1100
From: Tony Breeds <tony@bakeyournoodle.com>
To: Kyle McMartin <kyle@infradead.org>, Kumar Gala <galak@kernel.crashing.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ppc: detect sbc610 boards and only fixup nec usb on
	them
Message-ID: <20090304035930.GD24834@bilbo.ozlabs.org>
Mail-Followup-To: Kyle McMartin <kyle@infradead.org>,
	Kumar Gala <galak@kernel.crashing.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <20090304012229.GN28503@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090304012229.GN28503@bombadil.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 08:22:29PM -0500, Kyle McMartin wrote:
> From: Kyle McMartin <kyle@redhat.com>
> 
> Bug #486511 in Fedora, this is getting applied to any machine with a NEC
> USB pci device if this CONFIG_GEF_SBC610 is on (as it was in Fedora.)
> Obviously this isn't appropriate to do in any more than the SBC610
> case..., so flag that we're a sbc610 board, and skip the fixup if we're
> not.
> 
> (Fedora: Should fix USB on Mac G4/G5...)
> 
> Signed-off-by: Kyle McMartin <kyle@redhat.com>
> 
> ---
> diff --git a/arch/powerpc/platforms/86xx/gef_sbc610.c b/arch/powerpc/platforms/86xx/gef_sbc610.c
> index fb371f5..54afda2 100644
> --- a/arch/powerpc/platforms/86xx/gef_sbc610.c
> +++ b/arch/powerpc/platforms/86xx/gef_sbc610.c
> @@ -51,6 +51,8 @@
>  
>  void __iomem *sbc610_regs;
>  
> +static int is_sbc610;

I came up with this as well, but used the machine_is() infrasturcture.

Subject: [PATCH] Run fixup code only on the appropriate platform.

commit a969e76a7101bf5f3d369563df1ca1253dd6131b (powerpc: Correct USB
support for GE Fanuc SBC610) introduced a fixup for NEC usb controllers.
This fixup should only run on GEF SBC610 boards.

Fixes Fedora bug #486511.
(https://bugzilla.redhat.com/show_bug.cgi?id=486511)

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
---
 arch/powerpc/platforms/86xx/gef_sbc610.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/86xx/gef_sbc610.c b/arch/powerpc/platforms/86xx/gef_sbc610.c
index fb371f5..d6b772b 100644
--- a/arch/powerpc/platforms/86xx/gef_sbc610.c
+++ b/arch/powerpc/platforms/86xx/gef_sbc610.c
@@ -142,6 +142,10 @@ static void __init gef_sbc610_nec_fixup(struct pci_dev *pdev)
 {
 	unsigned int val;
 
+	/* Do not do the fixup on other platforms! */
+	if (!machine_is(gef_sbc610))
+		return;
+
 	printk(KERN_INFO "Running NEC uPD720101 Fixup\n");
 
 	/* Ensure ports 1, 2, 3, 4 & 5 are enabled */
-- 
1.6.0.6


Yours Tony
