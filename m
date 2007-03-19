Return-Path: <linux-kernel-owner+w=401wt.eu-S965812AbXCSIAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965812AbXCSIAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 04:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965827AbXCSIAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 04:00:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:56074 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965819AbXCSIAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 04:00:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=CTy9AJ4X80pBHZRbGN0HgWgXUf4ApDZPvgHd7xBoeMYIvtpT3c6AEChsw2GPgWKi6xE3mWVYaVu3qO6g+aAHAcObFoOVuePNRjxnkcD8vPau2reEmVWTU2yDcbeHylgiqB1f+SQrWFmf6aUstORDjqv65+t6+val0Zeb/p6K45Y=
Message-ID: <84144f020703190100j5becc9dka2eba58456ab95f3@mail.gmail.com>
Date: Mon, 19 Mar 2007 10:00:12 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.20.3: kernel BUG at mm/slab.c:597 try#2
Cc: "Andreas Steinmetz" <ast@domdv.de>,
       "Linux Kernel Mailinglist" <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
In-Reply-To: <20070318220006.7230fd58.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45FDDA8E.8030100@domdv.de>
	 <20070318220006.7230fd58.akpm@linux-foundation.org>
X-Google-Sender-Auth: 4da3c27e8e833933
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/19/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>         BUG_ON(!PageSlab(page));
>
> that's seriously screwed up.  Do you have CONFIG_DEBUG_SLAB enabled?  If
> not, please enable it and retest.

This is scary. Looking at disassembly of the OOPS:

Disassembly of section .text:

00000000 <.text>:
   0:   5f                      pop    %edi
   1:   c3                      ret
   2:   57                      push   %edi
   3:   89 c1                   mov    %eax,%ecx
   5:   89 d7                   mov    %edx,%edi
   7:   8d 92 00 00 00 40       lea    0x40000000(%edx),%edx
   d:   56                      push   %esi
   e:   c1 ea 0c                shr    $0xc,%edx
  11:   53                      push   %ebx
  12:   c1 e2 05                shl    $0x5,%edx
  15:   03 15 40 5d 5a c0       add    0xc05a5d40,%edx

At this point, edx has the result of virt_to_page().

  1b:   8b 02                   mov    (%edx),%eax
  1d:   f6 c4 40                test   $0x40,%ah
  20:   74 03                   je     0x25

If it's a compound page, look up the real page from ->private.

  22:   8b 52 0c                mov    0xc(%edx),%edx

Now, reload page flags.

  25:   8b 02                   mov    (%edx),%eax

And test...

  27:   a8 80                   test   $0x80,%al
  29:   75 04                   jne    0x2f
  2b:   0f 0b                   ud2a
  2d:   eb fe                   jmp    0x2d
  2f:   39 4a 18                cmp    %ecx,0x18(%edx)

[snip, snip]

EIP is at kmem_cache_free+0x29/0x5a
eax: c1800000   ebx: f0ae12c0   ecx: c18f73c0   edx: c1800000
esi: c1919de0   edi: 00000000   ebp: 00001000   esp: f1fe7e14
ds: 007b   es: 007b   ss: 0068

But somehow eax and edx have the same value 0xc1800000 here. Hmm?

                                   Pekka
