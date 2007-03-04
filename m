Return-Path: <linux-kernel-owner+w=401wt.eu-S1751379AbXCDBDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379AbXCDBDH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 20:03:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbXCDBDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 20:03:06 -0500
Received: from tapsys.com ([72.36.178.242]:35912 "EHLO tapsys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbXCDBDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 20:03:04 -0500
Message-ID: <45EA1AA7.3040902@madrabbit.org>
Date: Sat, 03 Mar 2007 17:02:31 -0800
From: Ray Lee <ray-lk@madrabbit.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ray Lee <madrabbit@gmail.com>
Subject: Re: userspace pagecache management tool
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>	<2c0942db0703031458i540c496fib892240619faa9b2@mail.gmail.com> <20070303153454.6548e562.akpm@linux-foundation.org>
In-Reply-To: <20070303153454.6548e562.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> <wonders about sys_reclaim_dentry(const char *pathname)>

Would there be any other users of it than updatedb? I'm not coming up
with much, but given that I'm not always clever, that doesn't mean much.

<thinks out loud...> A hypothetical on-demand file virus scanner is
going to hit already cached or about-to-be-cached entries by definition.
Perhaps some system audit daemon, such as tripwire. Well, that has the
same access patterns as updatedb, doesn't it: a directory at a time.
find, cp -a, the same.

So instead of sys_reclaim_dentry, how about extending fadvise to work on
the fd returned via opendir? And extending POSIX_FADV_NOREUSE on a file
fd to drop the dentry at close?

(Call me chicken; I just don't want to be the guy suggesting a new
syscall for a single or few users.)

 ~ ~

Alternately, there have been requests for a way for userspace to get
notification of all file events for indexing of data and metadata
(inotify, unfortunately, doesn't scale to a full filesystem). (cf.
http://lkml.org/lkml/2006/9/30/98 .) That'd allow an updatedb daemon to
keep the index up to date all the time, amortizing the cost. More
usefully, it'd allow a content indexing daemon to stay up to date all
the time, though inotify mostly works for those, I suppose.

(Hmm...
	ray@phoenix:~$ find ~ -type d | wc -l
	14067

...right. So it probably works fine for normal people.)

Hey, waitaminute. This should be a solved problem? SELinux must have
some sort of requirement for logging file access attempts. Google, at
least, implies so. Perhaps whatever it implements could be lifted into
the core kernel without dragging the rest behind it.

Dunno. Who do we CC?

Ray
