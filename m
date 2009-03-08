Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbZCHVjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbZCHVjX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 17:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbZCHVjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 17:39:14 -0400
Received: from smtp-out.google.com ([216.239.33.17]:2659 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbZCHVjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 17:39:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=G0kZIUAN5eBq8HaGrPod8MqG26t+/q9GDduTlRYv/xrKMyUCO7A5fQqMEENDBTaln
	VxhY5cXaUT4b/8Z3HMDNA==
Date: Sun, 8 Mar 2009 14:38:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Menage <menage@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] cpusets: add memory_slab_hardwall flag
In-Reply-To: <6599ad830903080953na692dcfh7f455bfe46a895c3@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0903081438180.30551@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903080917460.25207@chino.kir.corp.google.com> <6599ad830903080953na692dcfh7f455bfe46a895c3@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="497827084-2013226614-1236548330=:30551"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--497827084-2013226614-1236548330=:30551
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Sun, 8 Mar 2009, Paul Menage wrote:

> > +/**
> > + * current_cpuset_object_allowed - can a slab object be allocated on a node?
> > + * @node: the node for object allocation
> > + * @flags: allocation flags
> > + *
> > + * Return non-zero if object is allowed, zero otherwise.
> > + */
> > +int current_cpuset_object_allowed(int node, gfp_t flags)
> > +{
> > +       return !is_slab_hardwall(task_cs(current)) ||
> > +              cpuset_node_allowed_hardwall(node, flags);
> > +}
> > +
> 
> This should be in rcu_read_lock()/rcu_read_unlock() in order to safely
> dereference the result of task_cs(current)
> 

I've folded the following into the patch, thanks Paul.
---
 kernel/cpuset.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1205,8 +1205,12 @@ int current_cpuset_is_being_rebound(void)
  */
 int current_cpuset_object_allowed(int node, gfp_t flags)
 {
-	return !is_slab_hardwall(task_cs(current)) ||
-	       cpuset_node_allowed_hardwall(node, flags);
+	int is_hardwall;
+
+	rcu_read_lock();
+	is_hardwall = is_slab_hardwall(task_cs(current));
+	rcu_read_unlock();
+	return !is_hardwall || cpuset_node_allowed_hardwall(node, flags);
 }
 
 static int update_relax_domain_level(struct cpuset *cs, s64 val)
--497827084-2013226614-1236548330=:30551--
