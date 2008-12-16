Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbYLPJPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbYLPJPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 04:15:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbYLPJPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 04:15:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59016 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbYLPJP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 04:15:28 -0500
Date: Tue, 16 Dec 2008 10:15:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ken Chen <kenchen@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] x86: convert rdtscll() to use __native_read_tsc
Message-ID: <20081216091509.GA29872@elte.hu>
References: <b040c32a0812160032pf681f13s9e5e86c4b5448012@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0812160032pf681f13s9e5e86c4b5448012@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ken Chen <kenchen@google.com> wrote:

> Is there any reason why x86 rdtscll have to use the out of line function 
> instead of inline __native_read_tsc()?  native_read_tsc and 
> __native_read_tsc is essentially the same functions.

Your patch is correct.

The reason for the __native_read_tsc() / native_read_tsc() distinction is 
and obscure problem with paravirt function pointers. Such constructs:

  ./xen/enlighten.c:	.read_tsc = native_read_tsc,

do not always work fine with all versions of gcc, if native_read_tsc() is 
a simple static inline (as it should be) - the build would fail with 
certain gcc flags. (and i remember runtime problems too) The C semantics 
of taking the address of an inline function seem pretty clear: the inlined 
function should be instantiated in that .o and a pointer should be 
generated out of that local instantiation.

Perhaps the real fix is to do this rename as well:

    native_read_tsc => native_read_tsc_paravirt
  __native_read_tsc => native_read_tsc

as this makes the native_read_tsc_paravirt() a pure technical variant, to 
be used in paravirt_ops function pointer assignments. People would thus 
just use the obvious native_read_tsc() inline function most of the time 
and could forget about native_read_tsc_paravirt().

Jeremy?

	Ingo
