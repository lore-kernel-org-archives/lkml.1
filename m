Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbZGIA15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbZGIA15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 20:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbZGIA1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 20:27:48 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:39477 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799AbZGIA1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 20:27:47 -0400
Message-ID: <4A55397F.8050207@codemonkey.ws>
Date: Wed, 08 Jul 2009 19:27:43 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>, npiggin@suse.de,
       akpm@osdl.org, xen-devel@lists.xensource.com, tmem-devel@oss.oracle.com,
       kurt.hackel@oracle.com, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, dave.mccracken@oracle.com,
       linux-mm@kvack.org, chris.mason@oracle.com, sunil.mushran@oracle.com,
       Avi Kivity <avi@redhat.com>, Schwidefsky <schwidefsky@de.ibm.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, alan@lxorguk.ukuu.org.uk,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] Re: [RFC PATCH 0/4] (Take 2): transcendent memory
 ("tmem") for Linux
References: <ac5dec0d-e593-4a82-8c9d-8aa374e8c6ed@default> <4A553272.5050909@codemonkey.ws> <4A553707.5060107@goop.org>
In-Reply-To: <4A553707.5060107@goop.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> On 07/08/09 16:57, Anthony Liguori wrote:
>   
>> Why does tmem require a special store?
>>
>> A VMM can trap write operations pages can be stored on disk
>> transparently by the VMM if necessary.  I guess that's the bit I'm
>> missing.
>>     
>
> tmem doesn't store anything to disk.  It's more about making sure that
> free host memory can be quickly and efficiently be handed out to guests
> as they need it; to increase "memory liquidity" as it were.  Guests need
> to explicitly ask to use tmem, rather than having the host/hypervisor
> try to intuit what to do based on access patterns and hints; typically
> they'll use tmem as the first line storage for memory which they were
> about to swap out anyway.

If the primary use of tmem is to avoid swapping when measure pressure 
would have forced it, how is this different using ballooning along with 
a shrinker callback?

With virtio-balloon, a guest can touch any of the memory it's ballooned 
to immediately reclaim that memory.  I think the main difference with 
tmem is that you can also mark a page as being volatile.  The hypervisor 
can then reclaim that page without swapping it (it can always reclaim 
memory and swap it) and generate a special fault to the guest if it 
attempts to access it.

You can fail to put with tmem, right?  You can also fail to get?  In 
both cases though, these failures can be handled because Linux is able 
to recreate the page on it's on (by doing disk IO).  So why not just 
generate a special fault instead of having to introduce special accessors?

Regards,

Anthony Liguori
