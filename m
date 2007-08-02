Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbXHBKRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbXHBKRE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 06:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbXHBKQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 06:16:55 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:10295 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbXHBKQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 06:16:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=l1yyP/yEstvlXt6miIiek2E3ArH0VJGQB5iOJLlbBMCnNxGDkV1wxeo87jX7mIB4svW3W9DkWvQx2tMcbnL3sEU5K0jhvKETwDgYfiwXOPkQh0+saAGB/At4R1Igl/Lnh8dCR26MAMz91pKJkrbaezosE5y1fu/FrZ6WAPrhsK4=
Message-ID: <46B1AF0E.40703@gmail.com>
Date: Thu, 02 Aug 2007 18:16:46 +0800
From: "Antonino A. Daplas" <adaplas@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Daniel Drake <dsd@gentoo.org>, Zwane Mwaikambo <zwane@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] retrieve VBE EDID/DDC info independent of used video
 mode
References: <4678191D.76E4.0078.0@novell.com> <4686D85B.6090803@gentoo.org>	 <20070630154230.4ad373fa.akpm@linux-foundation.org>	 <4690E65B.5050607@gentoo.org>	 <20070708111404.1486e73c.akpm@linux-foundation.org>	 <46912E09.2070806@zytor.com> <4692BC61.9070500@gentoo.org>	 <4692BDEE.8020802@zytor.com> <4693BF02.2050705@gentoo.org>	 <4693C0A1.8010901@zytor.com> <4693CAFF.4000609@gentoo.org>	 <4693CCC6.7050400@zytor.com> <46AFCCBB.70307@gentoo.org>	 <Pine.LNX.4.64.0707311719540.5207@montezuma.windriver.com>	 <46AFDF3A.6080300@gentoo.org>  <1185933291.4688.11.camel@daplas>	 <1186024158.4629.1.camel@daplas> <46B1547F.3090403@zytor.com>
In-Reply-To: <46B1547F.3090403@zytor.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Antonino A. Daplas wrote:
>> On Wed, 2007-08-01 at 09:54 +0800, Antonino A. Daplas wrote:
>>> On Tue, 2007-07-31 at 21:17 -0400, Daniel Drake wrote:
>>>> Zwane Mwaikambo wrote:
>>>>> Sorry if this has been hashed out before, but could you point me
>>>>> towards the gentoo bugzilla entry? I'm trying to understand how
>>>>> your setup broke. Which version VBE does your system have?
>>>> Here's the bug:
>>>> http://bugs.gentoo.org/show_bug.cgi?id=181067
>>>>
>>> Looking at the dmesg output of the working and failing kernel, it does
>>> seem that there's no EDID block available in the failing kernel.
>>>
>>
>> BTW, I looked at the above bug report, it seems his last dmesg does not
>> have fbcon enabled.  Make sure that CONFIG_FRAMEBUFFER_CONSOLE=y before
>> doing more tests (the problem of lack of the EDID block in the failing
>> kernel still applies).
>>
> 
> Okay, I'm royally puzzled why that would be.  I've gone over the code
> quite a few times, and I do not see any way (other than VESA < 2.0) that
> could cause that.
> 
> I look forward to getting the debug output; depending on what it is we
> might have to get some debugging output from the setup code.
> 
> We can printf in the new setup code, although obviously that requires
> leaving the screen in text mode.  However, EDID information should still
> be available.
> 
 
How about this patch?

Tony
---

Subject: video setup: Fix VBE DDC reading

Add memory operand constraint and write-only modifier to the inline
assembly to effect the writing of the EDID block to boot_params.edid_info.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
---

 arch/i386/boot/video-vesa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/i386/boot/video-vesa.c b/arch/i386/boot/video-vesa.c
index e6aa9eb..f1bc71e 100644
--- a/arch/i386/boot/video-vesa.c
+++ b/arch/i386/boot/video-vesa.c
@@ -268,7 +268,7 @@ #ifdef CONFIG_FIRMWARE_EDID
 	dx = 0;			/* EDID block number */
 	di =(size_t) &boot_params.edid_info; /* (ES:)Pointer to block */
 	asm(INT10
-	    : "+a" (ax), "+b" (bx), "+d" (dx)
+	    : "+a" (ax), "+b" (bx), "+d" (dx), "=m" (boot_params.edid_info)
 	    : "c" (cx), "D" (di)
 	    : "esi");
 #endif /* CONFIG_FIRMWARE_EDID */

