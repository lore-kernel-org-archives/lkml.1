Return-Path: <linux-kernel-owner+w=401wt.eu-S932801AbXLNE0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801AbXLNE0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 23:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756937AbXLNE0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 23:26:34 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36952 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbXLNE0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 23:26:33 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: venkatesh.pallipadi@intel.com
Cc: ak@muc.de, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, akpm@linux-foundation.org,
       arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 02/12] PAT 64b: Basic PAT implementation
References: <20071213235543.568682000@intel.com>
	<20071213235711.464325000@intel.com>
	<m1d4taq6le.fsf@ebiederm.dsl.xmission.com>
Date: Thu, 13 Dec 2007 21:23:26 -0700
In-Reply-To: <m1d4taq6le.fsf@ebiederm.dsl.xmission.com> (Eric W. Biederman's
	message of "Thu, 13 Dec 2007 20:48:45 -0700")
Message-ID: <m1wsrhq4zl.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:


> We should use:
>> +		pat = PAT(0,WB) | PAT(1,WT) | PAT(2,WC) | PAT(3,UC) |
>> +		      PAT(4,WB) | PAT(5,WT) | PAT(6,WC) | PAT(7,UC);
>
> Changing the UC- which currently allows write-combining if the MTRRs specify it,
> to WC.  This grandfathers in all of our current usage and changes the one
> PAT type that could today and in legacy mode specify WC to really specify WC.
>
> I don't know if we need to set the high half or not, that would depend
> on the state of the PAT errata.
>
> I do know we need to use the low 4 pat mappings to avoid most of the PAT
> errata issues.
>
> As for Andi's concern about modules playing games with the PAT mappings
> if we don't redefine how we use the page table entries our exposure to
> badly behaved modules more limited.

Ok.  My analysis here was wrong.  Currently pgprot_noncached and
ioremap_nocache are out of sync.  With ioremap_nocache only specifying
_PAGE_PCD and pgprot_noncached specifying _PAGE_PCD | _PAGE_PWT.

So I don't have a clue how someone could reprogram the mtrrs currently
and expect things to work.

...

If we bother to ask ioremap for memory that is not cached, the last
thing in the world we want is the MTRRs upgrading that to write combining.
So ioremap_nocache has been slightly buggy for ages.  ioremap_nocache
and PAGE_KERNEL_NOCACHE should get _PAGE_PWT added to their
definitions.

Could we please get a cleanup patch at the beginning of this patchset
or that comes before it that fixes ioremap_nocache on x86?

That will make us a lot more git-bisect safe.


Eric









