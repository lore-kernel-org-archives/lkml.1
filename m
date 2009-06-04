Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbZFDNzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbZFDNzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 09:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbZFDNzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 09:55:37 -0400
Received: from ocean.emcraft.com ([213.221.7.182]:60520 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbZFDNzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 09:55:36 -0400
Date: Thu, 4 Jun 2009 17:55:36 +0400
From: Sergei Poselenov <sposelenov@emcraft.com>
To: linux-kernel@vger.kernel.org
Cc: wd@denx.de
Subject: Re: [PATCH] Re: 'make headers_check' failed to install headers to
 arbitrary location
Message-ID: <20090604175536.2a1d0add@emcraft.com>
In-Reply-To: <4A155B53.4040905@emcraft.com>
References: <4A0C3BFB.1010305@emcraft.com>
	<4A155B53.4040905@emcraft.com>
Organization: Emcraft Systems
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

On Thu, 21 May 2009 17:46:59 +0400
Sergei Poselenov <sposelenov@emcraft.com> wrote:

> Hello all,
> 
> A time ago I noted a 'make headers_check' failure, see the
> original message here:
> http://lkml.org/lkml/2009/5/14/248
> 
> The proposed patch fixes this error, please review.
> Tested on 2.6.30-rc5.
> 

Here is another version of the patch which fixes
the "Argument list too long" error for "make headers_check", used xargs
to minimize the perl calls (thanks, Wolfgang).

Signed-off-by: Sergei Poselenov <sposelenov@emcraft.com>
---
 scripts/Makefile.headersinst |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index 095cfc8..4c54d22 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -54,8 +54,14 @@ quiet_cmd_remove = REMOVE  $(unwanted)
       cmd_remove = rm -f $(unwanted-file)
 
 quiet_cmd_check = CHECK   $(printdir) ($(words $(all-files)) files)
-      cmd_check = $(PERL) $< $(INSTALL_HDR_PATH)/include $(SRCARCH) \
-                  $(addprefix $(install)/, $(all-files));           \
+# Headers list can be pretty long, xargs helps to avoid
+# the "Argument list too long" error.
+      cmd_check = rm -f hdrlist; touch hdrlist;                      \
+                  for f in $(all-files); do                          \
+                  echo "$(install)/$${f} " >> hdrlist; done;         \
+                  cat hdrlist | xargs                                \
+                  $(PERL) $< $(INSTALL_HDR_PATH)/include $(SRCARCH); \
+                  rm -f hdrlist;                                     \
 	          touch $@
 
 PHONY += __headersinst __headerscheck
-- 
1.6.0.6

