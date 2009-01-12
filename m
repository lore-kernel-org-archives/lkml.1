Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbZALHzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbZALHzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 02:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZALHz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 02:55:27 -0500
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:47278 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751376AbZALHz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 02:55:26 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAEOEakl5LDnl/2dsb2JhbADSLoVv
X-IronPort-AV: E=Sophos;i="4.37,252,1231075800"; 
   d="scan'208";a="291823432"
Date: Mon, 12 Jan 2009 18:55:16 +1100
From: Dave Chinner <david@fromorbit.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jamie Lokier <jamie@shareable.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Grissiom <chaos.proton@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] async: Don't call async_synchronize_full_special()
	while holding sb_lock
Message-ID: <20090112075516.GK8071@disturbed>
Mail-Followup-To: Arjan van de Ven <arjan@linux.intel.com>,
	Jamie Lokier <jamie@shareable.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Grissiom <chaos.proton@gmail.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <a0adeea50901080007q5a3ed5c8y5a744ce37e677325@mail.gmail.com> <1231425472.21528.13.camel@norville.austin.ibm.com> <20090108072111.1ebadebd@infradead.org> <1231429591.27353.14.camel@norville.austin.ibm.com> <20090108225050.GL9448@disturbed> <49668388.708@linux.intel.com> <20090109014054.GN9448@disturbed> <4966D652.4070105@linux.intel.com> <20090112023138.GD6428@shareable.org> <496ABF01.50001@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496ABF01.50001@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 03:54:41AM +0000, Arjan van de Ven wrote:
> Jamie Lokier wrote:
>> Arjan van de Ven wrote:
>>>> 	- removing a million files and queuing all of the
>>>> 	  deletes in the async queues....
>>> the async code throttles at 32k outstanding.
>>> Yes 32K is arbitrary, but if you delete  a million files fast, all 
>>> but the first few thousand are
>>> synchronous.
>>
>> Hmm.
>>
>> If I call unlink() a thousand times and then call fsync() on the
>> parent directories covering files I've unlinked... I expect the
>> deletes to be committed to disk when the last fsync() has returned.  I
>> require that a crash and restart will not see the files.  Several
>> kinds of transactional software and even some shell scripts expect this.
>>
>> Will these asynchronous deletes break the guaranteed
>> commit-of-the-delete provided by fsync() on the parent directory?
>
> 3 things:
> 1) removing the name from the directory and removing the data from disk are independent things.
> The former happens from unlink(), the later happens when the refcount hits 0 (eg no more openers nor
> any directory on disk referencing it). fsync() on a parent dir obviously only covers the first part,
> while only the 2nd part was made asynchronous.
> 2) with the right synchronization point in fsync, it will still work out

What scope does that synchronisation point have? I sincerely
hope you are not proposing to put a filesystem global
synchronisation point into fsync....

> 3) this code will be redone for 2.6.30; for 2.6.29 it is removed.

Can you tell use how you plan to redo this code and test it
adequately for 2.6.30?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
