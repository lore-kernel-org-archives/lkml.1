Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbYGJTsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbYGJTsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbYGJTr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:47:57 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:45401 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbYGJTr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:47:57 -0400
Subject: Re: Checkpoint/restart (was Re: [PATCH 0/4] - v2 - Object creation
	with a specified id)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Oren Laadan <orenl@cs.columbia.edu>,
       Kirill Korotaev <dev@parallels.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Nadia.Derbey@bull.net, Andrew Morton <akpm@linux-foundation.org>,
       nick@nick-andrew.net, Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <m14p6xy27s.fsf@frodo.ebiederm.org>
References: <20080418054459.891481000@bull.net>
	 <20080422193612.GA15835@martell.zuzino.mipt.ru>
	 <1208890580.17117.14.camel@nimitz.home.sr71.net>
	 <20080422210130.GA15937@martell.zuzino.mipt.ru>
	 <1208904967.17117.51.camel@nimitz.home.sr71.net>
	 <480ED9D5.1010906@parallels.com> <480FE037.2010302@cs.columbia.edu>
	 <m1y74a7b4w.fsf@frodo.ebiederm.org> <1215709949.9398.15.camel@nimitz>
	 <20080710173246.GA1857@us.ibm.com> <m163rd1sd5.fsf@frodo.ebiederm.org>
	 <1215716794.9398.41.camel@nimitz>  <m14p6xy27s.fsf@frodo.ebiederm.org>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 12:47:32 -0700
Message-Id: <1215719252.9398.53.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-10 at 12:21 -0700, Eric W. Biederman wrote:
> > Are we talking about the VMA itself, or the memory backing the VMA?
> 
> The memory backing the VMA.  We need to store the page protections
> that the memory was mapped with as well now that you point it out.  A
> VMA is not user space visible, which is why we can arbitrarily split
> and merge VMAs.

It is visible with /proc/$pid/{maps,smaps,numamaps?}.  That's the only
efficient way I know of from userspace to figure out where userspace's
memory is and if it *is* file backed, and what the permissions are.

We also can't truly split them arbitrarily because the memory cost of
the VMAs themselves might become too heavy (the remap_file_pages()
problem).

It gets trickier when things are also private mappings in addition to
being in a file-backed VMA.  We *do* need to checkpoint those, but only
the pages to which there was a write.

There's also the problem of restoring things read-only, but VM_MAYWRITE.
If there's a high level of (non-COW'd) sharing of these anonymous areas,
we may not be able to even restore the set of processes unless we can
replicate the sharing.  We might run out of memory if the sharing isn't
replicated.

Memory is fun! :)

-- Dave

