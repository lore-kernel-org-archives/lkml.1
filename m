Return-Path: <linux-kernel-owner+w=401wt.eu-S1762034AbXF0WME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762034AbXF0WME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 18:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbXF0WLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 18:11:52 -0400
Received: from rwcrmhc15.comcast.net ([204.127.192.85]:39956 "EHLO
	rwcrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbXF0WLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 18:11:51 -0400
Subject: Re: [patch 2/3] MAP_NOZERO - implement sys_brk2()
From: Nicholas Miell <nmiell@comcast.net>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Hugh Dickins <hugh@veritas.com>, Ulrich Drepper <drepper@gmail.com>,
       blaisorblade@yahoo.it,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706271135560.32731@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.29496.1182912260.2>
	 <a36005b50706262048y5eb8ba80kb0d852d649d1ac10@mail.gmail.com>
	 <Pine.LNX.4.64.0706262052060.26540@alien.or.mcafeemobile.com>
	 <a36005b50706262202w4aaa4494qc2322e49c71d8d7c@mail.gmail.com>
	 <Pine.LNX.4.64.0706271309500.26951@blonde.wat.veritas.com>
	 <a36005b50706271001o191f3e24n83b25988739429fb@mail.gmail.com>
	 <Pine.LNX.4.64.0706271807330.22337@blonde.wat.veritas.com>
	 <Pine.LNX.4.64.0706271111040.32731@alien.or.mcafeemobile.com>
	 <Pine.LNX.4.64.0706271921280.29060@blonde.wat.veritas.com>
	 <Pine.LNX.4.64.0706271135560.32731@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Wed, 27 Jun 2007 15:11:49 -0700
Message-Id: <1182982309.2737.9.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-27 at 11:45 -0700, Davide Libenzi wrote:
> On Wed, 27 Jun 2007, Hugh Dickins wrote:
> 
> > On Wed, 27 Jun 2007, Davide Libenzi wrote:
> > > On Wed, 27 Jun 2007, Hugh Dickins wrote:
> > > 
> > > > In honesty, I should add that I dislike and distrust Davide's
> > > > MAP_NOZERO very much indeed!  Would much rather leave my cpus
> > > > spending a little time in clear_page().  A uid in struct page
> > > > (though I'm sure we could find somewhere to tuck it away) -
> > > > the horror, the horror!  But I've so far failed to find a killer
> > > > argument against it, and am hoping for someone else to do so.
> > > 
> > > Little time? Please, do not trust me. Start oprofile and run a kernel 
> > > build. Look, I'm not even talking about som micro benchmark explicitly 
> > > built to exploit the thing. A kernel build.
> > > You will find clear_page to be the *1st* kernel entry after cc1 and as.
> > > That is bad for two reasons. The time it spends in there, and the cache it 
> > > blows.
> > 
> > I don't doubt that it shows real benefits; but dangerously cutting
> > corners usually shows benefits too.  Relying on a uid at this level
> > feels very wrong to me - but as I said, I've not found a killer
> > argument against it.
> 
> The reason why I posted is exactly so other ppl can look at it and find 
> possible flaws in the way pages and retired. If an effective UID was able 
> to see (or it generated) the data on that page, it should be able to get 
> that page back uncleared (when VM_NOZERO is set).
> >From a performance POV, a 2-3% boost on a non-micro-bench test like a 
> kernel build is not exaclty peanuts. And for more heavy malloc/anon-mmap 
> appliations, the boost goes up to 10-15%. That is not exactly what I 
> call "little time" ;)
>
> - Davide
> 

I don't think the security issues with this will ever make it
worthwhile.

Consider:

1) euid is not sufficient, you need to store away arbitrary LSM
information and call LSM hooks to decide security equivalence. The same
applies to VServer or whatever other container system you use.

2) Two processes, A and B, are in separate VFS namespaces but have
equivalent security identity according to LSM. Process A reads data from
file F which is not visible in process's B's namespace. You have to
prevent process B from ever getting a page that once contained data from
file F.

3) mlock() is often used by programs like GPG to prevent decrypted
secret keys from ever getting swapped out. You need to zero all
once-mlocked pages before they get reused to prevent that page from
getting swapped to disk or application bugs from leaking the key.

-- 
Nicholas Miell <nmiell@comcast.net>

