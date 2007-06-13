Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbXFMUfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbXFMUfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 16:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbXFMUfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 16:35:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbXFMUfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 16:35:20 -0400
Message-ID: <467054F6.7080604@redhat.com>
Date: Wed, 13 Jun 2007 16:35:02 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: Maciej Soltysiak <solt2@dns.toxicfilms.tv>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21.14 NFS related oops
References: <466FDC76.6020207@dns.toxicfilms.tv> <1181762227.6151.55.camel@heimdal.trondhjem.org>
In-Reply-To: <1181762227.6151.55.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2007 03:17 PM, Trond Myklebust wrote:
> On Wed, 2007-06-13 at 14:00 +0200, Maciej Soltysiak wrote:
>>  =======================
>> Code: 10 89 5c 24 10 89 c3 89 7c 24 18 89 d7 89 74 24 14 8b 70 28 75 1a 8b
>> 4e 08 89 fa 89 d8 ff 51 18 8b 5c 24 10 83 74 24 14 8b 7c 24 <18> 83 c4 1c c3
>> 89 74 24 0c 8b 40 10 8b 40 24 8b 40 10 8b 40 08 EIP: [<f0a93c94>]
>> rpcauth_checkverf+0x34/0x70 [sunrpc] SS:ESP 0068:e64b5eec
> 
> At a first guess, it looks as though something has scribbled over your
> credential. Have you tried running this kernel with slab debugging
> enabled?
> 

Disassembly of this code yields gibberish, like a bit got flipped
somewhere:

  1c:   ff 51 18                  call   *0x18(%ecx)
  1f:   8b 5c 24 10               mov    0x10(%esp),%ebx
  23:   83 74 24 14 8b            xorl   $0xffffff8b,0x14(%esp)
  28:   7c 24                     jl     4e <_EIP+0x4e>
   0:   18 83 c4 1c c3 89         sbb    %al,0x89c31cc4(%ebx)   <=====
   6:   74 24                     je     2c <_EIP+0x2c>
   8:   0c 8b                     or     $0x8b,%al
   a:   40                        inc    %eax
   b:   10 8b 40 24 8b 40         adc    %cl,0x408b2440(%ebx)
  11:   10                        .byte 0x10
  12:   8b 40 08                  mov    0x8(%eax),%eax

Somewhere around 23: things went horribly wrong.
At 12: it starts to make sense again.

