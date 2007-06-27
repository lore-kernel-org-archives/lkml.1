Return-Path: <linux-kernel-owner+w=401wt.eu-S1762367AbXF0Rnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762367AbXF0Rnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756361AbXF0Rnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:43:39 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:44400 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbXF0Rni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:43:38 -0400
Date: Wed, 27 Jun 2007 18:43:02 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Davide Libenzi <davidel@xmailserver.org>, blaisorblade@yahoo.it,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/3] MAP_NOZERO - implement sys_brk2()
In-Reply-To: <a36005b50706271001o191f3e24n83b25988739429fb@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706271807330.22337@blonde.wat.veritas.com>
References: <send-serie.davidel@xmailserver.org.29496.1182912260.2> 
 <a36005b50706262048y5eb8ba80kb0d852d649d1ac10@mail.gmail.com> 
 <Pine.LNX.4.64.0706262052060.26540@alien.or.mcafeemobile.com> 
 <a36005b50706262202w4aaa4494qc2322e49c71d8d7c@mail.gmail.com> 
 <Pine.LNX.4.64.0706271309500.26951@blonde.wat.veritas.com>
 <a36005b50706271001o191f3e24n83b25988739429fb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABGluYm94AGJsYWlzb3JibGFkZUB5YWhvby5pdABkYXZpZGVsQHhtYWlsc2VydmVyLm9yZwBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnAGRyZXBwZXJAZ21haWwuY29tAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007, Ulrich Drepper wrote:
> On 6/27/07, Hugh Dickins <hugh@veritas.com> wrote:
> > Not so: if an mmap can be done by extending either adjacent vma (prot
> > and flags and file and offset all match up), that's what's done and no
> > separate vma is created.  (And adjacent vmas get merged when mprotect
> > removes the difference in protection.)
> 
> mmap return values are randomized.  If they would be mergable
> something would be wrong.

The absolute virtual addresses are randomized, yes; but do a sequence
of mmaps and they come back adjacent to each other, and so mergable.
Or does your distro include a kernel patch to randomize them relative
to each other?

> > I don't think there's any such reason to prefer brk to mmap.
> 
> Talk to the Quadrics people.  Some of their interconnect adapters
> incur significant costs with separate VMAs.
> 
> > Please let me know if you've a test case which shows more vmas than
> > expected.
> 
> Not related to this, but we already have "too many" VMAs for some
> definition of "too many".  Since we split VMA when the protection
> changes each thread stack consists at least of two VMA (three for
> ia64).  There was an approach at some point to push the access flags
> down and allow VMAs to stretch further.  Why was this deemed
> unsuitable?

Blaisorblade's patch, yes.  I disliked it at the time I reviewed
it a couple of years back: it made a system call many of us regret
even nastier, and relied on tiresome per-arch pagetable encodings.
It seemed likely to cause us trouble down the line - though
undoubtedly it provides real benefits too.

I never found time to review it when it came around again recently,
thought Blaisorblade might prefer me to turn a blind eye to it ;)
and let others opine instead.  But I think noone else found time to
review it either.  I expect it's rather nicer now, but doubt it's
actually attractive.

It _might_ turn out to be more attractive, not to rely on that
peculiar sys_remap_file_pages, but make all our vmas independent
of protections, and hang differently protected ranges off them.
Maybe.

> It could have quite a bit with situations with many
> threads (Java).  As I've told back when this came up, we had one
> customer where the VMA lookup actually showed up in profiles.

In honesty, I should add that I dislike and distrust Davide's
MAP_NOZERO very much indeed!  Would much rather leave my cpus
spending a little time in clear_page().  A uid in struct page
(though I'm sure we could find somewhere to tuck it away) -
the horror, the horror!  But I've so far failed to find a killer
argument against it, and am hoping for someone else to do so.

Curmudgeonly,
Hugh
