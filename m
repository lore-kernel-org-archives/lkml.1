Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbZLQHzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbZLQHzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 02:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbZLQHzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 02:55:10 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:49102 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbZLQHzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 02:55:09 -0500
Date: Thu, 17 Dec 2009 08:54:16 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Michal Marek <mmarek@suse.cz>, Roland Dreier <rdreier@cisco.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Andrew Isaacson <adi@vmware.com>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: CONFIG_KPROBES=y build requires gawk
Message-ID: <20091217075416.GA4002@merkur.ravnborg.org>
References: <20091216235617.GA12267@hexapodia.org> <adabphy750b.fsf@roland-alpha.cisco.com> <4B29A686.9070603@redhat.com> <ada3a3a6xs6.fsf@roland-alpha.cisco.com> <4B29BA13.7020502@redhat.com> <aday6l25gnm.fsf@roland-alpha.cisco.com> <20091217054524.GA3931@merkur.ravnborg.org> <4B29C81E.2000704@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B29C81E.2000704@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 09:56:46PM -0800, H. Peter Anvin wrote:
> On 12/16/2009 09:45 PM, Sam Ravnborg wrote:
> >>
> >> diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
> >> index 45b20e4..0c46d60 100644
> >> --- a/arch/x86/lib/Makefile
> >> +++ b/arch/x86/lib/Makefile
> >> @@ -5,7 +5,7 @@
> >>  inat_tables_script = $(srctree)/arch/x86/tools/gen-insn-attr-x86.awk
> >>  inat_tables_maps = $(srctree)/arch/x86/lib/x86-opcode-map.txt
> >>  quiet_cmd_inat_tables = GEN     $@
> >> -      cmd_inat_tables = $(AWK) -f $(inat_tables_script) $(inat_tables_maps) > $@ || rm -f $@
> >> +      cmd_inat_tables = LC_ALL=C $(AWK) -f $(inat_tables_script) $(inat_tables_maps) > $@ || rm -f $@
> > 
> > This will result in error messages in english always from awk - no?
> > Some people will care.
> > 
> 
> True, we probably don't want to set LC_MESSAGES.  Which means:
> 
> diff --git a/Makefile b/Makefile
> index 33d4732..357e83b 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -302,6 +302,13 @@ MAKEFLAGS += --include-dir=$(srctree)
>  $(srctree)/scripts/Kbuild.include: ;
>  include $(srctree)/scripts/Kbuild.include
> 
> +# Avoid funny character set dependencies
> +LC_ALL=
> +LC_CTYPE=C
> +LC_COLLATE=C
> +LC_NUMERIC=C
> +export LC_ALL LC_CTYPE LC_COLLATE LC_NUMERIC
> +
>  # Make variables (CC, etc...)
> 
>  AS		= $(CROSS_COMPILE)as
> 
> 
> OK?

We tried something like this some time ago.
I cannot recall the details anymore but I managed to dig out this link:

http://git.kernel.org/?p=linux/kernel/git/torvalds/old-2.6-bkcvs.git;a=commit;h=191ba46a4aceb72f8481c58069b61f5e8cdef1f0

Today IIRC we no longer export the variable CFLAGS_vmlinux.lds.o so this may be a non-issue.
I bring up this only to say that there be some hidden side-effects of manipulating
with LC_*.
Back then I never understood exactly what was wrong - I just did the obvious revert.

One rationale behind the whish to add LC_* back then was to speed up the build.
I recall it had a measureable effect - but memory may trick me here.

	Sam
