Return-Path: <linux-kernel-owner+w=401wt.eu-S932469AbZJ1HDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbZJ1HDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 03:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932306AbZJ1HDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 03:03:31 -0400
Received: from mx3.orcon.net.nz ([219.88.242.53]:53066 "EHLO mx3.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932263AbZJ1HDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 03:03:31 -0400
Message-ID: <4AE7ECC2.8050202@orcon.net.nz>
Date: Wed, 28 Oct 2009 20:03:30 +1300
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: linux-alpha@vger.kernel.org
CC: linux-kernel@vger.kernel.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       David Howells <dhowells@redhat.com>
Subject: Alpha: suspicious compiler warning in entry.S
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx3.orcon.net.nz on Wed, 28 Oct 2009 20:03:32 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Wed Oct 28 20:03:35 2009
X-DSPAM-Confidence: 0.6952
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiler warning when compiling 2.6.32-rc5 as follows:

  AS      arch/alpha/kernel/entry.o
arch/alpha/kernel/entry.S: Assembler messages:
arch/alpha/kernel/entry.S:326: Warning: operand out of range 
(0x0000000000000406 is not between 0x0000000000000000 and 
0x00000000000000ff)
arch/alpha/kernel/entry.S:388: Warning: operand out of range 
(0x0000000000000406 is not between 0x0000000000000000 and 
0x00000000000000ff)

One offending line (326) is:

    and    $5, _TIF_WORK_MASK, $2

The warning occurs because commit d0420c83f39f "KEYS: Extend
TIF_NOTIFY_RESUME to (almost) all architectures [try #6]" introduces
TIF_NOTIFIY_RESUME which sets bit 10 in _TIF_WORK_MASK (see
arch/alpha/include/asm/thread_info.h) but _TIF_WORK_MASK is used in the
immediate addressing mode in the assembler instruction above. The 'and'
instruction can only take an immediate datum in the range 0 to 255.  With
the addition of the TIF_NOTIFY_RESUME bit, _TIF_WORK_MASK is no longer in
the valid range for immediate addressing in the 'and' instruction.

On the assumption that it is important to include the TIF_NOTIFY_RESUME bit
one might be tempted to modify the code to:

    lda    $2, _TIF_WORK_MASK
    and    $5, $2, $2

but this is time critical code.  I am wondering whether it might be better
to rearrange the bits in the thread information flags so that _TIF_WORK_MASK
has a value less than 255 and the single instruction to perform an and
operation can be maintained.

Comments?

Cheers
Michael.

