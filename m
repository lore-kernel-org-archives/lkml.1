Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbZAaJ7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbZAaJ7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 04:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbZAaJ7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 04:59:10 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:59090 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZAaJ7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 04:59:08 -0500
X-Auth-Info: mRzY8LpykcwM91fBWKQjD4YjUsSgmHPz4bdrS1a3DhM=
To: Grant Erickson <gerickson@nuovations.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
From: Wolfgang Denk <wd@denx.de>
Subject: Re: [RFC] Add Alternative Log Buffer Support for printk Messages
Mime-version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
In-reply-to: <C5A8B8CD.143B5%gerickson@nuovations.com>
References: <C5A8B8CD.143B5%gerickson@nuovations.com>
Comments: In-reply-to Grant Erickson <gerickson@nuovations.com>
   message dated "Fri, 30 Jan 2009 14:01:49 -0800."
Date: Sat, 31 Jan 2009 10:59:01 +0100
Message-Id: <20090131095901.E1D1583644C3@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Grant & Andrew,

In message <C5A8B8CD.143B5%gerickson@nuovations.com> you wrote:
>
> > We have an external log buffer, into which stuff was written by (say)
> > the boot prom code.

Correct. Typically we use this in U-Boot to pass Power-On Self Test
results to applications running under Linux, using the standard syslog
tools.

Another are of use is to save the log buffer over a reset (crash)  of
the  system,  so  that  it can be read either rom the boot loader or,
after a reboot, from Linux.

> > We want that to come out on the console during bootup.

Not necessarily. The main function is to feed it into the syslog
processing.

> > So what we do is to divert the normal printk log buffer so that it
> > starts writing at the tail of that existing external buffer.  We emit
> > the entire buffer some time during bootup.  We henceforth continue to
> > use that external buffer in the normal manner. If so, why do it this way?

Do you have a better approach how to share  the  log  buffer  between
Linux  and  a boot loader in such a way that the content will survive
crahses and reboots?


> I believe this to be a useful feature for the embedded system space;
> however, I am not wedded in any way to the current implementation and am
> happy to evolve it as needed to meet the needs of key stakeholders.

Indeed we use this heavily in embedded systems, mainly to process POST
results under Linux (for example, to disable certain functions when
the POST results indicate hardware issues, etc.).

> > Why not just copy the external buffer's contents into the normal buffer during
> > bootup?  ie: printk("%s", external_buffer).

For two reasons:

1) Additional copy operation (ok, that's cheap).

2) We would lose the capability that the buffer content even survives 
   a reset / crash / reboot.

   This is a feature can be very useful in embedded systems where
   there is (at least normally) nobody looking at any console
   messages; being able to see the kernel's crash messages after a
   reboot in the normal syslog messages can be really helpful.

> > I think a quite bad part of this feature is that it renders the
> > kernel's log_buf_len boot parameter (and its Kconfig defult)
> > ineffective.  That's a pretty useful feature - people often set it to
> > 1MB or more during problem diagnosis, and the new unalterable 16kbytes
> > is very very small.

Yes, we are aware of this, but it's a compromise. Basicly it depends
on hardware capabilities. In most cases, it is sufficient to keep the
syslog buffer in RAM. But if you really have to guarantee that the
content of the buffer remains stable, this cannot be used because
during a processor reset there will be usually a too long pause until
the memory controller gets re-initialized and RAM refresh continues -
we might lose data in this time. In most cases it just works fine,
but it's out of spec. In such situations, when such a guarantee is
needed, we can use any SRAM that may be available on the board, or we
can use some on-chip-memory (OCM, basicly also SRAM) that might be on
the processor.

The OCM on the processors in question is 16 kB, hence the limitation
there.


But note that the code is general enough to support the other options
(other, bigger SRAM, or arbitrarily sized buffer in RAM), too.

> Agreed; however, I'm not sure how often this technique is employed in
> embedded systems versus desktop systems.

I haven't seen this ever used in desktop systems yet. And I doubt if
there is any x86 with a boot loader that supports somehting like this.

But there is for example a pretty large number of mobile cranes all
ove rthe workd which are using this feature :-)

> I'd be happy to keep the existing log buffer and perform a prepend from the
> boot buffer to it rather than an append of the kernel buffer to the boot
> buffer. Thoughts?

Please don't - this would implement only the way to pass the buffer
from the boot loader too Linux, but not the way back.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
What we anticipate seldom occurs;  what  we  least  expect  generally
happens.                                          - Bengamin Disraeli
