Return-Path: <linux-kernel-owner+w=401wt.eu-S1756288AbYHMQgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbYHMQgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbYHMQgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:36:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbYHMQgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:36:37 -0400
Subject: TALPA - a threat model?  well sorta.
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: andi@firstfloor.org, riel@redhat.com, greg@kroah.com, tytso@mit.edu,
       viro@ZenIV.linux.org.uk, arjan@infradead.org, alan@lxorguk.ukuu.org.uk,
       peterz@infradead.org, hch@infradead.org
Content-Type: text/plain
Date: Wed, 13 Aug 2008 12:36:15 -0400
Message-Id: <1218645375.3540.71.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So after about a week of trying to squeeze information out of
anti-malware companies I'm starting to feel like I can better speak for
their needs (although they probably don't like what I have to say).  I
would like to point out that many enterprises are going to run this
stuff on their machines.  Period.  End of story.  Personally I'd rather
support a clean interface than have to try to support support problems
my customers have when their hacked fragile systems have trouble.

So, what is it that anti-malware companies do?  They scan files.  That's
it.  Many of the arguments they make and marketing speak we hear or
think we hear claim more grandious things.  But from what I've seen they
aren't the real deal.  Most of the security model descriptions that
people on list want actually are framed under the belief that these
products need to or attempt to completely block some class of attacks.
They don't.  If you think they do you need to fix your frame of
reference.  The only class of attacks this interface is supposed to
address is those that can be found by scanning files.  This is NOT an
LSM.  This is NOT an IDS.  This is a file scanner.  There may be all
sorts of marketing material or general beliefs that they provide
security against all sorts of wide and varied threats (and they do),
but in all reality the only threats they provide any help against are
those that can be found by scanning files.  Simple as that.  Some may
argue this isn't "good" security and I'm not going to make a strong
argument to the contrary, I can stand here for days and show cases where
this is highly useful but no one can provide a threat model more than to
say, "we attempt to locate files which may be harmful somewhere in the
digital ecosystem and try to deny access to that data."

It can be easily shown (and I can come up with LOTS of example) that
this is of value.  Lets consider a simple Linux worm:

http://www.ca.com/us/securityadvisor/virusinfo/virus.aspx?id=47869

This worm needs 4 vulnerabilities for it to work and a default RHEL
SELinux policy would likely, although I haven't verified this fact, also
stop the propagation.  I believe that the right way to "fix" this is to
patch your software and to run an LSM.  But notice that 'scanning files'
is also enough to break the chain.  When the download is completed
nothing would be able to execute the file in question since the
anti-malware software would prevent it.  Assuming some new vulnerability
was found to replace one of the patched problems its possible the
anti-malware code could still recognize enough of the binary to stop it.
I'm told by one AV company that they look for 95 Linux-specific threats
composed of 42 trojans and 53 viruses or worms.  At least 2 other
companies specifically stated that they look for malware which targets
Linux systems although didn't give hard numbers.  All three vendors who
have spoken with me also admit that most of their threats are found on
Windows.

I also gave a previous example how file scanning can help with subverted
distro repos.  That one is purely theoretical as opposed to the real
attack shown above, but clearly value can be easily demonstrated.

The value of a file scanning interface is not in stopping active
attacks.  Its in making the Linux platform a more difficult location for
the storage and propagation of bad data.  I think its reasonable to
think that we all agree we don't want to be the preferred hosting
platforms for trojan binaries intended to attack other non-Linux
systems.  Why would one want consciencely choose to leave Linux as a
safe haven for the existence of malware?  Even though the malware is not
attacking the Linux platform do we as the Linux community really want to
be a breeding and hosting ground as long as the costs are not too high?
(yes Ted, I'm talking directly to you here)

Assuming the costs are not too high, we should add this file scanning
subsystem to help prevent the storage and dissemination of malware
across our systems.  If I'm running a hosting company I wouldn't want
people to be able to upload their trojans and host them on my Linux
server even if those trojans will only ever be downloaded by another OS.
We are part of the larger computing ecosystem.  If we can make our
systems inhospitable to malware like data we help ourselves a little,
but the greater computing community a lot.

The real goal is to get files into to some userspace scanner and let
them do whatever they want.  Remember, this isn't a new LSM.  The goal
isn't to provide perfect security.  The goal isn't to stop already
running malicious programs.  The one and only goal is to scan files.  We
should not be considering timing attacks, we should not be considering
processes actively trying to get around the system for small periods of
time.  We should certainly not be considering root processes being able
to sneak things by.  The idea is that a file exists on disk and we want
some userspace program to give a best effort at scanning it.  Yes, we
might be able to prevent a root process from doing bad things, but a bad
root process already won.  

Now costs:

1) Kernel or userspace.  If we actually want a relatively robust
ecosystem of malware storage hardening it needs to be in kernel.  knfsd
makes it plainly obvious that userspace scanners will leave big gaping
holes.  Not to mention there cannot be any checks for files opened by
suid apps in userspace.  And while no specific claims are being made
about intentionally malicious code, putting this in kernel makes
programs which call syscalls directly much more difficult to be used to
circumvent the scanning.

2) I think the "best" time to do scanning is at read and write.  Any
disagreements there?  But what's the cost?  The cost is lots of scanning
and a huge performance hit on concurrent file access.  I'm willing to
put hard numbers behind this, but it does seem quite obvious that open
and close happen a lot less than read and write.  Sure that means
between open and read data may have become bad.  We aren't an LSM.  We
aren't and IDS.  We aren't making solid claims about local system
security.  We are claiming to harden the machine's storage and
propagation of 'bad' files.

3) code maintenance.  I'm here.  Sophos appears to be willing to help
and one of the other AV vendors said they may be willing to commit to
helping with support.  If nothing else we know the AV vendors will hop
to get stuff fixed every time an enterprise distro is about to release
*smile*

I've yet to hear a technical argument against my patch set (although I
do plan some changes like using the audit system and changing the
kernel->userspace interface) Andi pointed out that I completely didn't
consider rawio on the block device but I have decided to just accept
that as a "you've already lost" condition.  I've explained my mmap
support about 10 times, no one has said I'm wrong yet (I assume people
who can't read) keep talking about mmap.

No, this is not a new security system.  This is not some great wonderful
panacea that's going to stop every exploit.  Its a file scanner.  It's
not bad.  It clearly can help.  This isn't just a pipe dream, I've got
code.  Where's the problem?

-Eric

