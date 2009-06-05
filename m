Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbZFEMLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbZFEMLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 08:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbZFEMLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 08:11:09 -0400
Received: from ocean.emcraft.com ([213.221.7.182]:40686 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbZFEMLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 08:11:08 -0400
Date: Fri, 5 Jun 2009 16:11:09 +0400
From: Sergei Poselenov <sposelenov@emcraft.com>
To: Wolfgang Denk <wd@denx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Re: 'make headers_check' failed to install headers to
 arbitrary location
Message-ID: <20090605161109.50d4f253@emcraft.com>
In-Reply-To: <20090604170715.98806832E416@gemini.denx.de>
References: <4A0C3BFB.1010305@emcraft.com>
	<4A155B53.4040905@emcraft.com>
	<20090604175536.2a1d0add@emcraft.com>
	<20090604170715.98806832E416@gemini.denx.de>
Organization: Emcraft Systems
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Jun 2009 19:07:15 +0200
Dear Wolfgang,

Wolfgang Denk <wd@denx.de> wrote:

> Why not simply:
> 
> 	for f in $(all-files); do
> 		echo "$(install)/$${f}"
> 	done | xargs $(PERL) ...
> 
> ?
> 

Ah,right, I missed this.

Here is the modified version of the patch, tested on 2.6.30-rc8,
ARCH=arm

Subject: [PATCH] Fixed the "Argument list too long" error for "make headers_check",
 used xargs to minimize the perl calls.

Signed-off-by: Sergei Poselenov <sposelenov@emcraft.com>
---
 scripts/Makefile.headersinst |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index 095cfc8..0fcd838 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -54,8 +54,12 @@ quiet_cmd_remove = REMOVE  $(unwanted)
       cmd_remove = rm -f $(unwanted-file)
 
 quiet_cmd_check = CHECK   $(printdir) ($(words $(all-files)) files)
-      cmd_check = $(PERL) $< $(INSTALL_HDR_PATH)/include $(SRCARCH) \
-                  $(addprefix $(install)/, $(all-files));           \
+# Headers list can be pretty long, xargs helps to avoid
+# the "Argument list too long" error.
+      cmd_check = for f in $(all-files); do                          \
+                  echo "$(install)/$${f}"; done                      \
+                  | xargs                                            \
+                  $(PERL) $< $(INSTALL_HDR_PATH)/include $(SRCARCH); \
 	          touch $@
 
 PHONY += __headersinst __headerscheck
-- 
1.6.0.6

