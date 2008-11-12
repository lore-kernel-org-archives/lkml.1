Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbYKLC1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbYKLC1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 21:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYKLC1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 21:27:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36017 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbYKLC1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 21:27:07 -0500
Date: Wed, 12 Nov 2008 03:27:01 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
       chrisw@redhat.com, avi@redhat.com, izike@qumranet.com
Subject: Re: [PATCH 2/4] Add replace_page(), change the mapping of pte from
	one page into another
Message-ID: <20081112022701.GT10818@random.random>
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com> <1226409701-14831-2-git-send-email-ieidus@redhat.com> <1226409701-14831-3-git-send-email-ieidus@redhat.com> <20081111114555.eb808843.akpm@linux-foundation.org> <20081111210655.GG10818@random.random> <Pine.LNX.4.64.0811111522150.27767@quilx.com> <20081111221753.GK10818@random.random> <Pine.LNX.4.64.0811111626520.29222@quilx.com> <20081111231722.GR10818@random.random> <Pine.LNX.4.64.0811111823030.31625@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811111823030.31625@quilx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 06:27:09PM -0600, Christoph Lameter wrote:
> Then page migration will not occur because there is an unresolved
> reference.

So are you checking if there's an unresolved reference only in the
very place I just quoted in the previous email? If answer is yes: what
should prevent get_user_pages from running in parallel from another
thread? get_user_pages will trigger a minor fault and get the elevated
reference just after you read page_count. To you it looks like there
is no o_direct in progress when you proceed to the core of migration
code, but in effect o_direct just started a moment after you read the
page count.

What can protect you is PG lock or mmap_sem in _write_ mode (and
they've to be hold for the whole duration of the migration). I don't
see any of the two being hold while you read the page count... You
don't seem to be using stop_machine either (stop_machine pretty
expensive on the 4096 way I guess).

This wasn't reproduced in practice but it should be possible to
reproduce it by just writing a testcase with three threads, one forks
in a loop (child just quit) the other memset 0 the first 512bytes of a
page, and then o_direct read from a 0xff 512byte region and checks
that the first 512bytes are all non-zero in a loop, and the third
writes 1 byte to the last 512bytes of the page in a loop. Eventually
the comparison should show zero data in the page.

To reproduce with migration just start the thread that memset 0, reads
a 0xff region with o_direct, and checks it's all 0xff in a loop, and
then migrate the memory of this thread back and forth between two
nodes with the sys_move_pages (mpol is safe by luck because it
surrounds migrate_pages with the mmap_sem in write mode). Eventually
you should see zero bytes despite I/O is complete.

Reproducing this is normal life would take time and for the fork bug
it may not be reproducible depending of what the app is doing. Mixing
sys_move_pages with o_direct in the same process with on two different
threads, instead should eventually eventually reproduce it. And with
gup_fast is now unfixable until more infrastructure is added to
slowdown gup_fast a bit (unless Nick finds an RCU way of doing it).
