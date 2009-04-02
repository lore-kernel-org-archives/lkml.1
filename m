Return-Path: <linux-kernel-owner+w=401wt.eu-S1763495AbZDBSDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763495AbZDBSDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760935AbZDBSD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:03:27 -0400
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:40860 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754093AbZDBSD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:03:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BGs21XdeU/KHeNT0xU/sKGpsHdEHhiX0MGxgzs+1RqrjjuwZqodagUdd8LRKNuvfI/nma501YhIPNOM7ke2eT9wZ34waL1hBPkBB2R7j7dWUCleoKYMCu64uAvTAaFIbSnu5DziFLBbJJc+UmKECZaC/mwncm9z02pAM1eGe3vU=  ;
X-YMail-OSG: _b36md8VM1lWsfuQ6tIfSYbVKUg86lk.d2TUGCAePzxJpbuki6gXn6pQu_bC3CYa35rMZoWJ5NwphlhEK7ijo9noLkaKcuKxjA89mOJXGD1QA_a52TYMqtKm7mSQ2TWaurHs3iy8kpQPRinVg.FCTfw_RY7nXRFdyXBqYzuyWD3z4D3PLuiJmPfbtwNYJK61P.G.79bwYlm7dfiHPsnPJDiilHV79_sD.Q6mdJMRQRCJHBE4dtlW.WpOQi.pKGHhXMqEVYBk9s4CyTbHg.oJY8smOTJzwZ97Fyi0KhBEWya2QP5x91L.YG6pQoHqLe7nEAhf79MIMMMc7qotVMzujcZk7g--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 23/43] CacheFiles: Permit the page lock state to be monitored [ver #46]
Date: Fri, 3 Apr 2009 05:03:18 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <200904030335.13439.nickpiggin@yahoo.com.au> <6638.1238688892@redhat.com> <7156.1238691907@redhat.com>
In-Reply-To: <7156.1238691907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904030503.19020.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 April 2009 04:05:07 David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> > Presumably: at the point where data is needed.
> 
> But the point where the data is needed is where filemap.c is waiting on a
> netfs page.  Maybe the sync_page() aop can deal with it

I was thinking of more like just have some threads submitting the reads
and unlocking the waiters.

 
> There's also the problem of recording and pinning the backing page I'm waiting
> for.  Currently I can do that by hooking the monitor block into the page
> unlock watching list.  If I don't do that, I have to use up yet more memory to
> track those some other way.  It's not impossible, but I'd like to keep memory
> usage down.
> 
> > Or do you actually have numbers showing a problem if you just read the pages
> > then copy them?
> 
> I did, years ago.  It wasn't particularly good, but
> fscache_read_or_alloc_pages() was completely synchronous.

Performance wasn't good? Why?


> > If there is a problem, then why doesn't fscache_read_or_alloc_pages caller
> > do the work itself, then you get as many threads as you have indivisible
> > work units, so completing some part of the request before another wouldn't
> > gain you anything anyway...
> 
> (1) Trond stipulated FS-Cache had to be asynchronous, and it is, as far as I
>     can make it.  I still have to invoke bmap() synchronously, though, to find
>     out whether I have a page in the cache to read:-/

Why does it have to be asynchronous? Seems like an incredible complexity.
->readpage is called only in synchonous contexts, and ->readpages not but
do you even have the netfs filesystem request readahead on the backing
filesystem? (which then presumably tries to do readahead of its own)

 
> (2) You lose the advantage of being able to process what you've got whilst the
>     disk is fetching stuff in the background.

This should happen via readahead on the underlying filesystem, shouldn't
it?
