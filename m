Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbYAWS0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbYAWS0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 13:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYAWS0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 13:26:36 -0500
Received: from bipbip.grupopie.com ([195.23.16.24]:40230 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbYAWS0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 13:26:35 -0500
Message-ID: <479786D4.9080601@grupopie.com>
Date: Wed, 23 Jan 2008 18:26:28 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/6] POWERPC: use KSYM_NAME_LEN
References: <20080123173832.GA12877@cvg>
In-Reply-To: <20080123173832.GA12877@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> Use KSYM_NAME_LEN instead of numeric value.

The patch series looks like a nice cleanup, except for a few things in 
this patch.

> Actually because of too small 'tmp' there is
> a potential buffer overflow.

I don't think there is. "tmp" is not being passed to kallsyms to be 
filled with a symbol name, but it's being used to hold a name written by 
the user to lookup an address.

If the powerpc/xmon people feel that 63 characters is enough to hold a 
symbol name, it's their problem, but there is no buffer overflow.

> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> 
> Index: linux-2.6.git/arch/powerpc/xmon/xmon.c
> ===================================================================
> --- linux-2.6.git.orig/arch/powerpc/xmon/xmon.c	2008-01-23 19:04:42.000000000 +0300
> +++ linux-2.6.git/arch/powerpc/xmon/xmon.c	2008-01-23 19:12:45.000000000 +0300
> @@ -69,7 +69,7 @@ static unsigned long ndump = 64;
>  static unsigned long nidump = 16;
>  static unsigned long ncsum = 4096;
>  static int termch;
> -static char tmpstr[128];
> +static char tmpstr[KSYM_NAME_LEN];

This one seems ok, since "tmpstr" is used everywhere to hold symbol names.

>  #define JMP_BUF_LEN	23
>  static long bus_error_jmp[JMP_BUF_LEN];
> @@ -2354,7 +2354,7 @@ scanhex(unsigned long *vp)
>  		}
>  	} else if (c == '$') {
>  		int i;
> -		for (i=0; i<63; i++) {
> +		for (i = 0; i < sizeof(tmpstr) / 2; i++) {

This one is completely out of the blue. Why "sizeof(tmpstr) / 2"?

It would make more sense to use "sizeof(tmpstr) - 1", but either way it 
is a change in behavior.

>  			c = inchar();
>  			if (isspace(c)) {
>  				termch = c;
> @@ -2467,7 +2467,7 @@ symbol_lookup(void)
>  {
>  	int type = inchar();
>  	unsigned long addr;
> -	static char tmp[64];
> +	static char tmp[KSYM_NAME_LEN];
>  
>  	switch (type) {
>  	case 'a':
> @@ -2476,7 +2476,7 @@ symbol_lookup(void)
>  		termch = 0;
>  		break;
>  	case 's':
> -		getstring(tmp, 64);
> +		getstring(tmp, sizeof(tmp));
>  		if (setjmp(bus_error_jmp) == 0) {
>  			catch_memory_errors = 1;
>  			sync();

This also introduces a change in behavior. It is still a nice cleanup, 
though. So, if the powerpc people feel they can spare an extra 64 bytes 
of stack here, I guess it's ok.

-- 
Paulo Marques - www.grupopie.com

"As far as we know, our computer has never had an undetected error."
Weisert
