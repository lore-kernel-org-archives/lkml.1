Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbYHTRe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbYHTRe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 13:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYHTReS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 13:34:18 -0400
Received: from mail.lang.hm ([64.81.33.126]:59593 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbYHTReR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 13:34:17 -0400
Date: Wed, 20 Aug 2008 10:33:44 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Eric Paris <eparis@redhat.com>
cc: Jan Harkes <jaharkes@cs.cmu.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       tvrtko.ursulin@sophos.com, Theodore Tso <tytso@mit.edu>, davecb@sun.com,
       Adrian Bunk <bunk@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, Casey Schaufler <casey@schaufler-ca.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro
 linux interface for  for access scanning
In-Reply-To: <1219245321.3389.82.camel@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0808201004200.20991@asgard.lang.hm>
References: <20080818153212.6A6FD33687F@pmx1.sophos.com>  <1219076143.15566.39.camel@localhost.localdomain>  <20080818171500.78590801@lxorguk.ukuu.org.uk>  <1219080504.15566.65.camel@localhost.localdomain>  <20080818182556.13ced58f@lxorguk.ukuu.org.uk> 
 <1219082097.15566.82.camel@localhost.localdomain>  <20080818183540.GA5470@cs.cmu.edu>  <1219085176.15566.100.camel@localhost.localdomain>  <alpine.DEB.1.10.0808181159400.15109@asgard.lang.hm>  <alpine.DEB.1.10.0808191906270.20991@asgard.lang.hm>
 <1219245321.3389.82.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008, Eric Paris wrote:

> On Tue, 2008-08-19 at 19:44 -0700, david@lang.hm wrote:
>
>> please note that I am trying to state Erics position, I may be mistaken.
>
> you did pretty well.

thanks.

>> I expect to see IDS type scanners, possibly multiple ones on a machine,
>> each fairly simple and not trying to do a complete job, but authoritative
>> within it's area.
>>    this means that the interaction between approvals is more complex and
>> not something that should be coded into the kernel, it should be
>> configured in userspace.
>
> I don't understand how something can be 'authoritative within it's area'
> and still have a 'complex interaction policy.'  I see it as, either yes
> means yes and no means no, or it isn't authoritative.

as an example.

if the system package manager says the syslogd binary doesn't match the 
checksum that it has recorded should it be prevented from running? (a 
strict policy would say no, but the sysadmin may have recompiled that one 
binary and just wants a warning to be logged somewhere, not preventing the 
process from running)

what happens if scanner A (AV scanner) says that a binary has a virus in 
it, but scanner B (IDS scanner checkins checksums) says that it's the 
right version? what mechanism do you have to say that a yes from scanner B 
overrides a no from scanner A?

> If two scanners need some complex interaction it certainly needs to be
> in userspace, no question there.  Sounds like a dispatcher daemon needs
> to get the notification from the kernel and send them to the scanners
> and then let it do all sorts of magic and sprinkling of pixie dust
> before the daemon return an answer to the kernel.  In the end that
> deamon is the authoritative thing.  I don't plan to write it since I
> don't see the need, but the possibility of writing a dispatcher daemon
> certainly exists if there is actually need.

that could work, the need to have the userspace daemon to do the more 
complex things was part of what was pushing me to think in terms of 
userspace hooks for open/read/mmap/etc instead of kernelspace hooks 
(avoiding the context switches you mentioned in an earlier message becouse 
you start in userspace)

> Everything says yes at read/mmap we allow.  Anything says no we deny.
> You need more than that write an intermediary daemon in userspace to
> govern that interaction.
>
>> becouse of things like indexers, backups, and IDS type I see great value
>> in storing the fact that a file was scanned across reboots for some users
>> (other users may not want to trust the system without re-scanning it after
>> a reboot in case the files were changed)
>
> My answer is that if they want to store whatever it is they care about
> across boots so the scanner can write an xattr to help.  I believe that
> all scanners are going to need/want to have some for of userspace
> caching.  I plan to provide a fastpath in kernel scanners can make use
> of, but anything more complex should be a completely userspace solution
> and should be able to be built on what I provide at a later time.

without the kernel support to clear the flags when the file is dirtied how 
can these programs trust the xattr flags that say they scanned the file 
before?

you also mention using mtime, I don't think that's granular enough. we 
already have people running into problems during compiles with fast 
machines not being able to detect that a file has changed by the mtime.

I'm not saying that xattr is the only way to store the info, it just seems 
like a convienient place to store them without having to create a 
completely new API or changing anything in on-disk formats.

the real requirements that I see are more like this

1. must be able to be cleared by the kernel when the file is dirtied

2. must be able to be persistant across reboots

3. should allow free-form tags to be stored by scanners

4. if it's deemed nessasary to close the race condition of a file getting 
modfied while the scanner is scanning it, there should be an 'atomic to 
userspace' call to set a tag IFF an old tag exists. This is a new API 
call, but would only need to be used by the scanners.

while #3 can cause conflicts between scanners, I don't expect that in 
practice (I expect each scanner to use their own unique prefix to avoid 
conflicts)

David Lang
