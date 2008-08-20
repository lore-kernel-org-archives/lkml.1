Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbYHTIqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbYHTIqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 04:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYHTIqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 04:46:13 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:24558 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbYHTIqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 04:46:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jOsmU85C18hx24oQ0rjxZ9ekmwRpHYskNtOrUIf/o7ZoeJzqoErD8mAN6JgY+koRlD
         rzUT4z6BBjBl6cuImHaQoj0sl9Q8HoRTm1DuNy8eOuTg423C+6jgczxp2UMA1tIwp+sg
         4uyjkefN1sVpRLf9s8nNZo9Yj0EUcy2Ca1YdY=
Message-ID: <45a44e480808200146m1167b8e6o74d68324ad138dc5@mail.gmail.com>
Date: Wed, 20 Aug 2008 04:46:08 -0400
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] fbdefio: add set_page_dirty handler to deferred IO FB
Cc: "Ian Campbell" <ijc@hellion.org.uk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       stable@vger.kernel.org, "Nick Piggin" <npiggin@suse.de>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Hugh Dickins" <hugh@veritas.com>,
       "Johannes Weiner" <hannes@saeurebad.de>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Kel Modderman" <kel@otaku42.de>,
       "Markus Armbruster" <armbru@redhat.com>
In-Reply-To: <20080818233824.5d219105.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219125765-31833-1-git-send-email-ijc@hellion.org.uk>
	 <20080818233824.5d219105.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 2:38 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 19 Aug 2008 07:02:45 +0100 Ian Campbell <ijc@hellion.org.uk> wrote:
>
>> +static int fb_deferred_io_set_page_dirty(struct page *page)
>> +{
>> +     if (!PageDirty(page))
>> +             SetPageDirty(page);
>> +     return 0;
>> +}
>
> <searches, finds the thread.  "kernel BUG at lib/radix-tree.c:473!">
>
> Is there actually any benefit in setting these pages dirty?  Or should
> this be an empty function?  I see claims in the above thread that this
> driver uses PG_dirty for optimising writeback but I can't immediately
> locate any code which actually does that.

Hi Andrew,

I hope I have understood your question. You are right that PG_dirty
isn't used directly in defio. The defio portion does use each
page_mkwrite callback to build a list of the pages of the framebuffer
that were written to and then passes that list to pvfb (in this case).
pvfb then optimizes writeback by interpreting that list according to
its framebuffer and sending it to its actual destination. I think
Markus's code in xenfb_deferred_io() and xenfb_send* is doing the
latter.

>
> I suspect that we just shouldn't be pretending that this is a regular
> anon/pagecache page to this extent.  Maybe a suitable fix would be to
> teach fb_deferred_io_fault() to instantiate the pte itself
> (vm_insert_page()) and then return VM_FAULT_NOPAGE?
>

Ok, I haven't understood all the details of vm_insert_page() yet. I
noticed Peter's message that this won't work with page_mkclean (which
I need to do so that we can re-receive fault notification after the
driver has done writeback). I see your remark and Ian's that it would
be better to try to do the mapping and a_ops setup at open time. I
think I have some ideas of how to do this without breaking fb code
much. I will try to work on this issue this weekend. I'm sorry that
I'm so slow.

Thanks,
jaya
