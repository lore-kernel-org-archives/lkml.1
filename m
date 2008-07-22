Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbYGVDtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbYGVDtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 23:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755900AbYGVDtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 23:49:39 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:32616 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755661AbYGVDti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 23:49:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=b4sWQBoB/eLfeBoXP/rTDWeprz0ujFB23RleuSecga0ZsuDNh+WA8Tlo3v9jv7WJw4iBpFIxALB+c0wrYBpRDve+q9wXw94fhtQ10fkY28o33sWJ7qYYU0qNaTxP/jZikzMjVOVucVaiSxuaAdNKogfOZ2YgnqNvrRAfR6csDpk=  ;
X-YMail-OSG: X5J.SC4VM1k3wdltJM9UMCnB_7ALGILoynUrrVcctFYtCkufG4CaC069QhG38BdKCfJI8stScNZwsUF4NOqNUtOObW9OVhaHmQbwcTDlfM7AneJ3JIxMdiSPPP8CZodyRww-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH -mm] mm: more likely reclaim MADV_SEQUENTIAL mappings
Date: Tue, 22 Jul 2008 13:49:28 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Johannes Weiner" <hannes@saeurebad.de>,
       "Peter Zijlstra" <peterz@infradead.org>,
       Nossum <vegard.nossum@gmail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <87y73x4w6y.fsf@saeurebad.de> <20080721230405.6cfde9bd@bree.surriel.com> <200807221343.40017.nickpiggin@yahoo.com.au>
In-Reply-To: <200807221343.40017.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807221349.28641.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2008 13:43, Nick Piggin wrote:
> On Tuesday 22 July 2008 13:04, Rik van Riel wrote:
> > On Tue, 22 Jul 2008 12:54:28 +1000

> > > But we are not doing nothing because we already know and have coded
> > > for the fact that the mapping will be accessed once, sequentially.
> > > Now that we have gone this far, we should actually do it properly and
> > > 1. unmap after use, 2. POSIX_FADV_DONTNEED after use. This will give
> > > you much better performance and cache behaviour than any automatic
> > > detection scheme, and it doesn't introduce any regressions for existing
> > > code.
> >
> > If you run just one instance of the application!
> >
> > Think about something like an ftp server or a media server,
> > where you want to cache the data that is served up many
> > times, while evicting the data that got served just once.
> >
> > The kernel has much better knowledge of what the aggregate
> > of all processes in the system are doing than any individual
> > process has.
>
> That's true, but this case isn't really very good anyway. The information
> goes away after you drop the mapping anyway. Or did you hope that the
> backup program or indexer keeps all those mappings open until all the pages
> have filtered through? Or maybe we can add yet more branches into the unmap
> path to test for this flag as well?
>
> I don't think it is a good idea to add random things just because they seem
> at first glance like a good idea.

BTW. in the backup of a busy fileserver or some case like that, I'd
bet that even using FADV_DONTNEED would be much faster than leaving
these mappings around to try to drop them due to the decreased churn
on the LRUs overall anyway.

