Return-Path: <linux-kernel-owner+w=401wt.eu-S1759784AbZE1PtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784AbZE1PtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 11:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbZE1PtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 11:49:12 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:47225 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbZE1PtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 11:49:11 -0400
Message-ID: <4A1EB272.3050902@davidnewall.com>
Date: Fri, 29 May 2009 01:19:06 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Olaf Kirch <okir@suse.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com,
       Andreas Gruenbacher <agruen@suse.de>
Subject: Re: CFS Performance Issues
References: <200905281502.22487.okir@suse.de>
In-Reply-To: <200905281502.22487.okir@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Kirch wrote:
> As you probably know, we've been chasing a variety of performance issues
> ...
> I see this:
>
> ./slice 16
>     avg slice:  1.12 utime: 216263.187500
> ...
> Any insight you can offer here is greatly appreciated!
>   

About that: avg slice is in nsec, not msec (the old, off-by-one-million
bug), and utime, also an average, is in usec.

The first result indicates 1.12 nsec per context switch,  193 context
switches and 346% CPU utilisation.  You must have at least four CPU
cores.  Here's your table, extended* per this interpretation:

./slice 16
    avg slice:  1.12 utime: 216263.187500:  1.12 nsec/csw,  193 csw, 346 CPU%
    avg slice:  0.25 utime: 125507.687500:  0.25 nsec/csw,  502 csw, 200 CPU%
    avg slice:  0.31 utime: 125257.937500:  0.31 nsec/csw,  404 csw, 200 CPU%
    avg slice:  0.31 utime: 125507.812500:  0.31 nsec/csw,  404 csw, 200 CPU%
    avg slice:  0.12 utime: 124507.875000:  0.12 nsec/csw, 1037 csw, 199 CPU%
    avg slice:  0.38 utime: 124757.687500:  0.38 nsec/csw,  328 csw, 199 CPU%
    avg slice:  0.31 utime: 125508.000000:  0.31 nsec/csw,  404 csw, 200 CPU%
    avg slice:  0.44 utime: 125757.750000:  0.44 nsec/csw,  285 csw, 201 CPU%
    avg slice:  2.00 utime: 128258.000000:  2.00 nsec/csw,   64 csw, 205 CPU%
 ------ here I turned off new_fair_sleepers ----
    avg slice: 10.25 utime: 137008.500000: 10.25 nsec/csw,   13 csw, 219 CPU%
    avg slice:  9.31 utime: 139008.875000:  9.31 nsec/csw,   14 csw, 222 CPU%
    avg slice: 10.50 utime: 141508.687500: 10.50 nsec/csw,   13 csw, 226 CPU%
    avg slice:  9.44 utime: 139258.750000:  9.44 nsec/csw,   14 csw, 222 CPU%
    avg slice: 10.31 utime: 140008.687500: 10.31 nsec/csw,   13 csw, 224 CPU%
    avg slice:  9.19 utime: 139008.625000:  9.19 nsec/csw,   15 csw, 222 CPU%
    avg slice: 10.00 utime: 137258.625000: 10.00 nsec/csw,   13 csw, 219 CPU%
    avg slice: 10.06 utime: 135258.562500: 10.06 nsec/csw,   13 csw, 216 CPU%
    avg slice:  9.62 utime: 138758.562500:  9.62 nsec/csw,   14 csw, 222 CPU%


You don't seem to be getting good CPU utilisation.

*awk '{printf "%s: %5.2f nsec/csw, %4d csw, %3d CPU%%\n", $0, $3, $5/$3/1000, $5*16/10000}'

