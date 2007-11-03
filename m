Return-Path: <linux-kernel-owner+w=401wt.eu-S1759067AbXKCWll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067AbXKCWll (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 18:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692AbXKCWle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 18:41:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51846 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754259AbXKCWld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 18:41:33 -0400
Date: Sat, 3 Nov 2007 15:40:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org,
       "Dinakar Guniguntala [imap]" <dino@in.ibm.com>,
       Sripathi Kodi <sripathik@in.ibm.com>
Subject: Re: [patch] PID namespace design bug, workaround
In-Reply-To: <20071103201251.GB26366@elte.hu>
Message-ID: <alpine.LFD.0.999.0711031535450.15101@woody.linux-foundation.org>
References: <20071101144307.GA29566@elte.hu> <4729E7E4.8070208@openvz.org>
 <4729E936.4040400@redhat.com> <4729EB3C.9050102@openvz.org>
 <472A6D91.1020300@redhat.com> <472AD7D6.80900@openvz.org>
 <20071102010419.23f3db5c.akpm@linux-foundation.org> <1194024622.6271.108.camel@localhost>
 <alpine.LFD.0.999.0711021038480.3342@woody.linux-foundation.org>
 <20071103201251.GB26366@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 3 Nov 2007, Ingo Molnar wrote:
> 
> - one problem is that this condition is 'invisible'. If two namespaces 
>   happen to access the same robust futex (say a yum update from two 
>   PID namespaces sharing the same read-mostly filesystem) there's silent
>   breakage and data corruption due to PID overlap.

.. and this is in *no* way different from thousands of applications that 
write their pid to lock-files, and others decide that it's "stale" because 
using "kill(pid, 0)" returns that the pid doesn't exist any more.

The solution? You can't do that kind of locking over NFS, or across pid 
namespaces. Nobody blames NFS or pid namespaces for it. 

> - so via this we isolate an important category of syscalls from
>   cross-namespace use perhaps forever.

So? That's inherent to how those stupid stable mutexes work.

I don't understand how you can call this a "PID namespace design bug", 
when it clearly has nothing what-so-ever to do with pid namespaces, and 
everything to do with the *futexes* that blithely assume that pid's are 
unique and that made it part of the user-visible interface.

OF COURSE any pid namespace design will always break such assumptions, but 
that's not because of any PID namespace bugs. It's what the whole *point* 
of PID namespaces are. If you use pid's (instead of some opaque cookies), 
you will not be able to use such things across pid-separation.

			Linus
