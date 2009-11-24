Return-Path: <linux-kernel-owner+w=401wt.eu-S933649AbZKXRBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933649AbZKXRBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 12:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933331AbZKXRBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 12:01:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932505AbZKXRBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 12:01:47 -0500
Message-ID: <4B0C1141.3070807@redhat.com>
Date: Tue, 24 Nov 2009 12:00:49 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH -tip v5 07/10] kprobes/x86: Support kprobes jump optimization
 on x86
References: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com> <20091123232211.22071.58974.stgit@dhcp-100-2-132.bos.redhat.com> <4B0C0B50.6000907@zytor.com>
In-Reply-To: <4B0C0B50.6000907@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

H. Peter Anvin wrote:
> On 11/23/2009 03:22 PM, Masami Hiramatsu wrote:
>>
>> This uses stop_machine() for corss modifying code from int3 to jump.
>> It doesn't allow us to modify code on NMI/SMI path. However, since
>> kprobes itself doesn't support NMI/SMI code probing, it's not a
>> problem.
>>
>
> I'm a bit confused by the above statement... does that mean you're
> poking int3 and *then* do stop_machine()?

Yes, as I said in http://lkml.org/lkml/2009/11/24/310,
there are two separated issues.

----
We have to separate below issues:
  - int3-based multi-bytes code replacement
  - multi-instruction replacement with int3-detour code

The former is implemented on patch 9/10 and 10/10. As you can see,
these patches are RFC status, because I'd like to wait for official
reply of safeness from processor architects.
And it may be able to use a dummy IPI for 2nd IPI because it
just for waiting int3 interrupts. But again, it is just estimated that
replacing with/recovering from int3 is automatically synchronized...

However, at least stop_machine() method is officially described
at "7.1.3 Handling Self- and Cross-Modifying Code" on the intel's
software developer's manual 3A . So currently we can use it.

For the latter issue, as I explained on previous reply, we need
to wait all running interrupts including hardware interrupts.
Thus I used synchronize_sched().
----

So that the previous "x86 generic jump patching" patch is
basically for single-instruction replacement. For multi-instructions
replacement, we need to make detour code and wait for all running
interruption. (of course, there are other static code limitations,
as I described at "Safety check" section in patch 0/10.)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

