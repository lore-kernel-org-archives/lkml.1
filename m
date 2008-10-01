Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbYJAM5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbYJAM5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 08:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbYJAM52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 08:57:28 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:44897 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbYJAM52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 08:57:28 -0400
Date: Wed, 1 Oct 2008 06:57:11 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: introduce users of ioremap_pcibar()
Message-ID: <20081001125711.GG13822@parisc-linux.org>
References: <20080926163641.288bf868@infradead.org> <20080926163718.32f0867e@infradead.org> <20080929072643.GA28871@colo.lackof.org> <20080929064220.374c68a4@infradead.org> <20080929171049.GA14409@colo.lackof.org> <20080929102325.0ca5c0c9@infradead.org> <20081001052450.GB7348@colo.lackof.org> <20080930153001.1107c0de@infradead.org> <20081001124254.GD10632@phobos.i.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001124254.GD10632@phobos.i.cabal.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2008 at 08:42:54AM -0400, Kyle McMartin wrote:
> On Tue, Sep 30, 2008 at 03:30:01PM -0700, Arjan van de Ven wrote:
> > I'm fine with pci_iomap_bar()... it meets my goals
> > Would be nice if I'd be allowed to make it only work on MEM bars not IO
> > bars (so that drivers don't accidentally end up calling this on an IO
> > bar and then using readl() etc)
> 
> If they use the iomap interface they shouldn't be using readl at all,
> they should be using ioread*... It would be a bug otherwise.

That's a viewpoint I've heard several people espouse over the last few
days, but it's not (entirely) true.  Addresses returned from calling
iomap() on a memory location must be compatible with addresses returned
from calling ioremap(), so you can use readl() on an iomap address, as
long as you know that it was a memory address that was iomapped.

        if (flags & IORESOURCE_MEM) {
                if (flags & IORESOURCE_CACHEABLE)
                        return ioremap(start, len);
                return ioremap_nocache(start, len);
        }

OK, not all architectures use the generic code, but I've been through
and they all do more or less the above (mn10300 and frv just return the
address, but their readl() and inl() are identical)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
