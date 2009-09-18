Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbZIRASo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbZIRASo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 20:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbZIRASm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 20:18:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754661AbZIRASl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 20:18:41 -0400
Date: Thu, 17 Sep 2009 17:18:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [bug] /etc/profile: line 30: /dev/null: Permission denied (Was:
  Re: [PATCH] Remove broken by design and by implementation devtmpfs 
 maintenance disaster)
In-Reply-To: <ac3eb2510909171526ga51ecfag74af1a34a0437189@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0909171709410.4950@localhost.localdomain>
References: <m1y6oef08k.fsf@fess.ebiederm.org> <20090917125759.GA4045@kroah.com>  <m1ab0tcwep.fsf@fess.ebiederm.org> <20090917185306.GA28635@elte.hu>  <ac3eb2510909171218k4963fc7dv8fb7549007e511aa@mail.gmail.com>  <alpine.LFD.2.01.0909171322210.4950@localhost.localdomain>
 <ac3eb2510909171526ga51ecfag74af1a34a0437189@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Sep 2009, Kay Sievers wrote:
> 
> > So I suspect /dev/null and /dev/zero should be special - just make them
> > have 0666 permissions. Because they really _are_ special, and no other
> > permissions ever make sense for them.
> 
> That's true. I guess there are a few more devices that need special
> permissions.

/dev/tty is probably the only remaining one - I don't think there should 
be any other devices that are so special that normal programs expect them 
to be there, and expect to be able to open them.

/dev/null (and to a lesser degree /dev/zero) really are special, and they 
are special not so much because they are special devices, but because they 
are part of the unix environment in rather deep ways. For example, mmap() 
on /dev/zero is deeply special, and really is about shm rather than any 
devices, so it's a VM thing with an odd special case.

And /dev/tty is special in that you'd expected to be able to open it even 
if you can't open the device that it points to - you may have inherited a 
tty from a program that _used_ to have permission to the underlying 
/dev/ttyxyz thing, but even if you no longer can open that device, 
/dev/tty still works.

The rest of /dev really should be rather esoteric, or it should be about 
real devices. So I do think that with just null, zero and tty having 0666 
permissions, a "normal UNIX" program is supposed to work. That should be 
the minimal set, but also the maximal set of devices that people should 
_expect_ to work.

(Yeah, there are things like /dev/stderr etc, but they are symlinks to 
/proc/self/fd anyway, so permissions don't matter)

			Linus
