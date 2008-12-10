Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbYLJUL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbYLJUL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 15:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbYLJULT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 15:11:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752501AbYLJULS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 15:11:18 -0500
Date: Wed, 10 Dec 2008 12:10:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: rostedt@goodmis.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu
Subject: Re: Better way to force a rebuild
Message-Id: <20081210121048.6186eaf9.akpm@linux-foundation.org>
In-Reply-To: <20081210200242.GA15692@uranus.ravnborg.org>
References: <alpine.DEB.1.10.0812101443550.11805@gandalf.stny.rr.com>
	<20081210200242.GA15692@uranus.ravnborg.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 21:02:42 +0100
Sam Ravnborg <sam@ravnborg.org> wrote:

> On Wed, Dec 10, 2008 at 02:48:35PM -0500, Steven Rostedt wrote:
> > 
> > Hi,
> > 
> > In include/linux/kernel.h I currently have the following lines at the 
> > bottom of the file:
> > 
> > /* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
> > #ifdef CONFIG_FTRACE_MCOUNT_RECORD
> > # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
> > #endif
> > 
> > 
> > This is only there to force a rebuild of all files when 
> > CONFIG_FTRACE_MCOUNT_RECORD is modified. Since the modification of that 
> > config causes the build to act different, we need to rebuild all C 
> > objects. I added the #ifdef in kernel.h as a hack to force the rebuild by 
> > the config dependencies used in kbuild.
> > 
> > My question is, is there a better way to force a full rebuild on a 
> > modification of a config?
> 
> Why is that hack required in the first place?
> We rebuild if:
> - target file is missing (not the case here)
> - any prerequisite files are newer than target (not the case here)
> - any CONFIG_* options used by any prerequisite has changed (not the case here)
>   [It is due to your hack]
> - gcc changed (not the case here)
> - options are added/deleted to gcc (this should be the case for relevant files)
> 
> 
> Looking a bit deeper into this.
> I see that we have in Makefile.build:
> 
> define rule_cc_o_c
>         $(call echo-cmd,checksrc) $(cmd_checksrc)                         \
>         $(call echo-cmd,cc_o_c) $(cmd_cc_o_c);                            \
>         $(cmd_modversions)                                                \
>         $(cmd_record_mcount)   
> 
> So you want everyting to be rebuild if the command above changes.
> That should be doable - and it is indeed a bug that we do not do so.
> The integration of record_mcount needs to be improved.

Yes, changing the state of CONFIG_CC_OPTIMIZE_FOR_SIZE does exactly
what Steven wants.

But damn me it's hard to work out where and how this is implemented :(
