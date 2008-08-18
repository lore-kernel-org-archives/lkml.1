Return-Path: <linux-kernel-owner+w=401wt.eu-S1764812AbYHRTeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764812AbYHRTeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760372AbYHRTcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:32:50 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:55321 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760341AbYHRTcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:32:47 -0400
Date: Mon, 18 Aug 2008 15:32:26 -0400
From: Jan Harkes <jaharkes@cs.cmu.edu>
To: Eric Paris <eparis@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, tvrtko.ursulin@sophos.com,
       Theodore Tso <tytso@mit.edu>, davecb@sun.com, david@lang.hm,
       Adrian Bunk <bunk@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, Casey Schaufler <casey@schaufler-ca.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro
	to a linux interface for on access scanning
Message-ID: <20080818193226.GA22162@cs.cmu.edu>
Mail-Followup-To: Eric Paris <eparis@redhat.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, tvrtko.ursulin@sophos.com,
	Theodore Tso <tytso@mit.edu>, davecb@sun.com, david@lang.hm,
	Adrian Bunk <bunk@kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	malware-list@lists.printk.net,
	Casey Schaufler <casey@schaufler-ca.com>,
	Arjan van de Ven <arjan@infradead.org>
References: <20080818153212.6A6FD33687F@pmx1.sophos.com> <1219076143.15566.39.camel@localhost.localdomain> <20080818171500.78590801@lxorguk.ukuu.org.uk> <1219080504.15566.65.camel@localhost.localdomain> <20080818182556.13ced58f@lxorguk.ukuu.org.uk> <1219082097.15566.82.camel@localhost.localdomain> <20080818183540.GA5470@cs.cmu.edu> <1219085176.15566.100.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219085176.15566.100.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 02:46:16PM -0400, Eric Paris wrote:
> On Mon, 2008-08-18 at 14:35 -0400, Jan Harkes wrote:
> > The devil is in the details, and besides everyone trying to heap other
> > things on, one thing that keeps getting brought up, and seemingly keeps
> > getting ignored is the fact that there already is a perfectly reasonable
> > interface to pass file system events (open, close, read, write, etc) to
> > userspace applications in the form of FUSE which has already in some
> > ways solved issues wrt. subtle deadlocks that can happen when you bounce
> > from an in-kernel context to a userspace application.
> 
> Can you help me write/prototype something that will work for every
> regular file anywhere on the system including the kernel binary
...

Going back to your own email,

| From: Eric Paris <eparis@redhat.com>
| Date: Wed, 13 Aug 2008 12:36:15 -0400
| Message-Id: <1218645375.3540.71.camel@localhost.localdomain>
| Subject: TALPA - a threat model?  well sorta.
...
| The value of a file scanning interface is not in stopping active
| attacks.  Its in making the Linux platform a more difficult location for
| the storage and propagation of bad data.  I think its reasonable to
| think that we all agree we don't want to be the preferred hosting
| platforms for trojan binaries intended to attack other non-Linux
| systems.  Why would one want consciencely choose to leave Linux as a
| safe haven for the existence of malware?  Even though the malware is not
| attacking the Linux platform do we as the Linux community really want to
| be a breeding and hosting ground as long as the costs are not too high?
...

This is the threat model I addressed in my email. So now you change the
model to something where the malware is in fact attacking the Linux
platform? Well ok, I'll bite.

> in /boot, the glibc libraries in /lib/ld-linux.so, /sbin/ldconfig and
> every file on every USB stick you put into the machine?  When all of
> these are on separate partitions?  Every file under / needs to be
> exported to the scanner.  I'm very willing to believe fuse is the way to
> go for an HSM, but I don't see how to get every single file on the
> system through the FUSE based scanner.

Have a modified initrd which contains fuse and the scanner and when
mounting the root file system also start the scanner + fuse mount, and
then instead of pivoting into the root-fs, pivot into the fuse mounted
one.

Of course that doesn't yet deal with non-root disks or external devices
that are mounted later on. This would require a modified mount sequence
so that the mount action is completed by a daemon that is running in the
trusted root next to the scanning process so that the new mountpoint is
correctly placed underneath the scanning layer. Maybe it it possible to
start a new fuse/scanning process for every mount as well, but then you
may get some things scanned multiple times because the scanner in the
lower layer ends up having to verify/validate the actions of the
scanners in higher layers.

But at some point it really is just an excerise in who or what you
trust. Because if you at least are willing to trust that the root disk
has not been compromised and the system is allowed to boot then it
would be possible to modify just the mount binary to mount the untrusted
file system in a place that is not accessible for non-priviledged users
and mount the fuse loopback in the requested location. And because mount
is modified it can 'pretend' there is no fuse layer when it updates
/etc/mtab.

As you can tell, in my scenario I do need a modified mount binary and
possibly modified initrd depending on the level of paranoia.

> You're absolutely right about this thread droning on.  But I've got code
> that solves the problems.  If someone else shows me better code rather
> than talk I'm all for it!

Not sure if it is better code, I just happened to see it while looking
if I could find the example fuse loopback filesystem code on-line, but
here you go,

    http://clamfs.sourceforge.net/

Jan
