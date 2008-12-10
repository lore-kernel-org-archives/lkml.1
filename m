Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbYLJUB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbYLJUB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 15:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753766AbYLJUBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 15:01:17 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:57614 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbYLJUBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 15:01:17 -0500
Date: Wed, 10 Dec 2008 21:02:42 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       zippel@linux-m68k.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Better way to force a rebuild
Message-ID: <20081210200242.GA15692@uranus.ravnborg.org>
References: <alpine.DEB.1.10.0812101443550.11805@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812101443550.11805@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 02:48:35PM -0500, Steven Rostedt wrote:
> 
> Hi,
> 
> In include/linux/kernel.h I currently have the following lines at the 
> bottom of the file:
> 
> /* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
> #ifdef CONFIG_FTRACE_MCOUNT_RECORD
> # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
> #endif
> 
> 
> This is only there to force a rebuild of all files when 
> CONFIG_FTRACE_MCOUNT_RECORD is modified. Since the modification of that 
> config causes the build to act different, we need to rebuild all C 
> objects. I added the #ifdef in kernel.h as a hack to force the rebuild by 
> the config dependencies used in kbuild.
> 
> My question is, is there a better way to force a full rebuild on a 
> modification of a config?

Why is that hack required in the first place?
We rebuild if:
- target file is missing (not the case here)
- any prerequisite files are newer than target (not the case here)
- any CONFIG_* options used by any prerequisite has changed (not the case here)
  [It is due to your hack]
- gcc changed (not the case here)
- options are added/deleted to gcc (this should be the case for relevant files)


Looking a bit deeper into this.
I see that we have in Makefile.build:

define rule_cc_o_c
        $(call echo-cmd,checksrc) $(cmd_checksrc)                         \
        $(call echo-cmd,cc_o_c) $(cmd_cc_o_c);                            \
        $(cmd_modversions)                                                \
        $(cmd_record_mcount)   

So you want everyting to be rebuild if the command above changes.
That should be doable - and it is indeed a bug that we do not do so.
The integration of record_mcount needs to be improved.


	Sam
