Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbYBQWtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbYBQWtH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 17:49:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbYBQWsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 17:48:53 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:59065 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbYBQWsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 17:48:51 -0500
Date: Sun, 17 Feb 2008 16:48:51 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: charles.kirsch@internet.lu
Cc: serue@us.ibm.com, Andrew Morgan <morgan@kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Gerald Combs <gerald@wireshark.org>,
       Gilbert Ramirez <gram@alumni.rice.edu>, Guy Harris <guy@alum.mit.edu>
Subject: Re: Possible problem in linux file posix capabilities
Message-ID: <20080217224851.GA9168@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting charles.kirsch@internet.lu (charles.kirsch@internet.lu):
> Hello,
> I'm not sure it is you the right person to contact.
> I tried to run latest normal user wireshark with SUID dumpcap without success 
> under linux-2.6.24.2. After looking around it seems to be related to the file 
> in the kernel security/commoncap.c
> Inside function cap_task_kill (sorry I did not create a diff) I'm wondering if 
> the check is correct:
>         /*
>          * Running a setuid root program raises your capabilities.
>          * Killing your own setuid root processes was previously
>          * allowed.
>          * We must preserve legacy signal behavior in this case.
>          */
>          if (p->euid == 0 && p->uid == current->uid)
>                 return 0;
> 
> Should this check not be:
>         if (p->suid == 0 && p->uid == current->uid)
>                 return 0;
> 
> At least if I change this statement, wireshark runs correctly with as normal 
> user.
> For explanation: during capture, wireshark spins a new suid process called 
> dumpcap. To stop capture, wireshark sends SIGUSR1 to dumpcap. Hower, without 
> changing the line, kill fails with EPERM.
> 
> Thanks for your consideration.
> Kind Regards,
> Charles

Hi Charles,

thanks for the report.  Interesting.  I just downloaded the wireshark
source and as I suspected it's using capabilities.  The problem then is
that the helper starts as setuid root, sets just the capabilities it
needs, then changes back to it's original userid.  It's actually what
we'd like people to be doing.  But they then rely upon the traditional
setuid behavior of the unprivileged process being able to kill the
privileged one.  This is why checking suid instead of euid at
cap_task_kill() works for you.

Two quick fixes for you right now (apart from the one you've already
got :)  would be

	1. give wireshark cap_kill, by doing something like

		capset cap_kill=ep /bin/wireshark

	2. compile a kernel with SECURITY_FILE_CAPABILITIES=n

Andrew, this pretty much was bound to happen...  we need to figure out
what our approach here should be.  My preference is still to allow
signals when p->uid==current->uid so long as !SECURE_NOROOT.  Then as
people start using secure_noroot process trees they at least must know
what they're asking for.

An alternative stance is to accept these things as they come up and try
to quickly work with the authors of such programs to work around it.  I
suppose in a security sense that's the superior way :)  But it also
seems likely to lead to most people choosing option 2 above and not
bothering to fix the problem.

thanks,
-serge
