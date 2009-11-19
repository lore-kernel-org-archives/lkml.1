Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbZKSQia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbZKSQia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 11:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756813AbZKSQi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 11:38:29 -0500
Received: from mail49.e.nsc.no ([193.213.115.49]:54692 "EHLO mail49.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756613AbZKSQi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 11:38:29 -0500
Message-ID: <4B057487.7000607@free.fr>
Date: Thu, 19 Nov 2009 17:38:31 +0100
From: Mathieu Taillefumier <mathieu.taillefumier@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b5pre) Gecko/20090707 Lightning/1.0pre Shredder/3.0b3pre
MIME-Version: 1.0
To: Eric Anholt <eric@anholt.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] intel KMS bug on i915
References: <4AFAA396.5040903@free.fr> <1258433661.4882.5.camel@gaiman.anholt.net>
In-Reply-To: <1258433661.4882.5.camel@gaiman.anholt.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
>> I recently switched to the last git kernel (the rc6) and have a serious
>> problem with KMS and xorg. I reported it to the xorg list but after some
>> research it seems that this problem is caused by some recent change in
>> the intel KMS stack. Some warnings and errors are reported by the
>> kernel. they are the following (only a small part of it):
>>
>> [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
>> render error detected, EIR: 0x00000000
>> i915: Waking up sleeping processes
>> [drm:i915_wait_request] *ERROR* i915_wait_request returns -5 (awaiting 2
>> at 1)
>> [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
>> render error detected, EIR: 0x00000000
>>
>> This problem is recurrent with all 2.6.32-rc versions and gives rise to
>> an unusable xorg (independent of the version), while the same xorg stack
>> works pretty well with the 2.6.31 kernel. The hardware is a sony laptop
>> with a intel 965 chipset and the bug can be reproduced at 100%
>>      
> Could you bisect the problem?  I don't think I've seen reports of this
> (fails at a time other than resume)
>    
the result of the bisect section gave me this :

git bisect start 'drivers/gpu/'
# bad: [66b00a7c93ec782d118d2c03bd599cfd041e80a1] Merge branch 'fixes' 
of git://git.kernel.org/pub/scm/linux/kernel/git/davej/cpufreq
git bisect bad 66b00a7c93ec782d118d2c03bd599cfd041e80a1
# good: [74fca6a42863ffacaf7ba6f1936a9f228950f657] Linux 2.6.31
git bisect good 74fca6a42863ffacaf7ba6f1936a9f228950f657
# good: [e7d40b9a0a7c857383ef50db9766354bd3be1bf3] drm/radeon/kms: 
R600/RV770 remove dead code and print message for wrong BIOS
git bisect good e7d40b9a0a7c857383ef50db9766354bd3be1bf3
# bad: [c1176d6f03e1085797ce83648a2c76ae15a2b515] Merge branch 
'drm-next' of ../drm-next into drm-linus
git bisect bad c1176d6f03e1085797ce83648a2c76ae15a2b515
# good: [cd0b9fb400ba775737bdc3874c4cbee4047e66d8] drm/i915: Check that 
the relocation points to within the target
git bisect good cd0b9fb400ba775737bdc3874c4cbee4047e66d8
# bad: [94e0fb086fc5663c38bbc0fe86d698be8314f82f] Merge branch 
'drm-intel-next' of 
git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel
git bisect bad 94e0fb086fc5663c38bbc0fe86d698be8314f82f
# good: [bb6baf76f45708dbba651ed76a7ad94462f30c0b] drm/i915: Track 
purged state.
git bisect good bb6baf76f45708dbba651ed76a7ad94462f30c0b
# bad: [a419aef8b858a2bdb98df60336063d28df4b272f] trivial: remove 
unnecessary semicolons
git bisect bad a419aef8b858a2bdb98df60336063d28df4b272f
# good: [6ac3bd527007eeecb148b67ca47b21731fd8a503] PCI/vgaarb: cleanup 
some warnings + cleanup some comments.
git bisect good 6ac3bd527007eeecb148b67ca47b21731fd8a503
# bad: [e454cea20bdcff10ee698d11b8882662a0153a47] Driver-Core: extend 
devnode callbacks to provide permissions
git bisect bad e454cea20bdcff10ee698d11b8882662a0153a47

with this for the very last one :

e454cea20bdcff10ee698d11b8882662a0153a47 is first bad commit
commit e454cea20bdcff10ee698d11b8882662a0153a47
Author: Kay Sievers <kay.sievers@vrfy.org>
Date:   Fri Sep 18 23:01:12 2009 +0200

     Driver-Core: extend devnode callbacks to provide permissions

     This allows subsytems to provide devtmpfs with non-default permissions
     for the device node. Instead of the default mode of 0600, null, zero,
     random, urandom, full, tty, ptmx now have a mode of 0666, which allows
     non-privileged processes to access standard device nodes in case no
     other userspace process applies the expected permissions.

     This also fixes a wrong assignment in pktcdvd and a checkpatch.pl 
complain.

     Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

:040000 040000 a7c571fcd15ab134c2ce044e126d64aa94fabea3 
36c869e56350eb7ee74f4a0b46a0e3c2a454cc6c M      arch
:040000 040000 898c549d5a6f6be2534a01f2a5b22d8ed6aafd61 
79460f4129649fc404f7c3db73724b857b2ec548 M      block
:040000 040000 134d28af2f21517bf631c6b19a3775bb4ca294a3 
2411f973ce46c918379186c6c33364f33a5a079a M      drivers
:040000 040000 0ee311c5555b70843faa9a76651e353d811d9bc0 
35d7bfd19a5adec988386cac47d2d2ed2a72e5de M      include
:040000 040000 3a5e775fcc8b211a550cfa994a30a300236e0219 
9f0e3371fb2d5dcbdbf029db686ad212ef302dc9 M      sound

I should indicate that each time that the bisect is bad, I obtain either 
a black screen and I have to reboot with the magic keys or a graphical 
corruption. I can give more explicit details about which bad bisect 
gives a black screen or a graphics corruption but I have to start the 
session again.

regards

Mathieu


