Return-Path: <linux-kernel-owner+w=401wt.eu-S1760987AbXJPDPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760987AbXJPDPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 23:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbXJPDPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 23:15:35 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55159 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbXJPDPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 23:15:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH resend] ramdisk: fix zeroed ramdisk pages on memory pressure
References: <200710151028.34407.borntraeger@de.ibm.com>
	<200710160006.19735.nickpiggin@yahoo.com.au>
	<20071015021624.7d5233bd.akpm@linux-foundation.org>
	<200710160123.32434.nickpiggin@yahoo.com.au>
Date: Mon, 15 Oct 2007 21:14:39 -0600
In-Reply-To: <200710160123.32434.nickpiggin@yahoo.com.au> (Nick Piggin's
	message of "Tue, 16 Oct 2007 01:23:32 +1000")
Message-ID: <m1zlyjiwdc.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> On Monday 15 October 2007 19:16, Andrew Morton wrote:
>> On Tue, 16 Oct 2007 00:06:19 +1000 Nick Piggin <nickpiggin@yahoo.com.au> 
> wrote:
>> > On Monday 15 October 2007 18:28, Christian Borntraeger wrote:
>> > > Andrew, this is a resend of a bugfix patch. Ramdisk seems a bit
>> > > unmaintained, so decided to sent the patch to you :-).
>> > > I have CCed Ted, who did work on the code in the 90s. I found no
>> > > current email address of Chad Page.
>> >
>> > This really needs to be fixed...
>>
>> rd.c is fairly mind-boggling vfs abuse.
>
> Why do you say that? I guess it is _different_, by necessity(?)
> Is there anything that is really bad?

make_page_uptodate() is most hideous part I have run into.
It has to know details about other layers to now what not
to stomp.  I think my incorrect simplification of this is what messed
things up, last round.

> I guess it's not nice
> for operating on the pagecache from its request_fn, but the
> alternative is to duplicate pages for backing store and buffer
> cache (actually that might not be a bad alternative really).

Cool. Triple buffering :)  Although I guess that would only
apply to metadata these days.   Having a separate store would
solve some of the problems, and probably remove the need
for carefully specifying the ramdisk block size.  We would
still need the magic restictions on page allocations though
and it we would use them more often as the initial write to the
ramdisk would not populate the pages we need.

A very ugly bit seems to be the fact that we assume we can
dereference bh->b_data without any special magic which
means the ramdisk must live in low memory on 32bit machines.

Eric
