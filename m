Return-Path: <linux-kernel-owner+w=401wt.eu-S1752645AbZI0RYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbZI0RYH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 13:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbZI0RYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 13:24:07 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:33165 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbZI0RYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 13:24:06 -0400
Message-ID: <4ABF9FB4.6040608@cesarb.net>
Date: Sun, 27 Sep 2009 14:24:04 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: Re: [PATCH] WARN_ONCE(): use bool for boolean flag
References: <1254059590-31690-1-git-send-email-cesarb@cesarb.net>	 <1254060189.20648.462.camel@desktop>  <4ABF8B30.5050801@cesarb.net> <1254070336.20648.518.camel@desktop>
In-Reply-To: <1254070336.20648.518.camel@desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker escreveu:
> On Sun, 2009-09-27 at 12:56 -0300, Cesar Eduardo Barros wrote:
>> Daniel Walker escreveu:
>>> On Sun, 2009-09-27 at 10:53 -0300, Cesar Eduardo Barros wrote:
>>>>  #define
>>>> WARN_ON_ONCE(condition)        ({                              \
>>>> -       static int __warned;                                    \
>>>> +       static bool __warned;                                   \
>>>>         int __ret_warn_once = !!(condition);                    \
>>> Could __ret_warn_once be bool also ? It looks like just another
>>> conditional variable..
>> Yes, it could (as long as either it is converted back to int in the 
>> return of the macro, or all users do not care about the macro's return 
>> type). However, the justification used for the printk_once patch (and 
>> this WARN_ONCE patch) does not apply directly anymore, since the code is 
>> different (to start with, it is not a static variable).
> 
> I did a couple kernel builds to test this on a small normal config,
> 
> vmlinux.base-line
>    text	   data	    bss	    dec	    hex	filename
> 6718958	 497200	1082460	8298618	 7ea07a	vmlinux.base-line
> 
> vmlinux.one-bool <-- Your patch
>    text	   data	    bss	    dec	    hex	filename
> 6718590	 497232	1082292	8298114	 7e9e82	vmlinux.one-bool

I am still trying to understand why data increases (but not enough to 
offset the gains on text and bss). My own testing had the same 
qualitative result (x86-64 defconfig):

    text    data     bss     dec     hex filename
8101271 1207116  992764 10301151         9d2edf vmlinux.warn.before
8100553 1207148  991988 10299689         9d2929 vmlinux.warn.after

> vmlinux.all-bool-converted 
>    text	   data	    bss	    dec	    hex	filename
> 6718506	 497232	1082292	8298030	 7e9e2e	vmlinux.all-converted
> 
> your changes drops the size 368 bytes, and if you convert the other
> conditionals it drops it by another 84 bytes. Not much more, but it's
> something.
> 
> So I think Rolands original reasoning still holds.. As far as people
> needing an int output from WARN_ON() , I'm not sure that's happening
> anyplace .. I can't imagine a sane usage for that.. 

I took a quick look, and all uses seem to be directly in a boolean 
context (within an if()), so there would be no problem. Besides, the 
unlikely() all these macros end with does a double negation, meaning 
even if it is an int, it will be either 0 or 1 (but I am not sure I am 
reading these macros right - it seems CONFIG_TRACE_BRANCH_PROFILING 
turns all unlikely() into likely()).

In fact, I was expecting no change at all, since gcc should be able to 
see it is being treated as a boolean (perhaps I am trusting gcc too 
much). And to make matters even more confusing, my own test changing all 
__ret_warn_once to bool and dropping the !! caused an _increase_ of 598 
bytes (x86-64 defconfig).

    text    data     bss     dec     hex filename
8100553 1207148  991988 10299689         9d2929 vmlinux.warnret.before
8101119 1207180  991988 10300287         9d2b7f vmlinux.warnret.after

(And yes, data increased again.)

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
