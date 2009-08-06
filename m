Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbZHFKmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbZHFKmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 06:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbZHFKmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 06:42:25 -0400
Received: from smtp-out.google.com ([216.239.45.13]:8130 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbZHFKmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 06:42:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=fGGFUpKIyJrfYHVLLsCYYWmflz7QDc9aJ1r0bRfLK75JoANYNoBo1b9F1GiqSqkAa
	8w9+vwQt7hXln1Fq0DnUQ==
MIME-Version: 1.0
In-Reply-To: <1249554853.32113.145.camel@twins>
References: <2f86c2480908031113y525b6cbdhe418b8a0364c7760@mail.gmail.com>
	 <2f86c2480908041214r1f23c1b7q9a25b04e26c92a1a@mail.gmail.com>
	 <6599ad830908041228w67bc6f7fh57e28f244e1923b3@mail.gmail.com>
	 <20090805102057.GT29252@hawkmoon.kerlabs.com>
	 <6599ad830908050911t6f23f810i65fe8fe17f3ee698@mail.gmail.com>
	 <20090805164218.GB26446@hawkmoon.kerlabs.com>
	 <2f86c2480908051701s57120404q475edbedb58cdca1@mail.gmail.com>
	 <20090806095854.GD26446@hawkmoon.kerlabs.com>
	 <6599ad830908060328y21a008c1pc5ed5c27e0ec905d@mail.gmail.com>
	 <1249554853.32113.145.camel@twins>
Date: Thu, 6 Aug 2009 03:42:20 -0700
Message-ID: <6599ad830908060342m1fc8cdd2me25af248a8e0e183@mail.gmail.com>
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by tgid 
	at once
From: Paul Menage <menage@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Benjamin Blum <bblum@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 6, 2009 at 3:34 AM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> On Thu, 2009-08-06 at 03:28 -0700, Paul Menage wrote:
>
>> OK, well if lockdep can't currently handle the "writer takes a lock on
>> every thread" model,
>
> I haven't read what this is about, but simply looking at that sentence
> makes me want to hit someone with a cluebat. Have you any idea how
> expensive that is?

For lockdep to track that many locks, or just the concept of taking
that many locks generally?

The basic idea is that in order to implement a "procs" file in cgroups
that can migrate all threads in a process atomically, we need to
synchronize with concurrent clone() calls. But since thread clones are
likely to occur far more often than "procs" writes, and we wanted to
avoid introducing overhead into the clone path, one approach was to
give each thread a fork mutex, which it could take around the relevant
parts of the fork/clone operation, and have the "procs" writer deal
with obtaining the fork mutex for every thread in the process being
moved, so pushing the overhead on to the "procs" writer.

I don't think it's a deficiency of lockdep that it would have trouble
dealing with this - in fact, my original plan was that we'd just have
to live with the fact that anyone doing a "procs" move on a massive
process would have to live with lockdep printing an overflow warning.
But given that AFAICS we can eliminate the overhead associated with a
single lock by piggy-backing on the cache line containing
sighand->count, hopefully this won't be an issue any more.

Paul
