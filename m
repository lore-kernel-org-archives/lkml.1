Return-Path: <linux-kernel-owner+w=401wt.eu-S1763940AbYEOUM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763940AbYEOUM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbYEOUMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:12:49 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:44095 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbYEOUMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:12:48 -0400
Subject: Re: [RFC][PATCH v2] security:  split proc ptrace checking into
	read vs. attach
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lsm <linux-security-module@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080515193726.GA15111@sergelap.austin.ibm.com>
References: <1210877785.28282.131.camel@moss-spartans.epoch.ncsc.mil>
	 <20080515193726.GA15111@sergelap.austin.ibm.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 15 May 2008 15:45:57 -0400
Message-Id: <1210880757.28282.157.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-15 at 14:37 -0500, Serge E. Hallyn wrote:
> Quoting Stephen Smalley (sds@tycho.nsa.gov):
<snip>
> > Read access to /proc/pid/mem continues to apply a full ptrace attach
> > check since check_mem_permission() already requires the current task
> > to already be ptracing the target.  The other ptrace checks within
> > proc for elements like environ, maps, and fds are changed to pass the
> > read mode instead of attach.
<snip>
> In this particular case, would it be worthwhile to also split
> check_mem_permission or pass it a mode bit?  Note that two of the
> three calls are for read permission only.

I was going to split up the mem checking, but when I noticed that
check_mem_permission() presently always requires current to already be
tracing the target process, I saw no point in distinguishing between the
different modes of access - they all effectively require full ptrace in
the first place.

The other case that might be nice to distinguish is readlink vs.
follow_link, as the latter potentially allows access to objects that
would otherwise be private to the target process (pipes, sockets) or
unreachable by current (files in directories not searchable by current),
as noted by Chris, but I'm not sure how helpful that will be in practice
because most if not all programs that access /proc/pid/fd at all end up
at least stat'ing the fd files even if they never open them, and thus
always hit follow_link.  But SELinux will check those attempts to stat
or open the files at least.

-- 
Stephen Smalley
National Security Agency

