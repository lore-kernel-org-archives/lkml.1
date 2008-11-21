Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbYKULOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbYKULOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 06:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbYKULOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 06:14:34 -0500
Received: from ftp.linux-mips.org ([213.58.128.207]:36982 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbYKULOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 06:14:33 -0500
Date: Fri, 21 Nov 2008 11:14:30 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Daney <ddaney@caviumnetworks.com>,
       linux-mips <linux-mips@linux-mips.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Make BUG() __noreturn.
In-Reply-To: <Pine.LNX.4.64.0811211126420.26004@anakin>
Message-ID: <alpine.LFD.1.10.0811211059290.20023@ftp.linux-mips.org>
References: <49260E4C.8080500@caviumnetworks.com> <20081121100035.3f5a640b@lxorguk.ukuu.org.uk> <Pine.LNX.4.64.0811211126420.26004@anakin>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008, Geert Uytterhoeven wrote:

> > That sounds like your __noreturn macro is wrong.
> > 
> > Try using __attribute__ ((__noreturn__))
> > 
> > if that works then fix up the __noreturn definitions for the MIPS and gcc
> > you have.
> 
> Nope, gcc is too smart:
> 
> $ cat a.c
> 
> int f(void) __attribute__((__noreturn__));
> 
> int f(void)
> {
> }
> 
> $ gcc -c -Wall a.c
> a.c: In function f:
> a.c:6: warning: `noreturn' function does return
> $ 

 Hmm, in the case of your example the warning is justified, because the 
(virtual) "return" statement of your function is in a unconditional block.  
Otherwise it looks like the attribute is useless -- it looks like it can 
only be used for functions where GCC can determine the function does not 
return anyway.  Which means it is redundant.

 The cases where within the function concerned there is a volatile asm or 
a conditional block which cannot be determined with simple static analysis 
that it does stop look like legitimate ones for the use of the "noreturn" 
attribute and my opinion is GCC should not warn about them with -Wall, 
though a separate -W<whatever> option for the inquisitive would make sense 
to me.  It might be worthwhile to have a look into archives of the GCC 
mailing lists to see how the implementation has evolved into the current 
form and if no useful conclusion can be made, to bring the issue now 
and/or file a bug report.

  Maciej
