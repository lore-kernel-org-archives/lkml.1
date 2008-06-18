Return-Path: <linux-kernel-owner+w=401wt.eu-S1760515AbYFRGXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760515AbYFRGXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 02:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbYFRGWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 02:22:52 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:22973 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752111AbYFRGWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 02:22:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=j69vI2FEiArPuqRSxVgSVQu1ulq0FUjXkXvk4C3dnfqlsKBkIgVFDCNVugZadPKr8gJe1qu8kQ1DNcoAXiAvQDakgcwscKwOXyiOSaYxtgrrsRAH8bEKxNYIMfva/4wrAGARvMNJXG6uCdtVUCj2HKhRCqypsEbOR3C3jb26HuE=  ;
X-YMail-OSG: gw7A000VM1l1V9JLhBlwWEceBc8JdPJO3XzQjmUPUE9_0OP6jou99_e2GoaVHF_7nuccPOmts.ny5L9NJziFz.sdJN.InuY.k4XCiG4AvPlrmw7hO7I4qwMZPFr6_zn88rU-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386,=?iso-8859-1?q?=09bisected?=, reproducable)
Date: Wed, 18 Jun 2008 16:22:39 +1000
User-Agent: KMail/1.9.5
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>, Ingo Molnar <mingo@elte.hu>
References: <1213682570.13708.1258839317@webmail.messagingengine.com> <20080617221118.GM28946@ZenIV.linux.org.uk> <485838F9.8010001@firstfloor.org>
In-Reply-To: <485838F9.8010001@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806181622.40092.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 June 2008 08:21, Andi Kleen wrote:
> > AFAICS, what happened is that b0rken copy_*FROM*_user() had been
> > discussed with references to copy_*TO*_user().  With proposed patch
> > indeed not affecting any legitimate calls of the latter.  Does affect the
> > former and that, from my reading of the code in question, correctly.
> >
> > IOW, s/copy_to_user/copy_from_user/ in Linus' postings upthread and they
> > make sense.
>
> Yes, it makes some more sense, but I'm not completely happy with the fix
> because it makes the fault point reporting very unreliable (maximum error
> will be 63 instead of 7 now). iirc especially mount was sensitive to that.

It looks like mount does need an exact copy, so they've rolled their own
(exact_copy_from_user). I guess if you need an exact copy, then it doesn't
really matter how inexact an inexact one is, it's still unusable :)

All else being equal, a smaller maximum error is preferable, but surely
that is outweighed by the correctness issue of returning a valid number of
bytes left to operate on.

BTW. we already have lots (although steadily declining number) of corner
case issues around this whole area, but if we want to get really strict,
even an inexact report may be wrong for filemap.

Suppose we copy 10 bytes into the pagecache, but report that 5 were copied.
That means, we'll subsequently re-copy the delta. Between these two copies,
a 2nd writer might come in and write something over those 5 bytes. Then a
reader might see the following sequence of those 10 bytes
"0000000000"
"1111111111"
"2222222222"
"2222211111"
