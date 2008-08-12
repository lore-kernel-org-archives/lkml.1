Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbYHLQWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbYHLQWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 12:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbYHLQV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 12:21:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:2868 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbYHLQV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 12:21:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=KjIlCewpxBEtb1+8TL5j7tFkA+ZN6OUcM5JylTu81wkVXPHmcpdrl5Rkia2d8vWrBN
         UR/cKkIjMYydgnzAV3sgl/xqQdyXksJ156heNpesAt50ym4xin6L01OWJZta6mwYsQLU
         8bNMj9CcKvGo+nt2pBFH993cQRj6Zp6x/YAw8=
Date: Tue, 12 Aug 2008 20:21:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: protecting early_param from null injecting
Message-ID: <20080812162156.GA10163@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I spent some time on eraly_param handling and it seems
it will not be possible to just set absentee parameter
to end of string to prevent NULL deref. As I can see
the easier way is to add checking for NULL pointer.

And here is why - currently kernel will hang if user
forget to specify mandatory boot parameter - pointing
us to fix that point in kernel to prevent NULL deref.
If we may early_param to behave as __setup() funtion does -
we will have to review/fix kernel code anyway - for example
in arch/mips/kernel/setup.c

---
static int __init early_parse_mem(char *p)
{
	unsigned long start, size;

	/*
	 * If a user specifies memory size, we
	 * blow away any automatically generated
	 * size.
	 */
	if (usermem == 0) {
		boot_mem_map.nr_map = 0;
		usermem = 1;
 	}
	start = 0;
	size = memparse(p, &p);
	if (*p == '@')
		start = memparse(p + 1, &p);

	add_memory_region(start, size, BOOT_MEM_RAM);
	return 0;
}
early_param("mem", early_parse_mem);
---

If user will specify boot option as "mem=" without arg
we will have hang on eraly boot stage but if we change it
to zero-sized-string it will not fail and add_memory_region
will be processed as well by adding zero-sized memory region.
I don't know maybe it's safe to add zero-sized memory region
but I have a gut feeling in this way we could change program
flow and get hidden bugs.

I think there about ~15-20 places in kernel left without NULL
checking - not that many :) As only I finish with my current
APIC attempts - I could fix them.

		- Cyrill -
