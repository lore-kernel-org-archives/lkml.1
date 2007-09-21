Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbXIUMXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbXIUMXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 08:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbXIUMXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 08:23:48 -0400
Received: from mail.tmr.com ([64.65.253.246]:54302 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986AbXIUMXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 08:23:47 -0400
Message-ID: <46F3B89F.8000309@tmr.com>
Date: Fri, 21 Sep 2007 08:27:11 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: linux-tiny@selenic.com, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       Michael Opdenacker <michael@free-electrons.com>
Subject: Re: [Announce] Linux-tiny project revival
References: <46F1645D.9050406@am.sony.com> <200709201538.43093.rob@landley.net>
In-Reply-To: <200709201538.43093.rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> On Wednesday 19 September 2007 1:03:09 pm Tim Bird wrote:
>> Recently, the CE Linux forum has been working to revive the
>> Linux-tiny project.  At OLS, I asked for interested parties
>> to volunteer to become the new maintainer for the Linux-tiny patchset.
>>
>> A few candidates came forward, but eventually Michael Opdenacker
>> was selected as the new primary maintainer.  A few other
>> people, including John Cooper of Wind River and myself
>> are working to support this effort.
>>
>> Recently, many of the Linux-tiny patches have been brought up-to-date
>> and are now available for use with a 2.6.22 kernel.  The intent
>> is to test these, and begin mainlining the most effective sub-patches,
>> in the next few months.
> 
> Cool!
> 
> Could you update http://www.selenic.com/linux-tiny/ to mention the new 
> maintainer and new URLs?
> 
>> Some automated testing has already been set up, with some
>> preliminary results published at a CELF conference in Japan.
>> (See the linux-tiny page below for a link to the presentation.)
>> Hopefully, results publishing will also be automated soon.
>>
>> We encourage anyone with interest in this project to get involved.
>> If you have ideas how to reduce the static or dynamic memory footprint
>> of Linux, or, even better, patches for this, please let us know about
>> them.
> 
> I've been playing with an idea for a while to improve the printk() situation, 
> but it's a more intrusive change than I've had time to bang on.
> 
> Right now, the first argument to printk() is a loglevel, but it's handled via 
> string concatenation.  I'd like to change that to be an integer, and make it 
> an actual comma-separated first argument.  (Mandatory, not optional.)
> 
> So instead of:
>   printk(KERN_NOTICE "Fruit=%d\n", banana);
> It would now be:
>   printk(KERN_NOTICE, "Fruit=%d\n", banana);
> 
> Change the header from:
>   #define KERN_NOTICE "<5>"
> to:
>   #define KERN_NOTICE 5
> 
> Then you can change the printk guts to do something vaguely like (untested):
> #define printk(arg1, arg2, ...) actual_printk("<" #arg1 ">" arg2, __VA_ARGS__)
> 
> And so far no behavior has changed.  But now the _fun_ part is, you can add a 
> config symbol for "what is the minimum loglevel I care about?"  Set that as a 
> number from 0-9.  And then you can define the printk to do:
> 
> #define printk(level, str, ...) \
>   do { \
>     if (level < CONFIG_PRINTK_DOICARE) \
>       actual_printk("<" #level ">" str, __VA_ARGS__); \
>   } while(0);
> 
> And viola (however you spell that, I think I'm using the stringed instrument 
> but it's french and I'm not trying to type a diacritical mark anyway), the 
> compiler's dead code eliminator zaps the printks you don't care about so they 
> don't bloat the kernel image.  But this doesn't _completely_ eliminate 
> printks, so you can still get the panic() calls and such.  You tweak precisly 
> how much bloat you want, using the granularity information that's already 
> there in the source code...
> 
> Opinions?
> 
All the people who don't have the need will come up with reasons not to 
do it. Like "saves too little" and "makes debugging hard" (these are the 
people who don't realize that having no output device and human in the 
loop makes it hard, too). How about "too complex, would confuse users," 
that's popular.

I could go into a list of thing people want to take out or keep out for 
reasons which boil down to "I don't need it" or "leaving it out only 
bothers lazy users who don't want to convert to {flavor_of_the_month}."

People with really small systems care about every few bytes, people with 
big systems don't understand (in general) about people with small 
systems. The best developers do, fortunately, and will probably approve 
of kernel liposuction.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
