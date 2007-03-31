Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbXCaTuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbXCaTuu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 15:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbXCaTuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 15:50:50 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:48156 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbXCaTut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 15:50:49 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 31 Mar 2007 12:50:48 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Suparna Bhattacharya <suparna@in.ibm.com>,
       Zach Brown <zach.brown@oracle.com>, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [patch 10/13] signal/timer/event fds v8 - eventfd core ...
In-Reply-To: <20070330182603.5d6817d3.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703311247110.22390@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.28743.1174415840.10>
 <20070330124028.c6e54d2e.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703301804110.3721@alien.or.mcafeemobile.com>
 <20070330182603.5d6817d3.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007, Andrew Morton wrote:

> On Fri, 30 Mar 2007 18:11:55 -0700 (PDT) Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > 
> > > > + */
> > > 
> > > So it is the caller's responsibility to ensure that *file refers to an
> > > eventfd file?
> > 
> > In which function? I lost you ...
> > 
> 
> eventfd_signal() assumes that the passed in file* refers to an eventfd
> file.  So if a caller passes in a file* for /etc/passwd, the kernel will go
> splat.
> 
> I guess that's caveat emptor, and any violations of that will show up
> quickly in testing.  My main concern would be that there might be some way
> for a naughty user to force the kernel to pass a non-eventfd file* into
> this function.  That depends upon as-yet-unwritten code - is there a risk
> of this happening, and how do we prevent it?

That's the kernel side of the API. The userspace->kernel fd validation is 
done in eventfd_fget(), that the kernel uses to get an eventfd file* from 
an eventfd file descriptor. The eventfd_fget() does the file operations 
check and returns proper error.
At that point, if the kernel feeds eventfd_signal() with crap, it gets 
crap back. Like calling internal kernel functions with bogus mm_struct or 
task_struct.



> > > > +	DECLARE_WAITQUEUE(wait, current);
> > > > +
> > > > +	if (count < sizeof(ucnt))
> > > > +		return -EINVAL;
> > > > +	if (get_user(ucnt, (const __u64 __user *) buf))
> > > > +		return -EFAULT;
> > > 
> > > Some architectures do not implement 64-bit get_user()
> > 
> > copy_from_user it is, then ...
> > 
> 
> spose so.  I think architectures _should_ implement 64-bit get_user() and
> put_user() nowadays.  So you could leave the code as-is and inform the arch
> maintainers, if you're feeling keen.
> 
> If all this code has its own Kconfig options then the architectures won't
> break until their maintainers come along to enable the new features, so
> they'll implement 64-bit get_user() at that time and things will all unfold
> in a nicely non-chaotic fashion.

Agreed. I'll leave the get_user(u64).



- Davide


