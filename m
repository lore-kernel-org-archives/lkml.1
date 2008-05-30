Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbYE3No6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbYE3No6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 09:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbYE3Nos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 09:44:48 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:56650 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968AbYE3Nor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 09:44:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgEAH+hP0hMQWqh/2dsb2JhbACBVa1C
Date: Fri, 30 May 2008 09:44:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, maneesh@linux.vnet.ibm.com,
       jkennisto@us.ibm.com
Subject: Re: Question about smp_read_barrier_depends() in kernel/marker.c
Message-ID: <20080530134444.GA19720@Krystal>
References: <20080530122206.GA23396@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080530122206.GA23396@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:07:50 up 91 days,  9:18,  5 users,  load average: 2.94, 2.78,
	2.54
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> Hello, Mathieu,
> 
> I am a bit confused by the smp_read_barrier_depends() in kernel/markers.c.
> My (probably naive) view is that they need to move as shown in the patch
> below.  Help?
> 

Hi Paul,

I think it's good to clarify some details about the markers data
structures.

First, the struct marker_entry is a data structure that holds
information about activated markers in a hash table. All its updates are
done when the markers_mutex is held, so there is no memory ordering
issues related to its updates.

This structure is used as an information source when we update the
markers sites with correct memory ordering by set_marker() and
disable_marker().


> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  marker.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff -urpNa -X dontdiff linux-2.6.26-rc4/kernel/marker.c linux-2.6.26-rc4-marker-srbd/kernel/marker.c
> --- linux-2.6.26-rc4/kernel/marker.c	2008-05-30 04:39:01.000000000 -0700
> +++ linux-2.6.26-rc4-marker-srbd/kernel/marker.c	2008-05-30 05:05:55.000000000 -0700
> @@ -133,8 +133,8 @@ void marker_probe_cb(const struct marker
>  		 * data. Same as rcu_dereference, but we need a full smp_rmb()
>  		 * in the fast path, so put the explicit barrier here.
>  		 */
> -		smp_read_barrier_depends();

Actually, this barrier should make sure mdata->ptype is read before
mdata->multi. This should be changed to a smp_rmb(), given they are not
dependant. The comment about this barrier should be changed.

>  		multi = mdata->multi;
> +		smp_read_barrier_depends();

Yes. This should be added. mdata->multi must be read before the multi[i]
elements. The comment which applied to the previous
smp_read_barrier_depends() should be moved down here.

>  		for (i = 0; multi[i].func; i++) {
>  			va_start(args, fmt);
>  			multi[i].func(multi[i].probe_private, call_private, fmt,
> @@ -183,8 +183,8 @@ void marker_probe_cb_noarg(const struct 
>  		 * data. Same as rcu_dereference, but we need a full smp_rmb()
>  		 * in the fast path, so put the explicit barrier here.
>  		 */

Same as above here.

> -		smp_read_barrier_depends();
>  		multi = mdata->multi;
> +		smp_read_barrier_depends();
>  		for (i = 0; multi[i].func; i++)
>  			multi[i].func(multi[i].probe_private, call_private, fmt,
>  				&args);
> @@ -271,6 +271,7 @@ marker_entry_add_probe(struct marker_ent
>  	new[nr_probes].func = probe;
>  	new[nr_probes].probe_private = probe_private;
>  	entry->refcount = nr_probes + 1;
> +	smp_wmb(); /* Ensure struct is initialized before publication. *

This function only updates the struct marker_entry, protected by the
markers_mutex. The memory ordering constraints comes when we later call

marker_update_probes
  marker_update_probe_range
    set_marker
    or
    disable_marker

If we look at set_marker and disable_marker, they have smp_wmb() to
order each memory write. See the ----> arrow for the wmb which makes
sure the array data is written before the array pointer.
This wmb is in rcu_assign_pointer.

Snippet from set_marker :

        elem->call = (*entry)->call;
        /*
         * Sanity check :
         * We only update the single probe private data when the ptr is
         * set to a _non_ single probe! (0 -> 1 and N -> 1, N != 1)
         */
        WARN_ON(elem->single.func != __mark_empty_function
                && elem->single.probe_private
                != (*entry)->single.probe_private &&
                !elem->ptype);
        elem->single.probe_private = (*entry)->single.probe_private;
        /*
         * Make sure the private data is valid when we update the
         * single probe ptr.
         */
        smp_wmb();
        elem->single.func = (*entry)->single.func;
        /*
----->   * We also make sure that the new probe callbacks array is consistent
         * before setting a pointer to it.
         */
        rcu_assign_pointer(elem->multi, (*entry)->multi);
        /*
         * Update the function or multi probe array pointer before setting the
         * ptype.
         */
        smp_wmb();
        elem->ptype = (*entry)->ptype;
        elem->state = active;

Snippet from disable_marker :
        /* leave "call" as is. It is known statically. */
        elem->state = 0;
        elem->single.func = __mark_empty_function;
        /* Update the function before setting the ptype */
        smp_wmb();
        elem->ptype = 0;        /* single probe */
        /*
         * Leave the private data and id there, because removal is racy and
         * should be done only after an RCU period. These are never used until
         * the next initialization anyway.
         */

Does it clarify things a bit ?

Here is the updated patch :

Fix marker barriers

Paul pointed out two incorrect read barriers in the marker handler code in the
path where multiple probes are connected. Those are ordering reads of "ptype"
(single or multi probe marker), "multi" array pointer, and "multi" array data
access.

It should be ordered like this :

read ptype
smp_wmb()
read multi array pointer
smp_read_barrier_depends()
access data referenced by multi array pointer

The code with a single probe connected (optimized case, does not have to
allocate an array) has correct memory ordering.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
---
 kernel/marker.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/kernel/marker.c
===================================================================
--- linux-2.6-lttng.orig/kernel/marker.c	2008-05-30 06:08:53.000000000 -0400
+++ linux-2.6-lttng/kernel/marker.c	2008-05-30 06:10:43.000000000 -0400
@@ -127,6 +127,11 @@
 		struct marker_probe_closure *multi;
 		int i;
 		/*
+		 * Read mdata->ptype before mdata->multi.
+		 */
+		smp_wmb();
+		multi = mdata->multi;
+		/*
 		 * multi points to an array, therefore accessing the array
 		 * depends on reading multi. However, even in this case,
 		 * we must insure that the pointer is read _before_ the array
@@ -134,7 +139,6 @@
 		 * in the fast path, so put the explicit barrier here.
 		 */
 		smp_read_barrier_depends();
-		multi = mdata->multi;
 		for (i = 0; multi[i].func; i++) {
 			va_start(args, fmt);
 			multi[i].func(multi[i].probe_private, call_private, fmt,
@@ -177,6 +181,11 @@
 		struct marker_probe_closure *multi;
 		int i;
 		/*
+		 * Read mdata->ptype before mdata->multi.
+		 */
+		smp_wmb();
+		multi = mdata->multi;
+		/*
 		 * multi points to an array, therefore accessing the array
 		 * depends on reading multi. However, even in this case,
 		 * we must insure that the pointer is read _before_ the array
@@ -184,7 +193,6 @@
 		 * in the fast path, so put the explicit barrier here.
 		 */
 		smp_read_barrier_depends();
-		multi = mdata->multi;
 		for (i = 0; multi[i].func; i++)
 			multi[i].func(multi[i].probe_private, call_private, fmt,
 				&args);

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
