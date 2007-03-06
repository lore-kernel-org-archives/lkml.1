Return-Path: <linux-kernel-owner+w=401wt.eu-S965528AbXCFSPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965528AbXCFSPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965535AbXCFSPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:15:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965524AbXCFSPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:15:04 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0703051843030.10272@blonde.wat.veritas.com> 
References: <Pine.LNX.4.64.0703051843030.10272@blonde.wat.veritas.com>  <Pine.LNX.4.64.0703021646050.13167@blonde.wat.veritas.com> <20070216165042.GB409@lnx-holt.americas.sgi.com> <45D5B483.3020502@hitachi.com> <45D5B2E3.3030607@hitachi.com> <20368.1171638335@redhat.com> <18817.1171656543@redhat.com> <29317.1172931029@redhat.com> 
To: Hugh Dickins <hugh@veritas.com>
Cc: Robin Holt <holt@sgi.com>,
       "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: Re: [PATCH 3/4] coredump: ELF-FDPIC: enable to omit anonymous shared memory 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 06 Mar 2007 18:13:33 +0000
Message-ID: <3378.1173204813@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hugh Dickins <hugh@veritas.com> wrote:

> > > Under precisely what NOMMU conditions?
> > 
> > CONFIG_MMU=n.
> 
> Believe it or not, I had just about grasped that subtlety.  I was
> rather expecting some helpful response along the lines of "we share
> all the vmas across a fork" or "whenever we go to allocate a vma, we
> look to see if there's already an isomorphic vma which we can share"
> or something like that.  But don't worry about it, the source is
> there for me to look at whenever.

Any VMAs that can be shared are, as a general rule.  It works this way because
shared MAP_PRIVATE read-only file data (such as a segment of an ELF
executable) is stored in a kmalloc()'d buffer attached to the VMA.  The
lifetime of this buffer is handled by the VMA, and the buffer is not part of
the pagecache.

Maybe it could be; that'd make the ramfs handling more consistent with normal
file handling.

Such things as mappable chardevs do get separate VMA's, but those don't own
the backing store.  That's configured through the BDI information in the
address_space.

> > I can if it makes you happier.  It's not strictly necessary, but it does
> > make the struct smaller which is good.
> 
> No, it doesn't really make me any happier: I expect that if I look any
> deeper, I'll just find plenty more to worry about there.

Good.  I was hoping someone else would review it.

> I have the impression, now reinforced by your defensive posture,

*shrug*  I was trying to keep the VMA as little changed as possible and add as
little extra to it as possible.

> that NOMMU is a hack that squeamish outsiders had better not look too deeply
> into:

Anyone that squeamish should avoid the full MMU VM like the plague then - it's
way way worse.  NOMMU is considerably simpler.  Yes, some liberties have to be
taken, but there's no avoiding that as there's no MMU available.  I've tried to
take as few as possible, and I've managed to make sure almost all the
functionality afforded by the MMU kernels is available.

> so long as it mostly works for those who need it to work, we'd probably just
> be wasting your time anyway.

*shrug* as you wish.

David
