Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbZALDzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbZALDzI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 22:55:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbZALDyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 22:54:54 -0500
Received: from mga10.intel.com ([192.55.52.92]:52867 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752151AbZALDyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 22:54:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,250,1231142400"; 
   d="scan'208";a="656277077"
Message-ID: <496ABF01.50001@linux.intel.com>
Date: Mon, 12 Jan 2009 03:54:41 +0000
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Grissiom <chaos.proton@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] async: Don't call async_synchronize_full_special()	while
 holding sb_lock
References: <a0adeea50901080007q5a3ed5c8y5a744ce37e677325@mail.gmail.com> <1231425472.21528.13.camel@norville.austin.ibm.com> <20090108072111.1ebadebd@infradead.org> <1231429591.27353.14.camel@norville.austin.ibm.com> <20090108225050.GL9448@disturbed> <49668388.708@linux.intel.com> <20090109014054.GN9448@disturbed> <4966D652.4070105@linux.intel.com> <20090112023138.GD6428@shareable.org>
In-Reply-To: <20090112023138.GD6428@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> Arjan van de Ven wrote:
>>> 	- removing a million files and queuing all of the
>>> 	  deletes in the async queues....
>> the async code throttles at 32k outstanding.
>> Yes 32K is arbitrary, but if you delete  a million files fast, all but the 
>> first few thousand are
>> synchronous.
> 
> Hmm.
> 
> If I call unlink() a thousand times and then call fsync() on the
> parent directories covering files I've unlinked... I expect the
> deletes to be committed to disk when the last fsync() has returned.  I
> require that a crash and restart will not see the files.  Several
> kinds of transactional software and even some shell scripts expect this.
> 
> Will these asynchronous deletes break the guaranteed
> commit-of-the-delete provided by fsync() on the parent directory?

3 things:
1) removing the name from the directory and removing the data from disk are independent things.
The former happens from unlink(), the later happens when the refcount hits 0 (eg no more openers nor
any directory on disk referencing it). fsync() on a parent dir obviously only covers the first part,
while only the 2nd part was made asynchronous.
2) with the right synchronization point in fsync, it will still work out
3) this code will be redone for 2.6.30; for 2.6.29 it is removed.

