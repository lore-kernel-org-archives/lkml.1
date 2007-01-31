Return-Path: <linux-kernel-owner+w=401wt.eu-S1752197AbXAaGGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbXAaGGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 01:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932852AbXAaGGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 01:06:25 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:50020 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbXAaGGY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 01:06:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: cbe-oss-dev@ozlabs.org
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 4/4] Add support to OProfile =?iso-8859-1?q?for=09profiling_Cell_BE_SPUs_--?= update
Date: Wed, 31 Jan 2007 07:06:11 +0100
User-Agent: KMail/1.9.5
Cc: Carl Love <cel@us.ibm.com>, maynardj@us.ibm.com, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <45BE4ED0.5030808@us.ibm.com> <45BFBB78.7060907@us.ibm.com> <1170199869.5235.38.camel@dyn9047021078.beaverton.ibm.com>
In-Reply-To: <1170199869.5235.38.camel@dyn9047021078.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200701310706.12356.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX18jLoanvvP2GiH+Eq9hBD1IkuLvFrC1tnDlenDqVYTMzopH+OxKaJ6bMuUJmgvEY4zZLNsd9YpW65YUnmzKJtHnww8JrtwWAylIZMxEYVlSYQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 January 2007 00:31, Carl Love wrote:
> Unfortunately, the only way we know how to
> figure out what the LFSR value that corresponds to the number in the
> sequence that is N before the last value (0xFFFFFF) is to calculate the
> previous value N times.  It is like trying to ask what is the pseudo
> random number that is N before this pseudo random number?

Well, you can at least implement the lfsr both ways, and choose the one
that is faster to get at, like

u32 get_lfsr(u32 v)
{
	int i;
	u32 r = 0xffffff;
	if (v < 0x7fffff) {
		for (i = 0; i < v; i++)
			r = lfsr_forwards(r);
	} else {
		for (i = 0; i < (0x1000000 - v); i++)
			r = lfsr_backwards(r);
	}
	return r;
}

Also, if the value doesn't have to be really exact, you could have
a small lookup table with precomputed values, like:

u32 get_lfsr(u32 v)
{
	static const lookup[256] = {
		0xab3492, 0x3e3f34, 0xc47610c, ... /* insert actual values */
	};

	return lookup[v >> 16];
}

	Arnd <><
