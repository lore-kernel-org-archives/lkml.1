Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbZHKUFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbZHKUFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 16:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbZHKUFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 16:05:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35508 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754436AbZHKUFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 16:05:03 -0400
Date: Tue, 11 Aug 2009 17:04:36 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Luis Claudio =?iso-8859-1?Q?R=2E_Gon=E7alves?= 
	<lclaudio@redhat.com>,
       Clark Williams <williams@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 1/1] perf tools: Make dso__new handle deleted DSOs
Message-ID: <20090811200436.GA3478@ghostprotocols.net>
References: <20090811192211.GG18061@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090811192211.GG18061@ghostprotocols.net>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is better than showing the map addr, this way at least we know that we can't
get the symtabs because the DSO was deleted (system update) while an app still
used such DSO.

Yeah, don't do that, but if you do, you'll figure it out quicker this
way.

[acme@doppio linux-2.6-tip]$ perf report | head -15
# Samples: 3796
#
# Overhead  Command                                                        Shared Object  Symbol
# ........  .......  ...................................................................  ......
#
    23.55%   pidgin  /lib64/libglib-2.0.so.0.2000.4.#prelink#.Pd98lu (deleted)            [.] 0x00000000038844
    21.55%   pidgin  /lib64/libpthread-2.10.1.so.#prelink#.AFwK8Q (deleted)               [.] 0x0000000000a42d
    10.85%   pidgin  [kernel]                                                             [.] vread_hpet
     7.85%   pidgin  /lib64/libgobject-2.0.so.0.2000.4.#prelink#.o1vpU7 (deleted)         [.] 0x00000000014de8
     3.35%   pidgin  /lib64/libc-2.10.1.so (deleted)                                      [.] 0x0000000007a875
     3.19%   pidgin  /lib64/libdbus-1.so.3.4.0.#prelink#.6mwgZP (deleted)                 [.] 0x0000000001d254
     3.06%   pidgin  /usr/lib64/libgtk-x11-2.0.so.0.1600.5.#prelink#.511hAl (deleted)     [.] 0x000000002334e7
     2.90%   pidgin  /usr/lib64/libgdk-x11-2.0.so.0.1600.5.#prelink#.5qlMo1 (deleted)     [.] 0x00000000037b2d
     1.84%   pidgin  [kernel]                                                             [k] do_sys_poll
     1.45%   pidgin  /usr/lib64/libX11.so.6.2.0.#prelink#.iR59Rx (deleted)                [.] 0x0000000004c751
[acme@doppio linux-2.6-tip]$

Cc: Luis Claudio R. Gonçalves <lclaudio@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 2473fd4..5c0f42e 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -801,6 +801,8 @@ more:
 	}
 out:
 	free(name);
+	if (ret < 0 && strstr(self->name, " (deleted)") != NULL)
+		return 0;
 	return ret;
 }
 
-- 
1.6.2.5

