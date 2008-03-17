Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbYCQWRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbYCQWRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 18:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYCQWRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 18:17:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbYCQWRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 18:17:34 -0400
Message-ID: <47DEEDF1.6050403@redhat.com>
Date: Mon, 17 Mar 2008 18:17:21 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: ananth@in.ibm.com
CC: Yakov Lerner <iler.ml@gmail.com>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Subject: kprobes-x86: correct post-eip value in	post_hander()
References: <E1Jao7N-0005OC-Fe@io.site5.com> <20080317051956.GB7229@in.ibm.com> <f36b08ee0803170359w675130bas296b5276da5f2a3d@mail.gmail.com> <20080317123951.GC7229@in.ibm.com>
In-Reply-To: <20080317123951.GC7229@in.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ananth N Mavinakayanahalli wrote:
> On Mon, Mar 17, 2008 at 12:59:05PM +0200, Yakov Lerner wrote:
>> On Mon, Mar 17, 2008 at 7:19 AM, Ananth N Mavinakayanahalli
>> <ananth@in.ibm.com> wrote:
>>> On Sun, Mar 16, 2008 at 03:21:21AM -0500, Yakov Lerner wrote:
>>>  >
>>>  > I was trying to get the address of instruction to be executed
>>>  > next after the kprobed instruction.  But regs->eip in post_handler()
>>>  > contains value which is useless to the user. It's pre-corrected value.
>>>  > This value is difficult to use without access to resume_execution(), which
>>>  > is not exported anyway.
>>>  > I moved the invocation of post_handler() to *after* resume_execution().
>>>  > Now regs->eip contains meaningful value in post_handler().
>>>  >
>>>  > I do not think this change breaks any backward-compatibility.
>>>  > To make meaning of the old value, post_handler() would need access to
>>>  > resume_execution() which is not exported.  I have difficulty to believe
>>>  > that previous, uncorrected, regs->eip can be meaningfully used in
>>>  > post_handler().
>>>
>>>  resume_execution() exists not just for the program counter fixups after
>>>  out-of-line singlestepping, but is also as an insurance to put the
>>>  program counter back to the correct address in case the user's
>>>  post_handler() mucks around with it. That isn't possible with this
>>>  change :-(
>> I see your point. This can be prevented by saving and restoring regs->ip
>> around the post_handler() call, no ? Current code is beautiful. Saving and
>> restoring regs->ip would make this place look ugly.
>>
>> Otoh, if the post_handler() wants to crash the kernel, it can do it
>> in thousand ways, not just by trashing regs->ip, no ?
> 
> Of course, there still are other ways to shoot yourself in the foot with
> the post_handler(), but, atleast for cases we can control, we need to do
> the right thing.

Ananth, I think we can not prevent it even if resume_execution() is called
after post_handler, because resume_execution() refers reg->ip...:-(

And Yakov, I think you might need to make a patchset against all arch which
support kprobes, because this patch modifies expected behavior of kprobes
only on x86.

IMHO, Yakov's suggestion will be also good for resume_execution(), because
it only has to clean up after expectable-single-stepping. (user code is
unexpectable... we can not control all of that)


Thanks,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

