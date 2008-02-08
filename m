Return-Path: <linux-kernel-owner+w=401wt.eu-S1762978AbYBHQup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762978AbYBHQup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 11:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758343AbYBHQug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 11:50:36 -0500
Received: from ns1.suse.de ([195.135.220.2]:42665 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757618AbYBHQug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 11:50:36 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-kernel@vger.kernel.org,
       rth@redhat.com
Subject: Re: [PATCH] reduce large do_mount stack usage with noinlines
From: Andi Kleen <andi@firstfloor.org>
References: <47AA3126.8090102@redhat.com>
	<20080206143457.03e8741d.akpm@linux-foundation.org>
	<47AA3EAA.9080204@redhat.com>
	<20080206152239.a2352d6d.akpm@linux-foundation.org>
Date: Fri, 08 Feb 2008 17:50:30 +0100
In-Reply-To: <20080206152239.a2352d6d.akpm@linux-foundation.org> (Andrew Morton's message of "Wed\, 6 Feb 2008 15\:22\:39 -0800")
Message-ID: <p73myqb2y09.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
>>   */
>> -static int do_change_type(struct nameidata *nd, int flag)
>> +static noinline int do_change_type(struct nameidata *nd, int flag)
>
> What we could do here is defined a new noinline_because_of_stack_suckiness
> and use that.  Reasons:
>
> - self-documenting, so we don't need to comment each site
>
> - can be made a no-op for suitable __GNUC__ values if gcc ever fixes this

In theory it should be already fixed; iirc Richard H. (cc'ed) added
code for this somewhere in 4.x. Don't quite remember which x, likely 
either 1 or 2.

e.g. if I do a quick test here on gcc 4.2 then it definitely
reuses stack slots between inlines. As you can see only ~100 bytes
are allocated, not ~200.

-Andi

% cat ts.c
static inline a(void)
{
	char x[100];
	extf(x);
}

static inline b(void)
{
	char y[100];
	extf(y);
}

f()
{
	a();
	b();		
}
% gcc -O2 -S ts.c
% cat ts.s
  ...
f:
.LFB4:
	pushq	%rbx
.LCFI0:
	xorl	%eax, %eax
	subq	$112, %rsp
.LCFI1:
	movq	%rsp, %rdi
	call	extf
	movq	%rsp, %rdi
	xorl	%eax, %eax
	call	extf
	addq	$112, %rsp
	popq	%rbx
	ret
...
%

