Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbYDAIR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbYDAIR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 04:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbYDAIRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 04:17:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:15451 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbYDAIRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 04:17:44 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: OOM (HighMem) on linux 2.6.24.2
Date: Tue, 1 Apr 2008 10:17:35 +0200
User-Agent: KMail/1.8.2
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>, linux-kernel@vger.kernel.org
References: <1205974089.4023.20.camel@kulgan.wumi.org.au> <200804010431.11271.vda.linux@googlemail.com> <1207025847.8514.675.camel@twins>
In-Reply-To: <1207025847.8514.675.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804011017.35352.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 April 2008 06:57, Peter Zijlstra wrote:
> On Tue, 2008-04-01 at 04:31 +0200, Denys Vlasenko wrote:
> > On Thursday 20 March 2008 11:04, Kevin Shanahan wrote:
> > > Feb 28 06:32:20 hermes kernel: 5313 pages slab
> > > Feb 28 06:32:20 hermes kernel: 2632 pages pagetables
> > > Feb 28 06:32:20 hermes kernel: Out of memory: kill process 24013 (apache2) score 22070 or a child
> > > Feb 28 06:32:20 hermes kernel: Killed process 24013 (apache2)
> > > 
> > > Looks like the HighMem low watermark was hit again (though I've no idea
> > > if that's actually significant).
> > 
> > I kno that people routinely forget to do that, but
> > at least for purely paranoid reasons you are better
> > to run all daemons with setrlimit'ed memory size.
> > At least all daemons which you cannot reasonably
> > trust to be 100% leak-free and to have bounded
> > peak memory usage.
> 
> Afaik we don't actually implement RLIMIT_RSS.

I don't know, but the following definitely works for me:

#include <stdlib.h>
int main() {
    void *p;
    unsigned size = 1 << 20;
    unsigned long total = 0;
    while (size) {
        p = malloc(size);
        if (!p) size >>= 1;
        else {
            memset(p, 0x77, size);
            total += size;
            printf("Allocated %9u bytes, %12lu total\n", size, total);
        }
    }
    printf("Cannot malloc more. Exiting\n");
    return 0;
}

# softlimit -a 12000000 ./oom
Allocated   1048576 bytes,      1048576 total
Allocated   1048576 bytes,      2097152 total
Allocated   1048576 bytes,      3145728 total
Allocated   1048576 bytes,      4194304 total
Allocated   1048576 bytes,      5242880 total
Allocated   1048576 bytes,      6291456 total
Allocated   1048576 bytes,      7340032 total
Allocated   1048576 bytes,      8388608 total
Allocated   1048576 bytes,      9437184 total
Allocated   1048576 bytes,     10485760 total
Allocated    262144 bytes,     10747904 total
Cannot malloc more. Exiting

--
vda
