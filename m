Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbZCCScN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbZCCScN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 13:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbZCCSb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 13:31:58 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33908 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbZCCSb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 13:31:57 -0500
Date: Wed, 4 Mar 2009 03:28:02 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Johannes Weiner <jw@emlix.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oskar Schirmer <os@emlix.com>,
       David Howells <dhowells@redhat.com>,
       Russell King <rmk@arm.linux.org.uk>, Bryan Wu <cooloney@kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] binfmt_flat: fix data sections alignment
Message-ID: <20090303182801.GA6907@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Johannes Weiner <jw@emlix.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oskar Schirmer <os@emlix.com>, David Howells <dhowells@redhat.com>,
	Russell King <rmk@arm.linux.org.uk>, Bryan Wu <cooloney@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	linux-kernel@vger.kernel.org
References: <E1LeXY0-0007Fb-KQ@mailer.emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LeXY0-0007Fb-KQ@mailer.emlix.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 05:33:13PM +0100, Johannes Weiner wrote:
> The flat loader uses an architecture's flat_stack_align() to align the
> stack but assumes word-alignment is enough for the data sections.
> 
> However, on the Xtensa S6000 we need an alignment of more than
> wordsize for data that is loaded to 128bit wide registers.
> 
> This patch replaces the specific flat_stack_align() with a more
> generic flat_data_align() that is then used for both stack, the data
> and bss section.
> 
> It also fixes m32r which was obviously kaput, aligning an
> uninitialized stack entry instead of the stack pointer.
> 
Can you provide a bit more information about this for your platform? I
note that while this patch is aimed to generalize things for your
platform, there is no Xtensa patch included here, making it difficult to
Ack without having more context to go on.

Based on your description, it looks like you need register size alignment
in the case where your registers are greater than BYTES_PER_WORD, or the
pointer size. If this is the case, then you are going to have the same
issues with the slab caches and need to set ARCH_SLAB_MINALIGN
accordingly. This is presently a situation that exists for certain ARM
and SH platforms already today, but none that are actively used in nommu
configurations. It would be preferable to generalize this, rather than
duplicating the special-cased alignment.
