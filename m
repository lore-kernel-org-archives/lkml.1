Return-Path: <linux-kernel-owner+w=401wt.eu-S1752676AbXEXSxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbXEXSxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 14:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbXEXSxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 14:53:43 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:28813 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbXEXSxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 14:53:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VzFMRnoA2R5rtOug7fpPpwNQUpwHUDbZR4DRs/vRVJz5C2FZCL6Ok67tlxDF3NEKhOmbbbsv23XxOGj4BPgxiCOkxmm22RHg8kQOxtccyXMLUdJZKC+NP9zbEMS94FgN420SUH+RUKDThUOl1DQ4c1GNDZHk6j90oB8Rx2to0bk=
Message-ID: <a781481a0705241153m29781dd2u825c0e9bfdb6beb0@mail.gmail.com>
Date: Fri, 25 May 2007 00:23:39 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: any value to "NORET_TYPE" macro?
Cc: "Krzysztof Halasa" <khc@pm.waw.pl>, "Adrian Bunk" <bunk@stusta.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705241239560.10926@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain>
	 <Pine.LNX.4.64.0705221002350.14457@localhost.localdomain>
	 <20070522161951.GC2098@stusta.de> <m3ejl8k6e3.fsf@maximus.localdomain>
	 <Pine.LNX.4.64.0705221616270.18792@localhost.localdomain>
	 <m37ir0iodl.fsf@maximus.localdomain>
	 <a781481a0705230137v4c8ba82fx263212a2958b55b9@mail.gmail.com>
	 <Pine.LNX.4.64.0705230908180.4309@localhost.localdomain>
	 <a781481a0705230646x9a0255ak4254d05ba5442cad@mail.gmail.com>
	 <Pine.LNX.4.64.0705241239560.10926@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/24/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> On Wed, 23 May 2007, Satyam Sharma wrote:
>
> > Actually there's another thing :-) The __attribute__((xxx)) must go
> > with the function _declarations_ (and not the
> > implementations/definitions).
>
> that's not true, AFAICT.  the pattern seems to be that, in the case of
> declarations, attributes go at the end, as in:
>
> arch/sparc/boot/btfixupprep.c:void fatal(void) __attribute__((noreturn));

Yes, please, this is the normal way.

> while in actual definitions, they typically go after the return type,
> as in arch/arm/kernel/traps.c:
>
> void __attribute__((noreturn)) __bug(const char *file, int line)
> {
>         printk(KERN_CRIT"kernel BUG at %s:%d!\n", file, line);
>         *(int *)0 = 0;
>
>         /* Avoid "noreturn function does return" */
>         for (;;);
> }

Function attributes don't need to appear in function definitions at all.
(I've not come across such cases often, so this is certainly not the
standard). Anyway, the above is a case that the function lacks a
separate declaration which is why we put it there at the definition.
And yes, if we really do have to put an attribute in the function
definition, then we do need to place it _before_ the function name.

>   is that the standard that most people use?  if it is, i can use that
> standard for the cleanup.

Ok, so if you're really planning to do this cleanup, you can do the
following (for all occurrences of NORET_TYPE):

1. If this is a function _declaration_ (i.e. a prototype in some
header or some .c file), then remove the NORET_TYPE macro. Also,
if an ATTRIB_NORET or NORET_AND already exists then you're done.
Else, introduce an ATTRIB_NORET after the arglist but before ;

2. If this is a function _definition_, then remove the NORET_TYPE
macro.
	(a) If a _declaration_ also exists somewhere (say, some
	    header or in the same .c file) for this function, then go
	    and check it.
		(i) If it already contains an ATTRIB_NORET or
		    NORET_AND, then you're done.
		(ii) Else, introduce ATTRIB_NORET.

	(b) If no separate declaration exists for this function,
	    then just introduce the ATTRIB_NORET _before_ the
	    function name if it isn't there already.

I suspect the above would cover all cases :-)
