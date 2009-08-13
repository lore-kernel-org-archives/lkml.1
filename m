Return-Path: <linux-kernel-owner+w=401wt.eu-S1753929AbZHMJ2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbZHMJ2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 05:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbZHMJ2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 05:28:30 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35064 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbZHMJ23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 05:28:29 -0400
Subject: [PROBLEM] perf report is broken in latest linus git
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, paulus@samba.org,
       linux-kernel@vger.kernel.org
Date: Thu, 13 Aug 2009 12:28:28 +0300
Message-Id: <1250155708.6052.2.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

I don't know what to make out of this. I am profiling my userspace VM with perf
and something happened between 2.6.31-rc4 (which worked perfectly) and latest
Linus git. I am seeing completely different perf profiles and from what I can
tell, the userspace part isn't causing which makes me think it's a kernel
bug. See below for the perf reports.

			Pekka

Linux 2.6.31-rc4 (both kernel and userspace):
 
  [ Note: this makes the most sense to me knowing what the app does. ]

  penberg@penberg-laptop:~/testing/jato$ perf record -f jato HelloWorldSwing
  [ perf record: Captured and wrote 1.401 MB perf.data (~61218 samples) ]
  penberg@penberg-laptop:~/testing/jato$ perf report --sort comm,dso,symbol
  # Samples: 60421
  #
  # Overhead  Command                            Shared Object  Symbol
  # ........  .......  .......................................  ......
  #
      69.86%     jato  /home/penberg/bin/jato                   [.] gc_map_init
       2.06%     jato  /lib/tls/i686/cmov/libc-2.8.90.so        [.] _int_malloc
       1.95%     jato  /lib/tls/i686/cmov/libc-2.8.90.so        [.] __GI_strcmp
       1.68%     jato  /lib/tls/i686/cmov/libc-2.8.90.so        [.] __GI___libc_malloc
       1.61%     jato  [kernel]                                 [k] get_page_from_freelist
       1.01%     jato  /home/penberg/bin/jato                   [.] zalloc
       0.97%     jato  /usr/lib/libzip.so.1.0.0                 [.] _zip_get_name
       0.85%     jato  /home/penberg/bin/jato                   [.] cafebabe_constant_info_utf8_compare
       0.69%     jato  /usr/lib/libz.so.1.2.3.3                 [.] 0x0000000000e445
       0.59%     jato  /lib/tls/i686/cmov/libc-2.8.90.so        [.] cfree
       0.58%     jato  /home/penberg/bin/jato                   [.] analyze_liveness
       0.56%     jato  /home/penberg/bin/jato                   [.] split_interval_at
       0.56%     jato  /usr/lib/libfontconfig.so.1.3.0          [.] 0x0000000001127e
       0.56%     jato  /home/penberg/bin/jato                   [.] allocate_registers

