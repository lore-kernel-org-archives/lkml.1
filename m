Return-Path: <linux-kernel-owner+w=401wt.eu-S1753496AbZJYPzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbZJYPzj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 11:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbZJYPzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 11:55:38 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:27925 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbZJYPzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 11:55:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:mail-followup-to:cc:subject:references:from:date:in-reply-to
         :message-id:user-agent:mime-version:content-type;
        b=BO8pF0lxauexkC0RaDocu4em969cfEOq4UVtL+EgxWwr52ZWRE2BoRZO/mzdz2R2dG
         E9RanD/Yz25wOoCMFVVqIkQOpInUrGhEm2dRnFtneWKxuQ6llgmx/aJsyKiM+AQ+hjlj
         HyQdjiGPnnxEBlukNqE1Q3NyKRTEZPh+cOoEY=
To: wuzhangjin@gmail.com
Mail-Followup-To: wuzhangjin@gmail.com,pajko <kpajko79@gmail.com>,  linux-kernel@vger.kernel.org, GCC Patches <gcc-patches@gcc.gnu.org>, Adam Nemet <anemet@caviumnetworks.com>,  rostedt@goodmis.org, linux-mips@linux-mips.org,  Thomas Gleixner <tglx@linutronix.de>, Ralf Baechle <ralf@linux-mips.org>, Nicholas Mc Guire <der.herr@hofr.at>, David Daney <ddaney@caviumnetworks.com>, rdsandiford@googlemail.com
Cc: pajko <kpajko79@gmail.com>, linux-kernel@vger.kernel.org,
       GCC Patches <gcc-patches@gcc.gnu.org>,
       Adam Nemet <anemet@caviumnetworks.com>, rostedt@goodmis.org,
       linux-mips@linux-mips.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH -v4 9/9] tracing: add function graph tracer support for MIPS
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>
	<2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>
	<3f0d3515f74a58f4cfd11e61b62a129fdc21e3a7.1256135456.git.wuzhangjin@gmail.com>
	<96110ea5dd4d3d54eb97d0bb708a5bd81c7a50b5.1256135456.git.wuzhangjin@gmail.com>
	<af3ec1b5cd06b6f6a461c9fa7d09a51fabccb08d.1256135456.git.wuzhangjin@gmail.com>
	<a6f2959a69b6a77dd32cc36a5c8202f97d524f1e.1256135456.git.wuzhangjin@gmail.com>
	<53bdfdd95ec4fa00d4cc505bb5972cf21243a14d.1256135456.git.wuzhangjin@gmail.com>
	<26008418.post@talk.nabble.com> <1256467717.6143.13.camel@falcon>
From: Richard Sandiford <rdsandiford@googlemail.com>
Date: Sun, 25 Oct 2009 15:55:34 +0000
In-Reply-To: <1256467717.6143.13.camel@falcon> (Wu Zhangjin's message of "Sun\, 25 Oct 2009 18\:48\:37 +0800")
Message-ID: <87hbtn1n9l.fsf@firetop.home>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Zhangjin <wuzhangjin@gmail.com> writes:
> (Added linux-mips mailing list and the other people to the CC list.)
>
> On Thu, 2009-10-22 at 04:37 -0700, pajko wrote:
> [...]
>> > 
>> 
>> All this stuff can be avoided having PROFILE_BEFORE_PROLOGUE enabled in GCC
>> (gcc/config/mips/mips.h), like it is done one several other architectures.
>> Some of them even require it to be set for a working _mcount. 
>> Putting the call of _mcount before the function prologue should make no harm
>> (it's working for me), and this way RA can be hooked for function graph
>> tracing
>> before it is saved to stack in the function prologue. Thus there will be no
>> difference between leaf and non-leaf functions.
>
> Good idea! Seems PROFILE_BEFORE_PROLOGUE is commented by default in
> gcc/config/mips/mips.h of gcc 4.4:
>
> /* #define PROFILE_BEFORE_PROLOGUE */
>
> if we enable this macro, the handling will be the same to non-leaf and
> leaf function, so, David's patch to gcc is not need again.

Defining PROFILE_BEFORE_PROLOGUE isn't correct for abicalls code,
because "jal _mcount" is a macro that loads _mcount from the
GOT into $25.  We don't have access to $28 at the beginning of
the function, and we mustn't clobber the incoming value of $25.
So we could only make this change for non-abicalls code.

It's then a choice between (a) having new non-abicalls-specific
behaviour or (b) going with David's patch.  The advantage of
(a) is that the linux code is slightly simpler.  The disadvantage
is that it makes the _mcount interface differ between -mabicalls
and -mno-abicalls.  And IMO the disadvantage outweights the advantage.
If this new behaviour is useful for linux, it could easily be useful
for userspace too.  And with the new PLT support, non-shared abicalls
code is supposed to be link-compatible with non-abicalls code.

I think David's patch is the way to go.

Richard
