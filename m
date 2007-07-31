Return-Path: <linux-kernel-owner+w=401wt.eu-S1764443AbXGaP4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764443AbXGaP4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 11:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758464AbXGaP4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 11:56:10 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:29495 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757090AbXGaP4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 11:56:09 -0400
Date: Tue, 31 Jul 2007 19:55:27 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org, torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au
Subject: WARN_ON() which sometimes sucks
Message-ID: <20070731155527.GB7253@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It started when I tried to write

	WARN_ON(m->seq_ops_allocated);

in today's "[PATCH] single_open/seq_release leak diagnostics¹.
Suprisingly compiler told me piss off with:

	  CC      fs/seq_file.o
	fs/seq_file.c: In function 'seq_release':
	fs/seq_file.c:285: error: 'typeof' applied to a bit-field

Well, duh! Earlier versions of WARN_ON allowed that until commit
684f978347deb42d180373ac4c427f82ef963171² which added typeof().

OK, nobody noticed that WARN_ON(bitfield) stopped working. But I
question the rationale of that commit:

	Letting WARN_ON/WARN_ON_ONCE return the condition means that you could
	do

	if (WARN_ON(blah)) {
	        handle_impossible_case
	}

	Rather than

	if (unlikely(blah)) {
	        WARN_ON(1)
	        handle_impossible_case
	}

I think that second case is more clear and immediately understandable.
If folks agree, I'll send revert so that WARN_ON(var), WARN_ON(ptr),
WARN_ON(bitfield) and WARN_ON(condition) work as expected.

¹ http://marc.info/?l=linux-kernel&m=118588389612083&w=2
²

tree db9025d8c6b267565c7110e09b16193957186a48
parent 6299a2dec89d22940e36832f15c0addfb77e6910
author Herbert Xu <herbert@gondor.apana.org.au> 1159520346 -0700
committer Linus Torvalds <torvalds@g5.osdl.org> 1159546686 -0700

[PATCH] Let WARN_ON/WARN_ON_ONCE return the condition

Letting WARN_ON/WARN_ON_ONCE return the condition means that you could do

if (WARN_ON(blah)) {
	handle_impossible_case
}

Rather than

if (unlikely(blah)) {
	WARN_ON(1)
	handle_impossible_case
}

I checked all the newly added WARN_ON_ONCE users and none of them test the
return status so we can still change it.

[akpm@osdl.org: warning fix]
[akpm@osdl.org: build fix]
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Linus Torvalds <torvalds@osdl.org>

