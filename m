Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbYGUSip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbYGUSip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 14:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbYGUSii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 14:38:38 -0400
Received: from mga06.intel.com ([134.134.136.21]:60982 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751886AbYGUSih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 14:38:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,225,1215414000"; 
   d="scan'208";a="420042543"
Message-ID: <4884D7A3.6010802@linux.intel.com>
Date: Mon, 21 Jul 2008 20:38:27 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, robert.moore@intel.com,
       Alex Chiang <achiang@hp.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] acpi: fix crash in core ACPI code, triggered by	CONFIG_ACPI_PCI_SLOT=y
References: <200807161639.24289.jbarnes@virtuousgeek.org> <20080721135745.GA22748@elte.hu>
In-Reply-To: <20080721135745.GA22748@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

[For acpica issues please always put robert.moore@intel.com into Cc. Thanks]
[Bob, will need to resync this into ACPICA]

> I.e. when we called acpi_ns_handle_to_pathname(), we got required_size
> of 0 due to an error condition, but this is passed to the ACPI allocator
> unconditionally:
> 
>         required_size = acpi_ns_get_pathname_length(node);
> 
>         /* Validate/Allocate/Clear caller buffer */
> 
>         status = acpi_ut_initialize_buffer(buffer, required_size);
>         if (ACPI_FAILURE(status)) {
>                 return_ACPI_STATUS(status);
>         }
> 
> Where acpi_ut_initialize_buffer(), through many (unnecessary) layers, 
> ends up calling kzalloc(0). Which returns 0x10 and that then causes the 
> crash later on.
> 
> So fix both callers of acpi_ns_get_pathname_length(), which can return 0 
> in case of an invalid node.
> 
> Also add a WARN_ON() against zero sized allocations in 
> acpi_ut_initialize_buffer() to make it easier to find similar instances 
> of this bug.
> 
> I have tested this patch for the past 24 hours and the crash has not 
> reappeared.

Thanks for the detailed analysis and the patch. Patch looks mostly good,
except that the error message could be a little clearer ("Invalid zero 
length node string" perhaps?). It'll need to be backmerged into
the ACPICA code base, but that can be done in parallel without
delaying fixing this bug.

I can add it to my next batch your or you can add it one of yours
if you prefer.

-Andi
