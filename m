Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbYLAVCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbYLAVCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 16:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbYLAVCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 16:02:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980AbYLAVCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:02:37 -0500
Date: Mon, 1 Dec 2008 13:02:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Oren Laadan <orenl@cs.columbia.edu>, Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Serge Hallyn <serue@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC v10][PATCH 08/13] Dump open file descriptors
In-Reply-To: <1228164679.2971.91.camel@nimitz>
Message-ID: <alpine.LFD.2.00.0812011258390.3256@nehalem.linux-foundation.org>
References: <1227747884-14150-1-git-send-email-orenl@cs.columbia.edu>  <1227747884-14150-9-git-send-email-orenl@cs.columbia.edu>  <20081128101919.GO28946@ZenIV.linux.org.uk>  <1228153645.2971.36.camel@nimitz>  <493447DD.7010102@cs.columbia.edu>
 <1228164679.2971.91.camel@nimitz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Dec 2008, Dave Hansen wrote:
> 
> Why is this done in two steps?  It first grabs a list of fd numbers
> which needs to be validated, then goes back and turns those into 'struct
> file's which it saves off.  Is there a problem with doing that
> fd->'struct file' conversion under the files->file_lock?

Umm, why do we even worry about this?

Wouldn't it be much better to make sure that all other threads are 
stopped before we snapshot, and if we cannot account for some thread (ie 
there's some elevated count in the fs/files/mm structures that we cannot 
see from the threads we've stopped), just refuse to dump.

There is no sane dump from a multi-threaded app that shares resources 
without that kind of serialization _anyway_, so why even try?

In other words: any races in dumping are fundamental _bugs_ in the dumping 
at a much higher level. There's absolutely no point in trying to make 
something like "dump open fd's" be race-free, because if there are other 
people that are actively accessing the 'files' structure concurrently, you 
had a much more fundamental bug in the first place!

So do things more like the core-dumping does: make sure that all other 
threads are quiescent first!

			Linus
