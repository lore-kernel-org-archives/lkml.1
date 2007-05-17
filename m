Return-Path: <linux-kernel-owner+w=401wt.eu-S1760221AbXEQX1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221AbXEQX1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 19:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbXEQX1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 19:27:31 -0400
Received: from smtpa1.mediabeam.com ([194.25.41.13]:6743 "EHLO
	smtpa1.mediabeam.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbXEQX1a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 19:27:30 -0400
Message-ID: <464CE4CA.8000704@uni-greifswald.de>
Date: Fri, 18 May 2007 01:27:06 +0200
From: Philipp Kohlbecher <pk031698@uni-greifswald.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Dave Jones <davej@codemonkey.org.uk>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org, linux-assembly@vger.kernel.org
Subject: Re: [PATCH 2.6.21.1] i386: save registers before intra-privilege
 syscall
References: <20070517220638.GA6532@localhost.localdomain> <464CD44A.5000307@zytor.com>
In-Reply-To: <464CD44A.5000307@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-mediaBEAM-MailScanner-Information: Spam-/VirusProtection V1.1
X-mediaBEAM-VirusProtection: clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Philipp Kohlbecher wrote:
>> From: Philipp Kohlbecher <pk031698@uni-greifswald.de>
>>
>> The kernel_execve function issues a software interrupt (int 0x80) to make
>> a system call to sys_execve. This function expects to find the stack segment
>> and stack pointer of the function that issued the system call in the pt_regs
>> struct. The syscall entry code that sets up this struct expects the stack
>> segment and the stack pointer of the issuing function already on the stack.
>> But the Intel processor saves these registers only if a stack-switch occurs,
>> i.e. for inter-privilege interrupts and exceptions (cf. Intel Software
>> Developer’s Manual, Vol. 3A, p. 5-17,
>> http://www.intel.com/design/processor/manuals/253668.pdf).
>> For an intra-privilege interrupt like the one issued in kernel_execve, these
>> registers must be saved manually.
>>
> 
> Could you describe the failure scenario this causes?

I don't know of any problems this causes. The kernel needs to be aware
of the fact that the xss and esp fields of the pt_regs struct may
contain wrong values anyway, as hardware interrupts arriving while the
CPU is in kernel mode would also lead to this condition.
The file include/asm-i386/processor.h contains a comment to that effect
(lines 483-492).
With kernel_execve we can predict this, however, and account for it.
(This may be superfluous, but I don't think it hurts and it might
prevent future errors.)

- Phil Kohlbecher
