Return-Path: <linux-kernel-owner+w=401wt.eu-S1161010AbXEDFDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161010AbXEDFDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 01:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031356AbXEDFDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 01:03:46 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031353AbXEDFDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 01:03:45 -0400
Date: Thu, 3 May 2007 22:03:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ken Chen" <kenchen@google.com>
Cc: "Paul Jackson" <pj@sgi.com>, linux-kernel@vger.kernel.org, agl@us.ibm.com,
       hermes@gibson.dropbear.id.au, wli@holomorphy.com, clameter@sgi.com
Subject: Re: + per-cpuset-hugetlb-accounting-and-administration.patch added
 to -mm tree
Message-Id: <20070503220331.8fd70ca5.akpm@linux-foundation.org>
In-Reply-To: <b040c32a0705032149t2a380f82t8145c1d0f8f6736@mail.gmail.com>
References: <200705040104.l4414YFR026322@shell0.pdx.osdl.net>
	<20070503183821.b75e8f57.pj@sgi.com>
	<b040c32a0705032149t2a380f82t8145c1d0f8f6736@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007 21:49:12 -0700 "Ken Chen" <kenchen@google.com> wrote:

> On 5/3/07, Paul Jackson <pj@sgi.com> wrote:
> > Adding Christoph Lameter <clameter@sgi.com> to the cc list, as he knows
> > more about hugetlb pages than I do.
> >
> > This patch strikes me as a bit odd.
> >
> > Granted, it's solving what could be a touchy problem with a fairly
> > simple solution, which is usually a Good Thing(tm).
> >
> > However, the idea that different tasks would see different values for
> > the following fields in /proc/meminfo:
> >
> >         HugePages_Total:     0
> >         HugePages_Free:      0
> >
> > strikes me as odd, and risky.  I would have thought that usually, all
> > tasks in the system should see the same values in the files in /proc
> > (as opposed to the files in particular task subdirectories /proc/<pid>.)
> >
> > This patch strikes me as a bit of a hack, good for compatibility, but
> > hiding a booby trap that will bite some user code in the long run.
> >
> > But I'm not enough of an expert to know what the right tradeoffs are
> > in this matter.
> 
> Would annotating the Hugepages_* field with name of cpuset help?

There are existing programs which parse /proc/meminfo.  If we're going to
do any of this then it would need to be via new fields.

I don't think we should be altering the meaning of the HugePages fields
like this.  One can imagine scenarios in which such a change would cause
existing userspace scripts to fail.  Plus it's Just Weird to use
/proc/meminfo in this manner.

>  I
> orginally thought that since cpuset's mems are hirearchical in memory
> assignment, it is fairly straightforward to understand what's going
> on: parent cpuset stats include its and all of its children.  For
> example, if root cpuset has two sub job1 and job2 cpusets, each has 20
> and 30 htlb pages, when query at each level, we have:
> 
> [root@box]# echo $$ > /dev/cpuset/tasks
> [root@box]# grep HugePages_Total /proc/meminfo
> HugePages_Total:    50
> 
> [root@box]# echo $$ > /dev/cpuset/job1/tasks
> [root@box]# grep HugePages_Total /proc/meminfo
> HugePages_Total:    20
> 
> [root@box]# echo $$ > /dev/cpuset/job2/tasks
> [root@box]# grep HugePages_Total /proc/meminfo
> HugePages_Total:    30
> 
> If this is odd, do you have any suggestions for alternative?

If it's per-cpuset information then shouldn't it be presented in
/dev/cpuset/something?

