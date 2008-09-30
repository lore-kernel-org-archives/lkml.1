Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbYI3QOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbYI3QOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 12:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbYI3QOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 12:14:24 -0400
Received: from relay1.sgi.com ([192.48.171.29]:33639 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753080AbYI3QOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 12:14:23 -0400
Message-ID: <48E2506C.7000406@sgi.com>
Date: Tue, 30 Sep 2008 09:14:36 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, David Miller <davem@davemloft.net>,
       Alan.Brunelle@hp.com, tglx@linutronix.de, rjw@sisk.pl,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, arjan@linux.intel.com,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -	bisected
References: <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org> <200809251150.26760.rusty@rustcorp.com.au> <alpine.LFD.1.10.0809250836270.3265@nehalem.linux-foundation.org> <200809261525.30258.rusty@rustcorp.com.au> <48DC78F2.8060400@sgi.com> <20080927191653.GB18619@elte.hu> <48E0E73A.40803@sgi.com> <20080930110459.GB12529@elte.hu>
In-Reply-To: <20080930110459.GB12529@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>>> could you please send whatever .c changes you have already, so that 
>>> we can have a look at how the end result will look like? Doesnt have 
>>> to build, i'm just curious about how it looks like in practice, 
>>> semantically.
>>
>> I will, and the full "allyesconfig" does compile.  And it's basically 
>> a benign change in that the functionality is still the same.  I'm 
>> currently reordering it a bit to clean it up.
> 
> btw., are the resulting instructions also expected to be the same? If 
> yes then you might want to verify it all by making sure the md5's of the 
> .o's do not change.
> 
> (If that's not possible (gcc decides to compile it a bit differently) 
> then no big deal, just wanted to mention the possibility.)
> 
> 	Ingo

Well, not exactly... ;-)  It does institute the new API change that specifies
only pointers to cpumask's can be passed to functions and returned from
functions.  I really wanted the default cpumask_t to be a constant so those
instances where the passed in cpumask is used as a read/write temp variable
would be caught.  But it started getting messy.

One pain is:

	typedef struct __cpumask_s *cpumask_t;
	const cpumask_t xxx;

is not the same as:

	typedef const struct __cpumask_s *const_cpumask_t;
	const_cpumask_t xxx;

and I'm not exactly sure why.  It came up when I tried to declare
functions that returned a constant cpumask_t pointer (node_to_cpumask,
cpumask_of_cpu, etc.)

The other major change I'm contemplating is to remove "cpumask_t" completely
(maybe cpumask_ptr_t?).  This would force every instance of cpumask_t to be
examined.  (I found quite a few I had missed in my original edits when I
added the task struct temp cpumask's.)

Oh yeah, one question ... is "current" always valid?

Thanks,
Mike

