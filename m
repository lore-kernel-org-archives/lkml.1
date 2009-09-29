Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265AbZI2WLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbZI2WLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 18:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbZI2WLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 18:11:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752906AbZI2WLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 18:11:40 -0400
Date: Tue, 29 Sep 2009 15:11:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Arjan van de Ven <arjan@infradead.org>, Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, mingo@elte.hu,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-api@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [RFC][v7][PATCH 8/9]: Define clone2() syscall
In-Reply-To: <4AC267C7.4070300@zytor.com>
Message-ID: <alpine.LFD.2.01.0909291501530.6996@localhost.localdomain>
References: <20090924165548.GA16586@us.ibm.com> <20090924170308.GH16989@us.ibm.com> <200909242343.59903.arnd@arndb.de> <20090925082346.GB4436@localdomain> <20090925105632.GG12824@hawkmoon.kerlabs.com> <20090929180537.GD4625@us.ibm.com>
 <20090929184023.532DF34@magilla.sf.frob.com> <4AC255A4.4030002@zytor.com> <20090929210207.247b94df@infradead.org> <alpine.LFD.2.01.0909291207410.6996@localhost.localdomain> <4AC267C7.4070300@zytor.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 Sep 2009, H. Peter Anvin wrote:
> 
> That's not the main issue here, though.  The main issue is that the
> prototype of the function now depends on one of its arguments

Ok, I agree with that. The kernel side is easy (we have magic calling 
conventions there and need to turn registers into arguments anyway before 
you get to the shared code), but your point about the user side prototype 
is valid.

However, that could easily be handled by just having a extended_clone() 
prototype that then sets the CLONE_EXTINFO (or whatever) bit in the flags. 
I think most of the time the clone() stuff needs special user-level 
wrappers anyway to handle the stack setup etc, no?

In other words, what I'd suggest we could do is

 - the kernel "do_fork()" interface would be made to have the "extended" 
   format by default - so the _kernel_ never has two formats in its 
   generic logic.

 - the "sys_clone()" system call, that already needs to munge the user 
   mode registers into the "do_fork()" format, would be the one that 
   recognizes the new flag and copies the extended data from user mode 
   memory to the extended info mode.

Then each architecture would need to update it's "sys_clone()" function to 
take advantage of the new extended format, but that's something that the 
new system call would have had to do anyway, so that's not an added burden 
in any way.

Hmm?

I don't feel horribly strongly about this, and as far as I'm concerned 
it's fine to also do it as a new system call too (we already have 'fork()' 
and 'vfork()' as special case interfaces to do_fork() - the new 'extended 
clone' would be no different).

I just think that Roland is correct that if the new extended fork handles 
the "no new info" case itself _anyway_, then there is no upside to making 
it a new system call, since the complexity is the same as just extending 
the old one.

			Linus
