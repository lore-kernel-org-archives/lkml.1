Return-Path: <linux-kernel-owner+w=401wt.eu-S1760620AbZLOQzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620AbZLOQzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 11:55:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760604AbZLOQzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 11:55:09 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:24637 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760602AbZLOQzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 11:55:07 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: Are these MTRR settings correct?
Date: Tue, 15 Dec 2009 09:55:03 -0700
User-Agent: KMail/1.9.10
Cc: Robert Hancock <hancockrwd@gmail.com>, Tvrtko Ursulin <tvrtko@ursulin.net>,
       Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <200912130807.44905.tvrtko@ursulin.net> <4B26E4C7.8040100@gmail.com> <4B26E973.6080305@kernel.org>
In-Reply-To: <4B26E973.6080305@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912150955.03974.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 December 2009 06:42:11 pm Yinghai Lu wrote:
> Robert Hancock wrote:
> > Something else isn't quite right. It looks like MMCONFIG area should be
> > reserved:
> > 
> > [    0.308434] system 00:0c: iomem range 0xe0000000-0xefffffff has been
> > reserved
> > 
> > but the code didn't seem to detect that. In fact there doesn't seem to
> > be any output about whether it was or wasn't reserved, which from the
> > code it seems there should be.
> > 
> > Maybe because of that ACPI method execution error?
> 
> could be sth pnpacpi brokenness?

Robert, I assume you're referring to this from Tvrtko's post
(http://lkml.org/lkml/2009/12/13/90):

[    0.000000]  BIOS-e820: 00000000dffd0000 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
...
[    0.250088] PCI: Found AMD Family 10h NB with MMCONFIG support.
[    0.250091] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.250092] PCI: Not using MMCONFIG.
...
[    0.253491] ACPI Error (psargs-0359): [ECEN] Namespace lookup failure, AE_NOT_FOUND
[    0.253495] ACPI Error (psparse-0537): Method parse/execution failed [\] (Node ffffffff81656ab0), AE_NOT_FOUND
...
[    0.308434] system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved

I think we're rejecting MMCONFIG in the early call to
pci_mmcfg_reject_broken(), when we check only E820 resources, not
ACPI resources.  And indeed, the 0xe0000000-0xefffffff range is
not mentioned in E820.  Which output did you expect to see?

I am uncomfortable with this early/late checking and looking at both
E820 and ACPI.  It just feels hacky and error-prone.  I'm not happy about
adding Yinghai's special-case "if we found AMD Fam10h, don't check for
reservations" patch either.

I assume that Windows runs on this box without requiring per-machine
hacks in the kernel.  Linux should be able to do the same, and the fact
that we can't is telling us we're doing somethign wrong.  We should fix
whatever's wrong rather than papering over it.

Bjorn
