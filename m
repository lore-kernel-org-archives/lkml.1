Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbYH1BBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbYH1BBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 21:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbYH1BA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 21:00:57 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:35350 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752500AbYH1BA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 21:00:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UcgeRQLG7NArRUtYECNXMGHCA8svLS1TB0BIvtXv871KxVb6g2z2SAQaw+7CX7cvZARxP358MUvdD1xhNOTR7gF930ooMe+OZAR3DUIxVAu9LXmbuOJ68p0AsB8sVJboTY7+LsZaJkk4uxRgdYnSdDVTEnhh/d7wm5DrtyFZi88=  ;
X-YMail-OSG: MbDP.y4VM1kcwP1N5x30rNpQXcmgbo1R6U71yjmOiDm3mRG4GK8AnXIHyuAkUxYyX0IkM.bS_zCdN12SrwqSwt3GhvOfuNHD8LSDN2aGHy6jXRD8TRBb2F8k0auvSe6M5.U-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Definition of x86 _PAGE_SPECIAL and sharing _PAGE_UNUSED1
Date: Thu, 28 Aug 2008 11:00:46 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Hugh Dickens <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>
References: <48B5A4B0.9050308@goop.org> <200808281032.30594.nickpiggin@yahoo.com.au> <48B5F5A6.4060309@goop.org>
In-Reply-To: <48B5F5A6.4060309@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808281100.46380.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 August 2008 10:47, Jeremy Fitzhardinge wrote:
> Nick Piggin wrote:
> > Ah... pity it was hidden away there and not put into the include file.
>
> Yes.  I just prepped a patch to bring it out into the light.
>
> > I don't feel strongly about it. But you should put your definition in
> > pgtable.h (and possibly explain how it coexists with _SPECIAL).
>
> Yes, that was my plan, but without knowing how _SPECIAL is used, it's a
> bit tricky.  Is there a comment somewhere which describes who sets it
> and when?  From a quick look, it seems it's set on newly added user
> pages which aren't COWed.  Can they be shared file-backed pages?
> Anonymous pages?  Device pages?

They'll tend to be device pages. XIP filesystem mappings can set it too.

They won't be set on anonymous pages, or on normally mmap()ed pagecache
pages (although best not to take the latter as a strict rule because
in theory a filesystem _could_ map a pagecache page).


> >> Am I right in supposing that _PAGE_SPECIAL can only be set on user
> >> pages?
> >
> > Yes.
>
> OK, that won't clash with CPA tests at all, since they're kernel only.

Right. But they could nearly have clashed without ever being set on
kernel ptes -- if we ever _tested_ kernel ptes for that bit (gup.c
has other safeguards that should keep us away from kernel pages, but
it could in theory be implemented on x86 by only testing _PTE_SPECIAL
if we know it won't be set on kernel ptes).

But if we just document the fact now that _PTE_SPECIAL is valid for
only user ptes, then I think your CPA test bit fits nicely into the
kernel side and we're no longer wasting half a bit ;)


> >> (Also, "SPECIAL" is awfully generic.  Was there really no more
> >> descriptive name for this?)
> >
> > I thought it was about on par with its counterpart, which is "normal".
> > Either way, I don't think a casual reader would get an adequate idea
> > of how it works in one word. normal ~= refcounted, special ~= !refcounted
> > I guess, but it is slightly more than that and besides, normal was there
> > first, and I think Linus coined it... if you can convince him to change
> > it then you have my blessing to change special into whatever you want.
>
> It's only used in a couple of places, so giving it a longer name
> wouldn't cost much.  _PAGE_USER_UNCOUNTED?  But ugh, a lot of cross-arch
> churnpatch to do it.

And you have to get Linus to accept a patch turning vm_normal_page into
vm_user_counted. Good luck :)

