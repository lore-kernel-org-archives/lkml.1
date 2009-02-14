Return-Path: <linux-kernel-owner+w=401wt.eu-S1751881AbZBNIVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbZBNIVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 03:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750792AbZBNIVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 03:21:47 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:43234 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbZBNIVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 03:21:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eeqkONu6MZpND7VIALW8H0RdbW/h4kB8PKrZ0GE8JLnTGFHagLXL/4s9yBfelPKzhP
         tCaIARIru0duyYibFHHHVIy332q6WKhkEd8TNz2Mmc79tPelhOOlxlJgrBGwQ00jrXc/
         qXZGdeeCW+XX8I2LSsfCUVuG4m3//qlslRBXc=
Date: Sat, 14 Feb 2009 11:21:42 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>, Ingo Molnar <mingo@elte.hu>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/6] x86 tip asm ENTRY,ENDPROC cleanup
Message-ID: <20090214082142.GA7648@localhost>
References: <20090213215017.959278111@gmail.com> <1234567411.13034.1300286953@webmail.messagingengine.com> <49961178.6040101@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49961178.6040101@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Fri, Feb 13, 2009 at 04:34:00PM -0800]
> Alexander van Heukelum wrote:
>>
>> Hi Cyrill,
>>
>> I like this direction. If I understand correctly:
>>
>> ENTRY/END or GLOBAL/END for data.
>> ENTRY/ENDPROC or GLOBAL/ENDPROC for functions.
>>
>
> Fine for functions, but it's really not okay to use the same macros for  
> data.  Furthermore, we need to consider special entry points that don't  
> behave like normal functions -- like system call or interrupt entry.
>
> Why?  Because if we're compiling with frame pointers, we would like the  
> wrapper macros for functions to handle setting up and tearing down the  
> frame pointer, at least in the common case.
>
> 	-hpa
>

Peter, Alexander -- thanks for review!

>> ENTRY/END or GLOBAL/END for data.
>> ENTRY/ENDPROC or GLOBAL/ENDPROC for functions.

Well, there are nuances I believe. Plain .size without .cfi_...
for functions would not help in frame unwinding I think (in *.S
under debugger).

I wish we have strict rules for functions and data but it's not
that simple :)

For example, trampoline_64.S:
...
	.org 0x1000
trampoline_stack_end:
ENTRY(trampoline_level4_pgt)
...

we could use plain .globl (or new GLOBAL) here since we
have .org and ALIGN in ENTRY just not needed.

Same file:
...
ENTRY(trampoline_end)
...

I think we could have plain .globl here as well
(and we do that for 32bit version). Moreover TRAMPOLINE_SIZE
is page rounded anyway.

But in general I think you're right -- which means:
start with END for data and ENDPROC for functions and
then checkout the details as Peter mentioned. At least
I do ratiocinate like this. But I could be wrong :)

	- Cyrill -
