Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbZHMHbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbZHMHbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 03:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbZHMHbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 03:31:10 -0400
Received: from www.tglx.de ([62.245.132.106]:36601 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156AbZHMHbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 03:31:08 -0400
Date: Thu, 13 Aug 2009 09:30:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Will Schmidt <will_schmidt@vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>
Subject: Re: [ANNOUNCE] 2.6.31-rc4-rt1
In-Reply-To: <1250109930.7493.165.camel@lexx>
Message-ID: <alpine.LFD.2.00.0908130804010.1283@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>  <alpine.LFD.2.00.0904081937191.21577@localhost.localdomain>  <alpine.LFD.2.00.0904092046440.21577@localhost.localdomain>  <alpine.LFD.2.00.0904110003370.21577@localhost.localdomain> 
 <alpine.LFD.2.00.0904181204420.21577@localhost.localdomain>  <alpine.LFD.2.00.0904251500150.4529@localhost.localdomain>  <alpine.LFD.2.00.0904290036500.4529@localhost.localdomain>  <alpine.LFD.2.00.0905012348200.3375@localhost.localdomain> 
 <alpine.LFD.2.00.0905130122250.3561@localhost.localdomain>  <alpine.LFD.2.00.0905221459030.3570@localhost.localdomain>  <alpine.LFD.2.00.0906101803210.3367@localhost.localdomain>  <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain> 
 <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain>  <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain>  <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain>  <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain> 
 <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>  <1249500006.4365.86.camel@lexx>  <alpine.LFD.2.00.0908112005190.1283@localhost.localdomain> <1250109930.7493.165.camel@lexx>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

On Wed, 12 Aug 2009, Will Schmidt wrote:
> The .find_legacy_serial_ports function in the backtrace is very very
> early during boot.   I'll do a bit more looking around to see if it's
> anything obvious,..  

I almost expected some wreckage from converting a rwlock to a
spinlock. Grr. That code really takes the lock recursive. None of my
powerpc systems triggered that code path. :(

So the reason for having a rwlock was not the concurrent access, it
was just the lazy^W reuse of the existing functions which lead to
recursive locking.

As it's the only code in tree which would need the real rwlock version
I fixed up the of code instead of creating all the extra rwlock
functions for rt.

Does the patch below fix it ?

Thanks,

	tglx
-----
commit 925df9b36dc9abe0bab32cbd2ac544d773da71ff
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Thu Aug 13 09:04:10 2009 +0200

    OF: Fixup resursive locking code paths
    
    The conversion of devtree_lock from rwlock to spinlock unearthed
    recursive locking pathes. Instead of going down the hassle of having
    an atomic_rwlock implementation fixup the code pathes to avoid the
    recursive locking.
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 26f4a62..3626e37 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -59,16 +59,14 @@ int of_n_size_cells(struct device_node *np)
 }
 EXPORT_SYMBOL(of_n_size_cells);
 
-struct property *of_find_property(const struct device_node *np,
-				  const char *name,
-				  int *lenp)
+static struct property *__of_find_property(const struct device_node *np,
+					   const char *name, int *lenp)
 {
 	struct property *pp;
 
 	if (!np)
 		return NULL;
 
-	atomic_spin_lock(&devtree_lock);
 	for (pp = np->properties; pp != 0; pp = pp->next) {
 		if (of_prop_cmp(pp->name, name) == 0) {
 			if (lenp != 0)
@@ -76,6 +74,18 @@ struct property *of_find_property(const struct device_node *np,
 			break;
 		}
 	}
+
+	return pp;
+}
+
+struct property *of_find_property(const struct device_node *np,
+				  const char *name,
+				  int *lenp)
+{
+	struct property *pp;
+
+	atomic_spin_lock(&devtree_lock);
+	pp = __of_find_property(np, name, lenp);
 	atomic_spin_unlock(&devtree_lock);
 
 	return pp;
@@ -86,8 +96,20 @@ EXPORT_SYMBOL(of_find_property);
  * Find a property with a given name for a given node
  * and return the value.
  */
+static const void *__of_get_property(const struct device_node *np,
+				     const char *name, int *lenp)
+{
+	struct property *pp = __of_find_property(np, name, lenp);
+
+	return pp ? pp->value : NULL;
+}
+
+/*
+ * Find a property with a given name for a given node
+ * and return the value.
+ */
 const void *of_get_property(const struct device_node *np, const char *name,
-			 int *lenp)
+			    int *lenp)
 {
 	struct property *pp = of_find_property(np, name, lenp);
 
@@ -98,13 +120,13 @@ EXPORT_SYMBOL(of_get_property);
 /** Checks if the given "compat" string matches one of the strings in
  * the device's "compatible" property
  */
-int of_device_is_compatible(const struct device_node *device,
-		const char *compat)
+static int __of_device_is_compatible(const struct device_node *device,
+				     const char *compat)
 {
 	const char* cp;
-	int cplen, l;
+	int uninitialized_var(cplen), l;
 
-	cp = of_get_property(device, "compatible", &cplen);
+	cp = __of_get_property(device, "compatible", &cplen);
 	if (cp == NULL)
 		return 0;
 	while (cplen > 0) {
@@ -117,6 +139,20 @@ int of_device_is_compatible(const struct device_node *device,
 
 	return 0;
 }
+
+/** Checks if the given "compat" string matches one of the strings in
+ * the device's "compatible" property
+ */
+int of_device_is_compatible(const struct device_node *device,
+		const char *compat)
+{
+	int res;
+
+	atomic_spin_lock(&devtree_lock);
+	res = __of_device_is_compatible(device, compat);
+	atomic_spin_unlock(&devtree_lock);
+	return res;
+}
 EXPORT_SYMBOL(of_device_is_compatible);
 
 /**
@@ -319,7 +355,8 @@ struct device_node *of_find_compatible_node(struct device_node *from,
 		if (type
 		    && !(np->type && (of_node_cmp(np->type, type) == 0)))
 			continue;
-		if (of_device_is_compatible(np, compatible) && of_node_get(np))
+		if (__of_device_is_compatible(np, compatible) &&
+		    of_node_get(np))
 			break;
 	}
 	of_node_put(from);
@@ -363,15 +400,9 @@ out:
 }
 EXPORT_SYMBOL(of_find_node_with_property);
 
-/**
- * of_match_node - Tell if an device_node has a matching of_match structure
- *	@matches:	array of of device match structures to search in
- *	@node:		the of device structure to match against
- *
- *	Low level utility function used by device matching.
- */
-const struct of_device_id *of_match_node(const struct of_device_id *matches,
-					 const struct device_node *node)
+static const struct of_device_id *
+__of_match_node(const struct of_device_id *matches,
+		const struct device_node *node)
 {
 	while (matches->name[0] || matches->type[0] || matches->compatible[0]) {
 		int match = 1;
@@ -382,14 +413,32 @@ const struct of_device_id *of_match_node(const struct of_device_id *matches,
 			match &= node->type
 				&& !strcmp(matches->type, node->type);
 		if (matches->compatible[0])
-			match &= of_device_is_compatible(node,
-						matches->compatible);
+			match &= __of_device_is_compatible(node,
+							   matches->compatible);
 		if (match)
 			return matches;
 		matches++;
 	}
 	return NULL;
 }
+
+/**
+ * of_match_node - Tell if an device_node has a matching of_match structure
+ *	@matches:	array of of device match structures to search in
+ *	@node:		the of device structure to match against
+ *
+ *	Low level utility function used by device matching.
+ */
+const struct of_device_id *of_match_node(const struct of_device_id *matches,
+					 const struct device_node *node)
+{
+	const struct of_device_id *match;
+
+	atomic_spin_lock(&devtree_lock);
+	match = __of_match_node(matches, node);
+	atomic_spin_unlock(&devtree_lock);
+	return match;
+}
 EXPORT_SYMBOL(of_match_node);
 
 /**
@@ -412,7 +461,7 @@ struct device_node *of_find_matching_node(struct device_node *from,
 	atomic_spin_lock(&devtree_lock);
 	np = from ? from->allnext : allnodes;
 	for (; np; np = np->allnext) {
-		if (of_match_node(matches, np) && of_node_get(np))
+		if (__of_match_node(matches, np) && of_node_get(np))
 			break;
 	}
 	of_node_put(from);
