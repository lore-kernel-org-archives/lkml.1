Return-Path: <linux-kernel-owner+w=401wt.eu-S932255AbYEULJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbYEULJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 07:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756684AbYEULJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 07:09:01 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:34950 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675AbYEULJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 07:09:00 -0400
Message-ID: <4834035D.5090703@keyaccess.nl>
Date: Wed, 21 May 2008 13:11:25 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Soumyadip Das Mahapatra <kernelhacker@visualserver.org>
CC: Benoit Boissinot <bboissin@gmail.com>,
       Akinobu Mita <akinobu.mita@gmail.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] bitreversal program
References: <Pine.LNX.4.64.0805191859411.18461@visualserver.org> <1211229736.5915.86.camel@brick> <Pine.LNX.4.64.0805201254240.18899@visualserver.org> <961aa3350805200513i4e02716eh79da76345718c3b2@mail.gmail.com> <Pine.LNX.4.64.0805201716160.25111@visualserver.org> <40f323d00805200847t77b2d875j451d0eb9758cf9ff@mail.gmail.com> <Pine.LNX.4.64.0805201753430.25485@visualserver.org> <20080520163912.GP7567@pirzuine> <Pine.LNX.4.64.0805211029250.1736@visualserver.org>
In-Reply-To: <Pine.LNX.4.64.0805211029250.1736@visualserver.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21-05-08 10:54, Soumyadip Das Mahapatra wrote:

> Sorry to disturb you again. But i tested my code against Akinobu's one
> and the test result shows my code takes less cpu time than that of
> Akinobu's.

The unfortunate thing about these kinds of changes is that they're not 
all that easily tested. Straightforwardness would suggest that obviously 
the current table driven method will be faster due to needing fewer code 
cycles. Cache considerations add to that in the sense of instruction 
cache and can (!) detract from it in the sense of data cache; sometimes 
dramaticaly detract due to cache misses basically dwarving most anything 
else.

However, in this case the table is a tiny 256-byte one which isn't even 
going to be pulled in completely in normal usage (just the cache-lines 
needed) while on the other hand the extra i-cache pressure from the 
increased code in your version is always there.

It's unexpected that you would get better results from your new code 
(and I'm not; I took Benoit's posted test and get 15 seconds for your 
version versus 9 for the original table-driven one) and in this case, 
reality wouldn't contradict the micro-benchmark either. It's when the 
table grows and, especially, more of it is needed on a regular basis 
that you'd start to worry.

PS: If you're going to go really micro, there are even going to be 
differences between bitreversing 0x00000000 which is just going to need 
the first byte (hence cacheline) and say 0x004080c0 which is going to 
occupy 4 cachelines. Again not in the isolated test though; the data in 
this case is small enough that you should be having a hard time getting 
your version to perform better -- forking off a competing process that 
does its best to dirty cache might do it, but then you're in a situation 
which is no longer real-world with respect to this "call once" bit of API...

Rene.
