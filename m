Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbZA3Qzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbZA3Qzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 11:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbZA3QzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 11:55:22 -0500
Received: from outbound-mail-06.bluehost.com ([69.89.17.206]:40659 "HELO
	outbound-mail-06.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751346AbZA3QzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 11:55:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=gEJOzwQbw8gk9migq1Ycp903Ftfrm638/M1jZburmUecdpCU922WbshmXdDvhNIuJLRHdGOz9OnnwQC+b/ySfFT1Y9sebx9RFNQfvyvGKVmW+9QafzgPojNqPBuL0mSi;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: PROBLEM: kernel BUG at drivers/gpu/drm/drm_fops.c:146!
Date: Fri, 30 Jan 2009 08:55:17 -0800
User-Agent: KMail/1.9.10
Cc: Thomas =?iso-8859-1?q?Hellstr=F6m?= <thomas@shipmail.org>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       kerolasa@iki.fi, Laurent Pinchart <laurent.pinchart@skynet.be>,
       Dickins <hugh@veritas.com>, dri-devel@lists.sourceforge.net,
       kerolasa@gmail.com
References: <a6f8318b0901210358w7cced8e9yab86c487b3587d75@mail.gmail.com> <4982C4D3.4040704@shipmail.org> <20090130012134.bb4fe0bf.akpm@linux-foundation.org>
In-Reply-To: <20090130012134.bb4fe0bf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901300855.18622.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 30, 2009 1:21 am Andrew Morton wrote:
> On Fri, 30 Jan 2009 10:13:55 +0100 Thomas Hellstr__m <thomas@shipmail.org> 
wrote:
> > >> Sounds right to me.  The offsets are just handles, not real file
> > >> objects or backing store addresses.  We use them to take advantage of
> > >> all the inode address mapping helpers, since they track stuff for us.
> > >>
> > >> That said, unmap_mapping_range may not be the best way to do this;
> > >> basically we need a way to invalidate a given processes' mapping of a
> > >> GTT range (which in turn is backed by real RAM).  If there's some
> > >> other way we should be doing this I'm all ears.
> > >
> > > Well, we'd need to call in the big guns on this one - I've already
> > > stirred Hugh ;)
> > >
> > > unmap_mapping_range() is basically a truncate thing - it shoots down
> > > all mappings of a range of a *file*.  Across all processes in the
> > > machine which map that file.
> > >
> > > If that isn't what you want to do (and it sounds that way) then you'd
> > > want to use something which is mm_struct (or vma) centric, rather than
> > > file-centric.  zap_page_range(), methinks.
> >
> > I guess I was the one starting to use this function, so some explanation:
> >
> > When the drm device is used to provide address space for buffers,
> > user-space actually see it as a file with a distinct offset where
> > buffers are laid out in a linear fashion, To access a certain buffer you
> > need to lseek() to the correct offset and then read() write() or, the
> > more common use, mmap / munmap.
> >
> > When looking through its implementation, unmap_mapping_range() seemed to
> > do exactly the thing I wanted, namely to kill all user-space mappings of
> > all vmas of all processes mapping a part of the device address space.
>
> That's different from what Jesse said.  That _is_ a more appropriate
> use of unmap_mapping_range().  Although all the futzing that function
> does with truncate_count is now looking inappropriately-placed.

Yeah I misspoke, we do need to blow away *all* the mappings, not just the ones 
for a given process (since the backing GTT mapping is gone/moved).  We could 
probably use zap_page_range, but might have to do a bit more work in the 
driver if we did.

-- 
Jesse Barnes, Intel Open Source Technology Center
