Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbYGPWtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbYGPWtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 18:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbYGPWsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 18:48:51 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:56329 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbYGPWsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 18:48:50 -0400
Subject: KVM overflows the stack
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm@vger.kernel.org>,
       "Anthony N. Liguori [imap]" <aliguori@us.ibm.com>
In-Reply-To: <1216244660.8711.6.camel@nimitz>
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>
	 <47EA1C63.8010202@qumranet.com>
	 <1206550329.7883.5.camel@nimitz.home.sr71.net>
	 <47EA80AC.4070204@qumranet.com>
	 <1206551794.7883.7.camel@nimitz.home.sr71.net>
	 <47EB6AAC.3040607@qumranet.com>  <47EB7281.6070300@qumranet.com>
	 <1206629709.7883.30.camel@nimitz.home.sr71.net>
	 <47EBB63E.2060306@qumranet.com>
	 <1212445810.8211.9.camel@nimitz.home.sr71.net>
	 <48469BDA.3050206@qumranet.com> <1212738105.7837.3.camel@nimitz>
	 <48512028.3070104@qumranet.com>  <1216148242.25942.6.camel@nimitz>
	 <1216244660.8711.6.camel@nimitz>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 15:48:47 -0700
Message-Id: <1216248527.11664.9.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-16 at 14:44 -0700, Dave Hansen wrote:
> On a suggestion of Anthony's, I tried a defconfig kernel.
> 
> It is now bombing out on an assertion in the lapic code:
> 
> 	http://sr71.net/~dave/linux/2.6.26-oops1.txt

I think I found it!!!

$ (objdump -d kvm.ko ; objdump -d kvm-intel.ko ) | egrep 'sub.*0x...,.*esp|>:'  | egrep sub -B1
00001a90 <kvm_vcpu_ioctl>:
    1a9a:	81 ec 60 06 00 00    	sub    $0x660,%esp
--
00004e90 <kvm_arch_vcpu_ioctl>:
    4e9d:	81 ec 6c 08 00 00    	sub    $0x86c,%esp
--
00005900 <kvm_arch_vm_ioctl>:
    5903:	81 ec 34 05 00 00    	sub    $0x534,%esp
--
0000d4f0 <paging64_prefetch_page>:
    d4f8:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
--
0000dfd0 <paging32_prefetch_page>:
    dfd8:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
--
0000f390 <kvm_pv_mmu_op>:
    f3a1:	81 ec 28 02 00 00    	sub    $0x228,%esp

We're simply overflowing the stack.  I changed all of the large on-stack
allocations to 'static', and it actually boots now.  I know 'static'
isn't safe, but it was good for a quick test.

A 'make stackcheck' confirms this:

dave@nimitz:~/kernels/linux-2.6.git$ make checkstack
objdump -d vmlinux $(find . -name '*.ko') | \
	perl /home/dave/kernels/linux-2.6.git-t61/scripts/checkstack.pl i386
0x000042d3 kvm_arch_vcpu_ioctl [kvm]:			2148
0x000012e3 kvm_vcpu_ioctl [kvm]:			1620
0x00004a83 kvm_arch_vm_ioctl [kvm]:			1332
0x00009a26 airo_get_aplist [airo]:			1140
0x00009b76 airo_get_aplist [airo]:			1140
0x00009c82 airo_get_aplist [airo]:			1140
...

In other words, kvm has the top 3 stack users in my kernel.  As you can
see from my trace above, these things also get called with super-long
stacks already.  Man.  That sucked to find.

Avi, how would you like this fixed?  I'd be happy to prepare some
patches.  Do you have a particular approach that you think we should
use?  Just make the big objects dynamically allocated?

-- Dave

