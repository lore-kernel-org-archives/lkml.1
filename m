Return-Path: <linux-kernel-owner+w=401wt.eu-S1760470AbXEaWjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760470AbXEaWjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 18:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbXEaWjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 18:39:10 -0400
Received: from palrel13.hp.com ([156.153.255.238]:47027 "EHLO palrel13.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426AbXEaWjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 18:39:09 -0400
Date: Thu, 31 May 2007 17:39:08 -0500
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [2/4] 2.6.22-rc3: known regressions
Message-ID: <20070531223908.GA12325@beardog.cca.cpqcorp.net>
References: <465C188F.9000900@googlemail.com> <465C22F4.8080505@googlemail.com> <alpine.LFD.0.98.0705301918450.26602@woody.linux-foundation.org> <20070531220833.GA10867@beardog.cca.cpqcorp.net> <alpine.LFD.0.98.0705311516350.26602@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705311516350.26602@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 03:22:07PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 31 May 2007, Mike Miller (OS Dev) wrote:
> 
> > On Wed, May 30, 2007 at 07:22:14PM -0700, Linus Torvalds wrote:
> > > 
> > > 
> > > On Tue, 29 May 2007, Michal Piotrowski wrote:
> > > > 
> > > > Subject    : Oops on 2.6.22-rc2 when unloading the cciss driver
> > > > References : http://lkml.org/lkml/2007/5/24/172
> > > > Submitter  : Mike Miller (OS Dev) <mikem@beardog.cca.cpqcorp.net>
> > > > Status     : Unknown
> > > 
> > > I thought this one should be fixed by commit e9ca75b53. Not so?
> > 
> > I apologize for the slow response. I also apologize that I don't know enough
> > about git to figure out what commit e9ca75b53 does.
> 
> Even without git, you can use the kernel.org gitweb install:
> 
> 	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=e9ca75b53
> 
> (where the "h=...." is the magic part - pick any commit SHA1 you want, 
> including short-hand ones like the one I gave).
> 
> With git, you just do
> 
> 	git show e9ca75b53
> 
> to see a particular named commit.
> 
> > I submitted a fix that was blessed by Eric B. that fixed that Oops.
> 
> Ok, I don't think I have anything like that. The one I pointed to is the 
> one by Gerald Britton, acked by you ..
> 
> But I now realize that that commit was already in -rc2. In fact, it's just 
> before the -rc2 release. So while it claims to fix one oops on shutdown, 
> it may be the _cause_ of the oops on mudule unload.
> 
> 		Linus
Linus,
The fix from Gerald was a different Oops and is not related to this problem.
This is the patch I submitted for the rmmod Oops:

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index e01380b..6632150 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -558,12 +558,12 @@ static int msi_free_irqs(struct pci_dev* dev)

        list_for_each_entry_safe(entry, tmp, &dev->msi_list, list) {
                if (entry->msi_attrib.type == PCI_CAP_ID_MSIX) {
-                       if (list_is_last(&entry->list, &dev->msi_list))
-                               iounmap(entry->mask_base);
-
                        writel(1, entry->mask_base + entry->msi_attrib.entry_nr
                                  * PCI_MSIX_ENTRY_SIZE
                                  + PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
+
+                       if (list_is_last(&entry->list, &dev->msi_list))
+                               iounmap(entry->mask_base);
                }
                list_del(&entry->list);
                kfree(entry);

Reference:
http://groups.google.com/group/linux.kernel/browse_frm/thread/ed0949e9d42cfdef/5953daaa00ea5bf7?lnk=gst&q=cciss&rnum=3&hl=en#5953daaa00ea5bf7

I'm not sure what the status is right now.

Thanks,
mikem
