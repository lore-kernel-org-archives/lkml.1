Return-Path: <linux-kernel-owner+w=401wt.eu-S935039AbZJOIxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935039AbZJOIxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935007AbZJOIxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:53:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:33920 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934994AbZJOIxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:53:04 -0400
Message-ID: <4AD6E29B.8000506@kernel.org>
Date: Thu, 15 Oct 2009 17:51:39 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: "Luck, Tony" <tony.luck@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       "mingo@redhat.com" <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "rostedt@goodmis.org" <rostedt@goodmis.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "cebbert@redhat.com" <cebbert@redhat.com>
Subject: Re: [PATCH 13/16] percpu: remove per_cpu__ prefix.
References: <1255500125-3210-1-git-send-email-tj@kernel.org> <1255500125-3210-14-git-send-email-tj@kernel.org> <alpine.DEB.1.10.0910141026370.26476@gentwo.org> <57C9024A16AD2D4C97DC78E552063EA3E32264A8@orsmsx505.amr.corp.intel.com> <alpine.DEB.1.10.0910141420300.9708@gentwo.org> <57C9024A16AD2D4C97DC78E552063EA3E3226704@orsmsx505.amr.corp.intel.com> <alpine.DEB.1.10.0910141445110.30078@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0910141445110.30078@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 08:51:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph, Tony.

Christoph Lameter wrote:
> On Wed, 14 Oct 2009, Luck, Tony wrote:
> 
>>> we would still have to use per cpu operations to get to the contents of
>>> these variables.
>> That's good.
>>
>>> Hope that addresses your concerns.
>> But then I don't understand the original patch that was going to do:
>>
>>> -#define __ia64_per_cpu_var(var)	per_cpu__##var
>>> +#define __ia64_per_cpu_var(var)	var
>> Presumably all actual use of __ia64_per_cpu_var is being replaced
>> by some other "per cpu operations"?

Yeah, I wasn't so sure what to do about these, so just left them as
no-op for the moment.

> Hmmm... Right. IA64 is a special case because the access of the per cpu
> variable at a specific address causes per cpu TLBs to do the relocation.
> 
> Other platforms have to add a per cpu specific offset to a variable to get
> the right per cpu variable.
> 
> As a result IA64 strictly does not need this_cpu_read() and
> this_cpu_write(). However, not using the operations is going to cause
> the sparse annotation by Tejun to trigger errors. this_cpu_read() is
> likely a noop for IA64 that just changes the annotations so that sparse
> warnings do not trigger. Tejun?

__ia64_per_cpu_var() is slightly different from this_cpu_read() in
that the former only works for percpu variables which fall on the
first percpu page - ie. static percpu vars in the kernel image.  So,
__ia64_per_cpu_var() is a bit more efficient than this_cpu_read() as
it doesn't have to compute the address.

So, what we can do is to leave the macro alone for now and then add
sparse annotation to it later in the patch as it's basically another
specialized accessor.  How does that sound?

Thanks.

-- 
tejun
