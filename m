Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbYAKESa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbYAKESa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 23:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbYAKESV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 23:18:21 -0500
Received: from ruby.spiritone.com ([216.99.193.130]:36522 "EHLO
	ruby.spiritone.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096AbYAKESV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 23:18:21 -0500
Message-ID: <4786EE00.3050602@BitWagon.com>
Date: Thu, 10 Jan 2008 20:18:08 -0800
From: John Reiser <jreiser@BitWagon.com>
Organization: -
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: mingo@elte.hu, Jeff Dike <jdike@addtoit.com>,
       Sam Ravnborg <sam@ravnborg.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: STT_FUNC for assembler checksum and semaphore ops" in git-x86
References: <20080109215725.GA18185@basil.nowhere.org> <20080110074201.GA12585@uranus.ravnborg.org> <478649D8.9080209@BitWagon.com> <20080110180225.GA747@one.firstfloor.org> <4786BF88.5010802@BitWagon.com> <20080111025734.GA6908@one.firstfloor.org>
In-Reply-To: <20080111025734.GA6908@one.firstfloor.org>
X-Enigmail-Version: 0.92.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Thu, Jan 10, 2008 at 04:59:52PM -0800, John Reiser wrote:
> 
>>Andi Kleen wrote:
>>
>>>But actually checking the default implementation in linkage.h already
>>>implements size: [snip]
>>
>>>Are you sure it doesn't work?  Your patch should be not needed. If it's
>>>still wrong then just ENDPROCs() need to be added.
>>
>>The ENDPROCs() were not used everywhere.  Some code used just END() instead,
>>while other code used nothing.  um/sys-i386/checksum.S didn't #include
> 
> 
> END() is fine too since it contains .size too:
> 
> #ifndef END
> #define END(name) \
>   .size name, .-name
> #endif
> 
> 
>>diff --git a/arch/x86/lib/semaphore_32.S b/arch/x86/lib/semaphore_32.S
>>index 444fba4..e2c6e0d 100644
>>--- a/arch/x86/lib/semaphore_32.S
>>+++ b/arch/x86/lib/semaphore_32.S
>>@@ -49,7 +49,7 @@ ENTRY(__down_failed)
>> 	ENDFRAME
>> 	ret
>> 	CFI_ENDPROC
>>-	END(__down_failed)
>>+	ENDPROC(__down_failed)
> 
> 
> I don't think these change makes sense given the definition of END()
> shown above.
> 
> The only change that would make sense is adding END() (or ENDPROC()) 
> to a function that doesn't have either of them yet.

No.  The pseudo op ".type name, @function" appears only in ENDPROC;
it does not appear in END.  So changing END to ENDPROC *does* alter
the Elf32_Sym for 'name'.  Just END produces STT_NOTYPE; ENDPROC
produces STT_FUNC.  A static analysis tool can get the info it wants
much more easily if all subroutines are marked as STT_FUNC.
In theory the tool could sort the symbols, notice the disjoint
coverage of the address space by the .size intervals of consecutive
symbols that are the targets of a CALL instruction, and thus deduce
that ".type foo, @function" *should* have been specified.  But this
is a heuristic, and it fails on boundaries where assembly code is
invoked via trap, interrupt, or exception (anything other than CALL).
Instead, specify STT_FUNC for each subroutine in the first place.
That requires .type, which means ENDPROC (not END) from linux/linkage.h.

-- 
John Reiser, jreiser@BitWagon.com
