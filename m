Return-Path: <linux-kernel-owner+w=401wt.eu-S1764561AbXGaPKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764561AbXGaPKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 11:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762279AbXGaPJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 11:09:52 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:23811 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762720AbXGaPJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 11:09:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=uILgsSojk80VmunsZ+uAgoR2zqetL0wXBfvICteqKgvEFYqjgLHkpKjhWgsPi0otd530mFoa58CKSljz5yKczavBT9O40Hx7OwEt0nySdfkaQzx2FS+6qydJc8k6hEYyeSnrAKSaFHxPEmQBgP7HJk2rf0gwzaIW+aiF53++C0o=
Message-ID: <46AF4F9C.5060000@googlemail.com>
Date: Tue, 31 Jul 2007 17:05:00 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@o2.pl>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jason.wessel@windriver.com,
       amitkale@linsyssoft.com
Subject: Re: NETPOLL=y , NETDEVICES=n compile error ( Re: 2.6.23-rc1-mm1 )
References: <20070731083210.GA1797@ff.dom.local> <46AF0B8C.7070006@googlemail.com> <20070731121735.GA1046@ff.dom.local>
In-Reply-To: <20070731121735.GA1046@ff.dom.local>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote:
> On Tue, Jul 31, 2007 at 12:14:36PM +0200, Gabriel C wrote:
>> Jarek Poplawski wrote:
>>> On 28-07-2007 20:42, Gabriel C wrote:
>>>> Andrew Morton wrote:
>>>>> On Sat, 28 Jul 2007 17:44:45 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:
>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> I got this compile error with a randconfig ( http://194.231.229.228/MM/randconfig-auto-82.broken.netpoll.c ).
>>>>>>
>>>>>> ...
>>>>>>
>>>>>> net/core/netpoll.c: In function 'netpoll_poll':
>>>>>> net/core/netpoll.c:155: error: 'struct net_device' has no member named 'poll_controller'
>>>>>> net/core/netpoll.c:159: error: 'struct net_device' has no member named 'poll_controller'
>>>>>> net/core/netpoll.c: In function 'netpoll_setup':
>>>>>> net/core/netpoll.c:670: error: 'struct net_device' has no member named 'poll_controller'
>>>>>> make[2]: *** [net/core/netpoll.o] Error 1
>>>>>> make[1]: *** [net/core] Error 2
>>>>>> make: *** [net] Error 2
>>>>>> make: *** Waiting for unfinished jobs....
>>>>>>
>>>>>> ...
>>>>>>
>>>>>>
>>>>>> I think is because KGDBOE selects just NETPOLL.
>>>>>>
>>>>> Looks like it.
>>>>>
>>>>> Select went and selected NETPOLL and NETPOLL_TRAP but things like
>>>>> CONFIG_NETDEVICES and CONFIG_NET_POLL_CONTROLLER remain unset.  `select'
>>>>> remains evil.
>>> ...
>>>> I think there may be a logical issue ( again if I got it right ).
>>>> We need some ethernet card to work with kgdboe right ? but we don't have any if !NETDEVICES && !NET_ETHERNET.
>>>>
>>>> So maybe some ' depends on ... && NETDEVICES!=n && NET_ETHERNET!=n ' is needed too ? 
>>> IMHO, the only logical issue here is netpoll.c mustn't use 
>>> CONFIG_NET_POLL_CONTROLLER code without #ifdef if it doesn't
>>> add this dependency itself.
>>>
>> Well it does if NETDEVICES && if NET_ETHERNET which booth are N when !NETDEVICES is why KGDBOE uses select and not depends on.
> 
> "does if XXX" means may "use if XXX".

>From what I know means only use "if xxx" on !xxx everything inside the "if xxx" is n and "depends on <something inside the if xxx> 
does not work.

...

menuconfig FOO
	bool "FOO"
	depends on BAR
	default y 
	-- help --
	something
if FOO

config BAZ
	depends on WHATEVR && !NOT_THIS

menuconfig SOMETHING_ELSE
	....
if SOMETHING_ELSE

config BLUBB
	depends on PCI && WHATNOT

endif # SOMETHING_ELSE

config NETPOLL
        def_bool NETCONSOLE
        
config NETPOLL_TRAP
        bool "Netpoll traffic trapping"
        default n
        depends on NETPOLL
          
config NET_POLL_CONTROLLER
        def_bool NETPOLL

endif # FOO

Now if you set FOO=n all is gone and your driver have to select whatever it needs from there.

> 
>> Now KGDBOE just selects NETPOLL and NETPOLL_TRAP.
>> Adding 'select CONFIG_NET_POLL_CONTROLLER' let kgdboe compiles but the question is does it work without any ethernet card ?
> 
> Why kgdboe should care what netpoll needs? So, I hope, you are adding
> this select under config NETPOLL. On the other hand, if NETPOLL should
> depend on NET_POLL_CONTROLLER there is probably no reason to have them
> both.

NET_POLL_CONTROLLER has def_bool NETPOLL if NETDEVICES .

Net peoples ping ?:)

> 
> The "does it work" question isn't logical issue, so it's irrelevant
> here...

Right irrelevant for the compile error but relevant for the fix in my opinion.

> 
> Jarek P.
> 

Gabriel
