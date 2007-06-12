Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbXFLRZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbXFLRZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 13:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756561AbXFLRZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 13:25:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:37971 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756196AbXFLRZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 13:25:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,412,1175497200"; 
   d="scan'208";a="238310282"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Dave Jones <davej@redhat.com>
Subject: Re: [RFC][AGPGART]intel-agp: save whole config space in suspend/resume
Date: Tue, 12 Jun 2007 10:24:50 -0700
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>, andi@rhlx01.fht-esslingen.de,
       Keith Packard <keithp@keithp.com>
References: <20070612015459.GB28668@zhen-devel.sh.intel.com> <20070612033424.GA30200@zhen-devel.sh.intel.com> <20070612035914.GA23169@redhat.com>
In-Reply-To: <20070612035914.GA23169@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706121024.50717.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 11, 2007 8:59:14 Dave Jones wrote:
> On Tue, Jun 12, 2007 at 11:34:25AM +0800, Wang Zhenyu wrote:
>  > I understand. Before James reported his problem on i915, I have
>  > thought the basic restore on that chip should already be enough,
>  > but he proved I was wrong and I'm not sure if this also happens on
>  > other i915 board with different BIOS.
>  >
>  > And with my patch it has already removed the restore cases for
>  > 440BX like type, coz it's gmch_chip_id == 0 and
>  > intel_private.pcidev is NULL, so it won't save extra space on
>  > those chips.
>
> The 440BX was one example, for all we know there are similar ordering
> issues with other chipsets.  We hit this problem with the code that
> restores the first 64 bytes first of all. Then we found out we had
> to restore them in reverse order to be safe.  We were able to do
> this generically, because those bytes are standardised across
> devices.
>
> The upper config space isn't standardised, so we have to obey the
> per-device rules as to what order we read/write things.
> Writing back an "enable" bit somewhere before we've written back
> addresses in later registers for example may result in really
> bizarre things happening.  These are the kind of bugs that aren't
> obvious, and turn out to be "that weird reboot that happens
> every 3rd tuesday" six months after we've merged the changes
> and everyones forgotten all about the potential problems.
>
> The AGP code has had more than its fair share of really nasty
> bugs like this to track down, so I'm strongly opposed to introducing
> hacks that may trip us up later.
>
> Whilst I'm not a huge fan of the 815 patch in -mm as it stands,
> I think it's a better direction to go in to have per-chipset
> save/restore routines.

I agree.  I think saving the registers explicitly rather than as a block 
is the best long term direction.  That way we can carefully evaluate 
which ones actually need to be saved/restored, and it what order.  
Doing it as a block hides that and makes it seem chipset independent 
when it really might not be...

Jesse
