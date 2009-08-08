Return-Path: <linux-kernel-owner+w=401wt.eu-S1752811AbZHHW1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbZHHW1y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 18:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbZHHW1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 18:27:52 -0400
Received: from mx6.orcon.net.nz ([219.88.242.56]:55825 "EHLO mx6.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbZHHW1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 18:27:51 -0400
Message-ID: <4A7DFBE4.6060101@orcon.net.nz>
Date: Sun, 09 Aug 2009 10:27:48 +1200
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Falk Hueffner <falk@debian.org>
CC: Matt Turner <mattst88@gmail.com>, linux-kernel@vger.kernel.org,
       linux-alpha@vger.kernel.org
Subject: Re: Bad Code generated from __{get,put}_unaligned functions
References: <b4198de60908061056m2b27402cjd25f94b6bbed0707@mail.gmail.com> <20090806183941.GA6854@minet.uni-jena.de>
In-Reply-To: <20090806183941.GA6854@minet.uni-jena.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx6.orcon.net.nz on Sun, 09 Aug 2009 10:27:50 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sun Aug  9 10:27:51 2009
X-DSPAM-Confidence: 0.6525
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Falk Hueffner wrote:
> On Thu, Aug 06, 2009 at 01:56:12PM -0400, Matt Turner wrote:
>   
>> I was researching different ways of writing unaligned load/store
>> macros, so I checked how the kernel did it -- the most general way
>> possible. See include/linux/unaligned.h. As such, very bad code is
>> generated, for example on alpha with BWX, we can implement all these
>> functions with a single instruction, whereas we get stuff like this
>> generated from the generic functions.
>>
>> __get_unaligned_le32:
>>     .frame $30,0,$26,0
>>     .prologue 0
>>     ldbu $0,1($16)
>>     ldbu $1,2($16)
>>     ldbu $2,3($16)
>>     ldbu $3,0($16)
>>     sll $1,16,$1
>>     sll $0,8,$0
>>     bis $0,$1,$0
>>     sll $2,24,$2
>>     bis $0,$3,$0
>>     bis $0,$2,$0
>>     addl $31,$0,$0
>>     ret $31,($26),1
>>
>> 4 load byte instructions, shift, shift, or, shift, or, or, sign extend
>> -- or ldl_u instruction. The code is more than doubly-bad for le64.
>>
>> Do we use the generic functions for a reason I don't see? It appears
>> that it would be easy enough to add architecture-specific unaligned
>> get/put functions in arch/*/include/asm/unaligned.h
>>     
>
> There should be no need for architecture specific code for Alpha. GCC
> can generate the optimal code sequence for reads from unaligned struct
> members as in linux/unaligned/packed_struct.h, and this code should be
> used. So you should try to find out why it isn't.
>   

Indeed, the above code looks like what one would expect from the 
routines in linux/unaligned/le_byteshift.h rather than packed_struct.h

Michael.

