Return-Path: <linux-kernel-owner+w=401wt.eu-S1757649AbXH3HhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649AbXH3HhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 03:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbXH3HhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 03:37:04 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40104 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbXH3HhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 03:37:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Konstantin Baydarov <kbaidarov@ru.mvista.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       <vgoyal@in.ibm.com>, "RT" <linux-rt-users@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <ak@suse.de>,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH] kexec: reenable HPET before kexec
References: <20070820205530.1ffd5876@windmill.dev.rtsoft.ru>
	<20070823090845.GA13065@in.ibm.com>
	<20070823154936.3b7ae498@windmill.dev.rtsoft.ru>
	<20070827053656.GC9809@in.ibm.com>
	<653FFBB4508B9042B5D43DC9E18836F501522051@scsmsx415.amr.corp.intel.com>
	<20070828165832.5047d4de@windmill.dev.rtsoft.ru>
Date: Thu, 30 Aug 2007 01:32:30 -0600
In-Reply-To: <20070828165832.5047d4de@windmill.dev.rtsoft.ru> (Konstantin
	Baydarov's message of "Tue, 28 Aug 2007 16:58:32 +0400")
Message-ID: <m1ps1532b5.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Baydarov <kbaidarov@ru.mvista.com> writes:

> On Mon, 27 Aug 2007 11:26:29 -0700
> "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> wrote:
>
>> 
>> 
>> - Another thing to try is to disable HPET and boot with PIT in the
>> first kernel. Just to check whether PIT never works on this platform
>> or the first kernel is doing something to stop PIT. You can try
>> "hpet=disable" boot option for that.
>> 
>> Thanks,
>> Venki
>
> I've tried kernel 1 with HPET disabled - it boots fine, PIT works!
> Then I made additional investigations and found out that PIT won't work
> in kernel 2 if bit HPET_CFG_LEGACY is set.
> Bit HPET_CFG_LEGACY is set by hpet_enable_int() during HPET
> initialization, so if this bit is cleared in machine_kexec() kernel 2
> boots fine.
> I can't explain this magic, maybe someone can explain this. Thanks.
>
> Here is new version of workaround for 2.6.23-rc3

Ok.  It looks like you understand this issue.

Can you please try calling hpet_disable_int from
hpet_set_mode under CLOCK_EVT_MODE_SHUTDOWN.  I haven't
traced the clock event methods all of the way through
but as a first approximation I think that will get
things called at the appropriate time with out needing
to patch machine_kexec.  Which is very much the wrong
place to add call any hpet code from.

We may also need to make the hpet initialization more
robust so we can do something sane in the kexec on panic
case, where we deliberately don't run any shutdown methods.

Eric
