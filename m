Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbZI3Tp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbZI3Tp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 15:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbZI3Tp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 15:45:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139AbZI3Tp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 15:45:28 -0400
Message-ID: <4AC3B553.7070704@redhat.com>
Date: Wed, 30 Sep 2009 12:45:23 -0700
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext4: Add a stub for mpage_da_data in the trace header
References: <1254260407-14276-1-git-send-email-jistone@redhat.com> <20090930133335.GA14585@infradead.org> <20090930142049.GH24383@mit.edu>
In-Reply-To: <20090930142049.GH24383@mit.edu>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2009 07:20 AM, Theodore Tso wrote:
> On Wed, Sep 30, 2009 at 09:33:35AM -0400, Christoph Hellwig wrote:
>> On Tue, Sep 29, 2009 at 02:40:07PM -0700, Josh Stone wrote:
>>> The tracepoint ext4_da_write_pages has a struct mpage_da_data*
>>> parameter, but that struct is only defined in fs/ext4/ext4.h.  This
>>> patch adds a forward declaration for that struct, so this tracepoint
>>> header can still be used by tools like SystemTap.
>>
>> That's not what the tracepoints are for anyway.  No hacks for out of
>> tree crap like this please - just use the trace buffer directly like
>> ftrace and then you don't actually need any data types.

If you just want the data in the trace buffer, then SystemTap is not the
tool for you.  By all means, just write yourself a perl script or
something that parses the trace buffer however you like.

On the other hand, stap is useful to do some processing/inspection
*live*, at the moment the event happens.  For that, we register our own
tracepoint handler that can do something different than ftrace.

Anyway, I don't think it's a hack to add a simple struct declaration.
It's wrong to have an include/... header that requires definitions from
some subsystem internals, and that's the core thing I'm fixing here.

> Josh, you do realize that SystemTap can pull stuff out of the trace
> buffer by examining information found in 
> 
> 	/sys/kernel/debug/tracing/events/*/*/format
> 
> right?

Sure, but we want to be able to do more than just post-process the trace
buffer, so we hook up directly to the tracepoints.

> No need to for users to download gigabytes and gigabytes of DWARF
> crapola (and for developers to grow old waiting for a kernel compile
> with -g enabled to complete); SystemTap can just get what it needs
> straight out of /sys/kernel/debug/tracing/events, and then reading
> what it needs out of the ring buffer.

FWIW, Fedora rawhide's x86_64 kernel-debuginfo is a ~140MB package,
which installs to ~1.1GB, so that situation is not quite so bad.  The
compile time is of course still a beast.

However, SystemTap does *not* require the kernel debuginfo for using
tracepoints, even when reading parameters.  It should work in the
complete absence of CONFIG_DEBUGINFO, so if you find otherwise, please
let me know and I will fix it.

> In any case I've added the blind structure pointer to
> include/trace/events/ext4.h, but in the long term you're *much* better
> off pulling the information you need from the ftrace ring buffer and
> getting the information you need to interpret it out of
> /sys/kernel/debug/tracing.

Thank you for including it.

Josh
