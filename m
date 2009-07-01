Return-Path: <linux-kernel-owner+w=401wt.eu-S1752240AbZGAGb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbZGAGb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 02:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbZGAGbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 02:31:50 -0400
Received: from deleuze.hcoop.net ([69.90.123.67]:42930 "EHLO deleuze.hcoop.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbZGAGbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 02:31:49 -0400
X-Greylist: delayed 1431 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jul 2009 02:31:49 EDT
From: Jeremy Maitin-Shepard <jeremy@jeremyms.com>
To: tuxonice-devel@lists.tuxonice.net
Cc: linux-kernel@vger.kernel.org
Subject: RFC: Suspend-to-ram cold boot protection by encrypting page cache
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Tue, 30 Jun 2009 23:07:50 -0700
Message-ID: <87hbxx0wcp.fsf@jeremyms.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

My current understanding is that there is basically no protection in
Linux against the cold boot attack.  This means that any encryption keys
either in kernel memory or in the page cache, as well as any other data
in the page cache, could be compromised by such an attack.

Of course, hibernating to encrypted swap protects against this risk, but
having to resort to this effectively limits the usefulness of
suspend-to-ram.

I propose the following solution:

Encrypt, in place, the page cache (except for the pages used by a
special userspace helper program) prior to entering S3.  Upon resuming,
the userspace helper program somehow obtains the encryption key used to
encrypt the page cache (possibly by prompting the user for a password,
or reading the key off of some piece of removable hardware) and passes
it to the kernel to use to decrypt the page cache.  Anything in the
kernel that stores encryption keys, such as dm-crypt, would copy its
keys to a special memory area that encrypted using the same key as the
page cache, prior to clearing the keys from their normal memory
locations.

This would presumably be much faster than hibernating, since hibernation
is typically severely limited by disk write speeds.

Specifically, I imagine the following sequence of steps would be taken:

1. Userspace helper is started.

2. Userspace helper specifies to kernel the encryption key to use for
   the page cache.

3. Userspace helper tells kernel to enter S3.

4. Kernel uses freezer to freeze tasks (except userspace helper) exactly
   as is done when hibernating and otherwise does what is needed to
   ensure that nothing will try to access the page cache.

5. Kernel encrypts in place everything in the page cache except the
   pages that are needed by the userspace helper program.

6. Dm-crypt keys and any other encryption keys in the kernel are copied
   to a special memory area and encrypted using the same key as the page
   cache, prior to being cleared from their original memory locations.

7. Kernel suspends devices and enters S3.

<Wakeup from S3>

8. Kernel resumes devices as is normally done when exiting S3.  Tasks
   except the userspace helper should still be frozen at this point.

9. Userspace helper obtains the encryption key (e.g. from the user or a
   removable piece of hardware), and passes it to the kernel.

10. Kernel decrypts page cache and special key storage memory area.

11. Kernel tells dm-crypt and anything else that uses encryption keys in
    the kernel to reinitialize themselves using the keys they stored in
    the special key storage area.

12. Kernel unfreezes tasks.

13. Userspace helper exits.

Note: There is the additional issue of free pages.  The kernel could
zero out these pages at the same time as it is encrypting the page
cache.  The kernel could also just ensure all free pages are zeroed as
they become free.

This proposal doesn't address the issue of kernel memory that might
contain sensitive data (other than specifically the storage of
encryption keys in the kernel).  Perhaps others can comment on where in
kernel memory additional sensitive data might be stored, and how it
might be encrypted (without crashing the system).

Perhaps anyone interested can comment on the viability of this proposal.

Ostensibly, the idea doesn't have anything to do with hibernation.  It
does occur to me, though, that tuxonice may already support much of what
is needed to implement this proposal, and that it might be possible to
implement this with very little additional code added to tuxonice.
Handling dm-crypt keys and other sensitive data in kernel memory might
take more work (and in particular require some discussion about the
proper interface to use), but at least an initial proof-of-concept
implementation that only encrypts the page cache could probably be done
fairly easily.

If this were implemented (and it doesn't seem that it would take all
that much work), it would make Linux the only OS, as far as I know, that
is secure against cold boot attacks while in S3.

-- 
Jeremy Maitin-Shepard
