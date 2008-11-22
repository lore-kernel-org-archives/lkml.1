Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbYKVCYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbYKVCYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 21:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbYKVCYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 21:24:42 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:51893 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbYKVCYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 21:24:41 -0500
Date: Fri, 21 Nov 2008 18:24:24 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] kernel-doc: handle varargs cleanly
Message-Id: <20081121182424.024ed2ad.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.49276D5B.0151:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

The method for listing varargs in kernel-doc notation is:
 * @...: these arguments are printed by the @fmt argument

but scripts/kernel-doc is confused:  it always lists varargs as:
	...	variable arguments
and ignores the @...: line's description, but then prints that
line after the list of function parameters as though it's
not part of the function parameters.

This patch makes kernel-doc print the supplied @... description
if it is present; otherwise a boilerplate "variable arguments"
is printed.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- linux-next-20081120.orig/scripts/kernel-doc
+++ linux-next-20081120/scripts/kernel-doc
@@ -378,6 +378,10 @@ sub dump_section {
 #	print STDERR "parameter def '$1' = '$contents'\n";
 	$name = $1;
 	$parameterdescs{$name} = $contents;
+    } elsif ($name eq "@\.\.\.") {
+#	print STDERR "parameter def '...' = '$contents'\n";
+	$name = "...";
+	$parameterdescs{$name} = $contents;
     } else {
 #	print STDERR "other section '$name' = '$contents'\n";
 	if (defined($sections{$name}) && ($sections{$name} ne "")) {
@@ -1588,12 +1592,12 @@ sub push_parameter($$$) {
 
 	if ($type eq "" && $param =~ /\.\.\.$/)
 	{
-	    $type="";
-	    $parameterdescs{$param} = "variable arguments";
+	    if (!defined $parameterdescs{$param} || $parameterdescs{$param} eq "") {
+		$parameterdescs{$param} = "variable arguments";
+	    }
 	}
 	elsif ($type eq "" && ($param eq "" or $param eq "void"))
 	{
-	    $type="";
 	    $param="void";
 	    $parameterdescs{void} = "no arguments";
 	}
