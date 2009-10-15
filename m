Return-Path: <linux-kernel-owner+w=401wt.eu-S935104AbZJOJJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935104AbZJOJJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935096AbZJOJJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:09:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:47677 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935085AbZJOJJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:09:43 -0400
Message-ID: <4AD6E68C.8020902@kernel.org>
Date: Thu, 15 Oct 2009 18:08:28 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, mingo@redhat.com,
       tglx@linutronix.de, akpm@linux-foundation.org, rostedt@goodmis.org,
       hpa@zytor.com, cebbert@redhat.com, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 16/16] percpu: make accessors check for percpu pointer
 in sparse
References: <1255500125-3210-1-git-send-email-tj@kernel.org> <1255500125-3210-17-git-send-email-tj@kernel.org> <alpine.DEB.1.10.0910141039290.26476@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0910141039290.26476@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 09:08:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Wed, 14 Oct 2009, Tejun Heo wrote:
> 
>>  #ifndef SHIFT_PERCPU_PTR
>>  /* Weird cast keeps both GCC and sparse happy. */
>> -#define SHIFT_PERCPU_PTR(__p, __offset)				\
>> -	RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset))
>> +#define SHIFT_PERCPU_PTR(__p, __offset)	({				\
>> +	__verify_pcpu_ptr((__p));					\
>> +	RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset)); \
>> +})
> 
> If you have the verification in SHIFT_PER_CPU_PTR then why do you need it
> elsewhere?

Because this_cpu_*() macros might not calculate addresses using
SHIFT_PERCPU_PTR().

>>  #define __pcpu_size_call_return(stem, variable)				\
>>  ({	typeof(variable) pscr_ret__;					\
>> +	__verify_pcpu_ptr(&(variable));					\
>>  	switch(sizeof(variable)) {					\
>>  	case 1: pscr_ret__ = stem##1(variable);break;			\
>>  	case 2: pscr_ret__ = stem##2(variable);break;			\
>> @@ -250,6 +251,7 @@ extern void __bad_size_call_parameter(void);
>>
>>  #define __pcpu_size_call(stem, variable, ...)				\
>>  do {									\
>> +	__verify_pcpu_ptr(&(variable));					\
>>  	switch(sizeof(variable)) {					\
>>  		case 1: stem##1(variable, __VA_ARGS__);break;		\
>>  		case 2: stem##2(variable, __VA_ARGS__);break;		\
> 
> Would it not be better to put the verification in the arch code? The
> percpu_to/from_op may have multiple callsites (at least they have now). If
> you put it in there then all other stuff is covered.

I don't know.  The way these ops are defined, adding
__verify_pcpu_ptr() to size_call macros reliably cover all percpu
cases and I much prefer things like this being done in generic code
rather than requiring each arch to do it.  It's just more reliable
this way.

Thanks.

-- 
tejun
