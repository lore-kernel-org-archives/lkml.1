Return-Path: <linux-kernel-owner+w=401wt.eu-S934709AbXG3NAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934709AbXG3NAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 09:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763376AbXG3NAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 09:00:05 -0400
Received: from il.qumranet.com ([82.166.9.18]:53974 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223AbXG3NAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 09:00:04 -0400
Message-ID: <46ADE0DD.1030505@qumranet.com>
Date: Mon, 30 Jul 2007 16:00:13 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alistair John Strachan <alistair@devzero.co.uk>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1, KVM-AMD problem
References: <200707281855.41277.alistair@devzero.co.uk> <200707291444.18024.alistair@devzero.co.uk> <46AC9A8D.8060003@qumranet.com> <200707291510.31731.alistair@devzero.co.uk>
In-Reply-To: <200707291510.31731.alistair@devzero.co.uk>
Content-Type: multipart/mixed;
 boundary="------------020404030706030604000807"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020404030706030604000807
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Alistair John Strachan wrote:
> On Sunday 29 July 2007 14:47:57 you wrote:
>   
>> Alistair John Strachan wrote:
>>     
>>> On Sunday 29 July 2007 12:34:28 you wrote:
>>> [snip]
>>>
>>>       
>>>>> Doesn't help, I still get the same crashes. I tried 2.6.22 again and
>>>>> it's rock solid by comparison.
>>>>>           
>>>> Do you mean, kvm-33 on top of 2.6.22, or the kvm modules from 2.6.22?
>>>> Please describe your configuration *exactly*.
>>>>         
>>> I'm using the kvm-33 *userspace* package (based on Debian's kvm-28
>>> packaging) and 2.6.23-rc1's KVM modules. I patched 2.6.23-rc1 with the
>>> patch you provided in your last email. So I'm not using -git HEAD.
>>>
>>> Maybe there's been additional necessary fixes to -git requiring me to
>>> update to HEAD? That wasn't clear from your last email.
>>>       
>> No,  that patch is the only potential fix post -rc1.  There are a few
>> other fixes there, but they are intended to avoid guest crashes, not
>> host crashes.
>>
>> What guest are you running?  Maybe I can reproduce it here.
>>     
>
> Right now, Windows XP. I'm pretty sure Linux (well, Debian Etch) works fine. I 
> could only get Windows to install with -no-acpi, but I run it with the 
> following (if this is at all useful):
>
> kvm -no-acpi -m 256 -hda $IMAGE -net nic -net tap,script=/etc/kvm/kvm-ifup
>
> Basically, the installer seems to work fine, but Windows seemed to have 
> problems after installing post-SP2 updates. Maybe that's why not everybody is 
> seeing it yet.
>
>   

How about the attached patch? (I haven't yet tried to reproduce, but 
this can cause an AMD-only oops).

-- 
error compiling committee.c: too many arguments to function


--------------020404030706030604000807
Content-Type: text/x-patch;
 name="kvm-fix-debug-registers-on-amd.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kvm-fix-debug-registers-on-amd.patch"

commit 80917728e43e248155c019f743655806b582b099
Author: Avi Kivity <avi@qumranet.com>
Date:   Mon Jul 30 15:56:36 2007 +0300

    KVM: x86 emulator: disable writeback for debug register instructions
    
    These are handled internally by the instruction.
    
    Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 1a90ba0..2136da5 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1222,11 +1222,13 @@ twobyte_insn:
 		}
 		break;
 	case 0x21: /* mov from dr to reg */
+		no_wb = 1;
 		if (modrm_mod != 3)
 			goto cannot_emulate;
 		rc = emulator_get_dr(ctxt, modrm_reg, &_regs[modrm_rm]);
 		break;
 	case 0x23: /* mov from reg to dr */
+		no_wb = 1;
 		if (modrm_mod != 3)
 			goto cannot_emulate;
 		rc = emulator_set_dr(ctxt, modrm_reg, _regs[modrm_rm]);

--------------020404030706030604000807--
