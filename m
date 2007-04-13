Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbXDMOT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbXDMOT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 10:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbXDMOT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 10:19:27 -0400
Received: from mailout16.yourhostingaccount.com ([65.254.253.130]:42878 "EHLO
	mailout16.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754012AbXDMOT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 10:19:26 -0400
X-Greylist: delayed 1401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Apr 2007 10:19:26 EDT
Message-ID: <003201c77dd3$95b22500$0864a8c0@scs1>
From: "Tasos Parisinos" <t.parisinos@sciensis.com>
To: "Indan Zupancic" <indan@nul.nu>,
       "David Wagner" <daw-usenet@taverner.cs.berkeley.edu>
Cc: <linux-kernel@vger.kernel.org>, "Satyam Sharma" <satyam.sharma@gmail.com>
References: <4610D25F.7080005@ceid.upatras.gr>    <1349.81.207.0.53.1176302225.squirrel@secure.samage.net>    <a781481a0704120235q34d047c8q350b0ed29cde9f0f@mail.gmail.com>    <3630.81.207.0.53.1176380573.squirrel@secure.samage.net>    <evm8am$h12$2@taverner.cs.berkeley.edu> <4264.81.207.0.53.1176420676.squirrel@secure.samage.net>
Subject: Re: [PATCH resend][CRYPTO]: RSA algorithm patch
Date: Fri, 13 Apr 2007 16:56:42 +0300
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3028
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-EN-UserInfo: 6b5ac0c6b5a8f649d336ffa6ba3f3bc4:297516c839f78035fb456ced5af6b435
X-EN-AuthUser: tparisinos@sciensis.com
X-EN-OrigIP: 88.218.94.102
X-EN-OrigHost: dsl-88-218-94-102.customers.vivodi.gr
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again

As i formerly stated there was some 'management' mixup (and don't want to believe that it had to do with
my code and crypto competence :), anyway no offence about that, really) about what to submit and what 
not. Now things are getting a lot clearer and i think that we will be able to submit all the patches in
order to have:

The rsa module patch as is now with the following additions

1. Padding as PKCS#1 specificates
2. Crypto API glue code

And another patch that will be the code authenticating mechanism.

These two will be a complete binary authenticating mechanism to be used in embedded Linux much the way
it was described on a previous post of mine.

The above will take some time as they will be reworked significantly based on the experience 
gathered through this discussion

If this code organization is done, should this go in crypto as rsa module + binary signing module
or should be made as one unique module for code authentication (hiding the rsa implementation inside it) 
and putting it somewhere else (not in crypto)?

-----

Sharma really made a point about excluding padding from this module and leaving it to userspace
or other in-kernel code. It should be added in the module, as it is the only to be used anyway be everyone.
Also Indan is right, this module was supposed to be a simple mpi implementation to do modexp
using the montgomery algorithm to be used for binary authentication, but if it is to turn it into real RSA
it should have padding and crypto API glue code.

-----

Indan has said:
I don't see this happening soon. But a good start would be if someone who
cares about this sets up a mailing list or website to collect all users
and information.

I think that this is a nice idea, so i will try setup such a spot to be able to discuss and share code.

-----

I created this code taking Indan's way of looking at things. Not porting something like the whole
gmp but just re-implementing only the needed mpi code. This as a result can be a clear and robust
and really easy to audit, basis for future implementations and addons. The drawback is that it does
not provide generic mpi functions to be used in other places as well. The question is:

If a full mpi kernel lib would be big and complex and randomly used then it is better to have 
distinct little modules, implementing their own needed mpi functionality, isn't that so?

When there will be lots of them modules depending heavily on mpi calculations then those could
be reworked to reach that point and in that case you would have less complexity and code size.

-------

There was also big discussion about implementing CRT to do modexp with the private key.
In my view although this could be implemented in the RSA module in order for it to be generic
it is susceptible to timing and other attacks and i would personally would not use it neither i would
keep such keys on a plain filesystem on an embedded device on the market. That is why there is
only the implementation of the montgomery exponentiation in my patch to be used with public keys
and exponents to authenticate code on embedded devices as described in detail in a previous message. 
Excluding the use of private keys and CRT also makes code a lot simpler. I tell you again this module
is not created for PC security. It is created to address a specific need on embedded devices. Whether
it will be used by a PC user to cipher/decipher data on his disk is ok with me but really in that case there
is no added security anyway.

The question there is:

Create a generic and complex RSA module to be used by anyone even on PCs (where it could be done 
easily (and much with the same safety) on userland) or create a cut-down and specific authenticating 
mechanism (using RSA) to authenticate code, that would be able to be used by all Linux embedded
users at first (and for naive and unsafe usage in PC world)?

Bye for now
Tasos Parisinos
-
