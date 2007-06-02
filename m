Return-Path: <linux-kernel-owner+w=401wt.eu-S1762709AbXFBTPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762709AbXFBTPw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 15:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759958AbXFBTPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 15:15:46 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:47494 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760165AbXFBTPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 15:15:45 -0400
Date: Sat, 2 Jun 2007 21:16:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: jakub@redhat.com, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       daplas@gmail.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Section mismatches in drivers/video/console/promcon
Message-ID: <20070602191646.GA13264@uranus.ravnborg.org>
References: <20070602124255.GA10119@uranus.ravnborg.org> <1180790683.4524.13.camel@daplas>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180790683.4524.13.camel@daplas>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> promcon_init() can be called again from visual_init() during
> vc_allocate().  So anything referenced by promcon_init() should not be
> marked __init.
> 
> Although, if you want to keep promfont_unitable and promfont_unicount
> __init, you can probably use con_copy_unimap() using the default vc as
> the source instead of doing a promcon_init_unimap() again.

Too involved for me to look into.
I cooked up following very minimal patch - if you agree can you then please
forward/take care of it.

	Sam

Subject: video: fix section mismatch warning in promcon

Fix the following warnings in promcon:
WARNING: o-sparc64/drivers/video/console/built-in.o(.text+0x480): Section mismatch: reference to .init.data:promfont_unitable (between 'promcon_init_unimap' and 'promcon_init')
WARNING: o-sparc64/drivers/video/console/built-in.o(.text+0x488): Section mismatch: reference to .init.data:promfont_unitable (between 'promcon_init_unimap' and 'promcon_init')
WARNING: o-sparc64/drivers/video/console/built-in.o(.text+0x48c): Section mismatch: reference to .init.data:promfont_unicount (between 'promcon_init_unimap' and 'promcon_init')
WARNING: o-sparc64/drivers/video/console/built-in.o(.text+0x490): Section mismatch: reference to .init.data:promfont_unicount (between 'promcon_init_unimap' and 'promcon_init')

The warnings happens because the function: promcon_init_unimap()
references promfont_unitable and promfont_unicount which are marked
__initdata by the conmakehash command in the drivers/video/console/Makefile

Fix the warning by removing the __initdata marker on the two variables.
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
diff --git a/drivers/video/console/Makefile b/drivers/video/console/Makefile
index 9b26dda..ac46cc3 100644
--- a/drivers/video/console/Makefile
+++ b/drivers/video/console/Makefile
@@ -47,7 +47,7 @@ targets := promcon_tbl.c
 quiet_cmd_conmakehash = CNMKHSH $@
       cmd_conmakehash = scripts/conmakehash $< | \
 		sed -e '/\#include <[^>]*>/p' -e 's/types/init/' \
-		-e 's/dfont\(_uni.*\]\)/promfont\1 __initdata/' > $@
+		-e 's/dfont\(_uni.*\]\)/promfont\1 /' > $@
 
 $(obj)/promcon_tbl.c: $(src)/prom.uni
 	$(call cmd,conmakehash)

