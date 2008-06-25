Return-Path: <linux-kernel-owner+w=401wt.eu-S1759409AbYFYQIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbYFYQIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYFYQHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:07:52 -0400
Received: from smtp.fullrate.dk ([89.150.129.5]:58138 "EHLO dns2.fullrate.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbYFYQHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:07:52 -0400
X-Greylist: delayed 2108 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jun 2008 12:07:51 EDT
Message-ID: <48626514.2040905@agner.org>
Date: Wed, 25 Jun 2008 17:32:36 +0200
From: Agner Fog <agner@agner.org>
Organization: agner@agner.org
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ABI change for device drivers using future AVX instruction set
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The announced future Intel AVX instruction set extends the 128-bit XMM 
registers to 256-bit YMM registers.

Intel has proposed relevant ABI extensions, which I assume will be 
adopted in the System V ABI. See references below.

Some details are not covered in the Intel documents. I have discussed 
this with an Intel engineer who has supplied all the details I asked 
for. I have listed the necessary ABI changes in detail in my manual on 
calling conventions (see below).

One problem that has not been resolved yet, AFAIK, is how to handle the 
possible use of YMM registers in device drivers. Should these registers 
be saved before calling a device driver from an interrupt or should it 
be the responsibility of the device driver?

This is particularly problematic for the following reasons:

1. The YMM registers must be saved with the new instruction XSAVE and 
restored with XRESTOR if done in the device driver. Saving registers 
individually will be incompatible with future extensions of the register 
size to more than 256 bits.

2. There is a performance cost to using XSAVE / XRESTOR.

3. When compiling a device driver, the compiler may insert implicit 
calls to library functions such as memcpy and memset. These functions 
typically have a CPU dispatcher that chooses the largest register size 
available. The device driver may therefore use YMM registers without the 
knowledge of the programmer and without compiling with the AVX switch on.

4. The consequences of failing to save the YMM registers properly would 
be intermittent and irreproducible errors that are difficult to trace.

The possible solutions, as I see it, are:

A. The operating system saves the state with XSAVE before calling a 
device driver from an interrupt and restores with XRESTOR. The device 
driver can use any register. This method is safe but has a performance 
penalty.
 
B. The operating system disables the use of YMM registers with the 
instruction XSETBV before calling a device driver from an interrupt. If 
the device driver needs to use YMM registers it must save the state with 
XSAVE before enabling YMM with XSETBV, and reverse these actions before 
returning.
 
C. Make it the responsibility of the device driver to avoid the use of 
YMM registers unless it saves the state with XSAVE. This solution 
requires that available compilers have a switch to disable calls to 
library functions with internal CPU dispatchers. Appears unsafe to me.

A decision on this question should be made and published in the ABI so 
that people can make compatible device drivers.

Note:
Please Cc: me on this thread. I am not on this mailing list and I am not 
involved with Linux development.

References:
Intel AVX programming reference:
http://softwarecommunity.intel.com/isn/downloads/intelavx/Intel-AVX-Programming-Reference-31943302.pdf

Intel proposed ABI extensions (very brief):
http://intel.wingateweb.com/SHchina/published/NGMS002/SP_NGMS002_100r_eng.pdf

My interpretation of the ABI extensions in detail:
http://www.agner.org/optimize/calling_conventions.pdf

My discussion with Mark Buxton, Intel
http://softwarecommunity.intel.com/isn/Community/en-US/forums/thread/30257153.aspx

