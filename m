Return-Path: <linux-kernel-owner+w=401wt.eu-S1752985AbZDNJhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbZDNJhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbZDNJhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:37:33 -0400
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:20641 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751074AbZDNJhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:37:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bLp8ZHzCFj4t6C414YOeWXiXgvo4iTwbECap9JZ6ghQjs6njsPbJRcaUip5MMik2J6tcMGw9gLrNEWEXTbExPTHBsKbADncRDdzO5HH/dg2VgkrClCAiOrtBTj1YpLzAzMxqsnkDRf92o8NdJfkst4kJABJZfDyq8sU1X81WEcI=  ;
X-YMail-OSG: Plrwgm4VM1kX37yjspBqNRcSF7ajrCj_6MCUOSTbQOxuiyBnwAqzXMJgkIlY184DN7e6Nzxi5A6YONRnd7UVZdcZcVGGFYAGMCJuGry4jA9vp2XbJWwpZq5sr_e.xRxwR0HIsm90DvZ0BmPUCw05tTjooxeDJqeYoIptTClD6cFjc_Um6hTQNsluPPduKzVStJFGO0SJ.gC..xE_AF4kg_xXaSwXJUiip5J..6Iqfe5hHDtPbq6bs5Pw4oL6hO18bvaQQWXBvjZW0HYc5TYAI606VZANjGW8qXez9dJynmtCjK9l5Khz
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 0/6] IO pinning(get_user_pages()) vs fork race fix
Date: Tue, 14 Apr 2009 19:37:21 +1000
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <20090414151204.C647.A69D9226@jp.fujitsu.com> <200904141841.50397.nickpiggin@yahoo.com.au> <20090414175525.C67C.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090414175525.C67C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904141937.23584.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 April 2009 19:19:10 KOSAKI Motohiro wrote:

> > I don't see how it fixes vmsplice? vmsplice can get_user_pages pages from one
> > process's address space and put them into a pipe, and they are released by
> > another process after consuming the pages I think. So it's fairly hard to hold
> > a lock over this.
> 
> I recognize my explanation is poor.
> 
> firstly, pipe_to_user() via vmsplice_to_user use copy_to_user. then we don't need care
> receive side.
> secondly, get_iovec_page_array() via vmsplice_to_pipe() use gup(read).
> then we only need prevent to change the page.
> 
> I changed reuse_swap_page() at [1/6]. then if any process touch the page while
> the process isn't recived yet, it makes COW break and toucher get copyed page.
> then, Anybody can't change original page.
> 
> Thus, This patch series also fixes vmsplice issue, I think.
> Am I missing anything?

Ah thanks, I see now. No I don't think you're missing anything.


> > I guess apart from the vmsplice issue (unless I missed a clever fix), I guess
> > this *does* work. I can't see any races... I'd really still like to hear a good
> > reason why my proposed patch is so obviously crap.
> > 
> > Reasons proposed so far:
> > "No locking" (I think this is a good thing; no *bugs* have been pointed out)
> > "Too many page flags" (but it only uses 1 anon page flag, only fs pagecache
> > has a flags shortage so we can easily overload a pagecache flag)
> > "Diffstat too large" (seems comparable when you factor in the fixes to callers,
> > but has the advantage of being contained within VM subsystem)
> > "Horrible code" (I still don't see it. Of course the code will be nicer if we
> > don't fix the issue _at all_, but I don't see this is so much worse than having
> > to fix callers.)
> 
> Honestly, I don't dislike your.
> but I really hope to fix this bug. if someone nak your patch, I'll seek another way.

Yes, I appreciate you looking at alternatives, and you haven't been strongly
arguing against my patch. So this comment was not aimed at you :)


> > FWIW, I have attached my patch again (with simple function-movement hunks
> > moved into another patch so it is easier to see real impact of this patch).
> 
> OK. I try to test your patch too.

Well I split it out and it requires another patch to move functions around
(eg. zap_pte from fremap.c into memory.c). I just attached it here to
illustrate the core of my fix. If you would like to run any real tests, let
me know and I could send a proper rollup.
