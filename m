Return-Path: <linux-kernel-owner+w=401wt.eu-S1752404AbXDMIPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbXDMIPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 04:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbXDMIPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 04:15:36 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4387 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbXDMIPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 04:15:33 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Apr 2007 04:15:33 EDT
Message-ID: <7088.213.222.28.155.1176451483.squirrel@webmail.xs4all.nl>
In-Reply-To: <20070412090809.917795000@suse.de>
References: <20070412090809.917795000@suse.de>
Date: Fri, 13 Apr 2007 10:04:43 +0200 (CEST)
Subject: Re: [AppArmor 00/41] AppArmor security module overview
From: "Rob Meijer" <capibara@xs4all.nl>
To: jjohansen@suse.de
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org
Reply-To: capibara@xs4all.nl
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've posted on the subject before, and as noone seemed to truely relate
to the concept I concequently dropped my effords, but as you seem to be half
a step in the general right direction, this may be a good time to bring
it up again.

If instead of 'least privilege' and fat profiles, you would opt for 'least
authority' and (potentialy) thin profiles, this would make the whole also
usable for systems initialy designed with security in mind.
To accomplish such a thing I proposed that the non 'at' family of calls
for filesystems should be considdered to be priviledged operations (within
a least authority context), and the 'at' family of operations should have
invocations with uptree path tokens also be considdered priviledged
(within a least authority context). The non uptree invocations of the 'at'
family
should be considdered unpriviledged, and should thus always be allowed
seperately from any profile.

With this distinction implemented, you could than potentialy use thin
profiles and dynamicly exchange authority by passing along directory
file handles when needed.

Where with the 'least priviledge' approach the profile would need to grant
the each priviledge the application might need, but when you would be able
to use both file handles, socket handles and directory handles as tokens
of authorization that can be comunicated seperately and freely, without
being stopped from being used by least priviledge profiles, the profiles
needed will start out much thiner, and will dynamicly expand to just a
limited subset of the fat least priviledge profile.

I believe that being able to be able to distinguish between the
the least authority (no uptree) usage of open file/dir/socket handles and
other operations is essential. If a profile blocks a program from using
these open file/dir/socket handles in a way not violating least authority
(that is no uptree tokens in at family calls), this would be a major
design flaw.

Rob


On Thu, April 12, 2007 11:08, jjohansen@suse.de wrote:

> AppArmor's Overall Design
> =========================
>
> AppArmor protects systems from vulnerable software by confining
> processes, giving them "least privilege" access to the system's
> resources: with least privilege, processes are allowed exactly what they
> need, nothing more, and nothing less. Systems are thus protected from
> bugs in applications that would lead to privilege escalation, such as
> remote system access because of a buffer overflow in a web server, etc.
>
> AppArmor does this by defining application profiles which list allowed
> accesses, and assigning those profiles to processes. AppArmor does *not*
> require the user to confine all processes on the system.  Rather, you
> need to provide AppArmor profiles for every process that is potentially
> subject to manipulation by the attacker. For instance, to defend against
> network attack, confine all process that access the network.
>
> The corollary to this is that attacks against AppArmor that start with
> "assume some unconfined process does ..." are outside the AppArmor
> threat model. Any process that might do something malicious to an
> AppArmor system should be confined by an AppArmor profile.
>
> The kernel manages many different kinds of resources.  AppArmor
> currently controls access to two key resources among them: files, and
> POSIX Capabilities.  (Additional protection for things like rlimits,
> interprocess communication, and network access are being worked on, and
> are expected to become available in a future version.)
>
>
> File Access Control
> -------------------
>
> Application profiles control file access by pathname: each profile
> contains a list of fully qualified pathnames (potentially containing
> globbing) and associated access modes: read (r), write (w), different
> kinds of execute (ix, Px, px, Ux, ux), create hard-link (l), and memory
> map for execution (m).
>
> For example, the following two rules permit read access to any file
> below /srv/www/htdocs/**.html, and memory map for execution (m), execute
> inheriting the current profile (ix), and read (r) access to
> /usr/sbin/suexec2:
>
>     /srv/www/htdocs/**.html r,
>     /usr/sbin/suexec2 mixr,


