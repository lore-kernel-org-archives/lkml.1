Return-Path: <linux-kernel-owner+w=401wt.eu-S1752595AbXCMR72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbXCMR72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 13:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbXCMR72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 13:59:28 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:1843 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbXCMR71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 13:59:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kyKw4ciAyIkoMsg6xiwGaU6ilKo1IX9ohZT1ol6sPg6EoGy/UtNZpWeeLeXEmMIb8lsQ7ewcv4zqaL/PPybyHxIbQ8aqCnI9Q2toLFIdvOQ0+ov6s+Dxznuy9Kk6aJ8hqEh2VrqKPP/zVEATw45Mm1MBlL3wTYnun0PEiQ5ba5Y=
Message-ID: <f2b55d220703131059j2b47b3e0s1edae6150929684f@mail.gmail.com>
Date: Tue, 13 Mar 2007 10:59:20 -0700
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: sys_write() racy for multi-threaded append?
Cc: alan@lxorguk.ukuu.org.uk, 7eggert@gmx.de, dada1@cosmosbay.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <f2b55d220703130924h11786d9fh1d87f90bcd1b3d60@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f2b55d220703121746k1a849b78rec3131cb6f5eae38@mail.gmail.com>
	 <20070313022430.57503b08@lxorguk.ukuu.org.uk>
	 <f2b55d220703130025l48ea2e8ci15ddf0563cf21bf9@mail.gmail.com>
	 <20070313.004224.41634994.davem@davemloft.net>
	 <f2b55d220703130924h11786d9fh1d87f90bcd1b3d60@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Clearly f_pos atomicity has been handled differently in the not-so-distant past:

http://www.mail-archive.com/linux-fsdevel@vger.kernel.org/msg01628.html

And equally clearly the current generic_file_llseek semantics are
erroneous for large offsets, and we shouldn't be taking the inode
mutex in any case other than SEEK_END:

http://marc.theaimsgroup.com/?l=linux-fsdevel&m=100584441922835&w=2

read_write.c is a perfect example of the relative amateurishness of
parts of the Linux kernel.  It has probably gone through a dozen major
refactorings in fifteen years but has never acquired a "theory of
operations" section justifying the errors returned in terms of
standards and common usage patterns.  It doesn't have assertion-style
precondition/postcondition checks.  It's full of bare constants and
open-coded flag tests.  It exposes sys_* and vfs_* and generic_file_*
without any indication of which sanity checks you're bypassing when
you call the inner functions directly.  It leaks performance right and
left with missing likely() macros and function calls that can't be
inlined because there's no interface/implementation split.  And then
you want to tell me that it costs too much to spinlock around f_pos
updates when file->f_count > 1?  Give me a break.
