Return-Path: <linux-kernel-owner+w=401wt.eu-S1761212AbXEWGzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761212AbXEWGzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 02:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbXEWGzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 02:55:16 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:59266 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063AbXEWGzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 02:55:14 -0400
Date: Tue, 22 May 2007 23:54:58 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: section mismatches
Message-ID: <20070523065458.GH3429@sequoia.sous-sol.org>
References: <20070522145245.727813f3.akpm@linux-foundation.org> <46537996.20302@goop.org> <20070523001247.GA3390@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070523001247.GA3390@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Wright (chrisw@sous-sol.org) wrote:
> I tracked down a bunch of these a little while back.  It's not really
> iret_exc, but since there is no _sfixup/_efixup markers iret_exc is the
> closest symbol to pick on.  All the [iret_exc, _etext] warnings I found
> were completely harmless from things that used, for example, mfn_to_pfn
> in an __init function (which sucks in a fixup via __get_user).

Took a moment to check current -mm allmodconfig as Andrew did.

$ make ARCH=i386 O=obj-mod allmodconfig
$ make -j8 ARCH=i386 O=obj-mod > obj-mod/build.out 2>&1
$ objdump -dr -j.text obj-mod/vmlinux > obj-mod/objdump.out
$ grep iret_exc obj-mod/build.out | sed 's/.*(at offset 0x\(.*\)).*/\1/' | while read addr; do grep -B1 $addr obj-mod/objdump.out; done
c0306935:       e9 41 7e 19 00          jmp    c049e77b <romsignature+0x1f>
                        c0306936: R_386_PC32    .init.text
c0306941:       e9 83 7e 19 00          jmp    c049e7c9 <romchecksum+0x34>
                        c0306942: R_386_PC32    .init.text
c030694d:       e9 8e 85 19 00          jmp    c049eee0 <request_standard_resources+0x82>
                        c030694e: R_386_PC32    .init.text
c0306959:       e9 93 86 19 00          jmp    c049eff1 <request_standard_resources+0x193>
                        c030695a: R_386_PC32    .init.text
c0306fd4:       e9 bc c6 1a 00          jmp    c04b3695 <xenbus_probe_init+0x69>
                        c0306fd5: R_386_PC32    .init.text
c0307120:       e9 2c f3 1a 00          jmp    c04b6451 <pci_pcbios_init+0x33>
                        c0307121: R_386_PC32    .init.text

Each of these is indeed from __get_user called from an __init function.

- romsignature calls __get_user via probe_kernel_address
- romchecksum calls __get_user via probe_kernel_address
- request_standard_resources inlines probe_roms which
  twice calls __get_user via probe_kernel_address
- xenbus_probe_init calls __get_user via mfn_to_pfn
- pci_pcbios_init calls __get_user via probe_kernel_address

We could simply hush it up, by forcing that call to be out of line from
the __init function.  That's not really robust, since each callsite needs
attention (meaning new ones will sneak in over time).  Or fix the linker
script (and possibly modpost.c).
