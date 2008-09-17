Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYIQVq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYIQVq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 17:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbYIQVp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 17:45:57 -0400
Received: from gw.goop.org ([64.81.55.164]:35871 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592AbYIQVpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 17:45:55 -0400
Message-ID: <48D17A93.4000803@goop.org>
Date: Wed, 17 Sep 2008 14:45:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickens <hugh@veritas.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: Populating multiple ptes at fault time
References: <48D142B2.3040607@goop.org> <48D1625C.7000309@redhat.com>
In-Reply-To: <48D1625C.7000309@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:
> Is it still expensive when you're using nested page tables?

No, nested pagetables are the same as native to update, so the main
benefit in that case is the reduction of faults.

> We already have rather well-tested code in the VM to detect fault
> patterns, complete with userspace hints to set readahead policy.  It
> seems to me that if we're going to read nearby pages into pagecache,
> we might as well actually map them at the same time.  Duplicating the
> readahead code is probably a bad idea.

Right, that was my point.  I'm assuming that that machinery already
exists and would be available for use in this case.

>> Minor faults are easier; if the page already exists in memory, we should
>> just create mappings to it.  If neighbouring pages are also already
>> present, then we can can cheaply create mappings for them too.
>
> If we're mapping pagecache, then sure, this is really cheap, but
> speculatively allocating anonymous pages will hurt, badly, on many
> workloads.

OK, makes sense.  Does the access pattern detecting code measure access
patterns to anonymous mappings?

>> This seems like an obvious idea, so I'm wondering if someone has
>> prototyped it already to see what effects there are.  In the native
>> case, pte updates are much cheaper, so perhaps it doesn't help much
>> there, though it would potentially reduce the number of faults
>> needed. But I think there's scope for measurable benefits in the
>> virtual case.
>
> Sounds like something we might want to enable conditionally on the use
> of pv_ops features.

Perhaps, but I'd rather avoid it.  I'm hoping this is something we could
do that has - at worst - no effect on the native case, while improving
the virtual case.  The test matrix is already large enough without
adding another stateful switch.  After all, any side effect which makes
it a bad idea for the native case will probably be bad enough to
overwhelm any benefit in the virtual case.

    J
