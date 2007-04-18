Return-Path: <linux-kernel-owner+w=401wt.eu-S1161460AbXDRI7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161460AbXDRI7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 04:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161468AbXDRI7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 04:59:07 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:25337 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161460AbXDRI7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 04:59:04 -0400
Message-ID: <4625DEFC.7040701@sw.ru>
Date: Wed, 18 Apr 2007 13:03:56 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
CC: David Miller <davem@davemloft.net>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Patrick McHardy <kaber@trash.net>,
       Kirill Korotaev <dev@openvz.org>
Subject: Re: [NETLINK] Don't attach callback to a going-away netlink socket
References: <4625D3D2.9030507@sw.ru> <20070418081707.GA29267@2ka.mipt.ru> <4625D7A8.5030209@sw.ru> <20070418084416.GB4241@2ka.mipt.ru>
In-Reply-To: <20070418084416.GB4241@2ka.mipt.ru>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> On Wed, Apr 18, 2007 at 12:32:40PM +0400, Pavel Emelianov (xemul@sw.ru) wrote:
>> Evgeniy Polyakov wrote:
>>> On Wed, Apr 18, 2007 at 12:16:18PM +0400, Pavel Emelianov (xemul@sw.ru) wrote:
>>>> Sorry, I forgot to put netdev and David in Cc when I first sent it.
>>>>
>>>> There is a race between netlink_dump_start() and netlink_release()
>>>> that can lead to the situation when a netlink socket with non-zero
>>>> callback is freed.
>>> Out of curiosity, why not to fix a netlink_dump_start() to remove
>>> callback in error path, since in 'no-error' path it removes it in
>> Error path is not relevant here. The problem is that we
>> keep a calback on a socket that is about to be freed.
> 
> Yes, you are right, that it will not be freed in netlink_release(), 
> but it will be freed in netlink_dump() after it is processed (in no-error 
> path only though).
> 

But error path will leak it. On success path we would have
a leaked packet in sk_write_queue, since we did't see it in
skb_queue_purge() while doing netlink_release().

Of course we can place the struts in code to handle the case
when we have a released socket with the attached callback, but
it is more correct (IMHO) not to allow to attach the callbacks
to dead sockets.
