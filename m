Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbYGIUrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbYGIUrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbYGIUrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:47:08 -0400
Received: from gw.goop.org ([64.81.55.164]:41975 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbYGIUrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:47:07 -0400
Message-ID: <487523B9.8040802@goop.org>
Date: Wed, 09 Jul 2008 13:46:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org>	<20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <20080709133958.612635f0@infradead.org>
In-Reply-To: <20080709133958.612635f0@infradead.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> what's wrong with zero based btw?
>   

Nothing in princple.  In practice it's triggering an amazing variety of 
toolchain bugs.

> do they stop us from using gcc's __thread keyword for per cpu variables
> or something? (*that* would be a nice feature)
>   

The powerpc guys tried it, and it doesn't work.  per-cpu is not 
semantically equivalent to per-thread.  If you have a function in which 
you refer to a percpu variable and then have a preemptable section in 
the middle followed by another reference to the same percpu variable, 
it's hard to stop gcc from caching a reference to the old tls variable, 
even though we may have switched cpus in the meantime.

Also, we explicitly use the other segment register in kernel mode, to 
avoid segment register switches where possible.  Even with 
-mcmodel=kernel, gcc generates %fs references to tls variables.

    J
