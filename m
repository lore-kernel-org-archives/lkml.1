Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbXILTIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbXILTIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 15:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbXILTIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 15:08:31 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:55323 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbXILTIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 15:08:30 -0400
Date: Wed, 12 Sep 2007 21:09:53 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86 merge - a little feedback
Message-ID: <20070912190953.GA18978@uranus.ravnborg.org>
References: <20070911201219.GA9674@uranus.ravnborg.org> <alpine.LFD.0.999.0709111414410.16478@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709111414410.16478@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > If legacy.c numa.c, pcibios.c and visws.c placed in a directory named i386
> > then it would be obvious that this is i386 only.
> 
> But none of it is "i386 only" and putting it in a directory of its own 
> would be stupid and wrong. The visws.c thing is platform-specific thing, 
> and the fact that the platform happens to be 32-bit is totally secondary 
> to the much bigger issue of the *platform*, so again, it would be totally 
> wrong to split it up by wordsize.

In other words - of all directories I used the worst one to prove my point.
I had no idea that legacy.c, numa.c and pcbios.c was candidates for x86_64 usage.

The point I try to make and which seems to have been lost in platform/wordsize
inputs are that there is a reason for being able to see which of the two
architectures a given file belong to.
Try to grep for csum_partial in x86/lib and you will get this:

checksum.S: * Changes:     Ingo Molnar, converted csum_partial_copy() to 2.1 exception
checksum.S:unsigned int csum_partial(const unsigned char * buff, int len, unsigned int sum)
checksum.S:ENTRY(csum_partial)
checksum.S:ENDPROC(csum_partial)
checksum.S:ENTRY(csum_partial)
checksum.S:ENDPROC(csum_partial)
checksum.S:unsigned int csum_partial_copy_generic (const char *src, char *dst,
checksum.S: * Copy from ds while checksumming, otherwise like csum_partial
checksum.S:ENTRY(csum_partial_copy_generic)
checksum.S:ENDPROC(csum_partial_copy_generic)
checksum.S:ENTRY(csum_partial_copy_generic)
checksum.S:ENDPROC(csum_partial_copy_generic)
csum-copy.S:ENTRY(csum_partial_copy_generic)
csum-copy.S:ENDPROC(csum_partial_copy_generic)
csum-partial.c:__wsum csum_partial(const void *buff, int len, __wsum sum)
csum-partial.c:EXPORT_SYMBOL(csum_partial);
csum-partial.c: return csum_fold(csum_partial(buff,len,0));
csum-wrappers.c: * csum_partial_copy_from_user - Copy and checksum from user space. 
csum-wrappers.c:csum_partial_copy_from_user(const void __user *src, void *dst,
csum-wrappers.c:                isum = csum_partial_copy_generic((__force const void *)src,
csum-wrappers.c:EXPORT_SYMBOL(csum_partial_copy_from_user);
csum-wrappers.c: * csum_partial_copy_to_user - Copy and checksum to user space. 
csum-wrappers.c:csum_partial_copy_to_user(const void *src, void __user *dst,
csum-wrappers.c:        return csum_partial_copy_generic(src, (void __force *)dst,len,isum,NULL,errp); 
csum-wrappers.c:EXPORT_SYMBOL(csum_partial_copy_to_user);
csum-wrappers.c: * csum_partial_copy_nocheck - Copy and checksum.
csum-wrappers.c:csum_partial_copy_nocheck(const void *src, void *dst, int len, __wsum sum)
csum-wrappers.c:        return csum_partial_copy_generic(src,dst,len,sum,NULL,NULL);
csum-wrappers.c:EXPORT_SYMBOL(csum_partial_copy_nocheck);


OK - maybe this is obvious for you and a few others. But for me I get utterly confused
about where to look for the x86_64 version.
Diving into the Makefile I can figure it out.

But thats one indirection too much.

As an example where this plays out better are in x86/crypto.
When grepping for aes_dec_blk I got following output:

aes_32.c:asmlinkage void aes_dec_blk(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
aes_32.c:       aes_dec_blk(tfm, dst, src);
aes_64.c:asmlinkage void aes_dec_blk(struct crypto_tfm *tfm, u8 *out, const u8 *in);
aes_64.c:       aes_dec_blk(tfm, dst, src);
aes-i586-asm.S:/* void aes_dec_blk(struct crypto_tfm *tfm, u8 *out_blk, const u8 *in_blk) */
aes-i586-asm.S:.global  aes_dec_blk
aes-i586-asm.S:aes_dec_blk:
aes-x86_64-asm.S:/* void aes_dec_blk(struct crypto_tfm *tfm, u8 *out, const u8 *in) */
aes-x86_64-asm.S:       entry(aes_dec_blk,240,dec128,dec192)

See how obvious it is what are x86_64 specific and what are i386 specific.
And that despite the mixed naming convention used.

All files that _truely_ belongs to only one of the two architectures ought to
be named such that this is obvious when grepping like the above examples shows.

Using the wordsize to distingush the filename seems to cause confusion since there
are files that _truely_ only belongs to i386 but is not 32 bit specific because
they exist only on i386 because they are not needed on any x86_64 system.

	Sam
