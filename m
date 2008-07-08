Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbYGHNyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbYGHNyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 09:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbYGHNyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 09:54:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210AbYGHNye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 09:54:34 -0400
Subject: Re: [PATCH] Hugetlb: stop race when reading proc meminfo
From: Eric Paris <eparis@redhat.com>
To: Adam Litke <aglitke@gmail.com>
Cc: Nish Aravamudan <nish.aravamudan@gmail.com>, wli@holomorphy.com,
       linux-kernel@vger.kernel.org, agl@us.ibm.com, akpm@linux-foundation.org
In-Reply-To: <a0a62dfc0807030713m8d94c02m7a610ef2ec2c910b@mail.gmail.com>
References: <1213899342.16752.39.camel@localhost.localdomain>
	 <29495f1d0807021551l1c934e68o3471105170ea0334@mail.gmail.com>
	 <a0a62dfc0807030713m8d94c02m7a610ef2ec2c910b@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 09:51:02 -0400
Message-Id: <1215525062.7567.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-03 at 09:13 -0500, Adam Litke wrote:
> I agree with Nish on both of his points.  While it is slightly
> inconvenient for /proc/meminfo to occasionally display hugetlb pool
> counters that, together, don't make sense, it's worth living with for
> the two reasons he stated.  These counters are for informational
> purposes only and relying upon them will already get you into trouble
> in many other ways.  We also don't want to give any user the privilege
> to mount a denial of service attack on hugetlb applications.

I'm fine with this assessment.  Andrew feel free to throw this out of
-mm and forget about it forever.

-Eric


> 
> On Wed, Jul 2, 2008 at 5:51 PM, Nish Aravamudan
> <nish.aravamudan@gmail.com> wrote:
> > On 6/19/08, Eric Paris <eparis@redhat.com> wrote:
> >> minor nit that hugetlb_report_{,node_}meminfo() does not lock the
> >>  reading of nr_huge_pages, free_huge_pages, and friends so this is not an
> >>  atomic set of information put into the buffer.  If /proc/meminfo is read
> >>  while the number of hugetlb pages is in flux it is possible to get
> >>  incorrect output such as:
> >>
> >>  HugePages_Total:     7
> >>  HugePages_Free:      8
> >>  HugePages_Rsvd:      0
> >>  Hugepagesize:     4096 kB
> >>
> >>  (test available at https://bugzilla.redhat.com/attachment.cgi?id=309864)
> >>
> >>  With the patch we beat on a number of boxes for hours with the above
> >>  test and saw no inconsistencies in the meminfo output.
> >>
> >>  Signed-off-by: Eric Paris <eparis@redhat.com>
> >
> > While I understand the spirit of this patch, I'm not sure it's really
> > necessary. We've never bothered locking the output in the proc file
> > before because the information is inherently racy. It only gives you a
> > view of what was...if any application tries to make a decision based
> > upon that information (unless it has global control of the system, or
> > is a testcase, arguably), then it is already racy -- that is, the
> > numbers you read at one point in time have no bearing on whether those
> > pages will actually be free/available, etc when you actually need
> > them.
> >
> > That being said, I don't feel to strongly about it. Just seems like it
> > might be unnecessary for an interface we know not to be fully accurate
> > to begin with, but maybe consistency is worth a bit of extra locking.
> >
> > That actually also leads me to wonder if maybe the locking is not
> > there currently to avoid letting readers of proc files from blocking
> > users of hugepages?
> >
> > Thanks,
> > Nish
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> 
> 

