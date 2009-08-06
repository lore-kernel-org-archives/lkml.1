Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbZHFQu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbZHFQu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 12:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZHFQuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 12:50:55 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:48621 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbZHFQuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 12:50:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=GK0slmelpB7siFIWOQ1ruQWj4oujlYZrwWXbcmMhXnDQgHhY/KeYt5OG8WC2hOyY8p
         v28CZjNO9YK757Mhlk0xI5U6NA0n0pm0TlJcLvVS6yabGpgQ4Z2KxNw9e0tQ/gMjQf0B
         9DfNQgeUAAJjd0RwIUifihVYG95qAT56En7mE=
Message-ID: <4A7B09E6.7070900@gmail.com>
Date: Thu, 06 Aug 2009 13:50:46 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090725)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: X86_FEATURE_LAHF_LM set incorrectly (likely due to BIOS bug)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I have an AMD Athlon64 processor:

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 4
model name	: AMD Athlon(tm) 64 Processor 2800+
stepping	: 10
cpu MHz		: 1800.000
cache size	: 512 KB
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext lm 3dnowext 3dnow rep_good lahf_lm
bogomips	: 3600.25
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp

As you can see, the lahf_lm feature is reported as being present,
but the lahf/sahf instructions are not actually supported by this
processor.  A simple program:

int main() {
	asm("lahf");
}


results in:

$ ./a.out
Illegal instruction

I think the problem is with my BIOS, because, in the following guide
from AMD:

http://support.amd.com/us/Processor_TechDocs/25759.pdf

Erratum 110 indicates that some CPUs will not report the LAHF
capability, even if they have it, and the BIOS should write to a
specific MSR bit in order to get the feature reported as present (for
processors that support LAHF).  I believe that perhaps my BIOS is
writing to that bit unconditionally, and this causes my CPU to report
support for the feature.

If I am correct, would it be appropriate to add a check somewhere in
the CPU feature code to detect early Athlon 64 processors like mine
and clear that feature flag, in case other BIOSes have made the same
mistake?  If so, is there some kind of quirk mechanism for this, or
should I prepare a patch that adds the check directly to the feature
checking code?

Thanks,

-- 
Kevin Winchester

