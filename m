Return-Path: <linux-kernel-owner+w=401wt.eu-S1762138AbZEHIT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762138AbZEHIT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 04:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756487AbZEHITM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 04:19:12 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:42635 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbZEHITJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 04:19:09 -0400
Message-ID: <4A03EABF.40702@cosmosbay.com>
Date: Fri, 08 May 2009 10:18:07 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       ebiederm@xmission.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 01/14] x86, boot: align the .bss section in the decompressor
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com> <1241735222-6640-2-git-send-email-hpa@linux.intel.com> <20090508071759.GA12808@uranus.ravnborg.org>
In-Reply-To: <20090508071759.GA12808@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 08 May 2009 10:18:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg a écrit :
> On Thu, May 07, 2009 at 03:26:49PM -0700, H. Peter Anvin wrote:
>> From: H. Peter Anvin <hpa@zytor.com>
>>
>> Aligning the .bss section makes it trivially faster, and makes using
>> larger transfers for the clear slightly easier.
>>
>> [ Impact: trivial performance enhancement, future patch prep ]
>>
>> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
>> ---
>>  arch/x86/boot/compressed/vmlinux.lds.S |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
>> index 0d26c92..27c168d 100644
>> --- a/arch/x86/boot/compressed/vmlinux.lds.S
>> +++ b/arch/x86/boot/compressed/vmlinux.lds.S
>> @@ -42,6 +42,7 @@ SECTIONS
>>  		*(.data.*)
>>  		_edata = . ;
>>  	}
>> +	. = ALIGN(32);
> 
> Where does this magic 32 comes from?
> I would assume the better choice would be:
> 	. = ALIGN(L1_CACHE_BYTES);
> 
> So we match the relevant CPU.
> 
> In general for alignmnet of output sections I see the need for:
> 1) Function call
> 2) L1_CACHE_BYTES
> 3) PAGE_SIZE
> 4) 2*PAGE_SIZE
> 
> But I see magic constant used here and there that does not match
> the above (when looking at all archs).
> So I act when I see a new 'magic' number..
> 

I totally agree

gcc itself has a strange 32 bytes alignement rule (unless using -Os) for 
object of a >= 32 bytes size. Did you know that ?

$ cat try.c
char foo[32] = {1};
$ gcc -O -S try.c
        .file   "try.c"
.globl foo
        .data
        .align 32            <<< HERE , what a mess >>
        .type   foo, @object
        .size   foo, 32
foo:
        .byte   1
        .zero   31
        .ident  "GCC: (GNU) 4.4.0"
        .section        .note.GNU-stack,"",@progbits


It makes many .o kernel files marked with a 2**5 alignement of .data or percpudata
At link time, it creates many holes.

In my opinion, gcc should have a separate option than -Os, as this as too expensive
side effects on the code speed.

I can save lot of data space if I patch gcc-4.4.0/config/i386/i386.c

to :

/* Compute the alignment for a static variable.
   TYPE is the data type, and ALIGN is the alignment that
   the object would ordinarily have.  The value of this function is used
   instead of that alignment to align the object.  */

int
ix86_data_alignment (tree type, int align)
{
-  int max_align = optimize_size ? BITS_PER_WORD : MIN (256, MAX_OFILE_ALIGNMENT);
+  int max_align = BITS_PER_WORD;

  if (AGGREGATE_TYPE_P (type)
      && TYPE_SIZE (type)
      && TREE_CODE (TYPE_SIZE (type)) == INTEGER_CST
      && (TREE_INT_CST_LOW (TYPE_SIZE (type)) >= (unsigned) max_align
          || TREE_INT_CST_HIGH (TYPE_SIZE (type)))
      && align < max_align)
    align = max_align;

  /* x86-64 ABI requires arrays greater than 16 bytes to be aligned
     to 16byte boundary.  */
  if (TARGET_64BIT)
    {
      if (AGGREGATE_TYPE_P (type)
           && TYPE_SIZE (type)
           && TREE_CODE (TYPE_SIZE (type)) == INTEGER_CST
           && (TREE_INT_CST_LOW (TYPE_SIZE (type)) >= 128
               || TREE_INT_CST_HIGH (TYPE_SIZE (type))) && align < 128)
        return 128;


