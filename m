Return-Path: <linux-kernel-owner+w=401wt.eu-S1759571AbYFLU3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571AbYFLU3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 16:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbYFLU3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 16:29:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:43884 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbYFLU3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 16:29:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PblhRz3SGioybnohCYCZ0ccIy+ijupm0ho9IHgihHy3uf0XIctkuMbzrlYrVXAeCa/
         gurR0vy/5uQPwhlZ+q8lMtTAA/QuBjuVvSUAmB21mLdrGPvnp4M8XupZnno29AT6WZbP
         YVYCO2/0Fvj0OBfbBIjzIPQ9h/NtZ0auzely4=
Message-ID: <86802c440806121329s54bb1e6dobaaa15c26e7dc81c@mail.gmail.com>
Date: Thu, 12 Jun 2008 13:29:20 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Paul Jackson" <pj@sgi.com>, "Andi Kleen" <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Confusions with reserve_early, reserve_bootmem, e820, efi, ... on x86_64
Cc: mingo@elte.hu, bwalle@suse.de, hannes@saeurebad.de, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, steiner@sgi.com
In-Reply-To: <20080612151032.5a59309b.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080612050609.88a8cf7f.pj@sgi.com>
	 <86802c440806120525v2da860bfyf05eb8ec6b9943d0@mail.gmail.com>
	 <20080612111943.c140c4cb.pj@sgi.com>
	 <86802c440806121005g42f2e44cxbe5f7bdb06836a1e@mail.gmail.com>
	 <20080612151032.5a59309b.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 1:10 PM, Paul Jackson <pj@sgi.com> wrote:
> Yinghai wrote:
>> that function seems to increase the ebda to workaround some broken
>> machine blindly.
>
> Yes, true.
>
> The reserve_ebda_region() has probably been like that for a while;
> do you understand why it would be a problem conflicting with the
> EFI memmap only now?
>
> My other two concerns remain as well:
>
>  2) Is what amounts to a change from calling reserve_bootmem()
>    to calling reserve_early(), at the end of reserve_ebda_region()
>    in the 32 bit case (now that it is merged with the 64 bit code)
>    understood to be a desired and correct change?
>
>  3) There has been quite a few patches restructuring this early
>    memory reservation code over the last week.  What is the
>    state of that work ... is it still "in progress" or is it
>    thought to be complete?

please check that commit that increase the range to 1M.
it seems at that time, andi and peter had different idea, because
increase 1M could waste K bytes memory.

also wonder if EFI is there, we still need to ebda?

YH

commit f6eb62b6924b99ec7da97fb6f554685a9ad6dce4
Author: Alexander van Heukelum <heukelum@mailshack.com>
Date:   Mon Feb 25 19:07:51 2008 +0100

    x86: reserve_early end-of-conventional-memory to 1MB, 64-bit

    Explicitly reserve_early the whole address range from the end of
    conventional memory as reported by the bios data area up to the
    1Mb mark. Regard the info retrieved from the BIOS data area with
    a bit of paranoia, though, because some biosses forget to register
    the EBDA correctly.

    Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 38f32e7..b684552 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -49,33 +49,42 @@ static void __init copy_bootdata(char *real_mode_data)
        }
 }

-#define EBDA_ADDR_POINTER 0x40E
+#define BIOS_EBDA_SEGMENT 0x40E
+#define BIOS_LOWMEM_KILOBYTES 0x413

+/*
+ * The BIOS places the EBDA/XBDA at the top of conventional
+ * memory, and usually decreases the reported amount of
+ * conventional memory (int 0x12) too.
+ */
 static __init void reserve_ebda(void)
 {
-       unsigned ebda_addr, ebda_size;
+       unsigned int lowmem, ebda_addr;

-       /*
-        * there is a real-mode segmented pointer pointing to the
-        * 4K EBDA area at 0x40E
-        */
-       ebda_addr = *(unsigned short *)__va(EBDA_ADDR_POINTER);
+       /* end of low (conventional) memory */
+       lowmem = *(unsigned short *)__va(BIOS_LOWMEM_KILOBYTES);
+       lowmem <<= 10;
+
+       /* start of EBDA area */
+       ebda_addr = *(unsigned short *)__va(BIOS_EBDA_SEGMENT);
        ebda_addr <<= 4;

-       if (!ebda_addr)
-               return;
+       /* Fixup: bios puts an EBDA in the top 64K segment */
+       /* of conventional memory, but does not adjust lowmem. */
+       if ((lowmem - ebda_addr) <= 0x10000)
+               lowmem = ebda_addr;

-       ebda_size = *(unsigned short *)__va(ebda_addr);
+       /* Fixup: bios does not report an EBDA at all. */
+       /* Some old Dells seem to need 4k anyhow (bugzilla 2990) */
+       if ((ebda_addr == 0) && (lowmem >= 0x9f000))
+               lowmem = 0x9f000;

-       /* Round EBDA up to pages */
-       if (ebda_size == 0)
-               ebda_size = 1;
-       ebda_size <<= 10;
-       ebda_size = round_up(ebda_size + (ebda_addr & ~PAGE_MASK), PAGE_SIZE);
-       if (ebda_size > 64*1024)
-               ebda_size = 64*1024;
+       /* Paranoia: should never happen, but... */
+       if (lowmem >= 0x100000)
+               lowmem = 0xa0000;

-       reserve_early(ebda_addr, ebda_addr + ebda_size, "EBDA");
+       /* reserve all memory between lowmem and the 1MB mark */
+       reserve_early(lowmem, 0x100000, "BIOS reserved");
 }

 void __init x86_64_start_kernel(char * real_mode_data)
