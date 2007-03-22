Return-Path: <linux-kernel-owner+w=401wt.eu-S934155AbXCVRrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934155AbXCVRrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 13:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934161AbXCVRrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 13:47:19 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:61974 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934155AbXCVRrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 13:47:18 -0400
Date: Thu, 22 Mar 2007 10:46:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tasos Parisinos <t.parisinos@sciensis.com>
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1][NEW] crypto API: rsa algorithm module patch (kernel
 version 2.6.20.3)
Message-Id: <20070322104643.57d0645d.randy.dunlap@oracle.com>
In-Reply-To: <46024000.2070208@sciensis.com>
References: <Pine.LNX.4.64.0703211701260.27640@zenon.ceid.upatras.gr>
	<20070321090420.f46cef4f.randy.dunlap@oracle.com>
	<46024000.2070208@sciensis.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007 10:36:16 +0200 Tasos Parisinos wrote:

> > Hi,
> > Lots of good progress here, but still a few comments below.
> >
> > Needs to apply to current mainline.
> >
> >   
> What do you mean by mainline?

Linus's current kernel tree, i.e., the latest git tree or
git snapshot preferably, or at least use the latest -rc if there
is one.  IIRC, the patch was against 2.6.20.2 (or .3), but it does
not apply cleanly to the current mainline tree.

> > Most (probably all) of these functions should also be "static"
> > unless they are meant for use outside of this module.
> >
> > Which leads to the question:  which functions are meant for
> > external/exported use?
> >
> > And it would be really Good if those function headers were
> > documented in kernel-doc notation (not much of a change from
> > what you already have here; see Documentation/kernel-doc-nano-HOWTO.txt).
> >
> 
> I think that if someone wants to do modular exponentiation rsa-style 
> (where n is always odd)
> using the montgomery algorithm i implement, only rsa_modexp should be static
> 
> But the rest of the API can be used for multi-precision integer 
> arithmetics, so they could almost all
> be exported (except rsa_load and rsa_unload). Do you think that this is 
> namespace pollution?
> In that case i should make them all static except rsa_modexp

Sounds like they should all be static except for rsa_modexp().
If other functions need to be made non-static later, that's trivial
to do.  And if loadable modules should be able to use rsa_modexp(),
then it needs one of these:

EXPORT_SYMBOL(rsa_modexp);
or
EXPORT_SYMBOL_GPL(rsa_modexp);


> About exportable comments, i just missed it, i will fix that

> >>  = tmp = buf[i + j] + (abuf[j] * (u64)bbuf[i]) + (tmp >> 32);
> >>     
> >
> > Break that line to < 80 columns, please.
> >
> >   
> >> +			tmp[j] = product = tmp[j] + (m * (u64)nbuf[j]) + (product >> 32);
> >>     
> >
> > Line too long.
> >
> >   
> >
> Well this is going to be a problem, because i believe that in this way 
> gcc will create the best code. These internal product
> computations are essential and they get run many-many times. I will do 
> my best to write it in less than 80 columns

You can split the line's source code without making it be multiple
C-language statements.  I'm just talking about source line length here.
E.g., instead of (this one long line):

+			tmp[j] = product = tmp[j] + (m * (u64)nbuf[j]) + (product >> 32);

use:
			tmp[j] = product = tmp[j] +
				(m * (u64)nbuf[j]) + (product >> 32);

or:
			product = tmp[j] + (m * (u64)nbuf[j]) + (product >> 32);
			tmp[j] = product;


> Then i need to comment on some of the changes that where suggested on 
> the previous patch but where not carried out
> 
> First of all the
> 
> UINT32_T_MAX
> 
> This is nowhere in linux/kernel.h but there are some equivalents but they are 
> defined as macros that do some computation to compute the max 32 bit unsigned integer
> and this would steal some (enough) clocks in loops that execute a lot. So i use the static value
> 0xFFFFFFFF which is more efficient.

Well, from a higher level, the code looks very 32-bit focused.
How well does it work on 64-bit CPUs?

> Secondly the chunk that initializes the mpi data
> 
> /* Copy the data */
> for (i = size - 1, j = 0; i >= 0; i--, j++)
>  buf[j / 4] |= ((u32)str[i] << ((j % 4) * 8));
> 
> Ok this is not pretty, its rather cruel. What i want to do is have a byte array for example
> 
> \xab\x11\xed\x43\x54\x34\x56\xcd
> 
> and make the mpi having data[0] = 0x543456cd and data[1]=0xab11ed43
> 
> I could reverse the byte array and then memcpy, what do you think?
> Is there a faster (and prettier) way to do this? someone said ntohl but im not sure

I don't see a good way to do that.  I guess we need to set up a
foundation and have a coding contest.  8;)

Hm, won't swab32() help with that?  and access the byte array
4 bytes at a time instead of 1 byte at a time?

Something like (not tested, with size converted to number of
u32's in the str[]):

	for (i = size - 1, j = 0; i >= 0; i--, j++)
		data[j] = swab32((u32)str[4 * i]);



> Also there are places that memset or memcpy could be used, but i can't figure out if it
> is more efficient to execute the set/copy loop my own or call such a function
> What is your opinion on that?

How time-critical is the code?  Is it used often or just once when
loading a module?  If it's not used frequently, I'd go for readability,
maintainability, and understandability.

> All the other changes suggested where carried out


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
