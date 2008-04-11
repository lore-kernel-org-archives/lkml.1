Return-Path: <linux-kernel-owner+w=401wt.eu-S1759603AbYDKMY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603AbYDKMY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 08:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757862AbYDKMYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 08:24:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:63292 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958AbYDKMYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 08:24:47 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: file offset corruption on 32-bit machines?
To: Diego Calleja <diegocg@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
       Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Fri, 11 Apr 2008 14:24:34 +0200
References: <agh4d-6yc-35@gated-at.bofh.it> <ah5tY-3lR-7@gated-at.bofh.it> <ah5DA-3X9-9@gated-at.bofh.it> <ah5X5-4tl-13@gated-at.bofh.it> <ah66A-4Nk-7@gated-at.bofh.it> <ah7vN-7Wz-9@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1JkIJ0-0000tG-LV@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19/MXdH4zw5MyzVccb23D9y6L3heNEj54vCgN1
 CQDTVzoXOhX7vabAyL8w71BbO3PFcIKJw6u8R2hDbPfmZUqeXf
 o1TMWj2IwsKQSDabSwatQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Diego Calleja <diegocg@gmail.com> wrote:

> El Thu, 10 Apr 2008 16:31:09 +0200 (CEST), Jiri Kosina <jkosina@suse.cz>
> escribió:
> 
>> I think this is worth fixing.
> 
> This question comes very often, and Linus even wrote a patch
> (http://lkml.org/lkml/2006/4/13/124 , http://lkml.org/lkml/2006/4/13/130)
> 
> But apparently there's no much interest in fixing it, because it would
> slow down some workloads...

AS far as I understand, the race is e.g.:

fpos := A:a, we want to make process/thread a read A:b or B:a without it
being a correct value in fpos. a!=b!=c, A!=B, A!=C.

a: read fpos.high (A:?)
b: write fpos (B:b)
a: read fpos.low (A:b)


If you change this to 

a: read fpos.high
a: read fpos.low
a: read fpos.high
a: read fpos.low

and compare the results, you need to

a: read fpos.high (A:?)
b: write fpos (B:b)
a: read fpos.low (A:b)
b: write fpos (A:c)
a: read fpos.high (A:b),(A:?)
b: write fpos (C:b)
a: read fpos.low (A:b),(A:b)

That would be winning three races in order to hit the bug. 


OTOH, writers MUST NOT be interrupted, because:

b: write fpos.high (B:a)
a: read fpos.high (B:?)
a: read fpos.low (B:a)
a: read fpos.high (B:a),(B:?)
a: read fpos.low (B:a),(B:a)
b: write fpos.low (B:b)


