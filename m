Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbXD0FEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbXD0FEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 01:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755315AbXD0FEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 01:04:00 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44108 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbXD0FD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 01:03:58 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Zachary Amsden <zach@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: For debugging, make the initial page table setup less forgiving.
References: <200704132149.l3DLnvUY012097@tazenda.hos.anvin.org>
	<20070425044813.f83dde4e.akpm@linux-foundation.org>
	<462F73A0.40003@zytor.com> <m1irbks5qa.fsf@ebiederm.dsl.xmission.com>
	<462F9B64.3020107@goop.org> <m1wt00qnwg.fsf@ebiederm.dsl.xmission.com>
	<462FD179.6070802@goop.org> <m1ps5sozt6.fsf@ebiederm.dsl.xmission.com>
	<462FDF6D.8050903@goop.org> <m13b2oow70.fsf@ebiederm.dsl.xmission.com>
	<462FEEFC.6030401@goop.org>
Date: Thu, 26 Apr 2007 23:02:53 -0600
In-Reply-To: <462FEEFC.6030401@goop.org> (Jeremy Fitzhardinge's message of
	"Wed, 25 Apr 2007 17:14:52 -0700")
Message-ID: <m11wi6jtoi.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

>> I suspect what we want to do is come up with a function to call
>> to test to see if a page should be read-only and map such pages
>> _PAGE_KERNEL_RO, or _PAGE_KERNEL_RO_EXEC if it's code.
>>   
>
> Hm, I think that's a hard function to write in general. For the special
> case of pagetable_init it wouldn't be too hard, but it doesn't seem like
> a big improvement over the current state of affairs.


There is some difficulty there, and I need to look at the issue some more
but it just occurred to me that this problem of tracking special permissions
on pages is not confined to Xen.

Currently for pages we need to have a consistent global view if a pages
is uncached, write-combining or cached.  We need a way to check this so
that we don't get inconsistencies in how we are caching pages, when
we start controlling this on a per page basis.

Currently we are not doing this and it is blocking merging of PAT
write-combining support in the kernel because of the bad things
(silent data corruption and general cpu undefined behavior) that can
happen if we don't handling things consistently.

I don't know if we can solve the two problems with the same mechanism
but it is worth looking into.

Especially if what we do is just add support for marking some pages
as read-only.  We could use that ensuring there are no writable
mappings of the kernel's text segment for example.

Eric
