Return-Path: <linux-kernel-owner+w=401wt.eu-S1762972AbXFRMrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762972AbXFRMrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 08:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761680AbXFRMra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 08:47:30 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:39609 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752661AbXFRMr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 08:47:28 -0400
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
	pathname matching
From: Stephen Smalley <sds@tycho.nsa.gov>
To: casey@schaufler-ca.com
Cc: Greg KH <greg@kroah.com>, Crispin Cowan <crispin@novell.com>,
       Andreas Gruenbacher <agruen@suse.de>, Pavel Machek <pavel@ucw.cz>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <44036.5340.qm@web36611.mail.mud.yahoo.com>
References: <44036.5340.qm@web36611.mail.mud.yahoo.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 18 Jun 2007 08:47:14 -0400
Message-Id: <1182170834.7236.12.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 13:43 -0700, Casey Schaufler wrote:
> --- Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > On Fri, 2007-06-15 at 11:01 -0700, Casey Schaufler wrote:
> > > --- Greg KH <greg@kroah.com> wrote:
> > > 
> > > 
> > > > A daemon using inotify can "instantly"[1] detect this and label the file
> > > > properly if it shows up.
> > > 
> > > In our 1995 B1 evaluation of Trusted Irix we were told in no
> > > uncertain terms that such a solution was not acceptable under
> > > the TCSEC requirements. Detection and relabel on an unlocked
> > > object creates an obvious window for exploitation. We were told
> > > that such a scheme would be considered a design flaw.
> > > 
> > > I understand that some of the Common Criteria labs are less
> > > aggressive regarding chasing down these issues than the NCSC
> > > teams were. It might not prevent an evaluation from completing
> > > today. It is still hard to explain why it's ok to have a file
> > > that's labeled incorrectly _even briefly_. It is the systems
> > > job to ensure that that does not happen.
> > 
> > Um, Casey, he is talking about how to emulate AppArmor behavior on a
> > label-based system like SELinux,
> 
> Yes. What I'm saying (or trying to) is that such an implementation
> would be flawed by design.
> 
> > not meeting B1 or LSPP or anything like that
> > (which AppArmor can't do regardless).
> 
> We're not talking about an implementation based on AppArmor. As
> you point out, we're talking about implementing name based access
> control as an extension of SELinux.

We're talking about emulating pathname-based security on SELinux.
Pathname-based security is inherently non-tranquil (names can change at
any time) and ambiguous (a single name may refer to different objects in
different namespaces, multiple names may refer to the same object in a
single namespace), and thus cannot possibly meet information flow  /
classical confinement requirements.  So using restorecond as the basis
for such an emulation loses nothing from what you already had.  Using
restorecond as the fundamental basis for the security of SELinux itself
would be a bad thing, agreed.

> > As far as general issue
> > goes, if your policy is configured such that the new file gets the most
> > restrictive label possible at creation time and then the daemon relabels
> > it to a less restrictive label if appropriate, then there is no actual
> > window of exposure.
> 
> Is it general practice to configure policy such that "the new file gets
> the most restrictive label possible at creation time"? I confess that
> my understanding of the current practice in policy generation is based
> primarily on a shouted conversation in a crowded Irish pub.
> 
> > Also, there is such a daemon, restorecond, in SELinux (policycoreutils)
> > although we avoid relying on it for anything security-critical
> > naturally.
> 
> Yes, I am aware of restorecond. I find the need for restorecond troubling.

Understand that we view it as a method of last resort, only to be
considered after trying first to:
1) Configure policy transparently to label the file correctly at
creation time (based on the creating process' label, the parent
directory label, and the kind of file), or if that fails,
2) Modify the library or application code to label the file correctly at
creation time (e.g. when multiple files that should be protected
differently are created by the same process in the same directory,
e.g. /etc/passwd vs. /etc/shadow).

> > And one could introduce the named type transition concept
> > that has been discussed in this thread without much difficulty to
> > selinux.
> 
> Yup, I see that once you accept the notion that it is OK for a
> file to be misslabeled for a bit and that having a fixxerupperd
> is sufficient it all falls out.

I think you misunderstand what I mean by named type transition here -
that is a reference to earlier discussions in this thread on extending
the SELinux type_transition statements to let the kernel directly label
new files based not only on creating process and parent directory label
but also the last component name.  With such an extension, SELinux could
directly distinguish e.g. /etc/shadow from /etc/passwd at file creation
time in the kernel without needing anything like restorecond in
userspace.  There is no temporary mislabeling with such a mechanism.

-- 
Stephen Smalley
National Security Agency

