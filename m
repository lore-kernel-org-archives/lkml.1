Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbXLCI5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbXLCI5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 03:57:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbXLCI46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 03:56:58 -0500
Received: from il.qumranet.com ([82.166.9.18]:33177 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbXLCI45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 03:56:57 -0500
Message-ID: <4753C59A.4030206@qumranet.com>
Date: Mon, 03 Dec 2007 11:00:10 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Amit Shah <amit.shah@qumranet.com>
CC: kvm-devel@lists.sourceforge.net, Anthony Liguori <aliguori@us.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH] Refactor hypercall infrastructure (v2)
References: <11898788932902-git-send-email-aliguori@us.ibm.com> <200712021917.28706.amit.shah@qumranet.com> <475339A6.9020207@us.ibm.com> <200712031416.51710.amit.shah@qumranet.com>
In-Reply-To: <200712031416.51710.amit.shah@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Shah wrote:
> * Anthony Liguori wrote:
>   
>> Amit Shah wrote:
>>     
>>> * Anthony Liguori wrote:
>>>  
>>>
>>>       
>>>> This patch refactors the current hypercall infrastructure to better
>>>> support live migration and SMP.  It eliminates the hypercall page by
>>>> trapping the UD exception that would occur if you used the wrong
>>>> hypercall instruction for the underlying architecture and replacing it
>>>> with the right one lazily. 
>>>>         
>>> This doesn't work right for SVM. It keeps looping indefinitely; on a
>>> kvm_stat run, I get about 230,000 light vm exits per second, with the
>>> hypercall never returning to the guest.
>>>
>>> ...
>>>  
>>>       
>> What are you using to issue the hypercall?
>>     
>
> +       r = kvm_hypercall1(KVM_PV_PCI_DEVICE, page_gfn);
>
> Setup is done by:
>
> +       if (!kvm_para_available()) {
> +               printk(KERN_ERR "KVM paravirt support not available\n");
> +               r = -ENODEV;
> +               goto out_dereg;
> +       }
>   

There was a bug where instructions with a modrm byte specifying a 
register would try to access memory.  In the memory was not mapped,  
emulation would fail. vmcall is one such instruction.  This was fixed by

commit f83562246921d6a8a7de8b76853a6835ace3699d
Author: Aurelien Jarno <aurelien@aurel32.net>
Date:   Wed Oct 17 19:30:41 2007 +0200

    KVM: x86 emulator: fix access registers for instructions with ModR/M 
byte and Mod = 3

    The patch belows changes the access type to register from memory for
    instructions that are declared as SrcMem or DstMem, but have a
    ModR/M byte with Mod = 3.

    It fixes (at least) the lmsw and smsw instructions on an AMD64 CPU,
    which are needed for FreeBSD.

    Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 7c95ae5..8c50496 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -835,6 +835,14 @@ modrm_done:
                if (c->twobyte && c->b == 0x01
                                    && c->modrm_reg == 7)
                        break;
+               /*
+                * For instructions with a ModR/M byte, switch to register
+                * access if Mod = 3.
+                */
+               if ((c->d & ModRM) && c->modrm_mod == 3) {
+                       c->src.type = OP_REG;
+                       break;
+               }
 srcmem_common:
                c->src.type = OP_MEM;
                break;
@@ -897,7 +905,14 @@ srcmem_common:
                }
                break;
        case DstMem:
-               c->dst.type = OP_MEM;
+               /*
+                * For instructions with a ModR/M byte, switch to register
+                * access if Mod = 3.
+                */
+               if ((c->d & ModRM) && c->modrm_mod == 3)
+                       c->dst.type = OP_REG;
+               else
+                       c->dst.type = OP_MEM;
                break;
        }




-- 
error compiling committee.c: too many arguments to function

