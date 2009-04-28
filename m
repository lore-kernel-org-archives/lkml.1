Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbZD1WRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbZD1WRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 18:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbZD1WRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 18:17:37 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:40417 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbZD1WRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 18:17:37 -0400
Date: Tue, 28 Apr 2009 15:17:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>
Subject: [PATCH] kernel-doc: restrict syntax for private: and public:
Message-Id: <20090428151757.0547392d.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.49F78046.0055:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

scripts/kernel-doc can (incorrectly) delete struct members that
are surrounded by /* ... */ <struct members> /* ... */
if there is a /* private: */ comment in there somewhere also.

Fix that by making the "/* private:" only allow whitespace
between /* and "private:", not anything/everything in the world.

This fixes some erroneous kernel-doc warnings that popped up
while processing include/linux/usb/composite.h.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kernel-doc-nano-HOWTO.txt |    7 +++++--
 scripts/kernel-doc                      |    7 ++++---
 2 files changed, 9 insertions(+), 5 deletions(-)

--- linux-2.6.30-rc3-git4.orig/scripts/kernel-doc
+++ linux-2.6.30-rc3-git4/scripts/kernel-doc
@@ -1411,7 +1411,8 @@ sub dump_struct($$) {
     my $file = shift;
     my $nested;
 
-    if ($x =~/(struct|union)\s+(\w+)\s*{(.*)}/) {
+    if ($x =~ /(struct|union)\s+(\w+)\s*{(.*)}/) {
+	#my $decl_type = $1;
 	$declaration_name = $2;
 	my $members = $3;
 
@@ -1420,8 +1421,8 @@ sub dump_struct($$) {
 	$nested = $1;
 
 	# ignore members marked private:
-	$members =~ s/\/\*.*?private:.*?public:.*?\*\///gos;
-	$members =~ s/\/\*.*?private:.*//gos;
+	$members =~ s/\/\*\s*private:.*?\/\*\s*public:.*?\*\///gos;
+	$members =~ s/\/\*\s*private:.*//gos;
 	# strip comments:
 	$members =~ s/\/\*.*?\*\///gos;
 	$nested =~ s/\/\*.*?\*\///gos;
--- linux-2.6.30-rc3-git4.orig/Documentation/kernel-doc-nano-HOWTO.txt
+++ linux-2.6.30-rc3-git4/Documentation/kernel-doc-nano-HOWTO.txt
@@ -269,7 +269,10 @@ Use the argument mechanism to document m
 
 Inside a struct description, you can use the "private:" and "public:"
 comment tags.  Structure fields that are inside a "private:" area
-are not listed in the generated output documentation.
+are not listed in the generated output documentation.  The "private:"
+and "public:" tags must begin immediately following a "/*" comment
+marker.  They may optionally include comments between the ":" and the
+ending "*/" marker.
 
 Example:
 
@@ -283,7 +286,7 @@ Example:
 struct my_struct {
     int a;
     int b;
-/* private: */
+/* private: internal use only */
     int c;
 };
 
