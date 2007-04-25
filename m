Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbXDYWCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbXDYWCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 18:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbXDYWCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 18:02:41 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59278 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbXDYWCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 18:02:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem mappings
References: <20070414204154.871250608@goop.org>
	<200704192250.52633.ak@suse.de> <4627D756.5020405@zytor.com>
	<200704192304.01053.ak@suse.de> <4627DB0C.2010804@zytor.com>
	<4627DDAD.4070805@redhat.com> <4627E099.209@goop.org>
	<m1abwwqiof.fsf@ebiederm.dsl.xmission.com> <462FC8CD.1030505@goop.org>
Date: Wed, 25 Apr 2007 16:00:35 -0600
In-Reply-To: <462FC8CD.1030505@goop.org> (Jeremy Fitzhardinge's message of
	"Wed, 25 Apr 2007 14:31:57 -0700")
Message-ID: <m11wi8qflo.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Eric W. Biederman wrote:
>> Jeremy did your kernel have PAE enabled?
>>
>> It just occurred to me that we have at all of the memory below 1M (say about
>> 512K) mapped and available to setup new mappings.
>>
>> The only way I can see a page fault happening is if you were using a PAE
>> enabled kernel (so you were not updating the current page tables) and
>> you have more than 256M of low memory, and we don't get any much extra
>> from always mapping 4M at a time.
>
> Yes, that's the situation.  PAE enabled, ~768MB of memory and a large
> kernel which mostly fills the 8M mapping.

And it just occurred to me PSE disabled, otherwise you would not have
needed more than 4 pages.  I supposed you were testing the Xen case.

That said I know for certain now why we have never seen this in
production because all cpus that fit this configuration also support
PSE.

So the way I think we should properly fix this is:
- Enable PAE early so we are updating our current page table.
- Pass a limit to the bootmem allocator so we do not get pages
  pass the point where we have setup page tables.
- Handle memory allocation failures.

However only the first part is necessary to solve the problem,
in practice even if you are using 4K pages.

Eric
