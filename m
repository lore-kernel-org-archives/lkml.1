Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbYBYICZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbYBYICZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 03:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYBYICP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 03:02:15 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:5939 "EHLO
	outbound1-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147AbYBYICO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 03:02:14 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0JWSBM5-02-RC2-01
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 03/10] PCI: AMD SATA IDE mode quirk
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Mon, 25 Feb 2008 16:00:48 +0800
Message-ID: <206C6845C72CAE439DC3D9D413C571A49664E8@ssuzexmb3.amd.com>
In-Reply-To: <20080225073100.GE26674@colo.lackof.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 03/10] PCI: AMD SATA IDE mode quirk
Thread-Index: Ach3gIqdkQDnqnNZT5GaVkai4R7g8wAAyMJA
References: <20080221234644.GA7128@kroah.com> <1203637660-7247-3-git-send-email-gregkh@suse.de> <20080222041733.GD16995@parisc-linux.org> <206C6845C72CAE439DC3D9D413C571A49662F8@ssuzexmb3.amd.com> <20080222111105.GE16995@parisc-linux.org> <206C6845C72CAE439DC3D9D413C571A49663E6@ssuzexmb3.amd.com> <20080225073100.GE26674@colo.lackof.org>
From: "Cai, Crane" <Crane.Cai@amd.com>
To: "Grant Grundler" <grundler@parisc-linux.org>
Cc: "Matthew Wilcox" <matthew@wil.cx>, "Greg Kroah-Hartman" <gregkh@suse.de>,
       <linux-pci@atrey.karlin.mff.cuni.cz>, <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@osdl.org>, "Andrew Morton" <akpm@osdl.org>
X-OriginalArrivalTime: 25 Feb 2008 08:00:48.0653 (UTC) FILETIME=[88521BD0:01C87784]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Feb 25, 2008 at 09:43:59AM +0800, Cai, Crane wrote:
> > > On Fri, Feb 22, 2008 at 01:49:20PM +0800, Cai, Crane wrote:
> > > > > On Thu, Feb 21, 2008 at 03:47:33PM -0800, Greg
> > > Kroah-Hartman wrote:
> > > > > > +static void __devinit quirk_amd_ide_mode(struct pci_dev 
> > > > > > +*pdev)
> > > > > >  {
> > > > > > -	/* set sb600 sata to ahci mode */
> > > > > > -	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE) {
> > > > > > -		u8 tmp;
> > > > > > +	/* set sb600/sb700/sb800 sata to ahci mode */
> > > > > > +	u8 tmp;
> > > > > >  
> > > > > > +	pci_read_config_byte(pdev, PCI_CLASS_DEVICE, &tmp);
> > > > > > +	if (tmp == 0x01) {
> > > > > >  		pci_read_config_byte(pdev, 0x40, &tmp);
> > > > > 
> > > > > This seems like a dis-improvement.  Why are we reading a
> > > config byte
> > > > > for something we already have in the pci_dev?
> > > > > Why are we now checking against 0x01 instead of a
> > > symbolic constant?  
> > > > > Why are we no longer checking that this is 
> PCI_BASE_CLASS_STORAGE?
> > > > It is a quirk. In pci_ids.h did have PCI_CLASS_STORAGE_IDE and 
> > > > PCI_BASE_CLASS_STORAGE, these can not represent the right
> > > situation we
> > > > want to check. 0x01 represents PCI_CLASS_STORAGE_IDE last 2
> > > bit. Also
> > > > because it is a quirk, I do not think we need to change
> > > pci_ids.h. So
> > > > 0x01 used.
> > > 
> > > You haven't explained what is wrong with the original code:
> > > 
> > > 	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE) {
> > > 
> > 
> > When resume, this pdev->class is quirked, however BIOS has modified 
> > pci configuration too. Inconsistance occurs.
> 
> Can you update pdev->class from the quirk?
I think we can, there are many places where pdev->class is changed in quirks.c.
> It would be consistent then.
> That would leave the code as-is except it's re-reading the 
> field from config space.
> 
> hth,
> grant

> > > > > Nothing in the changelog entry suggests why we now need
> > > FIXUP_RESUME
> > > > > entries when we didn't before.
> > > > > 
> > > > PCI configuration space will be changed by BIOS and then in
> > > pci init
> > > > and restore. So resume also needed.
> > > 
> > > That information needed to be in the changelog.
> > 
> > This info, is a normal info. If maintainer need us to added 
> in source code. I preferred too. 
> > > --
> > > Intel are signing my paycheques ... these opinions are still mine 
> > > "Bill, look, we understand that you're interested in 
> selling us this 
> > > operating system, but compare it to ours.  We can't possibly take 
> > > such a retrograde step."
> > > 
> > > 
> > > 
> 
> 
> 

