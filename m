Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbZJZU2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbZJZU2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 16:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbZJZU2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 16:28:10 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:52123 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbZJZU2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 16:28:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ODvKqOa5ENEGdtyzxMAoS+OILy9+/ZoVRRQm91D0UXFYkf2EKBIzZ4Nt4QZ3I7ILyf
         B+yJDnvUrXG0D/ZufOBQAXy4hrtaq/Y3byIKCoCxJt9gZ+/Xy/pL15RpRlDBM9Jqh4d6
         nhSr0qZ882Pi0clPduzjGmlWnT2hPHZyEmzWo=
Date: Mon, 26 Oct 2009 23:28:11 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] irq: Do not attempt to create subdirectories if
	/proc/irq/<irq> failed
Message-ID: <20091026202811.GD5321@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a parent directory (ie /proc/irq/<irq>) could not be created
we should not attempt to create subdirectories. Otherwise it would
lead that "smp_affinity" and "spurious" entries are may be registered
under /proc root instead of a proper place.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Please review. This is not critical even if will be failing
at this point even at every call but better to be sure all
goe fine. I hope I don't miss anything?

 kernel/irq/proc.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.git/kernel/irq/proc.c
=====================================================================
--- linux-2.6.git.orig/kernel/irq/proc.c
+++ linux-2.6.git/kernel/irq/proc.c
@@ -214,6 +214,8 @@ void register_irq_proc(unsigned int irq,
 
 	/* create /proc/irq/1234 */
 	desc->dir = proc_mkdir(name, root_irq_dir);
+	if (!desc->dir)
+		return;
 
 #ifdef CONFIG_SMP
 	/* create /proc/irq/<irq>/smp_affinity */
