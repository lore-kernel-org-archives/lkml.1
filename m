Return-Path: <linux-kernel-owner+w=401wt.eu-S1760810AbYGOAuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760810AbYGOAuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 20:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759747AbYGOAue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 20:50:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46577 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759413AbYGOAud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 20:50:33 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <86802c440807141731m5286f640jfeaff1a73b923e7@mail.gmail.com>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <1216079223.27455.92.camel@shinybook.infradead.org>
	 <86802c440807141653s22b91c72gadd6f51ea4a477a@mail.gmail.com>
	 <1216081404.27455.97.camel@shinybook.infradead.org>
	 <86802c440807141731m5286f640jfeaff1a73b923e7@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 17:50:24 -0700
Message-Id: <1216083024.27455.123.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-14 at 17:31 -0700, Yinghai Lu wrote:
> make[1]: *** No rule to make target
> `include/config/builtin/firmware/dir.h', needed by
> `firmware/ql2100_fw.bin.gen.S'.  Stop.
> make: *** [firmware] Error 2

Oh, pants. Sorry, I renamed the CONFIG_BUILTIN_FIRMWARE option to
CONFIG_EXTRA_FIRMWARE some time back, but all my own test builds had the
include/config/builtin/firmware/dir.h file still lying around so I
didn't notice that I'd forgotten to change that manual dependency. And
evidently nobody using linux-next actually tried to include arbitrary
_other_ firmware into their tree. This patch should fix it...

(Why _do_ we have stray files left in include/config/ when config
options go away, btw? Shouldn't they get deleted?)

----
Subject: firmware: Correct dependency on CONFIG_EXTRA_FIRMWARE_DIR

When CONFIG_EXTRA_FIRMWARE_DIR gets changed, the filename in the .S file
(which uses .incbin to include the binary) needs to change. When we
renamed the BUILTIN_FIRMWARE_DIR option to EXTRA_FIRMWARE_DIR, we forgot
to update the manual dependency in firmware/Makefile, so it was
depending on a non-existent file in include/config/

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

diff --git a/firmware/Makefile b/firmware/Makefile
index 5a1e61c..ec4f0cc 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -146,7 +146,7 @@ $(patsubst %,$(obj)/%.gen.S, $(fw-shipped-y)): %: $(wordsize_deps) \
 		| $(objtree)/$$(dir %)
 	$(call cmd,fwbin,$(patsubst %.gen.S,%,$@))
 $(patsubst %,$(obj)/%.gen.S, $(fw-external-y)): %: $(wordsize_deps) \
-		include/config/builtin/firmware/dir.h | $(objtree)/$$(dir %)
+		include/config/extra/firmware/dir.h | $(objtree)/$$(dir %)
 	$(call cmd,fwbin,$(fwabs)/$(patsubst $(obj)/%.gen.S,%,$@))
 
 # The .o files depend on the binaries directly; the .S files don't.


-- 
dwmw2

