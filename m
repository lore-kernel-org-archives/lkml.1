Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbZFERr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbZFERr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 13:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZFERqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 13:46:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:26591 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbZFERqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 13:46:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IfvTjMxtx1ihfMdDyp6ur0tD1laMBRXdmuLET48QQNcLUqjHjRZE8ZQMhMjRLu+V8d
         5YvisvahPH631LNl88jRHLhU6nK32BMq08Pe5eKUsAO+BqT0XuVm0KMge830MQn2+myh
         E7tSw+k4aored6fmphoAx8F+tgW3Ke6hrR+B4=
Date: Fri, 5 Jun 2009 21:46:37 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Helsley <matthltc@us.ibm.com>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/9] exec_path 1/9: introduce ->exec_path and switch
	/proc/*/exe
Message-ID: <20090605174637.GA13567@x200.localdomain>
References: <20090526162415.fb9cefef.akpm@linux-foundation.org> <20090531215427.GA29534@x200.localdomain> <20090531151953.8f8b14b5.akpm@linux-foundation.org> <20090603230422.GB853@x200.localdomain> <20090605104517.GA11713@infradead.org> <alpine.LFD.2.01.0906050808551.6847@localhost.localdomain> <20090605154147.GA16766@x200.localdomain> <alpine.LFD.2.01.0906050848520.6847@localhost.localdomain> <20090605160943.GA5262@x200.localdomain> <alpine.LFD.2.01.0906050942450.6847@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906050942450.6847@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 09:48:02AM -0700, Linus Torvalds wrote:
> On Fri, 5 Jun 2009, Alexey Dobriyan wrote:
> > 
> > It's borrowed by kernel thread of course, not userspace task.
> 
> .. and even if it is, what's the problem? 

The problem is task_struct <=> mm_struct relationship is muzzled
for various reasons, and to not depend on subtleties of who-owns-mm-struct
of the day, ->exec_path is placed onto task_struct.

Done this, ->exec_path simply stop depend on other current and future
hacks, and only defined by what binfmt loader did.

> That kernel thread has borroed whe VM for a while. It effectively _is_ a 
> thread of the process now.

See? Thread is what you get via CLONE_THREAD.

> So it's technically not even wrong to 
> explicitly allow things like /proc/*/exe to see it as such.

This knowledge is some implementation detail, how AIO is implemented and
how kernel threads access userpace VM. But you're going to expose it
by not checking for kernel-threadness or something.

> But you can hide it by just checking some flag in the thread structure if 
> you really want to.
> 
> But when creating a regular thread, you should _not_ need to take a 
> spinlock and duplicate the executable path!

Since task_struct is literally copied during clone, _that_ line,
can be easily changed to just

	path_get(&p->exec_path);

But for consistency and to not give bad example it was written
with honest locking.
