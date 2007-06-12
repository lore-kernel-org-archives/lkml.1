Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbXFLD71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbXFLD71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 23:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbXFLD7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 23:59:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbXFLD7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 23:59:18 -0400
Date: Mon, 11 Jun 2007 23:59:14 -0400
From: Dave Jones <davej@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>, andi@rhlx01.fht-esslingen.de,
       Keith Packard <keithp@keithp.com>
Subject: Re: [RFC][AGPGART]intel-agp: save whole config space in
	suspend/resume
Message-ID: <20070612035914.GA23169@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>, andi@rhlx01.fht-esslingen.de,
	Keith Packard <keithp@keithp.com>
References: <20070612015459.GB28668@zhen-devel.sh.intel.com> <20070612022320.GA2125@redhat.com> <20070612033424.GA30200@zhen-devel.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612033424.GA30200@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 11:34:25AM +0800, Wang Zhenyu wrote:

 > I understand. Before James reported his problem on i915, I have thought
 > the basic restore on that chip should already be enough, but he proved I was
 > wrong and I'm not sure if this also happens on other i915 board with different
 > BIOS. 
 > 
 > And with my patch it has already removed the restore cases for 440BX like type,
 > coz it's gmch_chip_id == 0 and intel_private.pcidev is NULL, so it won't save
 > extra space on those chips.

The 440BX was one example, for all we know there are similar ordering
issues with other chipsets.  We hit this problem with the code that
restores the first 64 bytes first of all. Then we found out we had
to restore them in reverse order to be safe.  We were able to do
this generically, because those bytes are standardised across devices.

The upper config space isn't standardised, so we have to obey the
per-device rules as to what order we read/write things.
Writing back an "enable" bit somewhere before we've written back
addresses in later registers for example may result in really
bizarre things happening.  These are the kind of bugs that aren't
obvious, and turn out to be "that weird reboot that happens
every 3rd tuesday" six months after we've merged the changes
and everyones forgotten all about the potential problems.

The AGP code has had more than its fair share of really nasty
bugs like this to track down, so I'm strongly opposed to introducing
hacks that may trip us up later.

Whilst I'm not a huge fan of the 815 patch in -mm as it stands,
I think it's a better direction to go in to have per-chipset
save/restore routines.

	Dave

-- 
http://www.codemonkey.org.uk
