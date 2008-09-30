Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbYI3SC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbYI3SC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 14:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbYI3SCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 14:02:19 -0400
Received: from relay2.sgi.com ([192.48.171.30]:52484 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752359AbYI3SCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 14:02:18 -0400
Message-ID: <48E269B6.1080904@sgi.com>
Date: Tue, 30 Sep 2008 11:02:30 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Yinghai Lu <yhlu.kernel@gmail.com>, David Miller <davem@davemloft.net>,
       Alan.Brunelle@hp.com, tglx@linutronix.de, rjw@sisk.pl,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, arjan@linux.intel.com,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org> <200809251150.26760.rusty@rustcorp.com.au> <alpine.LFD.1.10.0809250836270.3265@nehalem.linux-foundation.org> <200809261525.30258.rusty@rustcorp.com.au> <48DC78F2.8060400@sgi.com> <20080927191653.GB18619@elte.hu> <48E0E73A.40803@sgi.com> <20080930110459.GB12529@elte.hu> <48E2506C.7000406@sgi.com> <alpine.LFD.2.00.0809300939450.3389@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0809300939450.3389@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 30 Sep 2008, Mike Travis wrote:
>> One pain is:
>>
>> 	typedef struct __cpumask_s *cpumask_t;
>> 	const cpumask_t xxx;
>>
>> is not the same as:
>>
>> 	typedef const struct __cpumask_s *const_cpumask_t;
>> 	const_cpumask_t xxx;
>>
>> and I'm not exactly sure why.
> 
> Umm. The const has different 
> 
> One is
> 
> 	typedef const struct __cpumask_s *const_cpumask_t;
> 
> which becomes
> 
> 	(const struct __cpumask_s) *
> 
> while the other is
> 
> 	const cpumask_t xxx
> 
> which is
> 
> 	const (struct __cpumask_s *)
> 
> and if you look a bit more closely, you'll see that they are _obviously_ 
> not the same thing at all.

Thanks, yes that explains what I should have figured out.  (Nice way to
explain it btw... ;-)

> 
> Quite frankly, I personally do hate typedefs that end up being pointers, 
> and used as pointers, without showing that in the source code.
> 
> When you do
> 
> 	type_t a;
> 
> 	fn(a);
> 
> I expect the code to essentially do a pass-by-value. But when the type_t 
> is a pointer, that doesn't really work.

I agree, and as I mentioned, Rusty was working towards an alternative
method of declaring cpumask's which does not hide this.

My goal was to create an (apparent) opaque handle for cpumask_t and modify
the code so all changes to the contents of the cpumask are via functions.

> 
> Your issue with 'const' is just another version of the same. You don't 
> want the _pointer_ to be const, you want what it points _to_ to be const. 
> But because you hid the pointerness inside the typedef, you simply cannot 
> do that.
> 
> The problem with cpumask's, of course, is that for the "small mask" case, 
> we really don't want it to be a pointer. So now it's sometimes a pointer 
> and sometimes not. The typedef hides that, and I understand why it's a 
> good idea, but I'm surprised you didn't understand what the implications 
> were for 'const', and I'm now a bit more leery about this whole thing just 
> because the typedef ends up hiding so much - it doesn't just hide the 
> basic type, it hides a very basic *code* issue.

Perhaps then defining the cpumask as a list of unsigned longs (remove the
outer struct) would play more "naturally".  Lists by definition are always
referenced by pointers.  I have another version of the patchset that shows
this and I'll post just the cpumask.h and doc files.

> 
> 			Linus

Thanks!
Mike
