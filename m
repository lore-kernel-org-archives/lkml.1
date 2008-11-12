Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbYKLAvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbYKLAvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbYKLAuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:50:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751544AbYKLAux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:50:53 -0500
Date: Tue, 11 Nov 2008 16:50:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: vda.linux@googlemail.com, hugh@veritas.com, torvalds@linux-foundation.org,
       deller@gmx.de, jirislaby@gmail.com, jer@gentoo.org,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Who broke cb8f488c33 patch? (was Re: [PATCH 1/1] USBHID:
 correct start/stop cycle)
Message-Id: <20081111165038.fb1f2f45.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.1.10.0811120126320.24889@jikos.suse.cz>
References: <1225579306-28524-1-git-send-email-jirislaby@gmail.com>
	<200811022024.31528.vda.linux@googlemail.com>
	<alpine.LNX.1.10.0811120021500.24889@jikos.suse.cz>
	<200811120124.41222.vda.linux@googlemail.com>
	<alpine.LNX.1.10.0811120126320.24889@jikos.suse.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 01:34:54 +0100 (CET)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Wed, 12 Nov 2008, Denys Vlasenko wrote:
> 
> > > > > I fully bisected it, and the final "buggy" patch seems to have been 
> > > > > Denys Vlasenko's patch: cb8f488c33539f096580e202f5438a809195008f (see 
> > > > > http://github.com/jonsmirl/digispeaker/commit/cb8f488c33539f096580e202f5438a809195008f) 
> > > > > Denys: Any reason you removed "!prev" in front of "expand_stack"?
> > > > Looks like I erroneously thought it can't be NULL,
> > > > or that expand_upwards() is ok with getting NULL vma parameter.
> > > > I looked again and neither is true.
> > > > Sorry, looks like I indeed broke this.
> > > Hmm, so ... ? Seems like this didn't get fixed in Linus' tree yet?
> > I found my original email in "sent" folder. The patch in that mail does 
> > NOT remove !prev. That change had beed added by someone else. See 
> > attached file with original email.
> > Ok, I think we are not much interested in who did it, 
> 
> Hmm, I in fact think we would like to know who removed the check and 
> folded it into your original patch. I have added all the Signoffs and CCs 
> to the recepient list.
> 
> Andrew usually puts
> 
> 	[someone@somewhere.com: added this and that to the patch]
> 
> marker into the changelog, but it's not the case here. 
> 
> Having your name in Signed-off-by field of something you are not aware of 
> should make you feel at least a little bit nervous IMHO.
> 
> > let's fix it for good.
> > Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> > --- linux-2.6.28-rc4/mm/mmap.c	Mon Nov 10 01:36:15 2008
> > +++ linux-2.6.28-rc4.fix/mm/mmap.c	Wed Nov 12 01:21:39 2008
> > @@ -1704,7 +1704,7 @@
> >  	vma = find_vma_prev(mm, addr, &prev);
> >  	if (vma && (vma->vm_start <= addr))
> >  		return vma;
> > -	if (expand_stack(prev, addr))
> > +	if (!prev || expand_stack(prev, addr))
> >  		return NULL;
> >  	if (prev->vm_flags & VM_LOCKED) {
> >  		if (mlock_vma_pages_range(prev, addr, prev->vm_end) < 0)
> 

It looks like this was caused by me fixing rejects.  That was the fancy
include-lots-of-context-so-it-wont-apply patch.

