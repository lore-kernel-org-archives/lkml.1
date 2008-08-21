Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbYHUAnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbYHUAnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 20:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbYHUAnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 20:43:11 -0400
Received: from mail.lang.hm ([64.81.33.126]:45345 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbYHUAnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 20:43:10 -0400
Date: Wed, 20 Aug 2008 17:42:24 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Eric Paris <eparis@redhat.com>
cc: Jan Harkes <jaharkes@cs.cmu.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       tvrtko.ursulin@sophos.com, Theodore Tso <tytso@mit.edu>, davecb@Sun.COM,
       Adrian Bunk <bunk@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, Casey Schaufler <casey@schaufler-ca.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro
 linux interface for  for access scanning
In-Reply-To: <1219260367.3389.125.camel@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0808201658310.20991@asgard.lang.hm>
References: <20080818153212.6A6FD33687F@pmx1.sophos.com>  <1219076143.15566.39.camel@localhost.localdomain>  <20080818171500.78590801@lxorguk.ukuu.org.uk>  <1219080504.15566.65.camel@localhost.localdomain>  <20080818182556.13ced58f@lxorguk.ukuu.org.uk> 
 <1219082097.15566.82.camel@localhost.localdomain>  <20080818183540.GA5470@cs.cmu.edu>  <1219085176.15566.100.camel@localhost.localdomain>  <alpine.DEB.1.10.0808181159400.15109@asgard.lang.hm>  <alpine.DEB.1.10.0808191906270.20991@asgard.lang.hm> 
 <1219245321.3389.82.camel@localhost.localdomain>  <alpine.DEB.1.10.0808201004200.20991@asgard.lang.hm> <1219260367.3389.125.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008, Eric Paris wrote:

> On Wed, 2008-08-20 at 10:33 -0700, david@lang.hm wrote:
>
>> if the system package manager says the syslogd binary doesn't match the
>> checksum that it has recorded should it be prevented from running? (a
>> strict policy would say no, but the sysadmin may have recompiled that one
>> binary and just wants a warning to be logged somewhere, not preventing the
>> process from running)
>
> My belief is that if you choose to run a file scanner and that file
> scanner gets the answer wrong you need to look at the file scanner.
> There shouldn't be arbitrary overrides.  If you don't accept the results
> of the scanner what's the point?  Tell you package manager scanner that
> you changed it.

and this is the core disagreement we have. I don't trust the AV vendors 
that much. I want there to be some way for me to disagree with them.

I've had AV false positives a few too many times where it flagged critical 
software as being bad to be comfortable giving them that much control

>> without the kernel support to clear the flags when the file is dirtied how
>> can these programs trust the xattr flags that say they scanned the file
>> before?
>
> I don't understand what you mean about trust.

if a program set an xattr to say that it scanned the file and then the 
system reboots, how can this program know that the file hasn't been 
modified since that xattr was set? your in-memory data is gone, so you 
can't tell from that. the xattr tag is still there.

> This is an argument for
> kernel support now?  What is it that you say needs and what doesn't need
> it?  Can you explain exactly what your perfect solution from top down?

1. a flag mechansim (namespace in xattr or something else) that allows for

1a. scanners to store arbatrary tags in a way that will survive a reboot.

1b. when the file is dirtied the kernel clears all flags that have been 
set on this file.

   especially for mmap access the kernel is in a good position to detect 
that the file has been dirtied, but nothing else is.

1c. when the kernel detect a formerly clean file getting dirtied it sends 
a message to userspace in a way that multiple scanners can receive the 
alerts

1d. to close the race of the file being modified while it's being scanned, 
add a system call (atomic as far as userspace is concerned) that sets a 
new tag IFF an old tag is set

2. on access a check is done against a list of 'required' tags, if not all 
tags are present the master scanning logic is invoked.

   for several reasons I've been thinking that this step could/should be 
done 
in userspace

If done in userspace

2a. define a place to record the 'required' tags.

   one way to do this is to have a directory for it, programs define 
'required' tags by creating a file with that as it's name with the 
contents of the file including the scanner name and the command line to 
execute to perform a scan

2b. define a way of stacking different scanners (being able to define what 
to do if each scanner says "yes", "no", "I don't know", "the file changed 
under me", and "the file changed under me, but I think I found a problem", 
and what to do with the combination of different answers).

   it may be that something resembling the way that pam works would be 
suitable.

3. modify knfsd so that it does the on access checks that the userspace 
library could do for #2 and calls out to the master scanning logic.

   this is new since the last time I wrote up the proposal (the first 
message in this thread), and is definantly more work, but in thinking 
about it I am starting to think that if the userspace solution is a good 
fit for everything but static binaries and knfsd, then the answer is to 
modify knfsd and say that the sysadmin/distro is responsible for making 
the static binaries compiled against the right libraries

when programs get ready to start scanning they can set a tag 
'app-scanning' when they complete the scan they can use the atomic op to 
say "if the tag 'app-scanning' is set, clear it and set the tag 
'app-scanned-gen1234'" (if 'app-scanning' is not set then the file was 
dirtied after the scan started)

if a program is running as part of an on-access scan it would then return 
it's opinion of the file.

it would be up to the master software (2b) to decide what to do if the 
scanners disagree, no scanner voices an opinion, or if a scanner reports 
the file changed while it was scanning it (it may want to kick off the 
scan immediatly, it may want to wait, it may want to limit the number of 
times it tries to scan a file and then either just allow or deny the 
access (all these thing are policy decisions)


>> I'm not saying that xattr is the only way to store the info, it just seems
>> like a convienient place to store them without having to create a
>> completely new API or changing anything in on-disk formats.
>
> And I saying we don't actually need any of this

I know, this is the core of our disagreement.

> and if it is actually
> needed by someone in the real world they can easily build their own
> solution on top of my generic interface.

most stuff could be, but I don't think everything could.

> I'm not making the assertion
> it is race free and don't think it is possible without making every
> sequential (hahahaha.)

I think we can make it race free.

> But I claim in the face of normal operation it's
> fine.  My interface, as proposed, is very generic.  Much more so than
> what I think you are trying to describe.  I couldn't make mine more
> minimal or broad.

and I am thinking that the slight additional step of having the kernel 
clear all tags rather then just having a single 'it was ok' tag is a 
significant advantage.

beyond that I think both approaches can work, the difference is how 
simple/complex we think the result is going to be used.

I think that we both agree that if you are right about how simply it's 
going to be used, you are also correct in putting it all in the kernel. 
however if I'm right about it being used for more complex things, then 
significant parts of it belong in userspace.

based on my beleive that much of this belongs in userspace, I'm then 
saying that it may make sense for all of #2 to be in userspace.

David Lang
