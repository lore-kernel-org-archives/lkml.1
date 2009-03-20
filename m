Return-Path: <linux-kernel-owner+w=401wt.eu-S1758556AbZCTQwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556AbZCTQwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 12:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbZCTQwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 12:52:13 -0400
Received: from [213.79.90.228] ([213.79.90.228]:41468 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754314AbZCTQwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 12:52:13 -0400
Date: Fri, 20 Mar 2009 19:52:10 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Steven Rostedt <srostedt@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v4 0/3] Tracers vs. CALLER_ADDR on PowerPC
Message-ID: <20090320165210.GA3414@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090320164404.GA19933@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090320164404.GA19933@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 07:44:04PM +0300, Anton Vorontsov wrote:
> Hi all,
> 
> Here is another approach to fixing tracers vs. CALLER_ADDR problem
> on PowerPC.
> 
> Preface for those who don't know or forgot what the problem is:
> 
> Gcc frame pointers do nothing useful on PowerPC (they're harmful,
> actually), and thus lib/Kconfig.debug makes CONFIG_FRAME_POINTER
> unselectable on PPC targets, but CALLER_ADDR macros are available
> only with CONFIG_FRAME_POINTER, therefore tracing is completely
> useless on PowerPC:
> 
> [...]
>   <idle>-0       0X.h3    2us+:      0:140:R   + [000]  1733:120:S mvtsd
>   <idle>-0       0X.h3    9us+: 0 (0)
>   <idle>-0       0X..3   72us : 0 (0)
>   <idle>-0       0X..3   73us :      0:140:R ==> [000]  1733:120:R mvtsd
> 
> While it should look like this:
> 
> [...]
>   <idle>-0       0X.h3    2us+:      0:140:R   + [000]  1740:120:S mvtsd
>   <idle>-0       0X.h3    9us+: hrtimer_wakeup (__run_hrtimer)
>   <idle>-0       0X..3   87us : cpu_idle (__got2_end)
>   <idle>-0       0X..3   89us :      0:140:R ==> [000]  1740:120:R mvtsd
> 
> I've tried to fix the issue via expanding the #ifdef in the ftrace.h:
> http://lkml.org/lkml/2009/1/31/141
> 
> Then Steven Rostedt suggested to implement something more generic,
> i.e. HAVE_NORMAL_FRAME_POINTERS Kconfig symbol.
> 
> I found a way to solve the problem w/o additional symbols, but
> with some Makefile magic (http://lkml.org/lkml/2009/2/4/273).
> But because of top-level Makefile issues on other arches
> (http://lkml.org/lkml/2009/2/14/89) I had to abandon the approach.

Oh, and btw, I'm aware of

  commit c79a61f55773d2519fd0525bf58385f7d20752d3
  Author: Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
  Date:   Fri Feb 27 21:30:03 2009 +0100

      tracing: make CALLER_ADDRx overwriteable

But I think the patch set is still applicable, considering that
it removes gcc bug workaround in a nice way, and makes
CONFIG_FRAME_POINTER available on PowerPC, thus other code
can rely on that.

If not, I can just fill-in the asm/ftrace.h for PowerPC.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
