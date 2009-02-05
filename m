Return-Path: <linux-kernel-owner+w=401wt.eu-S1759531AbZBEShb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531AbZBEShb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbZBEShX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:37:23 -0500
Received: from outbound-mail-136.bluehost.com ([67.222.39.26]:32827 "HELO
	outbound-mail-136.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753111AbZBEShW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:37:22 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=hVQHtmKqsECTf5KutKT4Fv9tLDdNpxYlkUs3AWuQk2Q/I/80+CNjL784dNwVVKDGc5JMtFODQQzLKfr3iMnAIQgzqoO2bGKOYiysSqOO8tTewb2rObDbx7D3kuu1rlS6;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Eric Anholt <eric@anholt.net>
Subject: Re: Gem GTT mmaps..
Date: Thu, 5 Feb 2009 10:37:19 -0800
User-Agent: KMail/1.9.10
Cc: Thomas =?iso-8859-15?q?Hellstr=F6m?= <thomas@shipmail.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <498A1760.7010108@shipmail.org> <200902041502.41524.jbarnes@virtuousgeek.org> <1233790920.16368.4.camel@gaiman>
In-Reply-To: <1233790920.16368.4.camel@gaiman>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902051037.20590.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 4, 2009 3:42 pm Eric Anholt wrote:
> On Wed, 2009-02-04 at 15:02 -0800, Jesse Barnes wrote:
> > On Wednesday, February 4, 2009 2:32 pm Thomas Hellström wrote:
> > > Jesse,
> > >
> > > I have some concerns about the GEM GTT mmap functionality.
> >
> > Thanks for looking it over again; you would know since some of this code
> > came from you in the first place. :)
> >
> > > First, a gem object pointer is copied to map->offset and then to the
> > > vma->vm_private_data without proper reference counting. This pointer is
> > > used in i915_gem_fault() to access the gem object. However if the gem
> > > object is destroyed and a process then tries to access data in a vma
> > > mapping the (now destroyed) object, it would dereference a stale
> > > pointer into kernel space? Shouldn't those pointers be reference
> > > counted, and to account for fork(), a vm open and close would be needed
> > > to  reference count corresponding pointers of newly created and
> > > destroyed vmas?
> >
> > Yeah looks like we don't protect against vm_private_data pointing at a
> > freed or other object.  But rather than refcounting the pointers I wonder
> > if we could make the private data use the GEM object name instead, then
> > do the lookup in the fault handler?
>
> The object doesn't necessarily have a public name.  You do need to
> refcount the objects.

So if we leave the lookup reference around from the GTT mapping ioctl, that 
would take care of new mappings.  And if we added/removed references at VM 
open/close time, we should be covered for fork.  But is it ok to add a new 
unref in the finish ioctl for GTT mapped objects?  I don't think so, because 
we don't know for sure if the caller was the one that created the new fake 
offset (which would be one way of detecting whether it was GTT mapped).  
Seems like we need a new unmap ioctl?  Or we could put the mapping ref/unref 
in libdrm, where it would be tracked on a per-process basis...

-- 
Jesse Barnes, Intel Open Source Technology Center
