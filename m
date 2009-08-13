Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbZHMJrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbZHMJrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 05:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbZHMJrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 05:47:18 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35875 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbZHMJrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 05:47:17 -0400
Subject: Re: [PROBLEM] perf report is broken in latest linus git
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, paulus@samba.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090813093648.GA22762@elte.hu>
References: <1250155708.6052.2.camel@penberg-laptop>
	 <20090813093648.GA22762@elte.hu>
Date: Thu, 13 Aug 2009 12:47:17 +0300
Message-Id: <1250156837.8141.4.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Thu, 2009-08-13 at 11:36 +0200, Ingo Molnar wrote:
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > Latest Linus git kernel with -rc4 perf userspace:
> > 
> >   penberg@penberg-laptop:~/testing/jato$ perf record -f jato HelloWorldSwing
> >   [ perf record: Captured and wrote 1.402 MB perf.data (~61261 samples) ]
> > 
> >   penberg@penberg-laptop:~/testing/jato$ perf report --sort comm,dso,symbol|head -30
> >   # Samples: 60457
> >   #
> >   # Overhead  Command                            Shared Object  Symbol
> >   # ........  .......  .......................................  ......
> >   #
> > 
> >   [ Note: the jato executable doesn't appear anywhere in the trace. I'm
> >     pretty sure the libzip functions, for example, are from jato, not perf.  ]
> > 
> >       36.14%     perf  /home/penberg/bin/perf                   [.] dso__synthesize_plt_symbols
> >       35.20%     perf  /home/penberg/bin/perf                   [.] dso__new
> >        3.57%     perf  /home/penberg/bin/jato                   [.] 0x0000000000c910
> 
> Perhaps it's this commit:
> 
> 4d1e00a: perf symbol: Fix symbol parsing in certain cases: use the build-id as a symlink
> 
> it does not revert cleanly, so you might want to check out these two 
> commits:
> 
>   4d1e00a
>   4d1e00a~1
> 
> and build perf on both, and check with your anomalous perf.data 
> (without changing it) whether the output makes most sense.

The commit seems fine. Like I said, the perf.data file is busted even
with 2.6.31-rc4 userspace so I think it's a kernel bug.

			Pekka

4d1e00a~1:

penberg@penberg-laptop:~/testing/jato$ perf report
# Samples: 57821
#
# Overhead  Command                            Shared Object  Symbol
# ........  .......  .......................................  ......
#
    73.55%     perf  /home/penberg/bin/perf                   [.] dso__synthesize_plt_symbols
     6.54%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] 0x0000000014b8c0
     3.31%     perf  /home/penberg/bin/jato                   [.] 0x0000000000c910
     1.37%     perf  [kernel]                                 [k] get_page_from_freelist
     1.05%     perf  /home/penberg/bin/perf                   [.] dso__load_sym
     0.91%     perf  /usr/lib/libzip.so.1.0.0                 [.] _zip_get_name
     0.59%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] __GI_strcmp
     0.57%     perf  /usr/lib/libfontconfig.so.1.3.0          [.] 0x00000000019700
     0.53%     perf  /usr/lib/libz.so.1.2.3.3                 [.] 0x0000000000f0c5
     0.49%     perf  /home/penberg/bin/perf                   [.] dso__load_kernel

4d1e00a:

penberg@penberg-laptop:~/testing/jato$ perf report
# Samples: 57821
#
# Overhead  Command                            Shared Object  Symbol
# ........  .......  .......................................  ......
#
    73.55%     perf  /home/penberg/bin/perf                   [.] dso__synthesize_plt_symbols
     6.53%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] 0x0000000014b8c0
     3.31%     perf  /home/penberg/bin/jato                   [.] 0x0000000000c910
     1.37%     perf  [kernel]                                 [k] get_page_from_freelist
     1.05%     perf  /home/penberg/bin/perf                   [.] dso__load_sym
     0.91%     perf  /usr/lib/libzip.so.1.0.0                 [.] _zip_get_name
     0.59%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] __GI_strcmp
     0.57%     perf  /usr/lib/libfontconfig.so.1.3.0          [.] 0x00000000019700
     0.53%     perf  /usr/lib/libz.so.1.2.3.3                 [.] 0x0000000000f0c5
     0.49%     perf  /home/penberg/bin/perf                   [.] dso__load_kernel
     0.43%     perf  /home/penberg/bin/perf                   [.] cmd_stat
     0.35%     perf  /home/penberg/bin/perf                   [.] store_aux
     0.34%     perf  [kernel]                                 [k] kunmap_atomic
     0.33%     perf  /home/penberg/bin/perf                   [.] quote_c_style_counted
     0.31%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] _int_malloc
     0.29%     perf  /home/penberg/bin/perf                   [.] 0x00000000026951
     0.29%     perf  /home/penberg/bin/perf                   [.] strbuf_addf
     0.28%     perf  /usr/lib/libzip.so.1.0.0                 [.] _zip_name_locate


