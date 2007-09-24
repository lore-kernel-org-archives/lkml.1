Return-Path: <linux-kernel-owner+w=401wt.eu-S1764778AbXIXRAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764778AbXIXRAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759478AbXIXRAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:00:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60556 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757561AbXIXRAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:00:16 -0400
Date: Mon, 24 Sep 2007 09:59:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Reuben Farrelly <reuben-linuxkernel@reub.net>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: 2.6.23-rc7-mm1
Message-Id: <20070924095929.76fce85c.akpm@linux-foundation.org>
In-Reply-To: <46F7CF2E.9030609@reub.net>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
	<46F7CF2E.9030609@reub.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 00:52:30 +1000 Reuben Farrelly <reuben-linuxkernel@reub.net> wrote:

> 
> 
> On 24/09/2007 7:17 PM, Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc7/2.6.23-rc7-mm1/
> > 
> > - New git tree git-powerpc-galak.patch added to the -mm lineup: ppc32
> >   things, mainly (Kumar Gala <galak@gate.crashing.org>)
> 
> I'm observing a problem with this kernel (as well as 2.6.23-rc6-mm1) which 
> manifests itself only in my Postfix/application mail.logs:
> 
> Sep 25 00:25:40 tornado postfix/smtp[12520]: fatal: select lock: Cannot allocate 
> memory
> Sep 25 00:25:41 tornado postfix/master[8002]: warning: process 
> /usr/lib64/postfix/smtp pid 12520 exit status 1
> 
> This is happening frequently with processes started via 'master' (smtp, smtpd 
> and cleanup), but it does not appear to have any noticeable operational impact 
> apart from logging a lot of copies of this message.
> 
> The corresponding code in Postfix which triggers this is (choice of 3 files in 
> src/master are all possibilities which all have much the same code)
> 
>      /*
>       * The event loop, at last.
>       */
>      while (var_use_limit == 0 || use_count < var_use_limit || client_count > 0) {
>          if (multi_server_lock != 0) {
>              watchdog_stop(watchdog);
>              if (myflock(vstream_fileno(multi_server_lock), INTERNAL_LOCK,
>                          MYFLOCK_OP_EXCLUSIVE) < 0)
>                  msg_fatal("select lock: %m");
>          }
>          watchdog_start(watchdog);
>          delay = loop ? loop(multi_server_name, multi_server_argv) : -1;
>          event_loop(delay);
>      }
>      multi_server_exit();
> }
> 
> 
> Now I'm not convinced this is an application problem, because I'm only seeing 
> this after running up kernel 2.6.23-rc6-mm1 or 2.6.23-rc7-mm1 and with NO 
> changes to the application itself.  Using the same application binaries it does 
> not occur with 2.6.22 mainline.  [I didn't get a lot of testing with the -mm 
> release prior to that unfortunately due to some other breakage.]
> 
> Is there anything new in the last two or so -mm kernels which could have caused 
> this?
> 
> I've put my .config up at http://www.reub.net/files/kernel/2.6.23-rc7-mm1.config

ug.

Lots of people have been futzing with the fs/locks.c code:

cleanup-macros-for-distinguishing-mandatory-locks.patch
fix-potential-oops-in-generic_setlease-v2.patch
fix-potential-oops-in-generic_setlease.patch
fs-locksc-use-list_for_each_entry-instead-of-list_for_each.patch
git-nfs.patch
git-nfsd.pc
rework-proc-locks-via-seq_files-and-seq_list-helpers-fix-2.patch
rework-proc-locks-via-seq_files-and-seq_list-helpers.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters.patch



