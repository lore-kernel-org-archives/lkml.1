Return-Path: <linux-kernel-owner+w=401wt.eu-S1757905AbYBLF4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905AbYBLF4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 00:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbYBLF40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 00:56:26 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:41368 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753298AbYBLF4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 00:56:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=hRHYwybt4yaq4h/rAiz9ti0BKXn6/VgpMLYmzSXxbRbTopwL340cSaSI2R/KwFmAvre0yWuIKhURFc5k2oD+09KJQ+VpOAwYD7X3fnjaTjO2JGwklyCh2kuhUn0GzAbshHwJeQdW4CIGryu6ZftBXYRsC7p+WZhXxeJRpjF4PYU=  ;
X-YMail-OSG: s4ANb3YVM1nxcdwl_W2zvrWBRI6_JHArHPc88DE7A487sxslKP63wfBCcSmicXtNgFIq9IuC4g--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] Avoid buffer overflows in get_user_pages()
Date: Tue, 12 Feb 2008 16:56:09 +1100
User-Agent: KMail/1.9.5
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
References: <fa.5jOFf0zR7ZoK3hLDItf3Omow4lE@ifi.uio.no> <fa.NNs+hqAlLlf93+yNZ/YJzSyGQbs@ifi.uio.no> <47B10FA4.2000808@shaw.ca>
In-Reply-To: <47B10FA4.2000808@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802121656.09440.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2008 14:16, Robert Hancock wrote:
> Nick Piggin wrote:
> > On Tuesday 12 February 2008 10:17, Jonathan Corbet wrote:
> >> Avoid buffer overflows in get_user_pages()
> >>
> >> So I spent a while pounding my head against my monitor trying to figure
> >> out the vmsplice() vulnerability - how could a failure to check for
> >> *read* access turn into a root exploit?  It turns out that it's a buffer
> >> overflow problem which is made easy by the way get_user_pages() is
> >> coded.
> >>
> >> In particular, "len" is a signed int, and it is only checked at the
> >> *end* of a do {} while() loop.  So, if it is passed in as zero, the loop
> >> will execute once and decrement len to -1.  At that point, the loop will
> >> proceed until the next invalid address is found; in the process, it will
> >> likely overflow the pages array passed in to get_user_pages().
> >>
> >> I think that, if get_user_pages() has been asked to grab zero pages,
> >> that's what it should do.  Thus this patch; it is, among other things,
> >> enough to block the (already fixed) root exploit and any others which
> >> might be lurking in similar code.  I also think that the number of pages
> >> should be unsigned, but changing the prototype of this function probably
> >> requires some more careful review.
> >>
> >> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> >>
> >> diff --git a/mm/memory.c b/mm/memory.c
> >> index e5628a5..7f50fd8 100644
> >> --- a/mm/memory.c
> >> +++ b/mm/memory.c
> >> @@ -989,6 +989,8 @@ int get_user_pages(struct task_struct *tsk, struct
> >> mm_struct *mm, int i;
> >>  	unsigned int vm_flags;
> >>
> >> +	if (len <= 0)
> >> +		return 0;
> >
> > BUG_ON()?
>
> Well, not if the code involved in the exploit can pass a zero value,

Which is a bug, and you want to catch it.


> otherwise it's just turning it into a DoS..

If it is due to a security bug, then the fix is to fix the point
where the kernel starts trusting an untrusted value. Not to hide
the bug like this. Arguably, a BUG_ON is better in the case of a
security hole because you want to halt the process as soon as you
detect a problem.
