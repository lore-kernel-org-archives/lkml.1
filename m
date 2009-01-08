Return-Path: <linux-kernel-owner+w=401wt.eu-S1759036AbZAHEvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036AbZAHEvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 23:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbZAHEvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 23:51:11 -0500
Received: from lists.laptop.org ([18.85.2.145]:41478 "EHLO mail.laptop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754962AbZAHEvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 23:51:10 -0500
Date: Wed, 7 Jan 2009 23:51:08 -0500
From: Michael Stone <michael@laptop.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: RFC: Network privilege separation.
Message-ID: <20090108045108.GL3164@didacte.laptop.org>
References: <1231307334-9542-1-git-send-email-michael@laptop.org> <87mye2yg8a.fsf@basil.nowhere.org> <20090108023111.GJ3164@didacte.laptop.org> <20090108031042.GQ496@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20090108031042.GQ496@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 04:10:42AM +0100, Andi Kleen wrote:
>On Wed, Jan 07, 2009 at 09:31:11PM -0500, Michael Stone wrote:
>I suppose I don't understand your requirements very well.

In that case, allow me to try to state them more clearly so that you can better
appreciate why your proposed solution is wholly unsatisfactory for my purposes.

In short, I'm trying to provide a general-purpose facility for

   * limiting networking per _process_, not per user, 

   * with an api that requires no privilege to exercise, 

   * which is suitable for widespread adoption by lots of Unix vendors and
     related standards bodies,

   * which is atomic from userland's perspective (i.e. so that userland never
     sees inconsistent or partial state)

   * which requires no userland refcounting or gc to maintain on long-running
     hosts

   * which is brain-dead simple to use

   * and which functions according to the standard Unix discretionary access
     control paradigm; namely that 

       + when your process has privileges, it can open resources (files,
         sockets, fds, ...) for later use and

       + when it drops privileges, it can still use any open resources that
         it has descriptors for regardless of how it got them but

       + when it drop privileges, it becomes unable to acquire new resources on
         its own

       + though other processes may still be able to send your process tokens
         which give it access to resources which it couldn't open on its own.

Does this help clarify the causes of my design choices?

>> * so far as I know, netfilter is only commonly used to filter IP traffic. 
>>   Can I really use it to limit connections to abstract unix sockets?
>
>No you can't. But is that really your requirement? 

It's my first-draft proposal but it's not a hard requirement. I picked it from
among several plausible alternate policies like:

   * permit localhost/loopback IP and abstract unix sockets
   * permit all unix sockets but no IP
   * permit only filesystem-based unix sockets

because it's the functionality that I personally want to be available to people
writing privilege-separated software and because Mark Seaborn (the author of
plash) criticised my previous choice of the second option in his review of one
of my previous attempts to implement a similar facility:

   http://lists.laptop.org/pipermail/security/2008-April/000391.html

After considering the matter, I came to agree with his position that permitting
low-privilege processes to connect to arbitrary "local" sockets is "not quite
safe" on the grounds that such sockets may be excellent vectors for user-land
privilege-escalation attacks.

(NB: This time, though, I have been careful to leave some room in my proposed
API for other people to implement other variations on this continuum by means
of RLIMIT_NETWORK values between 0 and RLIM_INFINITY.)

> Why limiting Unix sockets and not e.g. named pipes? 

Named pipes, like non-abstract unix sockets, are manageable through the
filesystem, e.g. by DAC and namespace manipulating tools like bind-mounts and
chroots.

> Unix sockets do not talk to the network.

Depends on your definition of "network". For the purposes of this discussion,
mine basically means "every sort of inter-process communication which is not
naturally mediated by UNIX DAC."

Regards,

Michael

P.S. - Thanks very much for your questions; I feel that they're definitely
helping me to clarify my thinking and arguments.
