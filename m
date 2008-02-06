Return-Path: <linux-kernel-owner+w=401wt.eu-S1762612AbYBFW4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762612AbYBFW4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 17:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758100AbYBFWz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 17:55:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757978AbYBFWz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 17:55:57 -0500
Message-ID: <47AA3AF7.7020609@redhat.com>
Date: Wed, 06 Feb 2008 16:55:51 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] reduce large do_mount stack usage with noinlines
References: <47AA3126.8090102@redhat.com> <20080206143457.03e8741d.akpm@linux-foundation.org>
In-Reply-To: <20080206143457.03e8741d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> Does the patch actually help?  I mean, if a() calls b() and both use N
> bytes of locals, our worst-case stack usage remains ~2N whether or not b()
> was inlined in a()?  In fact, uninlining makes things a little worse due to
> callframe stuff.

I think it does.

[linux-2.6.24-mm1]$ make fs/namespace.o > /dev/null
[linux-2.6.24-mm1]$ objdump -d fs/namespace.o | scripts/checkstack.pl
x86_64 | grep do_mount
0x00002307 do_mount [namespace.o]:                      616
[linux-2.6.24-mm1]$ quilt push
Applying patch patches/do_mount_stack
patching file fs/namespace.c

Now at patch patches/do_mount_stack
[linux-2.6.24-mm1]$ make fs/namespace.o > /dev/null
[linux-2.6.24-mm1]$ objdump -d fs/namespace.o | scripts/checkstack.pl
x86_64 | grep do_mount
0x00002a8b do_mount [namespace.o]:                      168

So clearly that one function is reduced.  But it's more than that....

I guess the problem is a() calls b() or c() or d() or e() or f(), and
gcc adds up all that stack usage, or seems to, and we get more like 6N
regardless of the path taken.

For example, 2 of the helper functions, once un-inlined, are:

0x00001fd9 do_move_mount [namespace.o]:                 288
0x00001e94 do_loopback [namespace.o]:                   168

so it looks like we do carry that baggage even if we go the
do_new_mount() path for example.

>> -static int do_change_type(struct nameidata *nd, int flag)
>> +static noinline int do_change_type(struct nameidata *nd, int flag)
> 
> There's no way for the reader to work out why this is here, so I do think
> it should be commented somewhere.

Ok, good point, will resend... want a comment on each, or perhaps above
do_mount?  I suppose on each.

-Eric
