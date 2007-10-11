Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbXJLKqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbXJLKqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 06:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756861AbXJLKpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 06:45:54 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:42107 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751073AbXJLKpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 06:45:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Ya7CcXcaCJIUfIsroMuQ11km/nQ5W0lmpNXG943dLIR20DD6DCkzTo2ObBS7V0YKlfwVvP4Xt9ELPsGnCBlweMUlu2ZCKe/0C7xOGbc94y+UFano2YkDxXXfvZvbXZCQKrfoqjWXf82ILinLZNOmsZHMWr4KQqYsKHrBEW2z1e8=  ;
X-YMail-OSG: 40aM5IMVM1nLZaRlu_NcCub8TOG54KaAK4jMnOLBRb6vJajE
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] mm: avoid dirtying shared mappings on mlock
Date: Fri, 12 Oct 2007 04:14:10 +1000
User-Agent: KMail/1.9.5
Cc: Suleiman Souhlal <ssouhlal@freebsd.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Suleiman Souhlal <suleiman@google.com>, linux-mm <linux-mm@kvack.org>,
       hugh <hugh@veritas.com>
References: <11854939641916-git-send-email-ssouhlal@FreeBSD.org> <200710120257.05960.nickpiggin@yahoo.com.au> <1192185439.27435.19.camel@twins>
In-Reply-To: <1192185439.27435.19.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710120414.11026.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 October 2007 20:37, Peter Zijlstra wrote:
> On Fri, 2007-10-12 at 02:57 +1000, Nick Piggin wrote:
> > On Friday 12 October 2007 19:03, Peter Zijlstra wrote:
> > > Subject: mm: avoid dirtying shared mappings on mlock
> > >
> > > Suleiman noticed that shared mappings get dirtied when mlocked.
> > > Avoid this by teaching make_pages_present about this case.
> > >
> > > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Acked-by: Suleiman Souhlal <suleiman@google.com>
> >
> > Umm, I don't see the other piece of this thread, so I don't
> > know what the actual problem was.
> >
> > But I would really rather not do this. If you do this, then you
> > now can get random SIGBUSes when you write into the memory if it
> > can't allocate blocks or ... (some other filesystem specific
> > condition).
>
> I'm not getting this, make_pages_present() only has to ensure all the
> pages are read from disk and in memory. How is this different from a
> read-scan?

I guess because we've mlocked a region that has PROT_WRITE access...
but actually, I suppose mlock doesn't technically require that we
can write to the memory, only that the page isn't swapped out.

Still, it is nice to be able to have a reasonable guarantee of
writability.


> The pages will still be read-only due to dirty tracking, so the first
> write will still do page_mkwrite().

Which can SIGBUS, no?
