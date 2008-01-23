Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbYAWSob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbYAWSob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 13:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbYAWSoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 13:44:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:25697 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbYAWSoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 13:44:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=YX2B5SXrqtH9bRXKtSMfar+Lg0f4o9q5PjM2P0ZMshEwYtsnrrKVgp6kTXT6m+vZOOl8X5VSwT8O8R0k6IbyNIBxIKArvYFBxNbp9E7RBRz697mf4wyDzO3bK7L7EQEU9F8VE62PI7sg87h0O0cudThnWLT67FtbVzOQhk5afRs=
Date: Wed, 23 Jan 2008 21:43:43 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Paulo Marques <pmarques@grupopie.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/6] POWERPC: use KSYM_NAME_LEN
Message-ID: <20080123184343.GG12877@cvg>
References: <20080123173832.GA12877@cvg> <479786D4.9080601@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479786D4.9080601@grupopie.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Paulo Marques - Wed, Jan 23, 2008 at 06:26:28PM +0000]
> Cyrill Gorcunov wrote:
>> Use KSYM_NAME_LEN instead of numeric value.
>
> The patch series looks like a nice cleanup, except for a few things in this 
> patch.
>
>> Actually because of too small 'tmp' there is
>> a potential buffer overflow.
>
> I don't think there is. "tmp" is not being passed to kallsyms to be filled 
> with a symbol name, but it's being used to hold a name written by the user 
> to lookup an address.
>
> If the powerpc/xmon people feel that 63 characters is enough to hold a 
> symbol name, it's their problem, but there is no buffer overflow.
>
>> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
>> ---
>> Index: linux-2.6.git/arch/powerpc/xmon/xmon.c
>> ===================================================================
>> --- linux-2.6.git.orig/arch/powerpc/xmon/xmon.c	2008-01-23 
>> 19:04:42.000000000 +0300
>> +++ linux-2.6.git/arch/powerpc/xmon/xmon.c	2008-01-23 19:12:45.000000000 
>> +0300
>> @@ -69,7 +69,7 @@ static unsigned long ndump = 64;
>>  static unsigned long nidump = 16;
>>  static unsigned long ncsum = 4096;
>>  static int termch;
>> -static char tmpstr[128];
>> +static char tmpstr[KSYM_NAME_LEN];
>
> This one seems ok, since "tmpstr" is used everywhere to hold symbol names.
>
>>  #define JMP_BUF_LEN	23
>>  static long bus_error_jmp[JMP_BUF_LEN];
>> @@ -2354,7 +2354,7 @@ scanhex(unsigned long *vp)
>>  		}
>>  	} else if (c == '$') {
>>  		int i;
>> -		for (i=0; i<63; i++) {
>> +		for (i = 0; i < sizeof(tmpstr) / 2; i++) {
>
> This one is completely out of the blue. Why "sizeof(tmpstr) / 2"?
>

the original code was 63 but 63 is 128/2-1 so to not change the
original idea of 'use a half size in this case' I made it like
that.

> It would make more sense to use "sizeof(tmpstr) - 1", but either way it is 
> a change in behavior.
>
>>  			c = inchar();
>>  			if (isspace(c)) {
>>  				termch = c;
>> @@ -2467,7 +2467,7 @@ symbol_lookup(void)
>>  {
>>  	int type = inchar();
>>  	unsigned long addr;
>> -	static char tmp[64];
>> +	static char tmp[KSYM_NAME_LEN];
>>   	switch (type) {
>>  	case 'a':
>> @@ -2476,7 +2476,7 @@ symbol_lookup(void)
>>  		termch = 0;
>>  		break;
>>  	case 's':
>> -		getstring(tmp, 64);
>> +		getstring(tmp, sizeof(tmp));
>>  		if (setjmp(bus_error_jmp) == 0) {
>>  			catch_memory_errors = 1;
>>  			sync();

just after that poin in the original code a call to kallsyms_lookup_name
is done - so i think it could be an overflow (of course it depends
on what *exactly* the name is being searched, and Paulo - I didn't
managed to get *the whole picture* of what is going on in this
code - so the thoughs were like: kallsyms_lookup_name could find
a quite long name restricted by KSYM_NAME_LEN (dunno how it could
happens - due to buggy code or due to memory corruption outside,
it does not matter - the only matter - it *could* find that long
name).

Anyway - it's just an attempt ;) we always could drop it far-far away ;)

>
> This also introduces a change in behavior. It is still a nice cleanup, 
> though. So, if the powerpc people feel they can spare an extra 64 bytes of 
> stack here, I guess it's ok.

Thanks a lot for review Paulo!

>
> -- 
> Paulo Marques - www.grupopie.com
>
> "As far as we know, our computer has never had an undetected error."
> Weisert
>
		- Cyrill -
