Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbYDGUBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbYDGUBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 16:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbYDGUBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 16:01:06 -0400
Received: from outbound-mail-130.bluehost.com ([67.222.38.30]:58294 "HELO
	outbound-mail-130.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752566AbYDGUBF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 16:01:05 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas =?iso-8859-1?q?Hellstr=F6m?= <thomas@tungstengraphics.com>
Subject: Re: [PATCH] x86: create array based interface to change page attribute
Date: Mon, 7 Apr 2008 12:59:19 -0700
User-Agent: KMail/1.9.9
Cc: Arjan van de Ven <arjan@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
       Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <200804071123.27411.jbarnes@virtuousgeek.org> <47FA7B58.6040907@tungstengraphics.com>
In-Reply-To: <47FA7B58.6040907@tungstengraphics.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804071259.19743.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 07, 2008 12:51 pm Thomas Hellström wrote:
> > Hopefully the WC stuff will be upstream right after 2.6.25 comes out. 
> > Any reason why we shouldn't keep the pages mapped in the kernel as WC
> > assuming the interface is there?
>
> If the pages are unmapped, we can get reasonable speed doing
> unbind-read-bind operations, kernel accesses to the memory will need to
> use an iomap_atomic_prot_pfn() type of operation.
> No IPI global tlb flushes needed for kernel mapping changes during
> unbind-read-bind and no cache flushes needed either if we write-protect
> the user-space mappings properly, or very limited cache flushes if we
> keep dirty-written-while-cached flags for each page.
>
> If the pages are wc-d we'll need two extra IPI global tlb flushes and a
> buffer-size cache flush every time we do unbind-read-bind, but OTOH we
> don't need the iomap_atomic_prot_pfn() to access single pages from the
> kernel.

Why would we need to flush at all at unbind-read-bind time?  We should be able 
to leave pages in the WC state even when we unbind them, then when we need to 
bind them back into the GTT they'll be ready, but maybe I'm misunderstanding 
you here...

> > Also, to make the API readable, we'd probably want to split the function
> > into kernel_map_pages(..., enum memory_type type) and
> > kernel_unmap_pages(...) (though like I said I think we really should be
> > mapping them WC not umapping them altogether, since we do want to hit the
> > ring buffer from the kernel with the WC type for example).
>
> I think ring-buffers are using ioremap() or vmap() already today. We can
> use these to get WC-type access also in the future. The only time we use
> the linear kernel mapping today is for single page access while patching
> up command buffers.

Yeah, they're ioremapped now, but that's a problem since with the PAT patches 
they'll be mapped hard UC (right now it just happens to work).

Thanks,
Jesse
