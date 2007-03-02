Return-Path: <linux-kernel-owner+w=401wt.eu-S933298AbXCBJee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298AbXCBJee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 04:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933299AbXCBJee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 04:34:34 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59436 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933298AbXCBJed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 04:34:33 -0500
Date: Fri, 2 Mar 2007 10:34:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>, Robin Holt <holt@sgi.com>,
       David Howells <dhowells@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>, Hideo AOKI <haoki@redhat.com>
Subject: Re: [PATCH 1/4] coredump: add an interface to control the core dump routine
Message-ID: <20070302093419.GA2001@elf.ucw.cz>
References: <45E7AAFA.4070402@hitachi.com> <45E7AC6F.8080704@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E7AC6F.8080704@hitachi.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This patch adds an interface to set/reset a flag which determines
> anonymous shared memory segments should be dumped or not when a core
> file is generated.
> 
> /proc/<pid>/coredump_omit_anonymous_shared file is provided to access
> the flag. You can change the flag status for a particular process by
> writing to or reading from the file.

Yes. So, you used very different interface interface from ulimit,
which means locking is hard.

Plus, what you are doing can be done in userspace using google
coredumper.

> +	if (down_write_trylock(&coredump_settings_sem)) {
> +		set_coredump_omit_anon_shared(mm, (val != 0));
> +		up_write(&coredump_settings_sem);
> +	} else
> +		ret = -EBUSY;

Now this is an ugly interface. "If user tries to write to /proc file
while it is locked, return him spurious error.


> @@ -75,6 +77,8 @@ extern int suid_dumpable;
>  #define SUID_DUMP_USER		1	/* Dump as user of process */
>  #define SUID_DUMP_ROOT		2	/* Dump as root */
>  
> +extern struct rw_semaphore coredump_settings_sem;
> +
>  /* Stack area protections */
>  #define EXSTACK_DEFAULT   0	/* Whatever the arch defaults to */
>  #define EXSTACK_DISABLE_X 1	/* Disable executable stacks */

Yep, very nice, if you used interface suited for the task (ulimit),
you'd not have to invent new locking like this.

Anyway, I don't care, and you don't listen. You got the design wrong,
and your code can be done in userspace, anyway. This is "NAK" from me,
but unfortunately I'm not in power to decide this. So at least drop me
from Cc in future submissions.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
