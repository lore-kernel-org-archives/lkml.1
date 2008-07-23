Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbYGWQ7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbYGWQ7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 12:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbYGWQ65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 12:58:57 -0400
Received: from outbound-mail-06.bluehost.com ([69.89.17.206]:45481 "HELO
	outbound-mail-06.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752609AbYGWQ64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 12:58:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=CWXCUYlSxj/5bCPt9qbj6jB0ITA8WGhGtT78huALm9h2sWVnEhjZ+zAlekEyOuPLd7H5uFAWPMEqJHQ/H5HB0RbkO6QWZzjHriD6r6HwddIqDz7ZeM2DFoWH/DadQ/Da;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: akataria@vmware.com
Subject: Re: acpi based pci gap calculation  - v3
Date: Wed, 23 Jul 2008 09:58:32 -0700
User-Agent: KMail/1.9.9
Cc: Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Brown@vger.kernel.org, Len <len.brown@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       TJ <linux@tjworld.net>
References: <1216148382.6135.21.camel@alok-dev1> <200807221450.52114.jbarnes@virtuousgeek.org> <1216767168.5693.31.camel@alok-dev1>
In-Reply-To: <1216767168.5693.31.camel@alok-dev1>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807230958.32898.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 22, 2008 3:52 pm Alok Kataria wrote:
> In the log that you sent me, please note the following debug messages
> -------
> E820_DEBUG: Searching for gap between (0x00000000 - 0x100000000)
> E820_DEBUG: Found gap starting at 0xbf000000 size 0x40f00000
> Allocating PCI resources starting at c0000000 (gap: bf000000:40f00000)
> -------
>
> This is the gap that was allocated by walking just the e820_map
>
> With my changes we query the _CRS resource and get following info
> ------
> ACPI_DEBUG start_addr 0xf8000000 gapsize 0x00400000 address_length
> 0x06b00000 end_addr is 0xfeb00000
> E820_DEBUG: Searching for gap between (0xf8000000 - 0xfeb00000)
> E820_DEBUG: Found gap at start starting at 0x100000000 size 0x07f00000
> ACPI_DEBUG start_addr 0xbf000000 gapsize 0x07f00000 address_length
> 0x31000000 end_addr is 0xf0000000
> E820_DEBUG: Searching for gap between (0xbf000000 - 0xf0000000)
> E820_DEBUG: Found gap starting at 0xbf000000 size 0x31000000
> ------
>
> So there are 2 producer regions one from [0xBF000000 - 0xF0000000] and
> another from [0xF8000000 - 0xFEB00000]. That means BIOS has reserved the
> area from [0xF0000000 - 0xF7FFFFFF] for some other resource.
> If you look a little below in the log there is this
>
> ----
> system 00:01: iomem range 0xf0000000-0xf7ffffff has been reserved
> ----
>
> So the gap that we had calculated first i.e. from e820_setup_gap did
> contain a collision i.e. though a resource was reserved from
> [0xf0000000 - 0xf7ffffff] our gap calculation doesn't take that into
> account.  My patch fixes this issue.
>
> So, IMHO this is a BUG and should be fixed. Please let me know your
> views.

Yes, there's a conflict there, but on many machines it's probably a harmless 
one.  My main concerns are these:
  1) it changes long standing behavior and doesn't fix any real reported bugs
     I'm aware of (feel free to point me at some)
  2) it looks like it will dramatically reduce the available PCI resource
     space on at least some platforms, and that space is already scarce in our
     current scheme

So basically, I'm just feeling very conservative about any changes to resource 
allocation, that's all.

If this change were coupled with one that allowed us to exploit more available 
address space for PCI resources I'd feel much more comfortable about it, 
which is why I'm so interested in TJ's work (/me goes off to read his wiki 
now).

Thanks,
Jesse
