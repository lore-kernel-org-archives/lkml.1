Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbZBPOJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbZBPOJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 09:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbZBPOJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 09:09:14 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49400 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbZBPOJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 09:09:14 -0500
Subject: Re: [PATCH] Export symbol ksize()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-crypto@vger.kernel.org,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Geert.Uytterhoeven@sonycom.com
In-Reply-To: <20090216135643.GA6927@cmpxchg.org>
References: <1234272104-10211-1-git-send-email-kirill@shutemov.name>
	 <84144f020902100535i4d626a9fj8cbb305120cf332a@mail.gmail.com>
	 <20090210134651.GA5115@epbyminw8406h.minsk.epam.com>
	 <Pine.LNX.4.64.0902101605070.20991@melkki.cs.Helsinki.FI>
	 <20090216135643.GA6927@cmpxchg.org>
Date: Mon, 16 Feb 2009 16:09:11 +0200
Message-Id: <1234793351.8944.12.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

On Mon, 2009-02-16 at 14:56 +0100, Johannes Weiner wrote:
> On Tue, Feb 10, 2009 at 04:06:53PM +0200, Pekka J Enberg wrote:
> > On Tue, Feb 10, 2009 at 03:35:03PM +0200, Pekka Enberg wrote:
> > > > We unexported ksize() because it's a problematic interface and you
> > > > almost certainly want to use the alternatives (e.g. krealloc). I think
> > > > I need bit more convincing to apply this patch...
> >  
> > On Tue, 10 Feb 2009, Kirill A. Shutemov wrote:
> > > It just a quick fix. If anybody knows better solution, I have no
> > > objections.
> > 
> > Herbert, what do you think of this (untested) patch? Alternatively, we 
> > could do something like kfree_secure() but it seems overkill for this one 
> > call-site.
> 
> There are more callsites which do memset() + kfree():
> 
> 	arch/s390/crypto/prng.c
> 	drivers/s390/crypto/zcrypt_pcixcc.c
> 	drivers/md/dm-crypt.c
> 	drivers/usb/host/hwa-hc.c
> 	drivers/usb/wusbcore/cbaf.c
> 	(drivers/w1/w1{,_int}.c)
> 	fs/cifs/misc.c
> 	fs/cifs/connect.c
> 	fs/ecryptfs/keystore.c
> 	fs/ecryptfs/messaging.c
> 	net/atm/mpoa_caches.c
> 
> How about the attached patch?  One problem is that zeroing ksize()
> bytes can have an overhead of nearly twice the actual allocation size.
> 
> So we would need an interface that lets the caller pass in either a
> number of bytes it wants to have zeroed out or say idontknow.
> 
> Perhaps add a size parameter that is cut to ksize() if it's too big?
> Or (ssize_t)-1 for figureitoutyourself?

I'd prefer the kzfree() interface as-is. I don't think you want to do
the memset/kfree in a fast-path anyway.

If you can convince Andrew to pick this patch up and maybe convert some
call-sites to actually use it, then:

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

			Pekka

