Return-Path: <linux-kernel-owner+w=401wt.eu-S1756346AbXF0A6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbXF0A6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 20:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbXF0A6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 20:58:23 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:33552 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbXF0A6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 20:58:22 -0400
Message-ID: <4681B611.1000704@novell.com>
Date: Tue, 26 Jun 2007 17:57:53 -0700
From: Crispin Cowan <crispin@novell.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, Andreas Gruenbacher <agruen@suse.de>,
       James Morris <jmorris@namei.org>, Chris Wright <chrisw@sous-sol.org>,
       linux-security-module@vger.kernel.org, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH try #2] security: Convert LSM into a static interface
References: <20070617135239.GA17689@sergelap> <20070624220903.GB3723@sequoia.sous-sol.org> <Line.LNX.4.64.0706250031350.15974@localhost.localdomain> <200706252237.59226.agruen@suse.de> <11C35822-4E11-4365-BADE-C1AE41F15B50@mac.com> <20070626134712.GA8615@sergelap.austin.ibm.com> <B189F69D-B63E-4EE3-8580-39C8AFA97E5A@mac.com>
In-Reply-To: <B189F69D-B63E-4EE3-8580-39C8AFA97E5A@mac.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> Let's go over the differences between "my fs" and "my LSM", and the
> similarities between "my VM" and "my LSM":  Filesystems don't get
> hooked from virtually every userspace-initiated operation, whereas
> both VMs and LSMs do.  VMs and LSMs attach anonymous state data to a
> large percentage of the allocated objects in the system, whereas
> filesystems allocate their own independent datastructure and use
> that.  Would you want to "rmmod ext3" and then "modprobe ext2" while
> you have an ext2-as-ext3 filesystem *mounted*???  If you want a good
> analogy, that's a better one than the "my fs can't be a module" crap.
>
> This whole discussion boils down to 2 points:
>   1) As currently implemented, no LSM may be safely rmmod-ed
>   2) Someone has submitted a patch which fixes that problem (you can't
> rmmod them at all, so no crashes)
>
> If you really want to do modular LSMs, then you need to submit a patch
> which fixes all the race conditions in LSM removal *without* adding
> much extra overhead.  I'm sure if your solutions works then everyone
> will be much more open to modular LSMs.  I said this before:
Hmmm. You seem to be mostly concerned with safely rmmod'ing modules. In
contrast, my main concern with the proposed patch is that it removes the
ability to *insert* a module.

Consider the use case of joe admin who is running enterprise-supported
RHEL or SLES, and wants to try some newfangled LSM FooSecureMod thingie.
So he grabs a machine, config's selinux=0 or apparmor=0 and loads his
own module on boot, and plays with it. He even likes FooSecure, better
than SELinux or AppArmor, and wants to roll it out across his data center.

Without James's patch, he can do that, and at worst has a tainted
kernel. RH or Novell or his favorite distro vendor can fix that with a
wave of the hand and bless FooSecure as a module. With James's patch, he
has to patch his kernels, and then enterprise support is hopeless, to
say nothing of the barrier to entry that "patch and rebuild kernel" is
more than many admins are willing to do.

So to solve the problem James & Kyle are concerned with, and preserve
user choice, how about we *only* remove the ability to rmmod, and leave
in place the ability to modprobe? Or even easier, LSMs that don't want
to be unloaded can just block rmmod, and simple LSMs that can be
unloaded safely can permit it.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
Director of Software Engineering   http://novell.com
	AppArmor Chat: irc.oftc.net/#apparmor

