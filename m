Return-Path: <linux-kernel-owner+w=401wt.eu-S965045AbXBQGDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965045AbXBQGDQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 01:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965050AbXBQGDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 01:03:16 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:27993 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965045AbXBQGDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 01:03:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hf6wMapWYbQaqibNgs7tfFfTfqGquOu081K6UnV/jjGegwm1NpRXYc5p/QAuet8j6O4fGSgd2D96TNOKcszjgQFkg8cyTE8QvsVgA5NFlo2PFmZV8ewfPDkrE46nCp4dBjs1Fjn97qm9uzkuUwgXdXs0c7S+ZxFYgFSpUnBApIg=
Message-ID: <a4e6962a0702162203y7af3d87ake846d7c295c88af6@mail.gmail.com>
Date: Sat, 17 Feb 2007 00:03:14 -0600
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] 9p: add write-cache support to loose cache mode (take 4)
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
In-Reply-To: <20070216170122.4cdafd78.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1171640221420-git-send-email-ericvh@gmail.com>
	 <11716732192318-git-send-email-ericvh@gmail.com>
	 <20070216170122.4cdafd78.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 16 Feb 2007 18:46:59 -0600
> Eric Van Hensbergen <ericvh@gmail.com> wrote:
> > +     if(!PageUptodate(page)) {
> > +             if (to - from != PAGE_CACHE_SIZE) {
> > +                     void *kaddr = kmap_atomic(page, KM_USER0);
> > +                     memset(kaddr, 0, from);
> > +                     memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
> > +                     flush_dcache_page(page);
> > +                     kunmap_atomic(kaddr, KM_USER0);
> > +             }
> > +             if ((file->f_flags & O_ACCMODE) != O_WRONLY)
> > +                     v9fs_vfs_readpage_worker(file, page);
> > +     }
>
> Seems strange to memset part of the page and to then go and fill the page
> in from backing store.  Perhaps some optimisation is possible here?
>

Just double-checking in an effort to actually get the next patch right
(hopefully) -- seems like there are two cases -- if I can read from
the file, I just call readpage and it'll zero out bits.  If the file
is open write-only, things are a little cloudy -- fs/cifs looks like
they just don't do anything.  In the write-only case, do I need to
zero the unwritten portions of the page, or does this get handled
under the covers?  Looks like NFS just avoids this by only writing the
bits that change, which I suppose has other advantages.  I'll refactor
the writepage code to follow the NFS example versus the CIFS code I
originally based my implementation on.

                      -eric
