Return-Path: <linux-kernel-owner+w=401wt.eu-S1751130AbXBNCHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130AbXBNCHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 21:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbXBNCHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 21:07:46 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:37368 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbXBNCHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 21:07:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DMSdiHgQkFmt8wrOn43ivHjyo7dLe6btW865pZ82AAdgejGrwFS4R0Lz5kMkozyxqRi+e1vDNFyFssjDQQotnPKeS8cXRGHzqM77zXPx1kGISyOb3XC7ZIbCQSj7HXWHoCAs0cpll86bBetpI5x3mUn8WE17kN2a58oQRChf+Zk=
Message-ID: <a4e6962a0702131807n30b08dd6na2e0bbd53c6b9600@mail.gmail.com>
Date: Tue, 13 Feb 2007 20:07:44 -0600
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RESEND][PATCH] 9p: add write-cache support to loose cache mode
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
In-Reply-To: <20070213161607.0ca21ea4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11714109311262-git-send-email-ericvh@gmail.com>
	 <20070213161607.0ca21ea4.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Tue, 13 Feb 2007 17:55:31 -0600 Eric Van Hensbergen <ericvh@gmail.com> wrote:
> > +int v9fs_prepare_write(struct file *file, struct page *page,
> > +                    unsigned from, unsigned to)
> > +{
> > +     if (!PageUptodate(page)) {
> > +             if (to - from != PAGE_CACHE_SIZE) {
> > +                     void *kaddr = kmap_atomic(page, KM_USER0);
> > +                     memset(kaddr, 0, from);
> > +                     memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
> > +                     flush_dcache_page(page);
> > +                     kunmap_atomic(kaddr, KM_USER0);
> > +             }
> > +             SetPageUptodate(page);
> > +     }
>
> This will mark the page uptodate while the piece between `to' and `from' is
> uninitialised.  A concurrent pagefault can come in and permit a read of
> that uninitialised data.  Because filemap_nopage() doesn't lock the page if
> it is uptodate.
>

Okay - I snagged this code from fs/libfs.c (simple_prepare_write) --
is that code also not correct, or am I just using it in the wrong
context?

        -eric
