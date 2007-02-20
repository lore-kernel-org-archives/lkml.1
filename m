Return-Path: <linux-kernel-owner+w=401wt.eu-S932870AbXBTK6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870AbXBTK6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 05:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932876AbXBTK6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 05:58:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932870AbXBTK6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 05:58:40 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <45DAC32B.4030603@hitachi.com> 
References: <45DAC32B.4030603@hitachi.com>  <45D5B483.3020502@hitachi.com> <45D5B2E3.3030607@hitachi.com> <20368.1171638335@redhat.com> 
To: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
Cc: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Robin Holt <holt@sgi.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: Re: [PATCH 3/4] coredump: ELF-FDPIC: enable to omit anonymous shared memory 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 20 Feb 2007 10:58:17 +0000
Message-ID: <18826.1171969097@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kawai, Hidehiro <hidehiro.kawai.ez@hitachi.com> wrote:

> Core dumping is separated two phases, one is the phase of writing
> headers, the other is the phase of writing memory segments.  If the
> coredump_omit_anon_shared setting is changed between these two phases,
> a corrupted core file will be generated because the offsets written
> in headers don't match their bodies.  So we need to use the same
> setting in both phases.

Hmmm...  Okay.

> I think that locking makes codes complex and generates overhead.
> So I wouldn't like to use lock as far as possible.  I think passing
> the flag as an extra argument is the simplest implementation to
> avoid the core file corruption.

Actually, I don't think the locking is that hard or that complex.

	int do_coredump(long signr, int exit_code, struct pt_regs * regs)
	{
		<setup vars>

		down_read(&coredump_settings_sem);

		...

	fail:
		up_read(&coredump_settings_sem);
		return retval;
	}

And:

	static ssize_t proc_coredump_omit_anon_shared_write(struct file *file,
						    const char __user *buf,
						    size_t count,
						    loff_t *ppos)
	{
		<setup vars>

		down_write(&coredump_settings_sem);

		...

	out_no_task:
		up_write(&coredump_settings_sem);
		return ret;
	}

The same could be applied to all controls that change the coredumping
variables, in particular the sysctl for core_pattern could be wrapped so as to
remove one of the reliances on lock_kernel() and the lock_kernel pair could be
removed from do_coredump().

David
