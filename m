Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbZI3OU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbZI3OU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 10:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbZI3OUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 10:20:55 -0400
Received: from thunk.org ([69.25.196.29]:36678 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbZI3OUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 10:20:54 -0400
Date: Wed, 30 Sep 2009 10:20:49 -0400
From: Theodore Tso <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Josh Stone <jistone@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext4: Add a stub for mpage_da_data in the trace header
Message-ID: <20090930142049.GH24383@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>,
	Josh Stone <jistone@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <1254260407-14276-1-git-send-email-jistone@redhat.com> <20090930133335.GA14585@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930133335.GA14585@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 09:33:35AM -0400, Christoph Hellwig wrote:
> On Tue, Sep 29, 2009 at 02:40:07PM -0700, Josh Stone wrote:
> > The tracepoint ext4_da_write_pages has a struct mpage_da_data*
> > parameter, but that struct is only defined in fs/ext4/ext4.h.  This
> > patch adds a forward declaration for that struct, so this tracepoint
> > header can still be used by tools like SystemTap.
> 
> That's not what the tracepoints are for anyway.  No hacks for out of
> tree crap like this please - just use the trace buffer directly like
> ftrace and then you don't actually need any data types.
> 

Josh, you do realize that SystemTap can pull stuff out of the trace
buffer by examining information found in 

	/sys/kernel/debug/tracing/events/*/*/format

right?   For example:

name: ext4_sync_fs
ID: 600
format:
	field:unsigned short common_type;	offset:0;	size:2;
	field:unsigned char common_flags;	offset:2;	size:1;
	field:unsigned char common_preempt_count;	offset:3;	size:1;
	field:int common_pid;	offset:4;	size:4;
	field:int common_tgid;	offset:8;	size:4;

	field:dev_t dev;	offset:12;	size:4;
	field:int wait;	offset:16;	size:4;

print fmt: "dev %s wait %d", jbd2_dev_to_name(REC->dev), REC->wait

No need to for users to download gigabytes and gigabytes of DWARF
crapola (and for developers to grow old waiting for a kernel compile
with -g enabled to complete); SystemTap can just get what it needs
straight out of /sys/kernel/debug/tracing/events, and then reading
what it needs out of the ring buffer.

In any case I've added the blind structure pointer to
include/trace/events/ext4.h, but in the long term you're *much* better
off pulling the information you need from the ftrace ring buffer and
getting the information you need to interpret it out of
/sys/kernel/debug/tracing.

     	      				- Ted
