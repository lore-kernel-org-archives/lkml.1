Return-Path: <linux-kernel-owner+w=401wt.eu-S933026AbXHLLJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026AbXHLLJb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 07:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756296AbXHLLJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 07:09:22 -0400
Received: from aa014msr.fastwebnet.it ([85.18.95.74]:42466 "EHLO
	aa014msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbXHLLJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 07:09:21 -0400
Date: Sun, 12 Aug 2007 13:09:04 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: "Dan Merillat" <dan.merillat@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: reset during bootup - solved
Message-ID: <20070812130904.7ecc9412@localhost>
In-Reply-To: <a56dfcf00708120244x3ae8f4w9183354cf5f33f93@mail.gmail.com>
References: <a56dfcf00708120244x3ae8f4w9183354cf5f33f93@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007 05:44:36 -0400
"Dan Merillat" <dan.merillat@gmail.com> wrote:

> However, a git-pull at 2am (b8d3f244) fixed it.  Not sure where in
> there it started working again, I can bisect backwards to find out if
> need be.

I think it is was fixed by this one:

----

    Do not replace whole memcpy in apply alternatives
    
    apply_alternatives uses memcpy() to apply alternatives.  Which has the
    unfortunate effect that while applying memcpy alternative to memcpy
    itself it tries to overwrite itself with nops - which causes #UD fault
    as it overwrites half of an instruction in copy loop, and from this
    point on only possible outcome is triplefault and reboot.

b8d3f2448b8f4ba24f301e23585547ba1acc1f04
 arch/x86_64/lib/memcpy.S |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86_64/lib/memcpy.S b/arch/x86_64/lib/memcpy.S
index 0ea0ddc..c22981f 100644
--- a/arch/x86_64/lib/memcpy.S
+++ b/arch/x86_64/lib/memcpy.S
@@ -124,6 +124,8 @@ ENDPROC(__memcpy)
 	.quad memcpy
 	.quad 1b
 	.byte X86_FEATURE_REP_GOOD
-	.byte .Lfinal - memcpy
+	/* Replace only beginning, memcpy is used to apply alternatives, so it
+	 * is silly to overwrite itself with nops - reboot is only outcome... */
+	.byte 2b - 1b
 	.byte 2b - 1b
 	.previous

-- 
	Paolo Ornati
	Linux 2.6.23-rc2-gac078602 on x86_64
