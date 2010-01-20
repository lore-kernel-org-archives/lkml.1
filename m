Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512Ab0ATPnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab0ATPnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 10:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438Ab0ATPns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 10:43:48 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:53838 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab0ATPnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 10:43:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=PjlPl+ic/D6AZXZze8I5IKDdBnq7UnHrWkptujJWvt2rnYLzuatxKUfpnSVsZKQo3x
         fEhSQgH17MEwa3nsGClPOzBUKJCxUiCqoX7CVyW3Rn57QDCTzRn75r19HpVz6UigQ7D8
         q+pqA0/Y7sTp5RIIgXxiL4o6e5RcrLZS706Ds=
From: John Kacur <jkacur@redhat.com>
To: Clark Williams <williams@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Carsten Emde <C.Emde@osadl.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       "Nikita V. Youshchenko" <yoush@cs.msu.su>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 2/2] rt-tests: Make cyclic test compilable for non-numa systems.
Date: Wed, 20 Jan 2010 16:36:24 +0100
Message-Id: <1264001784-11965-3-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264001784-11965-1-git-send-email-jkacur@redhat.com>
References: <1264001784-11965-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Runtime tests are not sufficient, cyclic tests needs to be compilable
on non-numa systems.

This separates numa functionality into rt_numa.h

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 src/cyclictest/cyclictest.c |   46 +++++++-------------------
 src/cyclictest/rt_numa.h    |   74 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 87 insertions(+), 33 deletions(-)
 create mode 100644 src/cyclictest/rt_numa.h

diff --git a/src/cyclictest/cyclictest.c b/src/cyclictest/cyclictest.c
index c1b5c7f..cff414f 100644
--- a/src/cyclictest/cyclictest.c
+++ b/src/cyclictest/cyclictest.c
@@ -31,7 +31,7 @@
 #include <sys/time.h>
 #include <sys/utsname.h>
 #include <sys/mman.h>
-#include <numa.h>
+#include "rt_numa.h"
 
 #include "rt-utils.h"
 
@@ -542,11 +542,8 @@ void *timerthread(void *param)
 	cpu_set_t mask;
 
 	/* if we're running in numa mode, set our memory node */
-	if (par->node != -1) {
-		if (numa_run_on_node(par->node))
-			warn ("Could not set NUMA node %d for thread %d: %s\n", 
-			      par->node, par->cpu, strerror(errno));
-	}
+	if (par->node != -1)
+		rt_numa_set_numa_run_on_node(par->node, par->cpu);
 
 	if (par->cpu != -1) {
 		CPU_ZERO(&mask);
@@ -804,7 +801,6 @@ static int interval = 1000;
 static int distance = 500;
 static int affinity = 0;
 static int smp = 0;
-static int numa = 0;
 
 enum {
 	AFFINITY_UNSPECIFIED,
@@ -987,10 +983,15 @@ static void process_options (int argc, char *argv[])
 		case 'U':  /* NUMA testing */
 			if (smp)
 				fatal("numa and smp options are mutually exclusive\n");
+#ifdef NUMA
 			numa = 1;
 			num_threads = max_cpus;
 			setaffinity = AFFINITY_USEALL;
 			use_nanosleep = MODE_CLOCK_NANOSLEEP;
+#else
+			warn("cyclicteset was not built with the numa option\n");
+			warn("ignoring --numa or -U\n");
+#endif
 			break;
 		case '?': display_help(0); break;
 		}
@@ -1178,24 +1179,6 @@ static void print_stat(struct thread_param *par, int index, int verbose)
 	}
 }
 
