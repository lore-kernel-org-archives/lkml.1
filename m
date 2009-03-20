Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbZCTQoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbZCTQoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 12:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756821AbZCTQoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 12:44:08 -0400
Received: from [213.79.90.228] ([213.79.90.228]:41414 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754314AbZCTQoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 12:44:07 -0400
Date: Fri, 20 Mar 2009 19:44:04 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <srostedt@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/3] Tracers vs. CALLER_ADDR on PowerPC
Message-ID: <20090320164404.GA19933@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is another approach to fixing tracers vs. CALLER_ADDR problem
on PowerPC.

Preface for those who don't know or forgot what the problem is:

Gcc frame pointers do nothing useful on PowerPC (they're harmful,
actually), and thus lib/Kconfig.debug makes CONFIG_FRAME_POINTER
unselectable on PPC targets, but CALLER_ADDR macros are available
only with CONFIG_FRAME_POINTER, therefore tracing is completely
useless on PowerPC:

[...]
  <idle>-0       0X.h3    2us+:      0:140:R   + [000]  1733:120:S mvtsd
  <idle>-0       0X.h3    9us+: 0 (0)
  <idle>-0       0X..3   72us : 0 (0)
  <idle>-0       0X..3   73us :      0:140:R ==> [000]  1733:120:R mvtsd

While it should look like this:

[...]
  <idle>-0       0X.h3    2us+:      0:140:R   + [000]  1740:120:S mvtsd
  <idle>-0       0X.h3    9us+: hrtimer_wakeup (__run_hrtimer)
  <idle>-0       0X..3   87us : cpu_idle (__got2_end)
  <idle>-0       0X..3   89us :      0:140:R ==> [000]  1740:120:R mvtsd

I've tried to fix the issue via expanding the #ifdef in the ftrace.h:
http://lkml.org/lkml/2009/1/31/141

Then Steven Rostedt suggested to implement something more generic,
i.e. HAVE_NORMAL_FRAME_POINTERS Kconfig symbol.

I found a way to solve the problem w/o additional symbols, but
with some Makefile magic (http://lkml.org/lkml/2009/2/4/273).
But because of top-level Makefile issues on other arches
(http://lkml.org/lkml/2009/2/14/89) I had to abandon the approach.


So, this patch set combines Steven Rostedt's idea and a small
Makefile change, so that now only top-level Makefile has to know
about the new symbol, and the rest of the kernel can stay with
using CONFIG_FRAME_POINTER.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
