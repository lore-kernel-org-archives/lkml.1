Return-Path: <linux-kernel-owner+w=401wt.eu-S1757712AbYGQI7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712AbYGQI7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 04:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754807AbYGQI7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 04:59:36 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:26512 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058AbYGQI7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 04:59:35 -0400
Message-Id: <487F2629.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 17 Jul 2008 09:59:53 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andrew Paprocki" <andrew@ishiboo.com>
Cc: <robert.moore@intel.com>, "Len Brown" <lenb@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Andi Kleen" <ak@linux.intel.com>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: ACPI WARNING: at drivers/acpi/tables/tbfadt.c:348
	acpi_tb_create_local_fadt+0x147/0x2f4()
References: <76366b180807161929i4eb9462exc3d2255e0ec881e8@mail.gmail.com>
 <76366b180807162034y1e725b15t7658c331bb89b52@mail.gmail.com>
In-Reply-To: <76366b180807162034y1e725b15t7658c331bb89b52@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>I added printk()s and this is what is reported here:
>
>        printk(KERN_INFO
>               "xpm1a_event_block bit_width=%d pm1_register_length=%d\n",
>               acpi_gbl_FADT.xpm1a_event_block.bit_width, pm1_register_length);
>        acpi_tb_init_generic_address(&acpi_gbl_xpm1a_enable,
>                                     pm1_register_length,
>                                     (acpi_gbl_FADT.xpm1a_event_block.address +
>                                      pm1_register_length));
>
>[    0.000000] xpm1a_event_block bit_width=8 pm1_register_length=0
>
>The bit width is not % 16, so the following patch addition a few lines
>earlier fails:
>
>        WARN_ON(ACPI_MOD_16(acpi_gbl_FADT.xpm1a_event_block.bit_width));

So it's a firmware bug in the system you saw this on. The specification
is clear about the width being at least 16 bits, and the warning was added
to indicate the problem you now got: Dividing 8 by 16 yields zero for
pm1_register_length, which results in acpi_gbl_xpm1a_enable aliasing
the address of the respective status register. That won't work, hence
the warning.

I'd be hesitant to fix this (as I think we should be allowed to expect
ACPI tables to not be that fundamentally flawed these days), but of
course Len (or others) might be of a different opinion.

>Also, I noticed that the patch changed the definition of
>acpi_tb_init_generic_address to name the parameter byte_width instead
>of bit_width. The declaration at the top of the file and the
>documentation still refer to it as bit_width.
>
>I also added printk()s to the first call to
>acpi_tb_init_generic_address ~ line 326 and the lengths passed to the
>function at that point are:
>[    0.000000] fadt_info_table[i].length=88
>[    0.000000] fadt_info_table[i].length=89
>[    0.000000] fadt_info_table[i].length=93

Hmm, indeed, I didn't notice the (pointless) earlier declaration, I realize
I failed to update the function description. Bob, could you fix this in
ACPICA without the need for me to send a patch against it (assuming
the base patch went into ACPICA)?

Jan

