Return-Path: <linux-kernel-owner+w=401wt.eu-S1755831AbYHTM3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbYHTM3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 08:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbYHTM3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 08:29:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840AbYHTM3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 08:29:19 -0400
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Ian Campbell" <ijc@hellion.org.uk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       stable@vger.kernel.org, "Nick Piggin" <npiggin@suse.de>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Hugh Dickins" <hugh@veritas.com>,
       "Johannes Weiner" <hannes@saeurebad.de>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Kel Modderman" <kel@otaku42.de>
Subject: Re: [PATCH] fbdefio: add set_page_dirty handler to deferred IO FB
References: <1219125765-31833-1-git-send-email-ijc@hellion.org.uk>
	<20080818233824.5d219105.akpm@linux-foundation.org>
	<45a44e480808200146m1167b8e6o74d68324ad138dc5@mail.gmail.com>
From: Markus Armbruster <armbru@redhat.com>
Date: Wed, 20 Aug 2008 08:27:33 -0400
In-Reply-To: <45a44e480808200146m1167b8e6o74d68324ad138dc5@mail.gmail.com> (Jaya Kumar's message of "Wed\, 20 Aug 2008 04\:46\:08 -0400")
Message-ID: <m3bpznan2i.fsf@crossbow.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jaya Kumar" <jayakumar.lkml@gmail.com> writes:

> On Tue, Aug 19, 2008 at 2:38 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> On Tue, 19 Aug 2008 07:02:45 +0100 Ian Campbell <ijc@hellion.org.uk> wrote:
>>
>>> +static int fb_deferred_io_set_page_dirty(struct page *page)
>>> +{
>>> +     if (!PageDirty(page))
>>> +             SetPageDirty(page);
>>> +     return 0;
>>> +}
>>
>> <searches, finds the thread.  "kernel BUG at lib/radix-tree.c:473!">
>>
>> Is there actually any benefit in setting these pages dirty?  Or should
>> this be an empty function?  I see claims in the above thread that this
>> driver uses PG_dirty for optimising writeback but I can't immediately
>> locate any code which actually does that.
>
> Hi Andrew,
>
> I hope I have understood your question. You are right that PG_dirty
> isn't used directly in defio. The defio portion does use each
> page_mkwrite callback to build a list of the pages of the framebuffer
> that were written to and then passes that list to pvfb (in this case).
> pvfb then optimizes writeback by interpreting that list according to
> its framebuffer and sending it to its actual destination. I think
> Markus's code in xenfb_deferred_io() and xenfb_send* is doing the
> latter.

Exactly.  xenfb_deferred_io() is the callback that receives the list
of pages that have been dirtied from fb_deferred_io_work().  It
computes a rectangle covering all these pages, and passes it to
xenfb_refresh().  Which takes care of sending it to the backend.

[...]
