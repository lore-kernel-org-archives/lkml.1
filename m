Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbXLWDBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbXLWDBi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 22:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbXLWDB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 22:01:28 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56689 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752309AbXLWDB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 22:01:26 -0500
Date: Sat, 22 Dec 2007 18:58:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>, Sam Ravnborg <sam@ravnborg.org>,
       Paul Mundt <lethal@linux-sh.org>, Richard Henderson <rth@twiddle.net>,
       Michael Starvik <starvik@axis.com>, David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Chris Zankel <chris@zankel.net>,
       Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] Avoid overflows in kernel/time.c (version 5)
Message-Id: <20071222185822.80bd4540.akpm@linux-foundation.org>
In-Reply-To: <200712180541.lBI5fnqB028037@tazenda.hos.anvin.org>
References: <20071218053729.GA13238@uranus.ravnborg.org>
	<200712180541.lBI5fnqB028037@tazenda.hos.anvin.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 13:53:23 -0800 "H. Peter Anvin" <hpa@zytor.com> wrote:

> When the conversion factor between jiffies and milli- or microseconds
> is not a single multiply or divide, as for the case of HZ == 300, we
> currently do a multiply followed by a divide.  The intervening
> result, however, is subject to overflows, especially since the
> fraction is not simplified (for HZ == 300, we multiply by 300 and
> divide by 1000).
> 
> This is exposed to the user when passing a large timeout to poll(),
> for example.
> 
> This patch replaces the multiply-divide with a reciprocal
> multiplication on 32-bit platforms.  When the input is an unsigned
> long, there is no portable way to do this on 64-bit platforms there is
> no portable way to do this since it requires a 128-bit intermediate
> result (which gcc does support on 64-bit platforms but may generate
> libgcc calls, e.g. on 64-bit s390), but since the output is a 32-bit
> integer in the cases affected, just simplify the multiply-divide
> (*3/10 instead of *300/1000).


alpha allmodconfig:

kernel/time.c: In function 'jiffies_to_msecs':
kernel/time.c:248: error: 'HZ_TO_MSEC_NUM' undeclared (first use in this function)
kernel/time.c:248: error: (Each undeclared identifier is reported only once
kernel/time.c:248: error: for each function it appears in.)
kernel/time.c:248: error: 'HZ_TO_MSEC_DEN' undeclared (first use in this function)
kernel/time.c: In function 'jiffies_to_usecs':
kernel/time.c:264: error: 'HZ_TO_USEC_NUM' undeclared (first use in this function)
kernel/time.c:264: error: 'HZ_TO_USEC_DEN' undeclared (first use in this function)
kernel/time.c: In function 'usecs_to_jiffies':
kernel/time.c:486: error: 'm' undeclared (first use in this function)
kernel/time.c:489: warning: control reaches end of non-void function
kernel/time.c: In function 'jiffies_to_usecs':
kernel/time.c:267: warning: control reaches end of non-void function
kernel/time.c: In function 'jiffies_to_msecs':
kernel/time.c:251: warning: control reaches end of non-void function

