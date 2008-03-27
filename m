Return-Path: <linux-kernel-owner+w=401wt.eu-S1757640AbYC0AQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640AbYC0AQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 20:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbYC0AP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 20:15:57 -0400
Received: from gw.goop.org ([64.81.55.164]:52837 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211AbYC0AP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 20:15:57 -0400
Message-ID: <47EAE736.307@goop.org>
Date: Wed, 26 Mar 2008 17:15:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: Trying to make use of hotplug memory for xen balloon driver
References: <47EAD83A.2000000@goop.org> <1206576544.7883.21.camel@nimitz.home.sr71.net>
In-Reply-To: <1206576544.7883.21.camel@nimitz.home.sr71.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> Yeah, this is your problem.  You've only allocated the iomem *resource*
> for the memory area, which means that you've basically claimed the
> physical addresses.
>
> But, you don't have any 'struct page's there.
>
> We really screwed up the memory hotplug code and ended up with some
> incredibly arcane function names.  You might want to look at
> add_memory().  It is hidden away in mm/memory_hotplug.c :)
>   

Sorry, I should have been clearer.  add_memory_resource() is a function 
I added; it's effectively add_memory() with the resource-allocating part 
factored out:

--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -171,7 +171,10 @@
 
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
 
+struct resource;
+
 extern int add_memory(int nid, u64 start, u64 size);
+extern int add_memory_resource(int nid, struct resource *res);
 extern int arch_add_memory(int nid, u64 start, u64 size);
 extern int remove_memory(u64 start, u64 size);
 extern int sparse_add_one_section(struct zone *zone, unsigned long start_pfn,
===================================================================
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -278,14 +278,28 @@
 
 int add_memory(int nid, u64 start, u64 size)
 {
-	pg_data_t *pgdat = NULL;
-	int new_pgdat = 0;
 	struct resource *res;
 	int ret;
 
 	res = register_memory_resource(start, size);
 	if (!res)
 		return -EEXIST;
+
+	ret = add_memory_resource(nid, res);
+
+	if (ret)
+		release_memory_resource(res);
+
+	return ret;
+}
+
+int add_memory_resource(int nid, struct resource *res)
+{
+	pg_data_t *pgdat = NULL;
+	int new_pgdat = 0;
+	int ret;
+	u64 start = res->start;
+	u64 size = res->end - res->start + 1;
 
 	if (!node_online(nid)) {
 		pgdat = hotadd_new_pgdat(nid, start);
@@ -320,8 +334,6 @@
 	/* rollback pgdat allocation and others */
 	if (new_pgdat)
 		rollback_node_hotadd(nid, pgdat);
-	if (res)
-		release_memory_resource(res);
 
 	return ret;
 }


> You might also note that most of the ppc64 memory hotplug is driven by
> userspace.  The hypervisor actually contacts a daemon on the guest to
> tell it where its new memory is.  That daemon does the addition
> through /sys/devices/system/memory/probe.  
>   

X86 Xen does it with a combination of hypervisor and userspace.  Mostly 
it comes down to asking the hypervisor to provide a machine page to put 
under a guest pseudo-physical page.

    J
