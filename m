Return-Path: <linux-kernel-owner+w=401wt.eu-S1760819AbYAKJI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760819AbYAKJI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 04:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705AbYAKJIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 04:08:44 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:32003
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756135AbYAKJIn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 04:08:43 -0500
Message-Id: <4787403C.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 11 Jan 2008 09:09:00 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <sam@ravnborg.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] scripts/mkmakefile: dynamic determination of output
	directory
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than fixing the output directory in the generated Makefile,
determine it from the placement of Makefile. This allows moving
the build tree around or accessing it through different mount paths.

(The lastword definition is a compatibility one for make prior to 3.81;
newer make will simply ignore it and use the [faster] built-in.)

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 scripts/mkmakefile |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- linux-2.6.24-rc7/scripts/mkmakefile	2008-01-10 16:55:30.000000000 +0100
+++ 2.6.24-rc7-mkmakefile-objdir/scripts/mkmakefile	2008-01-08 12:35:11.000000000 +0100
@@ -25,8 +25,11 @@ cat << EOF > $2/Makefile
 VERSION = $3
 PATCHLEVEL = $4
 
-KERNELSRC    := $1
-KERNELOUTPUT := $2
+lastword = \$(word \$(words \$(1)),\$(1))
+makedir := \$(dir \$(call lastword,\$(MAKEFILE_LIST)))
+
+MAKEARGS := -C $1
+MAKEARGS += O=\$(if \$(patsubst /%,,\$(makedir)),\$(CURDIR)/)\$(patsubst %/,%,\$(makedir))
 
 MAKEFLAGS += --no-print-directory
 
@@ -35,10 +38,11 @@ MAKEFLAGS += --no-print-directory
 all	:= \$(filter-out all Makefile,\$(MAKECMDGOALS))
 
 all:
-	\$(MAKE) -C \$(KERNELSRC) O=\$(KERNELOUTPUT) \$(all)
+	\$(MAKE) \$(MAKEARGS) \$(all)
 
 Makefile:;
 
 \$(all) %/: all
 	@:
+
 EOF



