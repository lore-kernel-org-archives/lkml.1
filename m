Return-Path: <linux-kernel-owner+w=401wt.eu-S1759696AbZDOL0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696AbZDOL0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 07:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759339AbZDOL02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 07:26:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57343 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759536AbZDOL0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 07:26:25 -0400
Date: Wed, 15 Apr 2009 13:25:11 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, linux-mm@kvack.org, avi@redhat.com,
       chrisw@redhat.com, mtosatti@redhat.com, hugh@veritas.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 3/4] add replace_page(): change the page pte is
	pointing to.
Message-ID: <20090415112511.GH9809@random.random>
References: <1239249521-5013-1-git-send-email-ieidus@redhat.com> <1239249521-5013-2-git-send-email-ieidus@redhat.com> <1239249521-5013-3-git-send-email-ieidus@redhat.com> <1239249521-5013-4-git-send-email-ieidus@redhat.com> <20090414150925.58b464f7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414150925.58b464f7.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 03:09:25PM -0700, Andrew Morton wrote:
> On Thu,  9 Apr 2009 06:58:40 +0300
> Izik Eidus <ieidus@redhat.com> wrote:
> 
> > replace_page() allow changing the mapping of pte from one physical page
> > into diffrent physical page.
> 
> At a high level, this is very similar to what page migration does.  Yet
> this implementation shares nothing with the page migration code.
> 
> Can this situation be improved?

This was discussed last time too. Basically the thing is that using
migration entry with its special page fault paths, for this looks a
bit of an overkill complexity and unnecessary dependency on the
migration code. All we need is to mark the pte readonly. replace_page
is a no brainer then. The brainer part is page_wrprotect
(page_wrprotect is like fork).

The data visibility in the final memcmp you mentioned in the other
mail is supposedly taken care of by page_wrprotect too. It already
does flush_cache_page for the virtual indexed and not physically
tagged caches. page_wrprotect has to also IPI all CPUs to nuke any not
wrprotected tlb entry. I don't think we need further smp memory
barriers when we're guaranteed all tlb entries are wrprotected in the
other cpus and an IPI and invlpg run in them, to be sure we read the
data stable during memcmp even if we read through the kernel
pagetables and the last userland write happened through userland ptes
before they become effective wrprotected by the IPI.
