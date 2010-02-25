Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475Ab0BYTry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:47:54 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41792 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932882Ab0BYTru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:47:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ISP5adX0bI9Pt20rBHXq0WMoeUhwKRj5ZHcjJJr/2EmK3p4zK9XAALchQuxgh5WpTq
         8MmDsdAgMOGB6WJ9G2CWFX7qx5MAtGAXktMMAZutnaeSVrwnrn6pHlvCSxHAeq0zq/p1
         NvFTNA3sME4AFpjz46/Re62ytNlGBPf2+I6G8=
Message-ID: <4B86D3E4.4000205@gmail.com>
Date: Thu, 25 Feb 2010 20:47:48 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Mikael Pettersson <mikpe@it.uu.se>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sha: prevent removal of memset as dead store in 	sha1_update()
References: <4B8692E3.9030509@gmail.com>	 <19334.40337.651079.440912@pilspetsen.it.uu.se>	 <73c1f2161002250833n120cda05s9371e5ce13cc0aac@mail.gmail.com>	 <19334.44752.357207.382349@pilspetsen.it.uu.se> <73c1f2161002250932j5167e2fan51dc11970df00f7@mail.gmail.com>
In-Reply-To: <73c1f2161002250932j5167e2fan51dc11970df00f7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 25-02-10 18:32, Brian Gerst schreef:
> On Thu, Feb 25, 2010 at 12:09 PM, Mikael Pettersson <mikpe@it.uu.se> wrote:
>> Brian Gerst wrote:
>>> Would barrier() (which is a simple memory clobber) after the memset work?
>>
>> I don't know. It's implemented as an asm with a "memory" clobber,
>> but I wouldn't bet on that forcing previous writes to a dying object
>> to actally be performed (it would have to have a data-dependency on
>> the dying object, but I don't think there is one).
> 
>>From the GCC manual, section 5.37:
> If your assembler instructions access memory in an unpredictable
> fashion, add `memory' to the list of clobbered registers. This will
> cause GCC to not keep memory values cached in registers across the
> assembler instruction and not optimize stores or loads to that memory.
> You will also want to add the volatile keyword if the memory affected
> is not listed in the inputs or outputs of the asm, as the `memory'
> clobber does not count as a side-effect of the asm.
> 
> --
> Brian Gerst
> 

Also from that document:

If you know how large the accessed memory is, you can add it as input or
output but if this is not known, you should add memory. As an example, if
you access ten bytes of a string, you can use a memory input like:

     {"m"( ({ struct { char x[10]; } *p = (void *)ptr ; *p; }) )}.

I am new to assembly but does this mean we could use something like:

#define SECURE_BZERO(x) do {                                            \
        memset(x, 0, sizeof(x));                                        \
        asm("" : :"m"( ({ struct { char __y[ARRAY_SIZE(x)]; } *__z =    \
                                        (void *)x ; *__z; }) ));        \
} while(0)

Roel
