Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbYKXVTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbYKXVTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 16:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbYKXVTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 16:19:09 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:19329 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbYKXVTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 16:19:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=okE8NehF1HbgykFtmm3/8XPnR2oWW1Prze4sBE4qDV7sPUZqYJ9NOfpW42QnYZ9rW+
         nW5N3C8yMbhfUxZj8aFydEluZ8ZH4z/XHTL6jwV581U07IADSllSWrnfLCQMNH+ROfM1
         Xg7hufqakeVtb7Us5jVmFmLyfGOCmy/cpfghE=
Message-ID: <19f34abd0811241319u1abf5e77xc2359b4e8d17b518@mail.gmail.com>
Date: Mon, 24 Nov 2008 22:19:05 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: v2.6.28-rc2: x86_32 relocation regression?
Cc: "Huang Ying" <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I couldn't help noticing that addr2line no longer works for me since
at least v2.6.28-rc2. I get this:

EIP: 0060:[<c039e613>] EFLAGS: 00000202 CPU: 0
EIP is at strcpy+0x13/0x30

    $ addr2line -e vmlinux -i c039e613
    ??:0

...even though the kernel was configured with CONFIG_DEBUG_INFO=y.

    $ grep DEBUG_INFO .config
    CONFIG_DEBUG_INFO=y

gdb too:

    (gdb) disas 0xc039e613
    No function contains specified address.

This is a simple x86_32 defconfig with CONFIG_DEBUG_INFO toggled.

    $ nm vmlinux | grep strcpy
    c12a3b90 t scsi_strcpy_devinfo
    c119e600 T strcpy

It looks like everything was offset by 0xe00000:

    $ addr2line -e vmlinux c119e613
    arch/x86/lib/string_32.c:20

I have also this:

 virtual kernel memory layout:
     fixmap  : 0xffc79000 - 0xfffff000   (3608 kB)
     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
     vmalloc : 0xc87f0000 - 0xff3fe000   ( 876 MB)
     lowmem  : 0xc0000000 - 0xc7ff0000   ( 127 MB)
       .init : 0xc08ce000 - 0xc0932000   ( 400 kB)
       .data : 0xc06c9a4b - 0xc08c46ec   (2027 kB)
       .text : 0xc0200000 - 0xc06c9a4b   (4902 kB)

Any ideas?

Thanks,


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
