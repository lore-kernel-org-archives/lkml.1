Return-Path: <linux-kernel-owner+w=401wt.eu-S1423604AbXD3SZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423604AbXD3SZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423605AbXD3SZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:25:51 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:49937 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423604AbXD3SZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:25:47 -0400
Date: Mon, 30 Apr 2007 11:28:38 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Len Brown <lenb@kernel.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>, Andi Kleen <ak@suse.de>,
       Shai Fultheim <shai@scalex86.org>, linux-kernel@vger.kernel.org
Subject: Re: ACPI build problem (2.6.21 CONFIG_X86_64_ACPI_NUMA)
Message-ID: <20070430182838.GA5558@localhost.localdomain>
References: <1177593963.5462.12.camel@quoit.chygwyn.com> <200704280159.46337.lenb@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704280159.46337.lenb@kernel.org>
User-Agent: Mutt/1.4.2.1i
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 01:59:46AM -0400, Len Brown wrote:
> On Thursday 26 April 2007 09:26, you wrote:
> ... 
> CONFIG_ACPI depends on CONFIG_PM, yet this build fails because you have
> CONFIG_ACPI=y and CONFIG_PM=n
> 
> Unfortunately kconfig doesn't trace dependencies when "select" is used,
> making select sort of evil.  Ie. select can't target anything which
> itself has dependencies.
> 
> In 2.6.15, b0bd35e622ffbda2c01dc67a0381c6a18817a29a added the select below,
> and subsequently ACPI became dependent on PM, which broke your build.
> Technically, this could have broken your build in other ways too
> since ACPI already had other dependencies.
> 
> +# Dummy CONFIG option to select ACPI_NUMA from drivers/acpi/Kconfig.
> +
> +config X86_64_ACPI_NUMA
> +       bool "ACPI NUMA detection"
> +       depends on NUMA
> +       select ACPI 
> +       select ACPI_NUMA
> +       default y
> +       help
> +	 Enable ACPI SRAT based node topology detection.
> 
> If you de-select CONFIG_X86_64_ACPI_NUMA then the select goes away
> and kconfig should work properly.
> 
> It isn't immediately clear to me how the NUMA Kconfig patch is a step
> forward, but perhaps the authors can comment.
>

Before the above change, to select NUMA for em64T systems, you *had* to
select K8_NUMA in the 'Processor type and features'  sub menu to select
CONFIG_NUMA, and then select ACPI NUMA from the generic PM menu, which is
not very intuitive when you have a EM64T NUMA system.

On x86_64 platforms, NUMA topology detection could be K8 style detection,
ACPI based topology  or NUMA emulation.  Most of the real NUMA systems
would need ACPI detection, older AMD platforms would need K8_NUMA, and 
NUMA emulation is a debugging/emulation option to emulate NUMA topology on
a regular SMP box.  Since CONFIG_NUMA + CONFIG_NUMA_EMU is a valid
combination, and since CONFIG_NUMA + CONFIG_K8_NUMA is a valid combination,
it makes sense to have X86_64_ACPI_NUMA on its own, and grouped along with
other NUMA topology styles in the Processor menu.  Hope this is good enough
reason :)

Regarding the subject build breakage, CONFIG_ACPI depends on CONFIG_PM with
an explicit 'depends' keyword. If PM does not get selected and CONFIG_ACPI
gets selected, I would think it is a Kconfig bug which needs fixing no?
Else, we can add a workaround by selecting CONFIG_PM if X86_64_ACPI_NUMA is
chosen.  But AFAICT the right thing is to fix the Kconfig bug.

Thanks,
Kiran
