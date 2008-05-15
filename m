Return-Path: <linux-kernel-owner+w=401wt.eu-S1764756AbYEOVC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764756AbYEOVC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 17:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYEOVCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 17:02:20 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:22415 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbYEOVCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 17:02:19 -0400
Date: Thu, 15 May 2008 13:58:40 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: murtuja bharmal <murtuja_bharmal@yahoo.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: Kbuild Makefile output
Message-ID: <20080515205840.GA814@mail.oracle.com>
Mail-Followup-To: murtuja bharmal <murtuja_bharmal@yahoo.com>,
	Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
	linux-kbuild <linux-kbuild@vger.kernel.org>
References: <20080515174222.GB24024@uranus.ravnborg.org> <818830.6509.qm@web95109.mail.in2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <818830.6509.qm@web95109.mail.in2.yahoo.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 07:31:31PM +0100, murtuja bharmal wrote:
> But now the problem is lots of file included in kernel
> module, compiled twice or even more then twice for
> user space (whithou kernel flag set) and kernel space
> as well.
> 
> Previously in 2.4 we use to put all output object file
> in different directories for kernel module and user
> binaries based on their compilation Flags.
> 
> Now after attaching kbuild makefile with this system,
> kbuild make all object file in source directory itself
> becasue of that userspace makefiles not able to
> compile those file again. Because one object file is
> already there by kbuild. So I am not able create
> userspace binary.

Two solutions.

1) Have the build name the output files appropritately.  That is,
compile foo.c to foo-kernel.o and foo-userspace.o.  Then link as needed.
The makefile dependencies Just Work.

2) Better - create a kbuild symlink farm.  That is, lay out your sources
however you want, but in a single directory that is not the parent put
your kbuild makefile.  Have it symlink all .c files for kernel building
into this directory.

toplevel
	dir1
		Makefile
		foo.c
	dir2
		Makefile
		bar.c
	dir3
		Makefile
		baz.c
	kbuild
		Makefile

The kbuild/Makefile does something like:

obj-$(CONFIG_MYMODULE) += mymodule.o
mymodule-objs := foo.o bar.o baz.o
mymodule-sources = $(patsubst %.o,%.c,$(mymodule-objs))

obj-sources = $(foreach obj,$(mymodule-sources),$(wildcard ../*/$(obj)))

$(mymodule-sources): $(obj-sources)
	for f in $(obj-sources); do	\
	  -ln -s $$f .;			\
	done

Joel

-- 

Life's Little Instruction Book #232

	"Keep your promises."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
