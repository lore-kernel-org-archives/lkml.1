Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbYGGGjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbYGGGjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 02:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbYGGGiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 02:38:55 -0400
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:31017 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751272AbYGGGiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 02:38:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5ZsOsRLdACe84wndI3ecK9vEmgs5wKbs8tONY6W6WP2oMH4aZz3hclv6kb/KHfq4Hgjc6O/aQbB/j752ZI+YvlcI/gwRAR8NZjH2LhrTW17Ve8cfvkN4ZRdKtHdsE00AXh7qaKAXMMo9N77ICqdQsr9WKl4rv7G9Na6dY247J7s=  ;
X-YMail-OSG: F.re6tAVM1nSebI_daNyBy9Cyrx3BjyZS2Dx0.NyKuNkD7VyHpqO0T4jRX5tu6D1pQD64XiqmYR5V.GjscJtZflpkUNE_gwL1jsTwM_WiJ3LH0DN0WI60mPHK4vuxDjgud0-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [patch 1/2] mm: dont clear PG_uptodate in invalidate_complete_page2()
Date: Mon, 7 Jul 2008 16:38:31 +1000
User-Agent: KMail/1.9.5
Cc: jamie@shareable.org, torvalds@linux-foundation.org, jens.axboe@oracle.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org, hugh@veritas.com
References: <20080625124038.103406301@szeredi.hu> <20080625173837.GA10005@shareable.org> <E1KBZqG-0008OZ-Pw@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KBZqG-0008OZ-Pw@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807071638.32955.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008 04:35, Miklos Szeredi wrote:
> > > I also really don't think this even fixes the problems you have with
> > > FUSE/NFSD - because you'll still be reading zeroes for a truncated
> > > file. Yes, you get the rigth counts, but you don't get the right data.
> >
> > ...
> >
> > > That's "correct" from a splice() kind of standpoint (it's essentially a
> > > temporary mmap() with MAP_PRIVATE), but the thing is, it just sounds
> > > like the whole "page went away" thing is a more fundamental issue. It
> > > sounds like nfds should hold a read-lock on the file while it has any
> > > IO in flight, or something like that.
> >
> > I'm thinking any kind of user-space server using splice() will not
> > want to transmit zeros either, when another process truncates the file.
> > E.g. Apache, Samba, etc.
> >
> > Does this problem affect sendfile() users?
>
> AFAICS it does.
>
> And I agree, that splice should handle truncation better.  But as I
> said, this affects every single filesystem out there.  And yes, my
> original patch wouldn't solve this (although it wouldn't make it
> harder to solve either).
>
> However the page invalidation issue is completely orthogonal, and only
> affects a few filesystems which call invalidate_complete_page2(),
> namely: 9p, afs, fuse and nfs.

I don't know what became of this thread, but I agree with everyone else
you should not skip clearing PG_uptodate here. If nothing else, it
weakens some important assertions in the VM. But I agree that splice
should really try harder to work with it and we should be a little
careful about just changing things like this.
