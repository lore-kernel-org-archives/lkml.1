Return-Path: <linux-kernel-owner+w=401wt.eu-S1757701AbZJPJlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbZJPJlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 05:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757316AbZJPJlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 05:41:13 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:36881 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757132AbZJPJlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 05:41:12 -0400
Date: Fri, 16 Oct 2009 15:10:17 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-arch@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [v9 PATCH 1/9]: cpuidle: Design documentation patch
Message-ID: <20091016094017.GC27350@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20091016093850.GB27350@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091016093850.GB27350@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-10-16 15:08:50]:

This patch adds a little information about the redesigned cpuidle
infrastructure in Documentation/cpuidle/core.txt

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 Documentation/cpuidle/core.txt |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

Index: linux.trees.git/Documentation/cpuidle/core.txt
===================================================================
--- linux.trees.git.orig/Documentation/cpuidle/core.txt
+++ linux.trees.git/Documentation/cpuidle/core.txt
@@ -21,3 +21,38 @@ which can be used to switch governors at
 is meant for developer testing only. In normal usage, kernel picks the
 best governor based on governor ratings.
 SEE ALSO: sysfs.txt in this directory.
+
+Design:
+
+Cpuidle allows for registration of multiple sets of idle routines.
+The latest registered set is used by cpuidle governors as the current
+active set to choose the right idle state. This set is managed as a
+list and each time the newly registered set is added to the head of the
+list and made the current active set.
+
+An example of how this would work on x86 is shown below.
+
+-----------------					-----------------
+|		|					|		|
+| choose b/w	|	mwait is chosen			|    mwait	|
+| mwait, poll,	|-------------------------------------> |(current active|
+| default, c1e	|	register to cpuidle		|    set)	|
+|		|	with mwait as the idle routine	|		|
+-----------------					-----------------
+
+
+-----------------					-----------------
+|		|					|  c1, c2, c3	|
+|     ACPI	|	register to cpuidle		|   (current)	|
+|   discovery	|-------------------------------------> |---------------|
+|		|	with c1, c2, c3			|     mwait	|
+|		|	as set of idle routines		|		|
+-----------------					-----------------
+
+With this mechanism, a module can register and unregister its set of
+idle routines at run time in a clean manner.
+
+The main idle routine called inside cpu_idle() of every arch is defined in
+driver/cpuidle/cpuidle.c which would in turn call the idle routine selected
+by the governor. If the CONFIG_CPU_IDLE is disabled, the arch needs to
+provide an alternate definition for cpuidle_idle_call().
