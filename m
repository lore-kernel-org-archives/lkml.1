Return-Path: <linux-kernel-owner+w=401wt.eu-S1752896Ab0AHLhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab0AHLhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 06:37:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797Ab0AHLhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 06:37:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60650 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab0AHLhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 06:37:12 -0500
Date: Fri, 8 Jan 2010 09:36:57 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Jamie Iles <jamie.iles@picochip.com>
Cc: linux-kernel@vger.kernel.org, Jamie Iles <jamie@jamieiles.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf symbols: don't use modules or try vmlinux unless
	needed
Message-ID: <20100108113657.GE12660@ghostprotocols.net>
References: <1262600634-6628-1-git-send-email-jamie.iles@picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262600634-6628-1-git-send-email-jamie.iles@picochip.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 04, 2010 at 10:23:54AM +0000, Jamie Iles escreveu:
> Commit 75be6cf (perf symbols: Make symbol_conf global) does what it says
> on the tin, but also initialises the member fields use_modules and
> try_vmlinux_path to true rather than the 'false' value they would have
> had when symbol_conf was static.
> 
> When there is no vmlinux on the system and modules loaded, perf top will
> not show any kernel symbols and perf report will only list raw IP's
> rather than symbol names. Unloading the modules will allow perf to give
> normal output.
> 
> Restore previous behaviour by initialising these fields to false.

James,

	I just tried using perf top here in such conditions:

[root@ana ~]# strace -e open -o /tmp/perf.open.strace perf top
------------------------------------------------------------------------
   PerfTop:      65 irqs/sec kernel:64.6% [1000Hz cycles], (all, 2 CPUs)
------------------------------------------------------------------------

             samples  pcnt function           DSO
             _______ _____ __________________ _________________

               12.00  7.0% format_decode      [kernel.kallsyms]
               10.00  5.8% __strstr_ia32      /lib/libc-2.11.so
                9.00  5.3% read_hpet          [kernel.kallsyms]
                7.00  4.1% module_get_kallsym [kernel.kallsyms]
                5.00  2.9% vsnprintf          [kernel.kallsyms]
                5.00  2.9% __memchr           /lib/libc-2.11.so
/usr/lib/libgtk-x11-2.0.so.0.1800.5.#prelink#.aAFN89 was updated,
restart the long running apps that use it!

[root@ana ~]# grep vmlinux /tmp/perf.open.strace 
open("vmlinux", O_RDONLY|O_LARGEFILE)   = -1 ENOENT (No such file or directory)
open("/boot/vmlinux", O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
open("/boot/vmlinux-2.6.31.9-174.fc12.i686", O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
open("/lib/modules/2.6.31.9-174.fc12.i686/build/vmlinux", O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)
open("/usr/lib/debug/lib/modules/2.6.31.9-174.fc12.i686/vmlinux", O_RDONLY|O_LARGEFILE) = -1 ENOENT (No such file or directory)

And it is resolving the kernel symbols.

Maybe some changes I made that aren't yet in Ingo's tree or upstream
fixed it, can you please try after those patches are merged?

- Arnaldo
