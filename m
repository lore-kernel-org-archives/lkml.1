Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbYFGDzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbYFGDzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 23:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbYFGDzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 23:55:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:20530 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbYFGDzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 23:55:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wG1utiH74RIz9+peUSLYveIy3nKBBkSJaO3J/CzuI+68lcFBduXkrj1iTgkIwizNIW
         hgAxnm6FG8+YCaoGB1IWaqvCvuhnyfq/BRraQIgCDrSf/E6GROmCgIYGhI2tyYxL80jI
         eTEAdecEP52HvmwpAbOEnUobwNiSa81/2eGnM=
Message-ID: <86802c440806062055j3431ef7cn72a92f2e0264d6ac@mail.gmail.com>
Date: Fri, 6 Jun 2008 20:55:29 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: x86_64 boot hang when CONFIG_NUMA=n
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
In-Reply-To: <20080606084217.d725fe04.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <15271334.1212702611270.JavaMail.oracle@acsmt304.oracle.com>
	 <86802c440806052241q90bb2dcmef9e98f2e24291e8@mail.gmail.com>
	 <20080606084217.d725fe04.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2008 at 8:42 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Thu, 5 Jun 2008 22:41:01 -0700 Yinghai Lu wrote:
>
>> On Thu, Jun 5, 2008 at 2:50 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> > On 2.6.26-rc[2345], I am seeing a hang during boot with CONFIG_NUMA=n, but changing
>> > to CONFIG_NUMA=y allows successful boot.
>> >
>> > This is on a 4-way AMD64 (HP) server with 8 GB RAM.
>> >
>> > Using initcall_debug, the last output on a hang is from arch/x86/pci/k8-bus_64.c:
>> >
>> > calling  early_fill_mp_bus_info+0x0/0x7b2
>> > node 0 link 1: io port [1000, 3fff]
>> > node 1 link 2: io port [4000, ffff]
>> > TOM: 0000000080000000 aka 2048M
>> > node 0 link 1: mmio [e8000000, fddfffff]
>> > node 1 link 2: mmio [fde00000, fdffffff]
>> > node 0 link 1: mmio [80000000, 83ffffff]
>> > node 1 link 2: mmio [84000000, 8fffffff]
>> > node 0 link 1: mmio [a0000, bffff]
>> > TOM2: 0000000280000000 aka 10240M
>> > bus: [00,3f] on node 0 link 1
>> > bus: 00 index 0 io port: [0, 3fff]
>> > bus: 00 index 1 mmio: [90000000, fddfffff]
>> > bus: 00 index 2 mmio: [80000000, 83ffffff]
>> > bus: 00 index 3 mmio: [a0000, bffff]
>> > bus: 00 index 4 mmio: [fe000000, ffffffff]
>> > bus: 00 index 5 mmio: [280000000, fcffffffff]
>> > bus: [40,ff] on node 1 link 2
>> > bus: 40 index 0 io port: [4000, ffff]
>> > bus: 40 index 1 mmio: [fde00000, fdffffff]
>> >
>> >
>> > There should be an index 2 line printed next, like this slightly modifed for debug
>> > version does (with CONFIG_NUMA=y), or maybe the following line(s) just aren't
>> > making it to the (net)console log and some other initcall function is actually
>> > hanging:  (??)
>> >
>> > bus: [40,ff] on node 1 link 2
>> > bus: 40 index 0/3 io port: [4000, ffff]
>> > bus: 40 index 1/3 mmio: [fde00000, fdffffff]
>> > bus: 40 index 2/3 mmio: [84000000, 8fffffff]
>> > early_fill_mp_bus_info: done
>> >
>> >
>> > Has anyone seen something like this?  Any patches to test?
>> >
>> > The next initcall functions (on a working boot) are:
>> >
>> > calling  arch_kdebugfs_init+0x0/0x8
>> > initcall arch_kdebugfs_init+0x0/0x8 returned 0 after 0 msecs
>> > calling  mtrr_if_init+0x0/0x77
>> > initcall mtrr_if_init+0x0/0x77 returned 0 after 0 msecs
>> > calling  ffh_cstate_init+0x0/0x31
>> > initcall ffh_cstate_init+0x0/0x31 returned -1 after 0 msecs
>> > initcall ffh_cstate_init+0x0/0x31 returned with error code -1
>> > calling  acpi_pci_init+0x0/0x4a
>> > ACPI: bus type pci registered
>> > initcall acpi_pci_init+0x0/0x4a returned 0 after 0 msecs
>>
>> can you send out your config?
>
> Yes, sorry about omitting that.  Bad (not working) and good/working
> are attached.
>

can you check latest tip/master?

I tried that with your bad config on server test servers. all work well.

YH
