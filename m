Return-Path: <linux-kernel-owner+w=401wt.eu-S1752135Ab0ARNfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab0ARNfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 08:35:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069Ab0ARNfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 08:35:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab0ARNfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 08:35:03 -0500
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
From: Mark Wielaard <mjw@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       utrace-devel <utrace-devel@redhat.com>
In-Reply-To: <4B5459CA.9060603@redhat.com>
References: <1263740593.557.20967.camel@twins>
	 <1263800752.4283.19.camel@laptop> <4B543F93.3060509@redhat.com>
	 <1263815072.4283.305.camel@laptop> <4B544D7C.2060708@redhat.com>
	 <1263816396.4283.361.camel@laptop> <4B544F8E.1080603@redhat.com>
	 <84144f021001180413w76a8ca2axb0b9f07ee4dea67e@mail.gmail.com>
	 <4B545146.3080001@redhat.com>	 <20100118124419.GC1628@linux.vnet.ibm.com>
	 <84144f021001180451k2a84f17x3dc24796fea986c9@mail.gmail.com>
	 <4B5459CA.9060603@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 14:34:40 +0100
Message-ID: <1263821680.2946.85.camel@springer.wildebeest.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 14:53 +0200, Avi Kivity wrote:
> On 01/18/2010 02:51 PM, Pekka Enberg wrote:
> >
> > And how many probes do we expected to be live at the same time in
> > real-world scenarios? I guess Avi's "one million" is more than enough?
> >    
> I don't think a user will ever come close to a million, but we can 
> expect some inflation from inlined functions (I don't know if uprobes 
> replicates such probes, but if it doesn't, it should).

SystemTap by default places probes on all instances of an inlined
function. It is still hard to get to a million probes though.
$ stap -v -l 'process("/usr/bin/emacs").function("*")'
[...]
Pass 2: analyzed script: 4359 probe(s)

You can try probing all statements (for every function, in every file,
on every line of source code), but even that only adds up to ten
thousands of probes:
$ stap -v -l 'process("/usr/bin/emacs").statement("*@*:*")'
[...]
Pass 2: analyzed script: 39603 probe(s)

So a million is pretty far out, even if you add larger programs and all
the shared libraries they are using.

As Srikar said the current allocation technique is the simplest you can
do, one xol slot for each uprobe. But there are other techniques that
you can use. Theoretically you only need a xol slot for each thread of a
process that simultaneously hits a uprobe instance. That requires a bit
more bookkeeping. The variant of uprobes that systemtap uses at the
moment does that. But the locking in that case is pretty tricky, so it
seemed easier to first get the code with the simplest xol allocation
technique upstream. But if you do that than you can use a very small xol
area to support millions of uprobes and only have to expand it when
there are hundreds of threads in a process all hitting the probes
simultaneously.

Cheers,

Mark

