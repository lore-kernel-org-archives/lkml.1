Return-Path: <linux-kernel-owner+w=401wt.eu-S1763380AbZEHRCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763380AbZEHRCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 13:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbZEHRCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 13:02:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45538 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbZEHRCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 13:02:43 -0400
Message-ID: <4A0464AC.9060308@zytor.com>
Date: Fri, 08 May 2009 09:58:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       ebiederm@xmission.com
Subject: Re: [PATCH 02/14] x86, boot: honor CONFIG_PHYSICAL_START when relocatable
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com> <1241735222-6640-3-git-send-email-hpa@linux.intel.com> <20090508073436.GB12808@uranus.ravnborg.org>
In-Reply-To: <20090508073436.GB12808@uranus.ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> 
> On the coding style side of thing...
>> +     movl %ebp, %ebx
>> +     cmpl %ebx, %eax
>> +     jbe 1f
>> +     movl %eax, %ebx
> 
> This looks messy with different idention of the operand.
> 
> Compare it to this:
>> +	movl	%ebp, %ebx
>> +	cmpl	%ebx, %eax
>> +	jbe	1f
>> +	movl	%eax, %ebx
> 
> 
> I like the latter more with vertical alignment of the operand.
> I see that you add spaces around operators (,) - good.

head_32.S was already written in the style with space (rather than tab)
between opcode and operands.  There was a total of three instructions
that didn't follow the pattern.  Re-styling the whole file is possible,
of course, but should be a separate patch entirely.

>>  	pushl %esi
>> -	leal _ebss(%ebp), %esi
>> -	leal _ebss(%ebx), %edi
>> -	movl $(_ebss - startup_32), %ecx
>> +	leal (_bss-4)(%ebp), %esi
>> +	leal (_bss-4)(%ebx), %edi
>> +	movl $(_bss - startup_32), %ecx
>> +	shrl $2, %ecx
> 
> I do not see why you mess around with _bss here?
> Do you use .bss for decompression?

This chunk of code is about moving the initialized segments into place.
 Moving the contents of the bss is a bug (and it clobbers the stack, the
setup of which I moved earlier in the code.)

However, using _edata would give an unaligned symbol, so use _bss
instead as being an aligned symbol at the beginning of the _bss; we thus
move the range from startup_32 to _bss.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

