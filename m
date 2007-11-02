Return-Path: <linux-kernel-owner+w=401wt.eu-S1757286AbXKBQPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbXKBQPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 12:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbXKBQO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 12:14:58 -0400
Received: from sacred.ru ([62.205.161.221]:60621 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbXKBQO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 12:14:57 -0400
Message-ID: <472B4937.1050106@openvz.org>
Date: Fri, 02 Nov 2007 18:58:47 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: [patch] PID namespace design bug, workaround
References: <20071101144307.GA29566@elte.hu>	<4729E7E4.8070208@openvz.org>	<4729E936.4040400@redhat.com>	<4729EB3C.9050102@openvz.org>	<472A6D91.1020300@redhat.com>	<472AD7D6.80900@openvz.org> <20071102010419.23f3db5c.akpm@linux-foundation.org> <472ADC78.6070706@openvz.org> <472B2EBD.7070007@redhat.com> <472B327E.2060006@openvz.org> <472B4378.80809@redhat.com>
In-Reply-To: <472B4378.80809@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 02 Nov 2007 18:58:46 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Pavel Emelyanov wrote:
>> So is "everything else", you mentioned, covered with the problems
>> above?
> 
> No, it's not.  If you'd read the mail carefully you'd notice that the
> use of PIDs especially in robust futexes is part of the API and that it
> simply isn't acceptable to say "don't do that".  A robust mutex can be
> stored in any file and as long as two processes have access to the same
> file (or they can pass each other shared memory) the underlying futex
> functionality simply must work.

This is the case when you export the pid to the user level outside 
the namespace. This case is not supposed to work at all. I know it 
and there's noting we can do with it. (some more comments about this
below)

> This whole approach to allow switching on and off each of the namespaces
> is just wrong.  Do it all or nothing, at least for the problematic ones
> like NEWPID.  Having access to the same filesystem but using separate
> PID namespaces is simply not going to work.

I'd like to note, that the original reason to switch the namespace off 
was to help embedded people get rid of the functionality they don't 
need and save the vmlinux size. Since Ingo proposed to disable the 
namespace creation in a ... strange way, I noticed, that there will be 
a more elegant way to do this. This was not the "fix" for cross-namespaces
communications.

Nevertheless...

Having access to the same IPCs in different pid namespaces won't work.
Having access to the same filesystem in different IPC namespaces won't work.
Having access to the same UID namespace in different VFS namespaces won't work.
Having access to the same <any> namespace in different <many others> namespace
 wont' work.

That's the idea OpenVZ tried to promote when the story with "containers"
started, but most of the other participants decided that we can create
individual namespaces and step-by-step try to make them work in all the
possible combinations.

Right now we have a pid namespace, which

a) works fine in the initial namespace (by this I mean that it doesn't
   introduce *new* bugs);
b) mostly works in the sub namespace. some work is to be done and it
   is being done;
c) doesn't work in some ways (but not at all) when tasks communicate 
   across the namespace boundary, but is not going to by definition.

I'm also looking for a good solution on how to workaround the
"c" case, but I'm not agree with the statement that "the pid
namespaces are completely broken". They are not completely broken,
but there is just some work to do with the case "b" and some way
to be invented to disable the case "c".

> You also brush completely over the SysV IPC issue.

I did not - this problem is only relevant when you try to setup the
IPC communication between processes from different namespaces, but
I have already answered this question.

If you use IPC within a single namespaces everything works just fine.

> And I doubt that I spent enough time thinking about all this to arrive
> at the more subtle problems.  I don't think especially the PID namespace
> is ready at all at this time.
> 
> - --
> ➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.7 (GNU/Linux)
> 
> iD4DBQFHK0N42ijCOnn/RHQRAkPyAJiDR9ZEPUbCdEa2xk+Te80B7avDAJ4mgy7v
> jgtZG129yBUGBrpQ8fbn7w==
> =ho0Z
> -----END PGP SIGNATURE-----
> 

