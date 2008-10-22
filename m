Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbYJVOA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbYJVOA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbYJVOAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:00:16 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:16910 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbYJVOAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:00:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=UESZkEg/+ZwCfvGGkjOCPJ69wX0aOp6G6zngfFcz4T6CZU5hVLfM2xxG7Aqb+QAW/U
         Trwkbp2Q5+vMtVvrglSvlnRFFu8YS9AYNWDsX5MdShWGQxrGU1BYaAcizOmwRCaXduFT
         +4rmDYSZf3/4r6uFFx2Oj4doQQw9pXcJoUQY4=
Date: Wed, 22 Oct 2008 18:00:09 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Glauber Costa <glommer@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: [PATCH -tip] x86: do_boot_cpu - check if we have ESR register
Message-ID: <20081022140009.GA9639@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should touch ESR register if only we have it.
The patch fixes the problem mentoined here

	http://lkml.org/lkml/2008/10/17/147

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Glauber Costa <glommer@gmail.com>
---

 arch/x86/kernel/smpboot.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/smpboot.c	2008-10-21 20:35:27.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/smpboot.c	2008-10-22 17:45:28.000000000 +0400
@@ -894,8 +894,10 @@ do_rest:
 		/*
 		 * Be paranoid about clearing APIC errors.
 	 	*/
-		apic_write(APIC_ESR, 0);
-		apic_read(APIC_ESR);
+		if (APIC_INTEGRATED(apic_version[phys_apicid])) {
+			apic_write(APIC_ESR, 0);
+			apic_read(APIC_ESR);
+		}
 	}
 
 	/*
