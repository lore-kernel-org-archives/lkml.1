Return-Path: <linux-kernel-owner+w=401wt.eu-S933874AbZJNUQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933874AbZJNUQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 16:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933819AbZJNUQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 16:16:06 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:31686 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933731AbZJNUQD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 16:16:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=R6g2EfJA81P8QSHWF+55E/rnFJcc/TDy4LsWILFzjkNgypkVwKlztpBUzPIECYgUBM
         N3XY/CdJr/Pw4YdyxLXwSqvb5We4X9kZrUE1aO+03mvmcH1GYlnctkH7Zfs19niJzsc7
         AGXTfzdla87BVT9IB00fRClIINyX6u1Xqd2SY=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20091014173448.GA18178@us.ibm.com>
References: <20091014173448.GA18178@us.ibm.com>
Date: Wed, 14 Oct 2009 22:14:56 +0200
Message-ID: <cfd18e0f0910141314w917be6dr3518500146658e0f@mail.gmail.com>
Subject: Re: [PATCH] define convenient securebits masks for prctl users
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Morgan <morgan@kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Serge,

Comments below. (Sorry, I could have made most of these comments on
the earlier version of the patch, but was in a hurry, and missed
noticing them.)

On Wed, Oct 14, 2009 at 7:34 PM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> The securebits are used by passing them to prctl with the
> PR_{S,G}ET_SECUREBITS commands.  But the defines must be
> shifted to be used in prctl, which begs to be confused and
> misused by userspace.  So define some more convenient
> values for userspace to specify.  This way userspace does
>
>        prctl(PR_SET_SECUREBITS, SECBIT_NOROOT);
>
> instead of
>
>        prctl(PR_SET_SECUREBITS, 1 << SECURE_NOROOT);
>
> Note that I'm shortcutting SECBIT_NOROOT_LOCKED to set
> (1 << SECURE_NOROOT | 1 << SECURE_NOROOT_LOCKED).

I don't think this is a good idea. Here you are defining a kind of
policy about how these bits will be used. It also invites some
confusion, since we have similarly named constants that result in
different semantics. I think it would be better to split these out,
and have SECBIT_NOROOT_LOCKED mean just SECURE_NOROOT_LOCKED, etc.

> Thanks to Michael for the idea.
>
> This patch also adds include/linux/securebits to the installed headers.
> Then perhaps it can be included by glibc's sys/prctl.h.
>
> Changelog:
>        Oct 14: As suggested by Michael Kerrisk, don't
>                use SB_* as that convention is already in
>                use.  Use SECBIT_ prefix instead.
>
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> Acked-by: Andrew G. Morgan <morgan@kernel.org>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> Cc: Ulrich Drepper  <drepper@redhat.com>
> ---
>  include/linux/Kbuild       |    1 +
>  include/linux/securebits.h |   23 ++++++++++++++++-------
>  2 files changed, 17 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/Kbuild b/include/linux/Kbuild
> index 3e8bd18..94fe9f7 100644
> --- a/include/linux/Kbuild
> +++ b/include/linux/Kbuild
> @@ -328,6 +328,7 @@ unifdef-y += scc.h
>  unifdef-y += sched.h
>  unifdef-y += screen_info.h
>  unifdef-y += sdla.h
> +unifdef-y += securebits.h
>  unifdef-y += selinux_netlink.h
>  unifdef-y += sem.h
>  unifdef-y += serial_core.h
> diff --git a/include/linux/securebits.h b/include/linux/securebits.h
> index d2c5ed8..5aae9b3 100644
> --- a/include/linux/securebits.h
> +++ b/include/linux/securebits.h
> @@ -1,6 +1,13 @@
>  #ifndef _LINUX_SECUREBITS_H
>  #define _LINUX_SECUREBITS_H 1
>
> +/* Each securesetting is implemented using two bits. One bit specifies
> +   whether the setting is on or off. The other bit specify whether the
> +   setting is locked or not. A setting which is locked cannot be
> +   changed from user-level. */
> +#define issecure_mask(X)       (1 << (X))
> +#define issecure(X)            (issecure_mask(X) & current_cred_xxx(securebits))
> +
>  #define SECUREBITS_DEFAULT 0x00000000
>
>  /* When set UID 0 has no special privileges. When unset, we support
> @@ -12,6 +19,10 @@
>  #define SECURE_NOROOT                  0
>  #define SECURE_NOROOT_LOCKED           1  /* make bit-0 immutable */
>
> +#define SECBIT_NOROOT          (issecure_mask(SECURE_NOROOT))
> +#define SECBIT_NOROOT_LOCKED   (issecure_mask(SECURE_NOROOT) | \
> +                                issecure_mask(SECURE_NOROOT_LOCKED))
> +
>  /* When set, setuid to/from uid 0 does not trigger capability-"fixup".
>    When unset, to provide compatiblility with old programs relying on
>    set*uid to gain/lose privilege, transitions to/from uid 0 cause
> @@ -19,6 +30,11 @@
>  #define SECURE_NO_SETUID_FIXUP         2
>  #define SECURE_NO_SETUID_FIXUP_LOCKED  3  /* make bit-2 immutable */
>
> +#define SECBIT_NO_SUID_FIXUP   (issecure_mask(SECURE_NO_SETUID_FIXUP))
> +#define SECBIT_NO_SUID_FIXUP_LOCKED \
> +                               (issecure_mask(SECURE_NO_SETUID_FIXUP) | \
> +                                issecure_mask(SECURE_NO_SETUID_FIXUP_LOCKED))

Please s/SUID/SETUID/ -- keep the names of the constants consistent.
People can afford to type the two extra letters. But they will be
puzzled by inconsistency.

> +
>  /* When set, a process can retain its capabilities even after
>    transitioning to a non-root user (the set-uid fixup suppressed by
>    bit 2). Bit-4 is cleared when a process calls exec(); setting both
> @@ -27,13 +43,6 @@
>  #define SECURE_KEEP_CAPS               4
>  #define SECURE_KEEP_CAPS_LOCKED                5  /* make bit-4 immutable */

I know they may be less often used, but for consistency, I think ther
should be SECBIT_* constants for KEEP_CAPS too. There's no good reason
*not* to do this, AFAICT.

Cheers,

Michael



> -/* Each securesetting is implemented using two bits. One bit specifies
> -   whether the setting is on or off. The other bit specify whether the
> -   setting is locked or not. A setting which is locked cannot be
> -   changed from user-level. */
> -#define issecure_mask(X)       (1 << (X))
> -#define issecure(X)            (issecure_mask(X) & current_cred_xxx(securebits))
> -
>  #define SECURE_ALL_BITS                (issecure_mask(SECURE_NOROOT) | \
>                                 issecure_mask(SECURE_NO_SETUID_FIXUP) | \
>                                 issecure_mask(SECURE_KEEP_CAPS))
> --
> 1.6.1
>
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/
