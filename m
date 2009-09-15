Return-Path: <linux-kernel-owner+w=401wt.eu-S1756984AbZIOIOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984AbZIOIOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 04:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbZIOIOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 04:14:03 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:63568 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbZIOIOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 04:14:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=goOMf611NI1Wx+xdZpqu7l/VAogU68b43EjsLHEboqlMwFY/4Vk3zRu3FtH1+XS3o7
         fbMjze7AeYEVTPUBc5vmi8GLBoij2XaYXPXgOWPcuMG+5dhdjG79Kxp6H+aoHn/RVKCz
         /n6WiaHZpELv9o0KgjSXXEiwdSHgEoMHotbpY=
Date: Tue, 15 Sep 2009 08:13:55 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Stephan von Krawczynski <skraw@ithnet.com>,
       Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: ipv4 regression in 2.6.31 ?
Message-ID: <20090915081354.GA10037@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914093128.4d709ff6@nehalam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-09-2009 18:31, Stephen Hemminger wrote:
> On Mon, 14 Sep 2009 17:55:05 +0200
> Stephan von Krawczynski <skraw@ithnet.com> wrote:
> 
>> On Mon, 14 Sep 2009 15:57:03 +0200
>> Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>>> Stephan von Krawczynski a A~(c)crit :
>>>> Hello all,
...
>>> rp_filter - INTEGER
>>>         0 - No source validation.
>>>         1 - Strict mode as defined in RFC3704 Strict Reverse Path
>>>             Each incoming packet is tested against the FIB and if the interface
>>>             is not the best reverse path the packet check will fail.
>>>             By default failed packets are discarded.
>>>         2 - Loose mode as defined in RFC3704 Loose Reverse Path
>>>             Each incoming packet's source address is also tested against the FIB
>>>             and if the source address is not reachable via any interface
>>>             the packet check will fail.
...
> RP filter did not work correctly in 2.6.30. The code added to to the loose
> mode caused a bug; the rp_filter value was being computed as:
>   rp_filter = interface_value & all_value;
> So in order to get reverse path filter both would have to be set.
> 
> In 2.6.31 this was change to:
>    rp_filter = max(interface_value, all_value);
> 
> This was the intended behaviour, if user asks all interfaces to have rp
> filtering turned on, then set /proc/sys/net/ipv4/conf/all/rp_filter = 1
> or to turn on just one interface, set it for just that interface.

Alas this max() formula handles also cases where both values are set
and it doesn't look very natural/"user friendly" to me. Especially
with something like this: all_value = 2; interface_value = 1
Why would anybody care to bother with interface_value in such a case?

"All" suggests "default" in this context, so I'd rather expect
something like:
    rp_filter = interface_value ? : all_value;
which gives "the inteded behaviour" too, plus more...

We'd only need to add e.g.:
 0 - Default ("all") validation. (No source validation if "all" is 0).
 3 - No source validation on this interface.

Jarek P.
