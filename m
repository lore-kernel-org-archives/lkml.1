Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbZLIPuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbZLIPuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 10:50:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755657AbZLIPuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 10:50:04 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:47690 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbZLIPuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 10:50:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iZs1pzJFFSMNYkBwWrXsENdbRVgWKwxCx2wX8DFP4OW0ccxRxWN35+40N7xwLOXERe
         bk/Ozsisg2aUDzAE809CPfiibss5LnSkF1216joq86jkqj2FmdJWUaGT3TvcC+ThvvGD
         73tYJ19f75Y8TaqVDX41LNL56bqEBm+Rt2Y2E=
Date: Wed, 9 Dec 2009 18:50:02 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, macro@linux-mips.org,
       yinghai@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] x86,apic: Use logical OR in noop-write operation
Message-ID: <20091209155002.GB5788@lenovo>
References: <20091208155316.561853924@openvz.org> <20091208155557.326359748@openvz.org> <20091208204838.GA26156@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091208204838.GA26156@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 11:48:38PM +0300, Cyrill Gorcunov wrote:
> On Tue, Dec 08, 2009 at 06:53:18PM +0300, Cyrill Gorcunov wrote:
> > For apic noop'ified we have to use logical OR statement,
> > otherwise any write on systems shipped with 82489DX
> > (where apic presence bit can't be retrieved via cpuid)
> > will not trigger the warning which is not desired.
> >
> ...
> 
> Ingo please dont apply this patch. Perhaps we may warn unconditionally
> (as Peter marked) which would be more clear approach indeed. Need more
> time to check all code flows.
> 
> Sorry for inconvenience.
> 
> 	-- Cyrill

Here is what done at moment. I've grepped x86 arch for apic_write and
except thermal monitoring (the patch is already sent) all other callers
do check if apic is active (either via cpu_has_apic or disable_apic).
So I think we may safely use unconditional warning if apic_write with
disabled apic is called.

Please take a look -- I would be glad to hear any comments/complains.

There is unclear moment for me with "SGI Visual Workstation" which
has ack_cobalt_irq and calls for apic_write which could trigger this
warning.

	-- Cyrill
---
x86,apic: Warn on noop_apic_write unconditionally

In apic noop'ified we should never call for write operation.
Otherwise it's a caller bug (we should be WARNed about).

Also add a comment on noop_apic_read WARN conditions.

CC: H. Peter Anvin <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Maciej W. Rozycki <macro@linux-mips.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

 arch/x86/kernel/apic/apic_noop.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/apic/apic_noop.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/apic_noop.c
+++ linux-2.6.git/arch/x86/kernel/apic/apic_noop.c
@@ -119,15 +119,28 @@ int noop_apicid_to_node(int logical_apic
 	return 0;
 }
 
+/*
+ * note that we allow this routine to be called
+ * under the following conditions:
+ *  - apic was explicitly disabled via boot option
+ *  - on old 486 machines (which has no apic presence bit
+ *    retrieved via cpuid)
+ * this is done only in a sake of callers code simplicity
+ */
 static u32 noop_apic_read(u32 reg)
 {
-	WARN_ON_ONCE((cpu_has_apic && !disable_apic));
+	WARN_ON_ONCE(cpu_has_apic && !disable_apic);
 	return 0;
 }
 
 static void noop_apic_write(u32 reg, u32 v)
 {
-	WARN_ON_ONCE(cpu_has_apic && !disable_apic);
+	/*
+	 * If someone is trying to write apic
+	 * register when it is NOOP'ified
+	 * this is a bug on caller side
+	 */
+	WARN_ON_ONCE(1);
 }
 
 struct apic apic_noop = {
