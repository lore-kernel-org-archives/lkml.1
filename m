Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbYHEE2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbYHEE2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 00:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbYHEE23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 00:28:29 -0400
Received: from smtp117.mail.mud.yahoo.com ([209.191.84.166]:41787 "HELO
	smtp117.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751996AbYHEE21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 00:28:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=aS/AGMaJY/8WJtgyEPg2PQjQOHbDBMDEL4B6sqKZSe57kPibVdK2IxwYDNTnIPTUsYBV0oSw+BowtMbv01XMYI+a2pu9LvEuRbnVVJAaQJ4MpH9r6GFUbL1W2HZQCWBF3wW3wCxFYdCWiH+vcC7jqPhi6nSvbKwl05eNqd3PJqg=  ;
X-YMail-OSG: MNjyQiwVM1lscQgG6LXIeUnoDKpPHpctiJz5dg01HEI7MEoaO1Hmrk988kHwVHNdt2ZrN0PpPMz.xu9Bym_Wo_1FF63omhevYjG4y2yGz9.R2bw72nSV3c_4b9zPsNVLiaw-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Hugh Dickins <hugh@veritas.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
Date: Tue, 5 Aug 2008 14:28:20 +1000
User-Agent: KMail/1.9.5
Cc: Keith Packard <keithp@keithp.com>, Christoph Hellwig <hch@infradead.org>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
References: <1217573919-7496-1-git-send-email-eric@anholt.net> <1217850352.24714.66.camel@koto.keithp.com> <Pine.LNX.4.64.0808041720500.25617@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0808041720500.25617@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808051428.20602.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 August 2008 03:09, Hugh Dickins wrote:
> On Mon, 4 Aug 2008, Keith Packard wrote:
> > On Mon, 2008-08-04 at 20:43 +1000, Nick Piggin wrote:
> > > read_mapping_page might help there.
> >
> > That does look a lot more like what I want, as it returns an unlocked
> > page. And, makes my code look cleaner to boot:
> >
> >         inode = obj->filp->f_path.dentry->d_inode;
> >         mapping = inode->i_mapping;
> >         for (i = 0; i < page_count; i++) {
> >                 page = read_mapping_page(mapping, i, NULL);
> >                 if (IS_ERR(page)) {
> >                         ret = PTR_ERR(page);
> >                         DRM_ERROR("read_mapping_page failed: %d\n", ret);
> >                         i915_gem_object_free_page_list(obj);
> >                         return ret;
> >                 }
> >                 obj_priv->page_list[i] = page;
> >         }
> >
> > Does this look like it conforms to the vfs api? It appears to work when
> > using shmem at least.
>
> Yes, that's a good suggestion from Nick, should work with shmem/tmpfs
> (with *proviso below) and others, and big improvement to your generality.
>
> Whether such usage conforms to VFS API I'm not so sure: as I understand
> it, it's really for internal use by a filesystem - if it's going to be
> used beyond that, we ought to add a check that the filesystem it's used
> upon really has a ->readpage method (and I'd rather we add such a check
> than you do it at your end, in case we change the implementation later
> to use something other than a ->readpage method - Nick, you'll be
> nauseated to hear I was looking to see if ->fault with a pseudo-vma
> could do it).  But if the layering police are happy with this, I am.

Yes, readpage is optional... A check will be required.

I don't exactly know if this would be deemed the best way to do it,
but it seems *relatively* filesystem agnostic (with the readpage
test being the exception), and it seems like it is to address_space
mappings what get_user_pages is to virtual memory mappings. And
there is no shortage of drivers using get_user_pages.

At any rate, it seems a bit nicer than using shmem_getpage directly.

cc'ing linux-fsdevel.


> The *proviso is that for tmpfs itself this actually isn't as convenient
> as directly using shmem_getpage: because this way passes a page in to
> shmem_getpage, when maybe the page wanted is already here but currently
> marked as swapcache rather than filecache.  It's an awkward extension
> that allows tmpfs to support ->readpage at all.  But that route is in
> use and well-tested, and only an inefficiency when swapping, so should
> not cause you any problems.
>
> (I have been agonizing over the way __read_cache_page, like your
> original i915_gem_object_get_page_list, uses find_get_page: whereas
> shmem_getpage uses find_lock_page.  I remember the latter is important,
> but don't quite remember all the why.  I'm believing that it's really
> only the ->fault usage where it becomes vital: things get confused, on
> 2.4 more than 2.6, if a swapcache tmpfs page is mapped into userspace.)
>
> You don't examine page->mapping at all: good, there's a race by which
> it could go to NULL after you acquired the page by read_mapping_page:
> not by file truncation, but by swapping out at the wrong instant.
> Don't worry, you have the right page, just don't rely on page->mapping.
>
> (Sorry if I'm rather talking aloud to myself here.)
>
> Hugh
