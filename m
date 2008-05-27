Return-Path: <linux-kernel-owner+w=401wt.eu-S1757246AbYE0IWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbYE0IWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 04:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755779AbYE0IWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 04:22:01 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45434 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645AbYE0IV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 04:21:59 -0400
Date: Tue, 27 May 2008 13:52:42 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Srinivasa D S <srinivasa@in.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mhiramat@redhat.com, jkenisto@us.ibm.com, srikar@linux.vnet.ibm.com
Subject: Re: [RFC] [PATCH] To improve kretprobe scalability
Message-ID: <20080527082242.GA3473@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <200805210632.17655.srinivasa@in.ibm.com> <20080521163235.0fcb39ed.akpm@linux-foundation.org> <200805221356.40098.srinivasa@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805221356.40098.srinivasa@in.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 01:56:39PM +0530, Srinivasa D S wrote:
> On Thursday 22 May 2008 05:02:35 am Andrew Morton wrote:
> > On Wed, 21 May 2008 06:32:17 +0530
> >
> > Srinivasa D S <srinivasa@in.ibm.com> wrote:

...
 
> Resending the patch, Again
> 
> 
> Currently list of kretprobe instances are stored in kretprobe object (as
> used_instances,free_instances) and in kretprobe hash table. We have one 
> global kretprobe lock to serialise the access to these lists. This causes 
> only one kretprobe handler to execute at a time. Hence affects system 
> performance, particularly on SMP systems and when return probe is set on
> lot of functions (like on all systemcalls).
> 
> Solution proposed here gives fine-grain locks that performs better on SMP
> system compared to present kretprobe implementation.
> 
> Solution:
>    1) Instead of having one global lock to protect kretprobe instances  
> present 
> in kretprobe object and kretprobe hash table. We will have two locks, one lock
> for protecting kretprobe hash table and another lock for kretporbe object.
> 	
>   2) We hold lock present in kretprobe object while we modify kretprobe 
> instance in
> kretprobe object and we hold per-hash-list lock while modifying kretprobe 
> instances 
> present in that hash list. To prevent deadlock, we never grab a per-hash-list
> lock while holding a kretprobe lock.
> 
>   3) We can remove used_instances from struct kretprobe, as we can track used
> instances of kretprobe instances using kretprobe hash table.
> 
> Time duration for  kernel compilation ("make -j 8") on a 8-way ppc64 system
> with return probes set on all systemcalls looks like this.
> 
> cacheline              non-cacheline             Un-patched kernel 
> aligned patch 	       aligned patch                            
> ===============================================================================
> real    9m46.784s       9m54.412s                  10m2.450s   
> user    40m5.715s       40m7.142s                  40m4.273s 
> sys     2m57.754s       2m58.583s                  3m17.430s                            
> ===========================================================
> 
> Time duration for kernel compilation ("make -j 8) on the same system, when 
> kernel is not probed.
> =========================
> real    9m26.389s
> user    40m8.775s
> sys     2m7.283s
> =========================
> 
> Please let me know your comments on the patch attached here.
> 
> Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com>
> Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