Latest Linus git kernel with -rc4 perf userspace:

  penberg@penberg-laptop:~/testing/jato$ perf record -f jato HelloWorldSwing
  [ perf record: Captured and wrote 1.402 MB perf.data (~61261 samples) ]

  penberg@penberg-laptop:~/testing/jato$ perf report --sort comm,dso,symbol|head -30
  # Samples: 60457
  #
  # Overhead  Command                            Shared Object  Symbol
  # ........  .......  .......................................  ......
  #

  [ Note: the jato executable doesn't appear anywhere in the trace. I'm
    pretty sure the libzip functions, for example, are from jato, not perf.  ]

      36.14%     perf  /home/penberg/bin/perf                   [.] dso__synthesize_plt_symbols
      35.20%     perf  /home/penberg/bin/perf                   [.] dso__new
       3.57%     perf  /home/penberg/bin/jato                   [.] 0x0000000000c910
       2.10%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] _int_malloc
       1.89%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] __GI_strcmp
       1.63%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] __GI___libc_malloc
       1.44%     perf  [kernel]                                 [k] get_page_from_freelist
       1.04%     perf  /home/penberg/bin/perf                   [.] dso__load_sym
       0.94%     perf  /usr/lib/libzip.so.1.0.0                 [.] _zip_get_name
       0.60%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] cfree
       0.52%     perf  /home/penberg/bin/perf                   [.] dso__load_kernel
       0.46%     perf  /usr/lib/libzip.so.1.0.0                 [.] _zip_name_locate
       0.46%     perf  /usr/lib/libfontconfig.so.1.3.0          [.] 0x00000000016706
       0.42%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] _int_free
       0.40%     perf  [kernel]                                 [k] kunmap_atomic
       0.38%     perf  /home/penberg/bin/perf                   [.] cmd_stat
       0.34%     perf  /home/penberg/bin/perf                   [.] quote_c_style_counted
       0.33%     perf  /usr/lib/libz.so.1.2.3.3                 [.] 0x0000000000ea89
       0.32%     perf  /home/penberg/bin/perf                   [.] 0x000000000261ea
       0.32%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] malloc_consolidate
       0.30%     perf  /home/penberg/bin/perf                   [.] strbuf_grow
       0.30%     perf  /home/penberg/bin/perf                   [.] store_aux
       0.30%     perf  /home/penberg/bin/jato                   [.] zalloc
       0.29%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] __GI___libc_realloc
       0.27%     perf  /home/penberg/bin/perf                   [.] strbuf_addf

Latest Linus git kernel and userspace:

  [ perf record: Captured and wrote 1.348 MB perf.data (~58887 samples) ]
  penberg@penberg-laptop:~/testing/jato$ perf record -f jato HelloWorldSwing
  [ perf record: Captured and wrote 1.342 MB perf.data (~58623 samples) ]
  penberg@penberg-laptop:~/testing/jato$ perf report | head -30
  # Samples: 57821
  #
  # Overhead  Command                            Shared Object  Symbol
  # ........  .......  .......................................  ......
  #
      72.88%     perf  /home/penberg/bin/perf                   [.] strbuf_readlink
       6.53%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] 0x0000000014b8c0
       3.31%     perf  /home/penberg/bin/jato                   [.] 0x0000000000c910
       1.37%     perf  [kernel]                                 [k] get_page_from_freelist
       0.91%     perf  /usr/lib/libzip.so.1.0.0                 [.] _zip_get_name
       0.67%     perf  /home/penberg/bin/perf                   [.] strbuf_getline
       0.59%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] __GI_strcmp
       0.57%     perf  /usr/lib/libfontconfig.so.1.3.0          [.] 0x00000000019700
       0.53%     perf  /usr/lib/libz.so.1.2.3.3                 [.] 0x0000000000f0c5
       0.50%     perf  /home/penberg/bin/perf                   [.] print_events
       0.48%     perf  /home/penberg/bin/perf                   [.] quote_c_style_counted
       0.47%     perf  /home/penberg/bin/perf                   [.] rb_erase
       0.40%     perf  /home/penberg/bin/perf                   [.] strlist__load
       0.40%     perf  /home/penberg/bin/perf                   [.] display_thread
       0.40%     perf  /home/penberg/bin/perf                   [.] run_hook
       0.34%     perf  [kernel]                                 [k] kunmap_atomic
       0.32%     perf  /home/penberg/bin/perf                   [.] strlist__parse_list_entry
       0.31%     perf  /lib/tls/i686/cmov/libc-2.8.90.so        [.] _int_malloc
       0.30%     perf  /home/penberg/bin/perf                   [.] dso__load
       0.28%     perf  /usr/lib/libzip.so.1.0.0                 [.] _zip_name_locate
       0.28%     perf  /home/penberg/bin/perf                   [.] cmd_stat
       0.26%     perf  /home/penberg/bin/perf                   [.] run_command_v_opt
       0.25%     perf  /home/penberg/bin/perf                   [.] strlist__parse_list
       0.23%     perf                                 a7d8bb0a  [.] 0x000000a7d8bb0a
       0.21%     perf  /home/penberg/bin/jato                   [.] cafebabe_constant_info_utf8_compare


