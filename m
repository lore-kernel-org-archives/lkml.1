Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbXIQBhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbXIQBhl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 21:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbXIQBhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 21:37:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:19300 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbXIQBhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 21:37:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,262,1186383600"; 
   d="scan'208";a="309834314"
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
From: Shaohua Li <shaohua.li@intel.com>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Robert Hancock <hancockr@shaw.ca>, Greg KH <gregkh@suse.de>,
       Matthew Wilcox <matthew@wil.cx>, lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <20070916151355.A18508@jurassic.park.msu.ru>
References: <fa.o5cJ0O7pLVWRzUiVPDEZL6nKqA8@ifi.uio.no>
	 <fa.tyYt4GOpTOmJTUbzsxpiCAObJPQ@ifi.uio.no>
	 <fa.13eJumylqINOxOaoEj9cthw0d0M@ifi.uio.no>
	 <fa.tAIuIM02CoL+ixB11n9Fmcqyz9M@ifi.uio.no>
	 <fa.pxFYhTaUz2NVN7Vux7b5xVRrKTw@ifi.uio.no> <46EA00DA.6010704@shaw.ca>
	 <20070914151401.A5586@jurassic.park.msu.ru> <46EA9B23.7030709@shaw.ca>
	 <20070914192913.A6668@jurassic.park.msu.ru> <46EB1F16.8060209@shaw.ca>
	 <20070916151355.A18508@jurassic.park.msu.ru>
Content-Type: text/plain
Date: Mon, 17 Sep 2007 09:21:47 +0800
Message-Id: <1189992107.26772.4.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-16 at 15:13 +0400, Ivan Kokshaysky wrote:
> On Fri, Sep 14, 2007 at 05:53:58PM -0600, Robert Hancock wrote:
> > In the first one, Linus talks about a USB controller whose SMM code 
> > chokes on the BAR being disabled. That explanation seems odd to me. If 
> > it chokes on the BAR disabled, how doesn't it choke on the BAR being 
> > moved to a different location, which is unavoidable during probing?
> 
> Here is an article with detailed explanation of that USB issue:
> 
>  http://support.microsoft.com/kb/250635
> 
> The most interesting fact there is that windows *does not* clear
> PCI_COMMAND_MEMORY bits during PCI bus enumeration, so BIOS writers
> have to rely on that. Yet another reason why your patch is unsafe.
> 
> > Also, I think we do USB handoff from the BIOS much earlier than we used 
> > to, which likely prevents these issues.
> 
> I don't think so. This can only be done in USB driver, which cannot run
> before PCI device discovery.
Most BIOS has an option called legacy emulation, which will emulate USB
mouse as legacy mouse. BIOS is using USB before driver is loaded.

If moving BAR work, disabling BAR should work too.

> > In the second one, he mentions that "So the secondary rule to "don't 
> > turnoff MEM or IO accesses" is "never allocate real PCI BAR resources at 
> > the top of memory". Well, unfortunately, the second one isn't possible 
> > to meet given that we have boards with the MMCONFIG up there, so 
> > disabling the decode is the only thing we can do. That whole discussion 
> > was also based on the fact that it wasn't necessary to solve problems. 
> > This is no longer a theoretical problem. We now have real problems that 
> > we need this in order to solve.
> 
> I have suggested a *practical* solution that disables the decode only
> when it's unavoidable. If it's not sufficient for some machines, it
> can be extended quite easily.
If you just want to workaroud the issue at hand, I'd take the method to
not use mmcfg at probe stage.

> > > No, it's impossible for several reasons. Most obvious one is that a PCI-E
> > > bridge does isolate stuff quite nicely.
> > 
> > It's not impossible at all. In fact I'm quite sure (Jesse can confirm) 
> > that in the case of the board he was using, it was an add-in graphics 
> > card where he saw this problem.
> 
> Again, it's impossible with AGP or PCI-E cards, which are always
> separated
> from the root bus by AGP or PCI-E bridge. The bridge does decode in
> the
> first place, so when you write the BAR with all ones, you move it
> outside
> the bridge decoding window. Address collision isn't possible in this
> case in principle.
I can confirm this is an add-in graphics card. the bfd is 00:02.0, so
it's not behind any AGP/PCI-E bridge.

Thanks,
Shaohua
