Return-Path: <linux-kernel-owner+w=401wt.eu-S932928AbXH2K3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928AbXH2K3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 06:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932509AbXH2K3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 06:29:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34458 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105AbXH2K3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 06:29:38 -0400
Date: Wed, 29 Aug 2007 16:12:39 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Jiri Slaby <jirislaby@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] V4L: stk11xx, add static to tables
In-Reply-To: <2680630254888919558@pripojeni.net>
Message-ID: <alpine.LFD.0.999.0708291448480.16082@enigma.security.iitk.ac.in>
References: <2680630254888919558@pripojeni.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,


On Tue, 28 Aug 2007, Jiri Slaby wrote:
> 
> stk11xx, add static to tables
> 
> ensure, that the compiler will put all the tables in static storage

> @@ -26,7 +26,7 @@ static int stk1125_load_microcode(struct stk11xx *dev)
>  	int retok;
>  
>  	/* From 80x60 to 640x480 */
> -	const u8 values_1_204[] = {
> +	static const u8 values_1_204[] = {
>  		0x12, 0x11, 0x3b, 0x6a, 0x13, 0x10, 0x00, 0x01, 0x02, 0x13,
>  		0x39, 0x38, 0x37, 0x35, 0x0e, 0x12, 0x04, 0x0c, 0x0d, 0x17,
>  		0x18, 0x32, 0x19, 0x1a, 0x03, 0x1b, 0x16, 0x33, 0x34, 0x41,


Probably I'm missing something (or am wrong/mistaken, in which case I hope
somebody corrects me), but what do we get with this change?

I think having "static const" on data having function-local scope (as is
the case with all occurrences in this patch) is often redundant/pointless
thing to do. "static" on function-local data serves only to instruct the
compiler to allocate storage in .data instead of stack -- .data because it
lives for as long as the program will, and also because it is read-write.
"const", OTOH will send it to the .rodata section anyway -- which has
similar storage lifetime, with additional restriction that it is read-only
and also allows the compiler to do all sorts of optimization tricks
(because such data is known to remain constant during runtime as well).
For "static const", .rodata is chosen over .data, neither of which is the
function's stack, so effectively it's not any more beneficial than simple
"const", and if anything might only confuse the compiler.

Note that having "static const" on _global_ (not function-local) data is
still a useful thing to do -- "static" scopes it within the current file,
and "const" throws it into the .rodata with all its other implications.
But that is not the case with any of the cases in this particular patch.

The reason I ask is because I did something similar recently -- allocated
an array of constant strings -- const char *stringarray[xxx] = {...};
inside a function, and am even fearlessly returning a pointer to one of
those strings back to the caller(!) Things do work correctly as expected,
but is there something subtle I missed?


Satyam
