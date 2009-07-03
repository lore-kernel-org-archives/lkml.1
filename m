Return-Path: <linux-kernel-owner+w=401wt.eu-S1757949AbZGCRzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbZGCRzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 13:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbZGCRyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 13:54:52 -0400
Received: from smtp-out.google.com ([216.239.33.17]:34777 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067AbZGCRyv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 13:54:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=C0o9pOGnMv6kzFUap+qdRD8KmI6+3C+BpgL98DG6D5kKiyKRt5KRNpzkNGDdj13Z1
	W3DB45qv1fLsH0ZAXBoCA==
MIME-Version: 1.0
In-Reply-To: <20090703095000.cf46ad19.akpm@linux-foundation.org>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	 <2f86c2480907021731h13e0bb95q94f06829eded9aa6@mail.gmail.com>
	 <20090702175341.fd2e26d5.akpm@linux-foundation.org>
	 <6599ad830907021808o6f3bb51eh324e4bf13544d83e@mail.gmail.com>
	 <2f86c2480907021817o79fce75yd9785aab682f7bb4@mail.gmail.com>
	 <20090702190845.0cafc46a.akpm@linux-foundation.org>
	 <6599ad830907022116n7a711c7fs52ff9b400ec8797f@mail.gmail.com>
	 <20090702235527.7ddc873c.akpm@linux-foundation.org>
	 <6599ad830907030911m6176dc59id3a7d897b03d2bd@mail.gmail.com>
	 <20090703095000.cf46ad19.akpm@linux-foundation.org>
Date: Fri, 3 Jul 2009 10:54:48 -0700
Message-ID: <6599ad830907031054x74d90149y38aae60afa403d58@mail.gmail.com>
Subject: Re: [PATCH 1/2] Adds a read-only "procs" file similar to "tasks" that 
	shows only unique tgids
From: Paul Menage <menage@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Blum <bblum@google.com>, lizf@cn.fujitzu.com, serue@us.ibm.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 3, 2009 at 9:50 AM, Andrew Morton<akpm@linux-foundation.org> wrote:
>
> I think you're saying "for each pid N in the cgroup, set the Nth
> element in an IDR tree".

Right.

> That would work.  And it automatically gives
> ordered traversal and dupe removal.
>
> I don't think IDRs permit in-order traversal, whereas radix-trees do
> support this.

I thought that an IDR *was* a form of radix tree.

Looking at the IDR API it doesn't appear support the notion of "insert
an entry with id N" anyway.

> Unfortunately radix-trees are presented as operating on
> void* data, so one would need to do some typecasting when storing
> BITS_PER_LONG-sized bitfields inside them.

That would mean adding something a bit like the IDA wrapper that
converts IDR to deal with bitfields?

Is the benefit of avoiding a vmalloc() at all costs really worth the
additional complexity, versus just doing:

if (size > 2 * PAGE_SIZE) {
  array = vmalloc(size);
} else {
  array = kmalloc(size, GFP_KERNEL);
}

?

That would only require vmalloc on cgroups with >2048 tasks, which is
going to be pretty rare, and is way simpler.

Paul
