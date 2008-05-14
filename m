Return-Path: <linux-kernel-owner+w=401wt.eu-S1759156AbYENJAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759156AbYENJAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 05:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbYENJAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 05:00:04 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:32443
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbYENJAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 05:00:03 -0400
Message-ID: <482AAA0F.2020607@qumranet.com>
Date: Wed, 14 May 2008 11:59:59 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Mark McLoughlin <markmc@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio_net: free transmit skbs in a timer
References: <1209565906-9019-1-git-send-email-markmc@redhat.com> <1210624663.14409.20.camel@muff> <48294776.3010504@qumranet.com> <200805141607.26306.rusty@rustcorp.com.au>
In-Reply-To: <200805141607.26306.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
>> Sorry to barge in late, but IMO the timer should be on the host, which
>> is cheaper than on the guest (well, a 100ms timer is likely zero cost,
>> but  I still don't like it).
>>
>> the host should fire a tx completion interrupt whenever the completion
>> queue has "enough" entries, where we can define "enough" now as the
>> halfway mark or a timer expiry, whichever comes earlier.
>>
>> We can later improve "enough" to be "just enough so the timer never
>> triggers" and adjust it dynamically.  It probably doesn't matter for
>> Linux, but I don't want to punish guests that can do true async
>> networking and depend on timely completion notification.
>>     
>
> This implies that we should not be supressing notifications in the guest at 
> all (unless we're sure there are more packets to come, which currently we 
> never are: that needs new net infrastructure).
>   

We don't have to be sure, just reasonably confident.  If we see a stream 
of packets, we open the window, but set a timer in case we're wrong.  
The expectation is that the timer will only fire when tx rate drops (or 
tx stops completely).

> But that means we'd get a notification on every xmit at the moment.  
> Benchmarks anyone?
>   

Notification on every xmit will surely kill performance.  I'm trying to 
get batching to work but also good latency when the link is not saturated.

-- 
error compiling committee.c: too many arguments to function

