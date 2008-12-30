Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124AbYL3WqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbYL3WqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 17:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbYL3Wpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 17:45:51 -0500
Received: from ozlabs.org ([203.10.76.45]:35865 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbYL3Wpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 17:45:50 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Helge Deller <deller@gmx.de>
Subject: Re: [PATCH] parisc: fix module loading failure of large kernel modules (take 2)
Date: Wed, 31 Dec 2008 09:15:40 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: "linux-parisc" <linux-parisc@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Randolph Chung <randolph@tausq.org>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       John David Anglin <dave@hiauly1.hia.nrc.ca>
References: <4959346E.7060600@gmx.de>
In-Reply-To: <4959346E.7060600@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812310915.41693.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 December 2008 07:04:54 Helge Deller wrote:
> This is the second take of the patch series.
> Changes to previous version:
> - new CONFIG_HAVE_MODULE_SECTION_STUBS config option
> - put stub entries of a code section in front of the section
> 
> ____________
> The parisc port (esp. the 32bit kernel) currently lacks the ability to
> load large kernel modules like xfs or ipv6. This is a long outstanding
> bug and has already been reported a few times, e.g.:
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=350482,
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=401439,
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=508489
> 
> The symptom is like this:
> # modprobe xfs
> FATAL: Error inserting xfs
> (/lib/modules/2.6.26-1-parisc/kernel/fs/xfs/xfs.ko): Invalid module
> format
> 
> In dmesg:
> module xfs relocation of symbol xfs_btree_read_bufs is out of range
> (0x3ffefffe in 17 bits)
> 
> The reason for the failure is, that the architecture only provides the
> R_PARISC_PCREL17F (for 32bit kernels) and R_PARISC_PCREL22F (for PA2.0
> and 64bit kernels) relocations, which sometimes can't reach the target
> address of the stub entry if the kernel module is too large. Currently
> parisc (like other architectures) creates one big PLT section for all
> stubs at the beginning of the init and core sections.
> 
> The following two patches changes the parisc module loader to put stubs
> for the code sections in front of each section, so that the distance to
> the stubs more easily fits into the available 17/22 bits.

So now any one section has to pass 17 bits to break?  How close are you with
the xfs module?

But it's kind of nasty, overloading sh_entsize further.  Could we instead
do something like add a arch_module_section_size() weak fn which you can
overload?  We'd use that in get_offset() so our layout and size calculations
were correct, and use sh_size everywhere else.

Cheers,
Rusty.