-void *
-threadalloc(size_t size, int node)
-{
-	if (node == -1)
-		return malloc(size);
-	return numa_alloc_onnode(size, node);
-}
-
-void
-threadfree(void *ptr, size_t size, int node)
-{
-	if (node == -1)
-		free(ptr);
-	else
-		numa_free(ptr, size);
-}			
-
-
 int main(int argc, char **argv)
 {
 	sigset_t sigset;
@@ -1212,8 +1195,8 @@ int main(int argc, char **argv)
 	if (check_privs())
 		exit(EXIT_FAILURE);
 
-	if (numa && numa_available() == -1)
-		fatal("--numa specified and numa functions not available\n");
+	/* Checks if numa is on, program exits if numa on but not available */
+	numa_on_and_available();
 
 	/* lock all memory (prevent paging) */
 	if (lockall)
@@ -1266,8 +1249,7 @@ int main(int argc, char **argv)
 			size_t stksize;
 
 			/* find the memory node associated with the cpu i */
-			if ((node = numa_node_of_cpu(i)) == -1)
-				fatal("invalid cpu passed to numa_node_of_cpu(%d)\n");
+			node = rt_numa_numa_node_of_cpu(i);
 
 			/* get the stack size set for for this thread */
 			if (pthread_attr_getstack(&attr, &currstk, &stksize))
@@ -1277,10 +1259,8 @@ int main(int argc, char **argv)
 			if (stksize == 0)
 				stksize = PTHREAD_STACK_MIN * 2;
 
-			/*  allocate memory for a stack on the appropriate node */
-			if ((stack = numa_alloc_onnode(stksize, node)) == NULL)
-				fatal("failed to allocate %d bytes on node %d for thread %d\n",
-				      stksize, node, i);
+			/*  allocate memory for a stack on appropriate node */
+			stack = rt_numa_numa_alloc_onnode(stksize, node, i);
 
 			/* set the thread's stack */
 			if (pthread_attr_setstack(&attr, stack, stksize))
diff --git a/src/cyclictest/rt_numa.h b/src/cyclictest/rt_numa.h
new file mode 100644
index 0000000..1348163
--- /dev/null
+++ b/src/cyclictest/rt_numa.h
@@ -0,0 +1,74 @@
+#ifndef _RT_NUMA_H
+#define _RT_NUMA_H
+
+#include "rt-utils.h"
+
+static int numa = 0;
+
+#ifdef NUMA
+#include <numa.h>
+
+static void *
+threadalloc(size_t size, int node)
+{
+	if (node == -1)
+		return malloc(size);
+	return numa_alloc_onnode(size, node);
+}
+
+static void
+threadfree(void *ptr, size_t size, int node)
+{
+	if (node == -1)
+		free(ptr);
+	else
+		numa_free(ptr, size);
+}			
+
+static void rt_numa_set_numa_run_on_node(int node, int cpu)
+{
+	int res;
+	res = numa_run_on_node(node);
+	if (res)
+		warn("Could not set NUMA node %d for thread %d: %s\n",
+				node, cpu, strerror(errno));
+	return;
+}
+
+static void numa_on_and_available()
+{
+	if (numa && numa_available() == -1)
+		fatal("--numa specified and numa functions not available.\n");
+}
+
+static int rt_numa_numa_node_of_cpu(int cpu)
+{
+	int node;
+	node = numa_node_of_cpu(cpu);
+	if (node == -1)
+		fatal("invalid cpu passed to numa_node_of_cpu(%d)\n", cpu);
+	return node;
+}
+
+static void *rt_numa_numa_alloc_onnode(size_t size, int node, int cpu)
+{
+	void *stack;
+	stack = numa_alloc_onnode(size, node);
+	if (stack == NULL)
+		fatal("failed to allocate %d bytes on node %d for cpu %d\n",
+				size, node, cpu);
+	return stack;
+}
+
+#else
+
+static inline void *threadalloc(size_t size, int n) { return malloc(size); }
+static inline void threadfree(void *ptr, size_t s, int n) { free(ptr); } 
+static inline void rt_numa_set_numa_run_on_node(int n, int c) { }
+static inline void numa_on_and_available() { };
+static inline int rt_numa_numa_node_of_cpu(int cpu) { return -1;}
+static void *rt_numa_numa_alloc_onnode(size_t s, int n, int c) { return NULL; }
+
+#endif	/* NUMA */
+
+#endif	/* _RT_NUMA_H */
-- 
1.6.6

