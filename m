Return-Path: <linux-kernel-owner+w=401wt.eu-S1753081Ab0AROYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab0AROYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 09:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505Ab0AROYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 09:24:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:57132 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab0AROYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 09:24:33 -0500
Date: Mon, 18 Jan 2010 12:24:14 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-perf-users@vger.kernel.org
Subject: Re: Bad kernel mmap in perf
Message-ID: <20100118142414.GA9423@ghostprotocols.net>
References: <20100117231345.GJ5035@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100117231345.GJ5035@nowhere>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 18, 2010 at 12:13:46AM +0100, Frederic Weisbecker escreveu:
> Hi!
> 
> That doesn't look related to my previous problem,
> but I get another trouble:
> 
> $ sudo ./perf sched record
> Couldn't record kernel reference relocation symbol.
> 
> After investigating a bit, it looks like we ask
> event__synthesize_kernel_mmap() to find the kernel text
> mapping boudaries starting from the _text symbol.

Its not exactly to get the kernel boundaries, it could be any symbol that is
present everywhere, we'll just look at where it was at 'perf record' time and
then at 'perf report' time, when we may be using a vmlinux file, where the
values may not be the same due to relocation performed by things like kexec.

Look at:

        dso__load_sym() 
                perf_session__reloc_vmlinux_maps()

> But I don't have _text in /proc/kallsyms, instead I
> have _stext.
> 
> I'm not sure what's the difference between both, looks like
> between _text and _stext I'm supposed to have boot code? (which
> is then unlikely to be used by perf).
> 
> That said the following patch fixes the issue, does that look
> sane to you?

yes, read more below

> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 7bb9ca1..49492f4 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -569,7 +569,7 @@ static int __cmd_record(int argc, const char **argv)
>  	}
>  
>  	err = event__synthesize_kernel_mmap(process_synthesized_event,
> -					    session, "_text");
> +					    session, "_stext");

Its a good thing we encode the symbol name in the kernel MMAP fake event :-)

We need to find one symbol that is present in all arches, or use a fallback
mechanism to pick one present at 'perf record' time.

Checking here I have "_text" and "_stext" on two 32-bit machines:

[root@filo ~]# uname -a
Linux filo.ghostprotocols.net 2.6.30.10-105.fc11.i586 #1 SMP Thu Dec 24 16:26:26 UTC 2009 i686 athlon i386 GNU/Linux
[root@filo ~]# grep -w _text /proc/kallsyms 
c0400000 T _text
[root@filo ~]# grep -w _stext /proc/kallsyms 
c04010f0 T _stext
[root@filo ~]#

[acme@ana Downloads]$ uname -a
Linux ana.ghostprotocols.net 2.6.31.9-174.fc12.i686 #1 SMP Mon Dec 21 06:24:20 UTC 2009 i686 i686 i386 GNU/Linux
[acme@ana Downloads]$ grep -w _text /proc/kallsyms 
c0400000 T _text
[acme@ana Downloads]$ grep -w _stext /proc/kallsyms 
c04010e8 T _stext
[acme@ana Downloads]$

Also on ppc64:

[acme@bombadil ~]$ cat /etc/fedora-release 
Fedora release 11 (Leonidas)
[acme@bombadil ~]$ uname -a
Linux bombadil.infradead.org 2.6.30.9-90.fc11.ppc64 #1 SMP Sat Oct 17 11:12:20 EDT 2009 ppc64 ppc64 ppc64 GNU/Linux
[acme@bombadil ~]$ grep -w _text /proc/kallsyms 
c000000000000000 T _text
[acme@bombadil ~]$ grep -w _stext /proc/kallsyms 
c000000000000000 T _stext
[acme@bombadil ~]$

And on parisc64:

acme@parisc:~$ cat /etc/debian_version 
squeeze/sid
acme@parisc:~$ uname -a
Linux parisc 2.6.33-rc4-tip+ #3 SMP Sat Jan 16 15:26:28 BRST 2010 parisc64 GNU/Linux
acme@parisc:~$ grep -w _text /proc/kallsyms 
0000000040100000 A _text
acme@parisc:~$ grep -w _stext /proc/kallsyms 
0000000040100000 T _stext
acme@parisc:~$

And x86-64:

[acme@doppio linux-2.6-tip]$ cat /etc/fedora-release 
Fedora release 11 (Leonidas)
[acme@doppio linux-2.6-tip]$ uname -a
Linux doppio.ghostprotocols.net 2.6.33-rc4-tip+ #3 SMP Wed Jan 13 11:58:15 BRST 2010 x86_64 x86_64 x86_64 GNU/Linux
[acme@doppio linux-2.6-tip]$ grep -w _stext /proc/kallsyms 
ffffffff81000190 T _stext
[acme@doppio linux-2.6-tip]$ grep -w _text /proc/kallsyms 
ffffffff81000000 T _text
[acme@doppio linux-2.6-tip]$


	So changing to "_stext" seems ok and perf.data files collected with it
as the "relocation reference symbol" will work with older perf binaries because
we encode the symbol name in the fake kernel MMAP event.

- Arnaldo
