Return-Path: <linux-kernel-owner+w=401wt.eu-S1760954AbXG2IQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954AbXG2IQw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 04:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760302AbXG2IQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 04:16:36 -0400
Received: from il.qumranet.com ([82.166.9.18]:55510 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760828AbXG2IQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 04:16:33 -0400
Message-ID: <46AC4CEB.9060401@qumranet.com>
Date: Sun, 29 Jul 2007 11:16:43 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alistair John Strachan <alistair@devzero.co.uk>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1, KVM-AMD problem
References: <200707281855.41277.alistair@devzero.co.uk>
In-Reply-To: <200707281855.41277.alistair@devzero.co.uk>
Content-Type: multipart/mixed;
 boundary="------------020605050006080107070004"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020605050006080107070004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Alistair John Strachan wrote:
> Hi,
>
> I'm getting periodic oopses running KVM-33 on 2.6.23-rc1. Here is a digital 
> photo of the oops. Alarmingly, a lot of the time it triple faults the machine 
> and I don't get a chance to grab it. This time I was lucky, though.
>
> http://devzero.co.uk/~alistair/kvm-2.6.23-rc1.jpg
>
> Unfortunately, some of the oops text scrolled out of the screen. I will 
> endeavour to reproduce the bug over serial console, but I can make no 
> guarantees.
>
> The CPU is an AMD X2 BE-2350, chipset is AMD 690G.
>
>   

If you are using the modules from 2.6.23-rc1, try upgrading to latest 
-git, which contains a patch that might fix this problem.  If you are 
using the modules from kvm-33, try applying the attached patch.


-- 
error compiling committee.c: too many arguments to function


--------------020605050006080107070004
Content-Type: text/x-patch;
 name="fix-0f-01.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-0f-01.patch"

commit bfa6c62f98bd0602025d7b48e267d817082f5d07
Author: Aurelien Jarno <aurelien@aurel32.net>
Date:   Wed Jul 25 10:19:54 2007 +0200

    KVM: disable writeback for 0x0f 0x01 instructions.
    
    0x0f 0x01 instructions (ie lgdt, lidt, smsw, lmsw and invlpg) does
    not use writeback. This patch set no_wb=1 when emulating those
    instructions.
    
    This fixes a regression booting the FreeBSD kernel on AMD.
    
    Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 21ce977..cbbb9c5 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1183,6 +1183,8 @@ pop_instruction:
 twobyte_insn:
 	switch (b) {
 	case 0x01: /* lgdt, lidt, lmsw */
+		/* Disable writeback. */
+		no_wb = 1;
 		switch (modrm_reg) {
 			u16 size;
 			unsigned long address;

--------------020605050006080107070004--
