Return-Path: <linux-kernel-owner+w=401wt.eu-S1757740AbYEMMNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740AbYEMMNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYEMMNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:13:35 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:24422 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751226AbYEMMNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:13:34 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 May 2008 08:13:34 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vuYIedKVLP5KJPRZlu32EFD4vDK+1ZR2Kd5zF8nPK4C9g+4IIAvOgRJMSHNJ4V6T+PBnUBCdZ8ulaDs2nnj2JhtvtJ1A9ASj7FuFH2jZWPMxt8EtdhXHgOAdZfyC3PU9yatLpYm0K+V2s4x8NKBRbekTMVHP08X3zG+asqYm35Y=  ;
X-YMail-OSG: _P1lFwIVM1lTWcdYWcaNPjM7fRVZ6amUiO_9LvRKzH73aQMpXffkT1bGkxg4uNaUkVfcFSx20cZ3p_Zz0ofgACyrPwnmVBDNoCBCTUJ1Zt78ReQxDINke4gylTvtcWG2xeA-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Robin Holt <holt@sgi.com>
Subject: Re: [PATCH 08 of 11] anon-vma-rwsem
Date: Tue, 13 May 2008 22:06:44 +1000
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrea Arcangeli <andrea@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, Eric Dumazet <dada1@cosmosbay.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
References: <6b384bb988786aa78ef0.1210170958@duo.random> <alpine.LFD.1.10.0805071429170.3024@woody.linux-foundation.org> <20080508003838.GA9878@sgi.com>
In-Reply-To: <20080508003838.GA9878@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805132206.47655.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 May 2008 10:38, Robin Holt wrote:
> On Wed, May 07, 2008 at 02:36:57PM -0700, Linus Torvalds wrote:
> > On Wed, 7 May 2008, Andrea Arcangeli wrote:
> > > I think the spinlock->rwsem conversion is ok under config option, as
> > > you can see I complained myself to various of those patches and I'll
> > > take care they're in a mergeable state the moment I submit them. What
> > > XPMEM requires are different semantics for the methods, and we never
> > > had to do any blocking I/O during vmtruncate before, now we have to.
> >
> > I really suspect we don't really have to, and that it would be better to
> > just fix the code that does that.
>
> That fix is going to be fairly difficult.  I will argue impossible.
>
> First, a little background.  SGI allows one large numa-link connected
> machine to be broken into seperate single-system images which we call
> partitions.
>
> XPMEM allows, at its most extreme, one process on one partition to
> grant access to a portion of its virtual address range to processes on
> another partition.  Those processes can then fault pages and directly
> share the memory.
>
> In order to invalidate the remote page table entries, we need to message
> (uses XPC) to the remote side.  The remote side needs to acquire the
> importing process's mmap_sem and call zap_page_range().  Between the
> messaging and the acquiring a sleeping lock, I would argue this will
> require sleeping locks in the path prior to the mmu_notifier invalidate_*
> callouts().

Why do you need to take mmap_sem in order to shoot down pagetables of
the process? It would be nice if this can just be done without
sleeping.
