Return-Path: <linux-kernel-owner+w=401wt.eu-S1767671AbXEDEeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767671AbXEDEeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 00:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767672AbXEDEeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 00:34:17 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35218 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767671AbXEDEeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 00:34:16 -0400
Date: Thu, 3 May 2007 21:34:15 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: Remove constructor from buffer_head
In-Reply-To: <20070503202111.667c9b14.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705032120020.16954@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705032007540.16627@schroedinger.engr.sgi.com>
 <20070503202111.667c9b14.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007, Andrew Morton wrote:

> The change looks nice, but I'd microbenchmark it with a write-to-ext2-on-ramdisk
> or something like that.

Hmmm... How does one benchmark buffer head performance? Guess just by 
copying files? Not sure if the following will cut it.

Two tests. First copying 8M of small files into a 16M ramdisk:

for i in 1 2 3 4 5 6 7 8 9; do

        mke2fs /dev/ram0 >/dev/null
        mount /dev/ram0 /media >/dev/null
        time cp -a /etc /media
        umount /dev/ram0

done;


No constructor

real    0m0.104s
user    0m0.016s
sys     0m0.056s

real    0m0.090s
user    0m0.008s
sys     0m0.056s

real    0m0.089s
user    0m0.016s
sys     0m0.048s

real    0m0.097s
user    0m0.004s
sys     0m0.064s

real    0m0.091s
user    0m0.008s
sys     0m0.052s

real    0m0.091s
user    0m0.004s
sys     0m0.060s

real    0m0.098s
user    0m0.008s
sys     0m0.060s

real    0m0.091s
user    0m0.000s
sys     0m0.064s

real    0m0.090s
user    0m0.012s
sys     0m0.052s

W/constructor

real    0m0.099s
user    0m0.004s
sys     0m0.100s

real    0m0.098s
user    0m0.008s
sys     0m0.096s

real    0m0.091s
user    0m0.016s
sys     0m0.080s

real    0m0.091s
user    0m0.012s
sys     0m0.084s

real    0m0.090s
user    0m0.012s
sys     0m0.080s

real    0m0.090s
user    0m0.020s
sys     0m0.076s

real    0m1.269s
user    0m0.012s
sys     0m0.084s

real    0m0.095s
user    0m0.016s
sys     0m0.084s

real    0m0.096s
user    0m0.020s
sys     0m0.084s

The no constructor numbers are generally lower.
Lowest is no constructor with 0.089.

Second. Copy vmlinux (52M) to 128M ramdisk:

for i in 1 2 3 4 5 6 7 8 9; do

        mke2fs /dev/ram0 >/dev/null
        mount /dev/ram0 /media >/dev/null
        time cp slub/vmlinux /media
        umount /dev/ram0

done;


No constructor:

real    0m2.095s
user    0m0.000s
sys     0m0.168s

real    0m0.187s
user    0m0.008s
sys     0m0.124s

real    0m0.186s
user    0m0.008s
sys     0m0.120s

real    0m0.195s
user    0m0.008s
sys     0m0.128s

real    0m0.177s
user    0m0.004s
sys     0m0.120s

real    0m0.182s
user    0m0.004s
sys     0m0.120s

real    0m0.186s
user    0m0.008s
sys     0m0.120s

real    0m0.190s
user    0m0.004s
sys     0m0.128s

real    0m0.174s
user    0m0.004s
sys     0m0.116s


Constructor

real    0m0.183s
user    0m0.004s
sys     0m0.188s

real    0m0.183s
user    0m0.004s
sys     0m0.192s

real    0m0.177s
user    0m0.012s
sys     0m0.176s

real    0m0.186s
user    0m0.004s
sys     0m0.192s

real    0m0.187s
user    0m0.008s
sys     0m0.188s

real    0m0.184s
user    0m0.004s
sys     0m0.192s

real    0m0.177s
user    0m0.012s
sys     0m0.176s

real    0m0.183s
user    0m0.004s
sys     0m0.192s

real    0m0.182s
user    0m0.004s
sys     0m0.188s

Same here. Low is 0.174 no constructor.


