Return-Path: <linux-kernel-owner+w=401wt.eu-S1751998AbXCOUhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbXCOUhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 16:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbXCOUhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 16:37:46 -0400
Received: from smtp.osdl.org ([65.172.181.24]:40011 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbXCOUhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 16:37:43 -0400
Date: Thu, 15 Mar 2007 13:37:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Robin Holt <holt@sgi.com>, David Howells <dhowells@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>, Hideo AOKI <haoki@redhat.com>
Subject: Re: [PATCH 0/4] coredump: core dump masking support v4
Message-Id: <20070315133721.ecbec123.akpm@linux-foundation.org>
In-Reply-To: <45E7AAFA.4070402@hitachi.com>
References: <45E7AAFA.4070402@hitachi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Mar 2007 13:41:30 +0900
"Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com> wrote:

> This patch series is version 4 of the core dump masking feature,
> which provides a per-process flag not to dump anonymous shared
> memory segments.

First up, please convince us that this problem cannot be solved in
userspace.  Note that we now support dumping core over a pipe to a
userspace application which can perform filtering such as this (see
Documentation/sysctl/kernel.txt:core_pattern).


Assuming that your argument is successful...

- The unpleasing trylock in proc_coredump_omit_anon_shared_write() is
  there, I believe, to handle the case where a coredump is presently in
  progress.  We don't want to change the filtering rule while the dump is
  happening.

  What I suggest you do instead is to take a copy of
  mm->coredump_omit_anon_shared into a local variable with one single read
  per coredump.  Pass that local down into all the callees which need to
  see it.  That way, no locking is needed.

- These games we're playing with the atomicity of the bitfields in the
  mm_struct need to go away.

  First up, please prepare a standalone patch which removes
  mm_struct.dumpable and adds `unsigned long mm_struct.flags'.  Include a
  comment telling people that they must use atomic bitops (set_bit, clear_bit) on
  mm_struct.flags.

  Reimplement the current three-value dumpable silliness using two or
  three separate flags in mm_struct.flags.  Of course, this design means
  that there will be tiny timing windows where the value of these two or
  three flags have intermediate, invalid states.  Please take care of those
  little windows and document how you did so.  I expect a suitable approach
  would be to set and clear the flags in a suitable order, so that if a
  race _does_ happen, the results are benign.

- Once that is done, you're ready to think about your new functionality. 
  Start out with 

	#define MM_FLAG_COREDUMP_OMIT_ANON_SHARED	(1 << 3)

  or whatever, and it all becomes easy.

- Finally, the code as you have it here is very specific to your specific
  requirement: don't dump shared memory segments.

  But if we're going to implement in-kernel core-dump filtering of this
  nature, we should design it extensibly, even if we don't actually
  implement those extensions at this time.

  Because other people might (reasonably) wish to omit anonymous memory,
  or private mappings, or file-backed VMAs, or whatever.

  So maybe /proc/pid/coredump_omit_anon_shared should become
  /proc/pid/core_dumpfilter, which is a carefully documented bitmask.
