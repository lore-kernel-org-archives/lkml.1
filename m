Return-Path: <linux-kernel-owner+w=401wt.eu-S1752936AbXIDD0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbXIDD0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 23:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbXIDD0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 23:26:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34312 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbXIDD0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 23:26:38 -0400
Date: Tue, 4 Sep 2007 04:26:37 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Pallewatta Mano-FPCD67 <Mano.Pallewatta@motorola.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux-2.6.16.51 gzipped core dump patch
Message-ID: <20070904032637.GY21089@ftp.linux.org.uk>
References: <1188AA083E6C7C4EBCE34803004A84014FE921@de01exm72.ds.mot.com> <20070904013811.GX21089@ftp.linux.org.uk> <1188AA083E6C7C4EBCE34803004A84014FE926@de01exm72.ds.mot.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188AA083E6C7C4EBCE34803004A84014FE926@de01exm72.ds.mot.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2007 at 10:32:00PM -0400, Pallewatta Mano-FPCD67 wrote:
> This patch was developed for embedded systems which had limited space
> for file storage. If an external process is to compress core files you
> will need to store those files somewhere first as core dump output
> cannot be directly fed to the stdin of compression program.

Why?  Create a pipe, start a new process, put the reader struct file
into its descriptor table as stdin, do execve in new process and
pass the writer struct file to ->core_dump().

As the matter of fact, it's already done - see
        lock_kernel();
        ispipe = format_corename(corename, core_pattern, signr);
        unlock_kernel();
        if (ispipe) {
                /* SIGPIPE can happen, but it's just never processed */
                if(call_usermodehelper_pipe(corename+1, NULL, NULL, &file)) {
                        printk(KERN_INFO "Core dump to %s pipe failed\n",
                               corename);
                        goto fail_unlock;
                }
        } else
                file = filp_open(corename,
                                 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
                                 0600);
in do_coredump().  So take a look at fs/exec.c:format_corename() and see
what to feed for it in order to get the equivalent of your patch.
core_patttern is set by sysctl (just say
echo [whatever] >/proc/sys/kernel/core_pattern 
and don't forget quoting, since | should be the first character to indicate
that you want to pipe coredump through a helper).

I really don't see a reason to do that kind of work in the kernel, embedded
system or not.
