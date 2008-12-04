Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbYLDBYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbYLDBYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 20:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbYLDBY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 20:24:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48975 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbYLDBY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 20:24:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Thu, 4 Dec 2008 02:23:53 +0100
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812031220.36711.rjw@sisk.pl> <alpine.LFD.2.00.0812030735230.3256@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812030735230.3256@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812040223.54341.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 3 of December 2008, Linus Torvalds wrote:
> 
> On Wed, 3 Dec 2008, Rafael J. Wysocki wrote:
> > 
> > Then, voila!, I'm not able to reproduce the hibernation-resume failure.
> > 
> > This appears to mean that:
> > (1) The sizes of the allocations and the locations of devices in the memory
> >     address space don't matter here.
> > (2) The presence and size of the prefetchable memory window don't matter here.
> > (3) What matters is the presence of non-prefetchable memory window on the
> >     supposedly transparent bridge.  Namely, if the window is there, resume from
> >     hibernation occasionally fails (again, the size of the window and the
> >     location of it in the memory address space doesn't seem to matter).
> 
> That is indeed rather odd, and very interesting. 
> 
> > So, apparently, on this box (and I guess on Frans' too) we could avoid the
> > problem if we didn't allocate the non-prefetchable memory window in
> > pci_bus_size_cardbus(), but I guess that wouldn't be generally correct.
> 
> Well, I think that what _would_ be generally correct, and actually pretty 
> simple, is a rather different approach: just not sizing things behind a 
> transparent bridge AT ALL, since it really shouldn't matter.
> 
> So if the appended patch fixes things for you, I think this might 
> potentially be the right approach.
> 
> NOTE NOTE NOTE! This patch is entirely untested, as usual. I didn't check 
> that this is necessarily the correct place to test for this, but it 
> does make sense. IOW, it _feels_ like the rigth thing.

Yes, it _looks_ sane.

> However, even if it fixes things for you, I think we're too late in the
> 2.6.28 cycle to really apply this.

Absolutely.

> So it really does make sense to consider a root bridge and a transparent 
> one to be equivalent here, since in both cases any bridge windows should 
> be irrelevant. Which is why I think this patch is interesting.
> 
> > Also, I would be happy to actually understand _why_ this happens.
> 
> 100% agreed. I do _not_ see why it should ever matter how we set up a PCI 
> bridging window - whether prefetchable or not - on a bridge that should be 
> transparent. It sounds really odd. I'm wondering if there is something 
> we're missing here.
> 
> But apart from the existence of the bridging window, the only thing that 
> it seems to affect is really just a minor layour issue. So it does seem 
> like it matters. Odd.

Well, in principle it may be related to the way we handle bridges during
resume, but I really need to read some docs and compare them with the code
before I can say anything more about that.  Surely, nothing like this issue has
ever been reported before.

Anyway, thanks for the patch, I'm going to try it tomorrow.

Best,
Rafael
