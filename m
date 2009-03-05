Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbZCETRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbZCETRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756355AbZCETQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:16:29 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:58562 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757112AbZCETQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:16:27 -0500
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090305174037.GA2274@x200.localdomain>
References: <20090305163857.0C18F3FD@kernel>
	 <20090305174037.GA2274@x200.localdomain>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 11:16:07 -0800
Message-Id: <1236280567.22399.99.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 20:40 +0300, Alexey Dobriyan wrote:
> On Thu, Mar 05, 2009 at 08:38:57AM -0800, Dave Hansen wrote:
> > This takes a suggestion of Ingo's along with comments from lots of
> > other people.  It can track whether a given file is able to be
> > checkpointed.  It introduces a f_op to allow easy customization
> > like the reset of the VFS.
> 
> Here is how alternative looks like
> * without touching VFS at all
> * without adding default handlers

Are these bad things?  If this was harmful to the VFS, I can bet
Christoph would be speaking up.  As far as the default handlers, blame
Christoph. :)

> * without duplicate code every ->checkpoint hook will have

Well, I had actually planned to break the generic function up into a
"common" function that all of the handlers can call or could be called
before each handler.  This is trivially fixable, but it would look kinda
goofy without some code to use it.

> * without largely useless "special file" messages
>   (what's so special about it?)

Very true.  I'll improve that one.

> * without adding userspace-visible /proc/*/checkpointable 

Ingo, could you weigh in on how you expected this "checkpointable" flag
to get exposed to and checked by userspace?

> * without recalculating "checkpointable" property on fs_struct
>   on every C/R=y kernel.

Yeah, this is certainly less than ideal.  Although, I haven't seen your
proposal for where to tie your code into the kernel.  Do you suggest
that we do nothing during normal kernel runtime and all the checking at
sys_checkpoint() time?

> * with "ban by default" policy as well
> * with error message immediatly understandable by developer:
> 
> 	cr_check_file: can't checkpoint file f61a0f40, ->f_op = socket_file_ops+0x0/0x1c0

That's a much better error message than I have.  I think I'll steal it
if you don't mind.  

> It may lack some printk, but printks are trivial to insert including
> using d_path for precise info.

This is definitely workable approach.  However, could you show how you
would support /dev/null and, say, /proc/$$/stat?  I've shown what it
takes to do that in my patches, and I think it would show a lot about
your approach.  

-- Dave

