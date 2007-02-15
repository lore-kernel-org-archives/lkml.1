Return-Path: <linux-kernel-owner+w=401wt.eu-S964878AbXBOCxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964878AbXBOCxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 21:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964876AbXBOCxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 21:53:39 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:27887 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964878AbXBOCxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 21:53:39 -0500
In-Reply-To: <20070214213505.GA24812@elte.hu>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org> <20070214210251.GA15025@elte.hu> <Pine.LNX.4.64.0702141321200.20368@woody.linux-foundation.org> <20070214213505.GA24812@elte.hu>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <94CAAAF3-5EF0-4F76-BD8C-25A2B9EE0030@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [patch 05/11] syslets: core code
Date: Wed, 14 Feb 2007 18:52:46 -0800
To: Ingo Molnar <mingo@elte.hu>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> But the whole point is that the notion of a "register" is wrong in  
>> the
>> first place. [...]
>
> forget about it then. The thing we "register" is dead-simple:
>
>  struct async_head_user {
>          struct syslet_uatom __user              **completion_ring;
>          unsigned long                           ring_size_bytes;
>          unsigned long                           max_nr_threads;
>  };
>
> this can be passed in to sys_async_exec() as a second pointer, and the
> kernel can put the expected-completion pointer (and the user ring idx
> pointer) into its struct atom. It's just a few instructions, and  
> only in
> the cachemiss case.
>
> that would make completions arbitrarily split-up-able. No registration
> whatsoever. A waiter could specify which ring's events it is  
> interested
> in. A 'ring' could be a single-entry thing as well, for a single
> instance of pending IO.

I like this, too.  (Not surprisingly, having outlined something like  
it in a mail in one of the previous threads :)).

I'll bring up the POSIX AIO "list" IO case.  It wants to issue a  
group of IOs and sleep until they all return.  Being able to cheaply  
instantiate a ring implicitly with the submission of the IO calls in  
the list will make implementing this almost too easy.  It'd obviously  
just wait for that list's ring to drain.

I hope.  There might be complications around the edges (waiting for  
multiple list IOs to drain?), but it seems like this would be on the  
right track.

I might be alone in caring about having a less ridiculous POSIX AIO  
interface in glibc, though, I'll admit.  It seems like it'd be a  
pretty sad missed opportunity if we rolled a fantastic general AIO  
interface and left glibc to still screw around with it's own manual  
threading :/.

- z
