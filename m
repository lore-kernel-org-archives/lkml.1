Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbZKPRIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbZKPRIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 12:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbZKPRIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 12:08:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790AbZKPRIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 12:08:36 -0500
Message-ID: <4B018703.3080507@redhat.com>
Date: Mon, 16 Nov 2009 19:08:19 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: gregory.haskins@gmail.com, herbert@gondor.apana.org.au,
       ghaskins@novell.com, mst@redhat.com,
       alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC PATCH] net: add dataref destructor to sk_buff
References: <4AF98A8C.9040201@novell.com>	<20091114011229.GA18580@gondor.apana.org.au>	<4AFE08EF.2030308@gmail.com> <20091113.190438.78469912.davem@davemloft.net>
In-Reply-To: <20091113.190438.78469912.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2009 05:04 AM, David Miller wrote:
> From: Gregory Haskins<gregory.haskins@gmail.com>
> Date: Fri, 13 Nov 2009 20:33:35 -0500
>
>    
>> Well, not with respect to the overall protocol, of course not.  But with
>> respect to the buffer in question, it _has_ to be.  Or am I missing
>> something?
>>      
> sendfile() absolutely, and positively, is not.
>
> Any entity can write to the pages being send via sendfile(), at will,
> and those writes will show up in the packet stream if they occur
> before the NIC DMA's the memory backed by those pages into it's
> buffer.
>
> There is zero data synchronization whatsoever, we don't lock the
> pages, we don't block their usage while they are queued up in the
> socket send queue, nothing like that.
>
>    

But it must maintain a reference count on the page being dmaed and drop 
it only after dma is complete.  Otherwise we risk the page being 
recycled and arbitrary memory sent out on the wire; and an application 
can trivially cause this by truncate()ing a sendfile.

> The user returns long before it every hits the wire and there is zero
> "notification" to the user that the pages in question for the
> sendfile() request are no longer in use.
>    

The put_page() is a notification except it doesn't reach the caller.  
Gregory's patch (and previous shared info destructor patches) is an 
attempt to make it reach the caller, IIUC.

-- 
error compiling committee.c: too many arguments to function

