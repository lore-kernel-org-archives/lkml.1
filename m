Return-Path: <linux-kernel-owner+w=401wt.eu-S1762602AbZE3UWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762602AbZE3UWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 16:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbZE3UWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 16:22:10 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:39223 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbZE3UWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 16:22:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tuDE6DmOUIuSU23aDEqma0xCdOV5B3/9jvMB7MBga23DyfaP3OPR78djJF317FNOVK
         mNtTkXQ2QYdfF5VDG8OIyK1qeR+VYIyl/cPFrBJyelUWP5sfeyQJpC89IcOsRylharrU
         O3ozzEPh+aUXZVaztiLYlbCc89FDO7//Z0RDk=
MIME-Version: 1.0
In-Reply-To: <20090530180333.GH6535@oblivion.subreption.com>
References: <4A187BDE.5070601@redhat.com>
	 <20090528072702.796622b6@lxorguk.ukuu.org.uk>
	 <20090528090836.GB6715@elte.hu>
	 <20090528125042.28c2676f@lxorguk.ukuu.org.uk>
	 <84144f020905300035g1d5461f9n9863d4dcdb6adac0@mail.gmail.com>
	 <20090530075033.GL29711@oblivion.subreption.com>
	 <4A20E601.9070405@cs.helsinki.fi>
	 <20090530082048.GM29711@oblivion.subreption.com>
	 <20090530173428.GA20013@elte.hu>
	 <20090530180333.GH6535@oblivion.subreption.com>
Date: Sat, 30 May 2009 23:22:09 +0300
X-Google-Sender-Auth: 1d03aa414c7f3a38
Message-ID: <84144f020905301322g7bbdd42cpe1391c619ffda044@mail.gmail.com>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page 
	allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Larry H." <research@subreption.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Larry,

On Sat, May 30, 2009 at 9:03 PM, Larry H. <research@subreption.com> wrote:
> The first issue is that SLOB has a broken ksize, which won't take into
> consideration compound pages AFAIK. To fix this you will need to
> introduce some changes in the way the slob_page structure is handled,
> and add real size tracking to it. You will find these problems if you
> try to implement a reliable kmem_ptr_validate for SLOB, too.

Does this mean that kzfree() isn't broken for SLAB/SLUB? Maybe I read
your emails wrong but you seemed to imply that.

As for SLOB ksize(), I am sure Matt Mackall would love to hear the
details how ksize() is broken there. I am having difficult time
understanding the bug you're pointing out here as SLOB does check for
is_slob_page() in ksize() and falls back to page.private if the page
is not PageSlobPage...

On Sat, May 30, 2009 at 9:03 PM, Larry H. <research@subreption.com> wrote:
> The second is that I've experienced issues with kzfree on 2.6.29.4, in
> which something (apparently the freelist pointer) is overwritten and
> leads to a NULL pointer deference in the next allocation in the affected
> cache. I didn't fully analyze what was broken, besides that for
> sanitizing the objects on kfree I needed to rely on the inuse size and
> not the one reported by ksize, if I wanted to avoid hitting that
> trailing meta-data.

Which allocator are you talking about here?

On Sat, May 30, 2009 at 9:03 PM, Larry H. <research@subreption.com> wrote:
> BTW, talking about branches and call depth, you are proposing using
> kzfree() which involves further test and call branches (including those
> inside the specific ksize implementation of the allocator being used)
> and it duplicates the check for ZERO_SIZE_PTR/NULL too. The function is
> so simple that it should be a static inline declared in slab.h. It also
> lacks any validation checks as performed in kfree (besides the zero
> size/null ptr one).
>
> Also, users of unconditional sanitization would see unnecessary
> duplication of the clearing, causing a real performance hit (which would
> be almost non existent otherwise). That will make kzfree unsuitable for
> most hot spots like the crypto api and the mac80211 wep code.
>
> Honestly your proposed approach seems a little weak.

Honestly, this seems like more hand-waving to me.

                                       Pekka
