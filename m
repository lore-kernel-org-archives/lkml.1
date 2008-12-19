Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbYLSWVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbYLSWVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbYLSWVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:21:24 -0500
Received: from gw.goop.org ([64.81.55.164]:36826 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbYLSWVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:21:23 -0500
Message-ID: <494C1E5E.7070809@goop.org>
Date: Fri, 19 Dec 2008 14:21:18 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Bart Van Assche <bart.vanassche@gmail.com>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>, netdev@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH][RFC 23/23]: Support for zero-copy TCP transmit of user
 space data
References: <494009D7.4020602@vlnb.net> <494012C4.7090304@vlnb.net> <494C0255.8010208@goop.org> <20081219220452.GB704@ioremap.net>
In-Reply-To: <20081219220452.GB704@ioremap.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> On Fri, Dec 19, 2008 at 12:21:41PM -0800, Jeremy Fitzhardinge (jeremy@goop.org) wrote:
>   
>> I think Rusty has a patch to put some kind of put notifier in struct 
>> skb_shared_info, but I'm not sure of the details.
>>     
>
> Yes, he added destructor callback into shared info.
>
> There maybe a problem though, if iscsi will run over xen network, but in
> this case xen may copy the data, or iscsi may do that after determining
> that underlying network device does not allow shared info destructor
> (vis device/route flag for example).
>   

Xen only needs the callback in the case of traffic originating in 
another Xen domain.  If iscsi is involved, it will be running in the 
other domain, and so all its callbacks and so on will happen there.  
There's no conflict.

>> Wouldn't you only need to do the lookup on the last put?
>>
>> An external lookup table might well for for us, if the net_put_page() 
>> change is acceptable to the network folk.
>>     
>
> That sounds like the best solution for this problem.
>   

An external lookup would just need to change put_page -> net_put_page, I 
think.

> David, will you accept shared info destructor?
>   

I'm not very familiar with the network stack, but am I right in assuming 
that the shared_info destructor would be called when the network stack 
has finished with all the pages it refers to?  And those pages could be 
the combination of pages separately submitted in different skbs?

    J
