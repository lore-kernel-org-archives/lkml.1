Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbZDFJf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbZDFJf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbZDFJfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:35:10 -0400
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:20489 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752702AbZDFJfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:35:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KDe7UYSf5glRxycPVmA0vldzBJUjnBkjL/mWUYekLkIggwwyJtjL5NGmQuEPaAsJM+zes7AsyUVJc+iHUO6HM2MCkxoFEN6nCiraFSPryVphPM3tu5i0wZYwtCR+5cpNCX+i5noMCSxIL/RgqYLwidCYf8xJsiM09HD4X4SRMf0=  ;
X-YMail-OSG: dqoELjYVM1l8IcBRUbYSb1rqENQejP3NVmciCx__FFP.zU3qLqcGa7HgFPGa8SCtfZO7LBw1A07pHEfvgJCBtnczAEwY4lsmFR8yHzj5XDc4enwDnVDweezIcFkwolV_wcy2N.WzlKjROa.G9kJYF.HYcHIvyZV7IKyoeamkyGUMLKrLzc5qD.ZmqwafSblEOmD2346t36ytDmOM.Cu_g7Uj8wtmUDj1ZSFF.v_fTPnJ9uS8bGamlDQbdzbhsCGzWhq.I0P0Jg7z8cT7luONzJHhqrTF5bDdQXHdqD7_X6vUyte9pL.pCYhsrqf0FWwc6sJusL5X_6llzcB8DC1geFknXA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 21/41] CacheFiles: Permit the page lock state to be monitored [ver #48]
Date: Mon, 6 Apr 2009 19:34:59 +1000
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
References: <200904041709.31651.nickpiggin@yahoo.com.au> <20090403155624.28714.87176.stgit@warthog.procyon.org.uk> <32240.1238844700@redhat.com>
In-Reply-To: <32240.1238844700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904061935.00000.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 April 2009 22:31:40 David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> > I would really like to know exactly why it *has* to be asynchronous,
> > and see what the diff looks like between a simple synchronous design
> > and what you have here.
> 
> Okay.  See attached patch.
> 
> Three benchmarks, all with data preloaded into the cache, and all with all the
> data in memory on the server:
> 
>  (1) dd of a 100MB file.
> 
>  (2) dd of a 200MB file.
> 
>  (3) Eight parallel tars of 340MB kernel trees.
> 
> 	Benchmark	Without Patch	With Patch
> 	1		1.971s		3.371s
> 	2		3.750s		7.093s
> 	3		18 mins		22 mins
> 
> With this patch, we wait for the pages to be read from the backing fs and copy
> them in fscache_read_or_alloc_pages().

Thanks. Pretty good numbers, really, for a first cut.


> I'm sure there are ways to optimise things, but whilst doing a synchronous
> read at this in fscache_read_or_alloc_pages() might help an start-to-end read
> as done by most programs, it's less likely to help random-access reads, such
> as page-in for mmapped sections.

Why is this the case? ->readpage is always a synchronous call, whether it
is via read(2) or page fault.

->readpages is asynchonous, for readahead, but in that case the caller
isn't locking the page and waiting on them anyway, so do you really need
an asynchronous callback? You could still kick off asynchronous reads to
the backing file.


> Note also: (1) the caller of the netfs's readpages() has already done
> readahead speculation, and we should probably make best use of that, rather
> than doing it again; and

The caller *is* the readahead speculation. But if you're hooking into
the backing filesystem at the ->readpage level, then you don't get
extra readahead there anyway.


> (2) all the metadata for where the data blocks are on
> the backing fs has already been read by dint of calling bmap() to determine
> whether the data blocks exist or not.
> 
> What might be cute is to have cachefiles_read_or_alloc_pages() dentry_open()
> the backing file with O_DIRECT|O_NOHOLE, use ->read() to load the data into
> the netfs pages directly, and then fput() the file once it has finished.

It would definitely be nicer to move this thing higher up to look as
much like userspace syscalls as possible. You could probably use AIO
with your DIO too.
