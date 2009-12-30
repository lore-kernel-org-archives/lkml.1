Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbZL3TMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbZL3TMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 14:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbZL3TMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 14:12:33 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:51757 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbZL3TMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 14:12:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH] BUG(): CONFIG_BUG=n version of BUG() should be unreachable()
Date: Wed, 30 Dec 2009 20:12:05 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Alexander Beregalov <a.beregalov@gmail.com>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, sam@ravnborg.org,
       dhowells@redhat.com
References: <1261531032-15225-1-git-send-email-a.beregalov@gmail.com> <4B3171DF.4070903@caviumnetworks.com> <4B31743F.8070804@caviumnetworks.com>
In-Reply-To: <4B31743F.8070804@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912302012.05827.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/gV9ZGrscsLPC7NeYsMB5u04Jd1GoTky2kYCg
 otAR0uZi74R5TQyNCvQFySXJkALmMkqawm2pmFMtkUxjPN34Sz
 olgW+9luckVMN9LISAE6A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 December 2009, David Daney wrote:
> David Daney wrote:
> 
> Well that may be too strong an objection, but I would really recommend 
> deeper consideration.
> 
> If you use: #define BUG() __builtin_unreachable()
> 
> which is what your patch does for GCC >= 4.5, it is truly undefined what 
> happens if it is ever reached.  One typical thing that might happen is 
> that you start to try to execute data.  It is unclear to me if it is 
> preferable in the kernel to do that, rather than loop endlessly.  You 
> would likely achieve smaller code, but at what cost?

That is exactly what I was about to reply at first as well, but the
definition is BUG() is really "this should never happen". Normally,
i.e. CONFIG_BUG=y, we will print a stack dump and kill the running
task here. The case that Alexander is patching is for !CONFIG_BUG,
where we intentionally remove the handling for the unexpected bug
in order to reduce code size. This option is really just for people
that want to squeeze out every possibly byte from the kernel object
code, while everyone else just enables CONFIG_BUG.

Currently, this is "do { } while (0)", which on old compilers is
the best approximation of doing the right thing there, but may
cause build warnings.

__builtin_unreachable() is even better on gcc-4.5, because gcc may
save a few more instructions and not print warnings any more. Getting
into an undefined state here is not an issue, because if we get to 
a BUG() statement, the system state is already known to be broken
and !CONFIG_BUG means we don't even try to to improve it any more.

The alternative "do { } while (1)" is not ideal, because an
endless loop still requires more code (typically one instruction)
than doing nothing at all.

If there are only than a handful of places that actually cause a warning,
using "do { } while (0)" (or __builtin_unreachable where available) and
fixing up the code using it might be better.

	Arnd
