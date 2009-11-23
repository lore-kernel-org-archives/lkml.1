Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbZKWBBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbZKWBBc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 20:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbZKWBBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 20:01:31 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:47819 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbZKWBB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 20:01:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZA74biOZdmZpO/+Jx2iyikWJ907zk5BpqsoE3o6vBdJ50HRQ/sEJNRBJMtLv5AhXny
         ONZ6HsesbM9nv21EJnFJag4S3b4pTSO/287LQtV9fT6skxZ4lno/8VPzZaggW3jApzhH
         Uu2Ahfb9AlFtFMy8YIfkU4/rM+0bTxyO1AyBg=
Subject: Re: RFC: Put printk buffer in video ram
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Dave Jones <davej@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1258892101.3231.20.camel@maxim-laptop>
References: <1258855506.3153.1.camel@maxim-laptop>
	 <20091122023237.GA6572@nowhere>  <20091122082511.GC24558@elte.hu>
	 <1258892101.3231.20.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 03:01:28 +0200
Message-ID: <1258938089.3134.22.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-22 at 14:15 +0200, Maxim Levitsky wrote: 
> On Sun, 2009-11-22 at 09:25 +0100, Ingo Molnar wrote: 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > On Sun, Nov 22, 2009 at 04:05:06AM +0200, Maxim Levitsky wrote:
> > > > After doing some successful debugging by placing printk buffer in video
> > > > ram, here I publish cleaned version of it.
> > > > 
> > > > I discovered that on my system video ram isn't cleared on reboot, and I
> > > > took advantage of that by placing printk buffer directly there.
> > > > This allows to capture oopses/panicks almost from everywhere.
> > > > It is also very simple to setup.

Few more thoughts:

First of all, if I implement this as a console driver, I won't be able
to capture all kernel log, but only from the point I register the
console.
My implementation, also isn't set up very early, but I copy already
written log to the memory buffer.

Problem of automatic unregistration isn't a problem, its just a feature,
I could skip using.

Secondary, I found out that system ram isn't cleared ether on my
notebook, however I found out that I can't reserve small memory range
with 'memmap' kernel parameter. System just panics.
I used for reference 'memmap=2M$0x60000000'
My system has 2GB of memory.

I could reserve the memory same way using the code, but it would
probably fail in same way. Also I could try early reservations, but I am
not sure I can reserve _any_ address range. I test this.

I think that patches to put printk buffer at predefined area in system
ram were once posted on LKML.



And now, to be honest, lets talk about existing solutions:

1 - kdump/kexec - not a bad thing, but it has some disadvantages, namely
I need to compile seperate kernel, there is a probility of new kernel
not booting up (in fact I once installed kexec-tools, and it made system
reboot using kexec, and I remember a hang because of that...)
However, this approach doesn't need any 'help' from BIOS.

2 - mtdoops + phram - There is a console driver that logs into mtd
device. I don't know how it selects one. 
It is possible to create a 'fake' mtd device that will span a range in
physical memory.
I couldn't make this work, it has problems with early output, etc..


Best regards,
Maxim Levitsky

