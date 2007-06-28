Return-Path: <linux-kernel-owner+w=401wt.eu-S1764262AbXF1Guj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764262AbXF1Guj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 02:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760123AbXF1GuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 02:50:24 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:12046 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764149AbXF1GuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 02:50:22 -0400
X-Greylist: delayed 1870 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jun 2007 02:50:21 EDT
Date: Wed, 27 Jun 2007 23:19:11 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Rik van Riel <riel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/3] MAP_NOZERO - implement a new VM_NOZERO/MAP_NOZERO page retirement policy
Message-ID: <20070628061911.GA16986@hexapodia.org>
References: <send-serie.davidel@xmailserver.org.29496.1182912259.1> <4681D37E.2020706@redhat.com> <Pine.LNX.4.64.0706262016080.26540@alien.or.mcafeemobile.com> <4681E52A.8030300@redhat.com> <Pine.LNX.4.64.0706262127300.26540@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706262127300.26540@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.4.2.2i
X-PGP-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-PGP-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 09:32:44PM -0700, Davide Libenzi wrote:
> > Because an SUID program can change its UID back.
> > 
> > At least, one that was SUID root.  OTOH, any
> > program running as root can change UID, so we
> > should probably not allow root to get nonzeroed
> > pages.
> 
> Well, root can in general access the whole system in any case. At the 
> moment, root cannot access othe UIDs pages. Only their own. And this 
> differs from standard security policies where root can access everything.
> Pages used internally by the kernel, cannot be reused by anyone.

But MAP_NOZERO adds a new possible information leak from root out to the
non-root user.  If root does

    setuid(newuid);
    exec(...);
    exit(1);

and there are MAP_NOZERO pages which contain sensitive information,
a process running as newuid would be able to race the exec with
PTRACE_ATTACH and extract the sensitive information.  Without MAP_NOZERO
the information leak is limited to information which was in the setuid
program's address space (and presumably, setuid programs are written to
be careful about such things).

That said, I think I like the idea of MAP_NOZERO.  Could it be
generalized to some kind of "free pool" rather than keyed off of uid?

-andy
