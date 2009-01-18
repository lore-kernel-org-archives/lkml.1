Return-Path: <linux-kernel-owner+w=401wt.eu-S1764373AbZARHqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764373AbZARHqa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 02:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763226AbZARHqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 02:46:18 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:3436 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773AbZARHqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 02:46:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AuVZnmwe2FRoU9MiyD6pQ8MKOUZkdaQT9TOg+Y0RunJFsIgGkyo0yJDytLGlkiIPaR
         8ChOe05rrx1Ag3VvdhSUQ6Aw3jdFm2lJ8uVDxjUWmxHq7qxEiC0OCq3BIJKC5up5u90p
         xxtU3XQ5Bs26KbJhn5Ru/nvvqi4JW2SbgscHY=
MIME-Version: 1.0
In-Reply-To: <4972B5A1.9090708@kernel.org>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
	 <1232115396-26367-9-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-10-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-11-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-12-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-13-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-14-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-15-git-send-email-brgerst@gmail.com>
	 <1232115396-26367-16-git-send-email-brgerst@gmail.com>
	 <4972B5A1.9090708@kernel.org>
Date: Sun, 18 Jan 2009 02:46:15 -0500
Message-ID: <73c1f2160901172346k3d6170eeqd733724e3af84e95@mail.gmail.com>
Subject: Re: [PATCH 16/17] x86-64: Remove the PDA
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2009 at 11:52 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> Brian Gerst wrote:
>> Now that the PDA is empty except for the stack canary, it can be removed.
>> The irqstack is moved to the start of the per-cpu section.  If the stack
>> protector is enabled, the canary overlaps the bottom 48 bytes of the irqstack
>> on SMP.  On UP it is a seperate variable, since it is the only thing referenced
>> via %gs.
>
> Eh... I don't know.  Locating stack canary at hard 40byte offset is a
> dirty thing to do one way or another.  I kind of like doing it
> directly in the linker script as it makes the dirty nature more
> obvious and doesn't require hunting down the definition in the first
> section.
>
> How about something like the following?
>
> #define CANARY_OFFSET   40
> #define CANARY_SIZE     8
>
> DECLARE_PER_CPU(unsigned long, stack_canary);
>
> and in linker script,
>
> PERCPU_VADDR_PREALLOC(0, :percpu, CANARY_OFFSET + CANARY_SIZE)
> per_cpu__stack_canary = __per_cpu_start + CANARY_OFFSET;
>

The thing I don't like about the prealloc method is that it puts the
page-aligned variables at the end.  This leaves a gap which is
unavailable for dynamic allocations.  Stealing 48 bytes from the
bottom of the irqstack (which is 16k) keeps the page-aligned section
at the start.  It's really no different than how the thread_info
structure sits at the bottom of the process stack.

How about something like:
union irq_stack_union {
	char irq_stack[IRQSTACKSIZE];
	struct {
		char pad[40];
		unsigned long stack_canary;
	}
};

That documents the overlay better, and avoids having to touch the linker script.

--
Brian Gerst
