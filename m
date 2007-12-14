Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbXLNXjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbXLNXjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 18:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbXLNXi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 18:38:56 -0500
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:38765 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbXLNXiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 18:38:55 -0500
Date: Fri, 14 Dec 2007 17:38:18 -0600
From: Nathan Lynch <ntl@pobox.com>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fix bloat-o-meter for ppc64
Message-ID: <20071214233817.GI28696@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bloat-o-meter assumes that a '.' anywhere in a symbol's name means
that it is static and prepends 'static.' to the first part of the
symbol name, discarding the portion of the name that follows the '.'.
However, the names of function entry points begin with '.' in the
ppc64 ABI.  This causes all function text size changes to be accounted
to a single 'static.' entry in the output when comparing ppc64
kernels.

Change getsizes() to ignore the first character of the symbol name
when searching for '.'.

Signed-off-by: Nathan Lynch <ntl@pobox.com>
---
 scripts/bloat-o-meter |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/bloat-o-meter b/scripts/bloat-o-meter
index ce59fc2..6501a50 100755
--- a/scripts/bloat-o-meter
+++ b/scripts/bloat-o-meter
@@ -18,7 +18,8 @@ def getsizes(file):
     for l in os.popen("nm --size-sort " + file).readlines():
         size, type, name = l[:-1].split()
         if type in "tTdDbB":
-            if "." in name: name = "static." + name.split(".")[0]
+            # function names begin with '.' on 64-bit powerpc
+            if "." in name[1:]: name = "static." + name.split(".")[0]
             sym[name] = sym.get(name, 0) + int(size, 16)
     return sym
 
-- 
1.5.3.7.1112.g9758e

