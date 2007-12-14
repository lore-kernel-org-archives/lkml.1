Return-Path: <linux-kernel-owner+w=401wt.eu-S1763364AbXLNVmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763364AbXLNVmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 16:42:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbXLNVl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 16:41:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:26102 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428AbXLNVl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 16:41:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,169,1196668800"; 
   d="scan'208";a="439519725"
Date: Fri, 14 Dec 2007 13:40:27 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Roland Dreier <rdreier@cisco.com>, venkatesh.pallipadi@intel.com,
       ak@muc.de, torvalds@linux-foundation.org, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, arjan@infradead.org,
       jesse.barnes@intel.com, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 06/12] PAT 64b: Add ioremap_wc support
Message-ID: <20071214214026.GC717@linux-os.sc.intel.com>
References: <20071213235543.568682000@intel.com> <20071213235712.339088000@intel.com> <ada8x3x7vw5.fsf@cisco.com> <m1sl25q4rc.fsf@ebiederm.dsl.xmission.com> <ada4pel7v6a.fsf@cisco.com> <m1odctq3tn.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1odctq3tn.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 09:48:36PM -0700, Eric W. Biederman wrote:
> Roland Dreier <rdreier@cisco.com> writes:
> 
> >  > > Also I didn't see anything like pgprot_wc() in the patchset (although
> >
> >  > pgprot_writcombined.
> >
> > Oh I see it now (pgprot_writecombine() actually).
> >
> > However the same comment as before applies: there needs to be a
> > fallback to pgprot_noncached() for all other architectures so that
> > drivers can actually use it in a sane way.
> 
> Sounds reasonable.

We will fix it in next rev.

> It should be the conflict checking that is the actual bottleneck.
> The rest is just gravy.

Yes. We are looking for comments for our proposal to track the
reserved/non-reserved regions some what different.
This is the critical issue which had been holding off PAT for years now...

<snip from the other mails>

Change x86_64 identity map to only map non-reserved memory. This helps
to handle UC/WC mapping of reserved region in a much simple manner
(we don't have to do cpa any more, as such not keep track of the actual
reference counts. We still track all the usages to keep the mappings
consistent. We just avoid the headache of splitting mattr regions for
managing ref counts for every individual usage of the reserved area).

For now, we don't track RAM pages using memattr infrastructure. This is because,
memattr infrastructure is not enough. i.e., while the page is getting
tracked using memattr infrastructure, potentially the page can get
freed(a bug that we need to catch, to avoid attribute aliasing).
For example, a driver does ioremap_uc and an application mapped the
same page using /dev/mem. When the driver does iounamp and free the page,
/dev/mem mapping is still live and we run into aliasing issue.

Can we use the existing page struct to keep track of the attribute
and usage? /dev/mem mappings then can increment the page ref count and not
allow to free the page while the /dev/mem mappings are active. And allow
/dev/mem to map only those pages which are marked reserved (which the driver
does before doing iomap).

Or when a WB mapping through /dev/mem is active, don't allow any driver
to map the page as UC.. Can we do this tracking for RAM pages through
struct page. Or there any issues we should keep in mind..

thanks,
suresh
