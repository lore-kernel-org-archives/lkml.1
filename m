Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbZBOUJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbZBOUJh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 15:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbZBOUJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 15:09:10 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:36020 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751990AbZBOUJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 15:09:04 -0500
Message-ID: <49987672.2050102@ru.mvista.com>
Date: Sun, 15 Feb 2009 23:09:22 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/2 resend] libata-sff: avoid byte swapping in ata_sff_data_xfer()
References: <200902152230.38271.sshtylyov@ru.mvista.com> <4998717A.2090507@pobox.com>
In-Reply-To: <4998717A.2090507@pobox.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:

>> Handling of the trailing byte in ata_sff_data_xfer() is suboptimal 
>> bacause:

>> - it always initializes the padding buffer to 0 which is not really 
>> needed in
>>   both the read and write cases;

>> - it has to use memcpy() to transfer a single byte from/to the padding 
>> buffer;

> Have you looked at the assembly, before deciding it is suboptiomal?

    I'm estimating the code itself, not what the compiler can do to fix it. :-)

> gcc optimizes tiny arrays and structures quite well, and is well capable 
> of seeing one path where the initialization is clobbered without a 
> single read, and another code path where it is used.

    The initialier just shouldn't have been there in the first place, 
clobbered or not. And let's looks at what gcc gave me:

.L504:
         .loc 1 727 0
         testb   $1, %bl #, buflen
         jne     .L511   #,
[...]
.L511:
.LBB635:
         .loc 1 731 0
         movl    8(%ebp), %eax   # rw,
         .loc 1 729 0
         leal    (%esi,%ebx), %ebx       #, tmp72
.LVL440:
         .loc 1 728 0
.LBB635:
         .loc 1 731 0
         movl    8(%ebp), %eax   # rw,
         .loc 1 729 0
         leal    (%esi,%ebx), %ebx       #, tmp72
.LVL440:
         .loc 1 728 0
         movw    $0, -14(%ebp)   #, align_buf
         .loc 1 731 0
         testl   %eax, %eax      #
         jne     .L507   #,
         .loc 1 732 0
         movl    -20(%ebp), %eax # data_addr, data_addr
         call    ioread16        #
         movw    %ax, -14(%ebp)  # D.29224, align_buf
.LBB629:
.LBB630:
         .loc 4 60 0
         movzbl  -14(%ebp), %eax #, tmp73
         movb    %al, -1(%ebx)   # tmp73,
.L509:
.LBE630:
.LBE629:
         .loc 1 738 0
         addl    $1, %edi        #, words
         jmp     .L505   #
.L507:
.LBB631:
.LBB632:
         .loc 4 60 0
         movzbl  -1(%ebx), %eax  #, tmp74
.LBE632:
.LBE631:
         .loc 1 736 0
         movzwl  -14(%ebp), %eax # align_buf, align_buf
         call    iowrite16       #
         jmp     .L509   #

    As you can see, it happily assigned 0 to align_buf[0] at .LVL440, 
regardless of the value of 'rw'.

> As for memcpy, for small and/or constant values that is quite often a 
> compiler builtin.  It is rarely useful, these days, to convert a memcpy() to a hand-rolled 
version of same.

    Here memcpy() just shouldn't have appeared in the first place. But indeed, 
gcc did optimize it away.

>     Jeff

MBR, Sergei
