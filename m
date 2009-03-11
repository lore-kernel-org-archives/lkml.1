Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbZCKPEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbZCKPEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 11:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZCKPEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 11:04:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714AbZCKPE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 11:04:29 -0400
Date: Wed, 11 Mar 2009 07:59:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: your mail
In-Reply-To: <87ljrccp57.wl%vmayatsk@redhat.com>
Message-ID: <alpine.LFD.2.00.0903110756180.32478@localhost.localdomain>
References: <87ljrccp57.wl%vmayatsk@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Mar 2009, Vitaly Mayatskikh wrote:
> 
> (v)scnprintf says it should return 0 when size is 0, but doesn't do
> so. Also size_t is unsigned, it can't be less then 0. Fix the code and
> comments.

That is bogus.

The code really does (od "did"? Maybe you removed it) check for _smaller_ 
than 0:

	int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
	{
		...
		/* Reject out-of-range values early.  Large positive sizes are
		   used for unknown buffer sizes. */
		if (unlikely((int) size < 0)) {
			/* There can be only one.. */
			static char warn = 1;
			WARN_ON(warn);
			warn = 0;
			return 0;
		}
		...

because under/overflows have happened.

The kernel is _not_ a regular libc. We have different rules.

		Linus
