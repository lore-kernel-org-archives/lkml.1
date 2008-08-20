Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbYHTPQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbYHTPQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 11:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbYHTPPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 11:15:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058AbYHTPPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 11:15:47 -0400
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro
	linux interface for  for access scanning
From: Eric Paris <eparis@redhat.com>
To: david@lang.hm
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       tvrtko.ursulin@sophos.com, Theodore Tso <tytso@mit.edu>, davecb@sun.com,
       Adrian Bunk <bunk@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, Casey Schaufler <casey@schaufler-ca.com>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <alpine.DEB.1.10.0808191906270.20991@asgard.lang.hm>
References: <20080818153212.6A6FD33687F@pmx1.sophos.com>
	 <1219076143.15566.39.camel@localhost.localdomain>
	 <20080818171500.78590801@lxorguk.ukuu.org.uk>
	 <1219080504.15566.65.camel@localhost.localdomain>
	 <20080818182556.13ced58f@lxorguk.ukuu.org.uk>
	 <1219082097.15566.82.camel@localhost.localdomain>
	 <20080818183540.GA5470@cs.cmu.edu>
	 <1219085176.15566.100.camel@localhost.localdomain>
	 <alpine.DEB.1.10.0808181159400.15109@asgard.lang.hm>
	 <alpine.DEB.1.10.0808191906270.20991@asgard.lang.hm>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 11:15:21 -0400
Message-Id: <1219245321.3389.82.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-19 at 19:44 -0700, david@lang.hm wrote:

> please note that I am trying to state Erics position, I may be mistaken.

you did pretty well.

> He expect AV signatures to change rapidly
>    so storing the results of scans is of very limited value

Not quite.  I believe it should be the responsibility of the scanner to
determine how and if they want to store the results of the scan.  I'm
willing (and want) to provide a simplistic kernel fast path if all of
the scanners agree to use it.

> He is expecting the scanning software to set the policy
>    so there is no reason to have a system/distro defined policy

I'm not sure of the definition of this 'policy' but, yes, I think all
scanners should make their own decisions in their own little bubble.


> I am seeing things (I think) a bit more broadly (definantly differently).
> 
> I think that the availability of a general 'this file was written to' 
> interface in the kernel combined with 'take action before opening' will 
> lead to many uses beyond AV work.

At the moment I'm leaning towards a separate async notification system
for open/mtime change/close which will be a fire and forget notification
system with no access control mechanism.

A second, although very similar, mechanism will block on read/mmap
(although I'm not so sure how to handle O_NONBLOCK without a kernel
fastpath/inode marking that actually gets used, this is really a serious
design issue with putting this at read/mmap.  I don't think we are ready
to give up on O_NONBLOCK for S_ISREG altogether just yet are we?) and
provide access control.  I also plan to include open() in the
blocking/access control based on a /proc tunable.  If applications can't
handle EPERM at read/mmap they can get it at open and suffer the
perf/blocking hit needlessly on open/stat sequences.

> I expect to see IDS type scanners, possibly multiple ones on a machine, 
> each fairly simple and not trying to do a complete job, but authoritative 
> within it's area.
>    this means that the interaction between approvals is more complex and 
> not something that should be coded into the kernel, it should be 
> configured in userspace.

I don't understand how something can be 'authoritative within it's area'
and still have a 'complex interaction policy.'  I see it as, either yes
means yes and no means no, or it isn't authoritative.

If two scanners need some complex interaction it certainly needs to be
in userspace, no question there.  Sounds like a dispatcher daemon needs
to get the notification from the kernel and send them to the scanners
and then let it do all sorts of magic and sprinkling of pixie dust
before the daemon return an answer to the kernel.  In the end that
deamon is the authoritative thing.  I don't plan to write it since I
don't see the need, but the possibility of writing a dispatcher daemon
certainly exists if there is actually need.

Everything says yes at read/mmap we allow.  Anything says no we deny.
You need more than that write an intermediary daemon in userspace to
govern that interaction.

> becouse of things like indexers, backups, and IDS type I see great value 
> in storing the fact that a file was scanned across reboots for some users 
> (other users may not want to trust the system without re-scanning it after 
> a reboot in case the files were changed)

My answer is that if they want to store whatever it is they care about
across boots so the scanner can write an xattr to help.  I believe that
all scanners are going to need/want to have some for of userspace
caching.  I plan to provide a fastpath in kernel scanners can make use
of, but anything more complex should be a completely userspace solution
and should be able to be built on what I provide at a later time.

> Eric has one other significant advantage, he has produced code, and is 
> presumably payed to work on this (based on his posts and @redhat address)

Not paid much   :)

