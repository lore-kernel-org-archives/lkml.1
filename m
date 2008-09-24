Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbYIXUwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbYIXUwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 16:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbYIXUwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 16:52:11 -0400
Received: from smtp-out.google.com ([216.239.33.17]:56629 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbYIXUwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 16:52:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references:x-gmailtapped-by;
	b=eYGQHK57J8bwpSuiaiYWEEhlI0K4rD4IQ2VDx4dQ8bSZbktZwBciYFVRtywFSi7fE
	ll8kCbISInTLswiLMkg5Q==
Message-ID: <33307c790809241351k53f322a1o794dd73255393e11@mail.gmail.com>
Date: Wed, 24 Sep 2008 13:51:55 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Cc: torvalds@linux-foundation.org, rostedt@goodmis.org, peterz@infradead.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       akpm@linux-foundation.org, prasad@linux.vnet.ibm.com,
       compudj@krystal.dyndns.org, fche@redhat.com, dwilder@us.ibm.com,
       hch@lst.de, zanussi@comcast.net, srostedt@redhat.com
In-Reply-To: <20080924.133720.72895701.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org>
	 <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com>
	 <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org>
	 <20080924.133720.72895701.davem@davemloft.net>
X-GMailtapped-By: 172.25.146.36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> So I'd like the thing to have small headers, and be designed from the
>> start to have small headers.
>
> Small headers are good, but I'd suggest making sure there is an
> "offset" or similar field in there.
>
> Not that I want to encourage frequent changes to header layout, but if
> you do need to add something, then this offset field allows you to do
> so while keeping existing analysis tools working.  They will just
> ignore the new information in the headers, but they will still be able
> to get at the data bits using the offset.

One thing we said we could do is compile the "decompaction" tools
along with the kernel, in the kernel tree. Then if we change the in-kernel
format, you don't break all the userspace tools. We used:

struct ktrace_time {
        u32 seconds;
        u32 nanoseconds;
};

struct ktrace_event {
        struct ktrace_time time;
        u16 cpu;
        u16 type;
        u32 pid;
        u32 data;
        u32 elapsed_time;               /* ns for interrupt, otherwise us */
        u32 expanded_length;
}

The format is much easier to parse for userspace tools, though much
less compact. A simple C tool can turn in-kernel format into userspace
format:

1. Merge the per-cpu buffers into a single stream
2. put cpu ids in
3. Work out which pid was running, from the last context switch
4. Put in elapsed times (keeping track of the start of a system call
and recording the delta at end of system call (or interrupt, etc))
