Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbXLHVKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbXLHVKl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 16:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbXLHVKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 16:10:15 -0500
Received: from 1wt.eu ([62.212.114.60]:2616 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbXLHVKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 16:10:12 -0500
Date: Sat, 8 Dec 2007 22:07:58 +0100
From: Willy Tarreau <w@1wt.eu>
To: Matt Mackall <mpm@selenic.com>
Cc: Jeff Garzik <jeff@garzik.org>, Theodore Tso <tytso@mit.edu>,
       Mike McGrath <mmcgrath@redhat.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
       Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org,
       hmh@debian.org
Subject: Re: entropy gathering (was Re: Why does reading from /dev/urandom deplete entropy so much?)
Message-ID: <20071208210758.GA14729@1wt.eu>
References: <20071205144934.GL7259@thunk.org> <1197099477.20786.149.camel@perihelion> <20071208173204.GI17037@thunk.org> <475AD585.7020908@redhat.com> <20071208174908.GJ17037@thunk.org> <20071208181525.GL19691@waste.org> <475AF241.5000809@garzik.org> <20071208195342.GO19691@waste.org> <475AF8D0.1090407@garzik.org> <20071208201954.GP19691@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071208201954.GP19691@waste.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 02:19:54PM -0600, Matt Mackall wrote:
> On Sat, Dec 08, 2007 at 03:04:32PM -0500, Jeff Garzik wrote:
> > Matt Mackall wrote:
> > >On Sat, Dec 08, 2007 at 02:36:33PM -0500, Jeff Garzik wrote:
> > >>As an aside...
> > >>
> > >>Speaking as the maintainer rng-tools, which is the home of the hardware 
> > >>RNG entropy gathering daemon...
> > >>
> > >>I wish somebody (not me) would take rngd and several other projects, and 
> > >>combine them into a single actively maintained "entropy gathering" 
> > >>package.
> > >
> > >I think we should re-evaluate having an internal path from the hwrngs
> > >to /dev/[u]random, which will reduce the need for userspace config
> > >that can go wrong.
> > 
> > That's a bit of a tangent on a tangent.  :)  Most people don't have a 
> > hardware RNG.
> > 
> > But as long as there are adequate safeguards against common hardware 
> > failures (read: FIPS testing inside the kernel), go for it.
> 
> We can do some internal whitening and some other basic tests
> (obviously not the full FIPS battery). The basic von Neumann whitening
> will do a great job of shutting off the spigot when an RNG fails in a
> non-nefarious way. And FIPS stuff is no defense against the nefarious
> failures anyway.
> 
> But I think simply dividing our entropy estimate by 10 or so will go
> an awfully long way.

Agreed. The example program you posted does a very good job. I intuitively
thought that it would show best results where CPU clock >>> system clock,
but even with a faster clock (gettimeofday()) and a few tricks, it provides
an excellent whitened output even at high speed. In fact, it has the advantage
of automatically adjusting its speed to the source clock resolution, which
ensures we don't return long runs of zeroes or ones. Here's my slightly
modified version to extract large amounts of data from gettimeofday(),
followed by test results :

#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
int get_clock()
{
        struct timeval tv;
        unsigned i;

        gettimeofday(&tv, NULL);

        i = tv.tv_usec ^ tv.tv_sec;
        i = (i ^ (i >> 16)) & 0xffff;
        i = (i ^ (i >> 8)) & 0xff;
        i = (i ^ (i >> 4)) & 0xf;
        i = (i ^ (i >> 2)) & 0x3;
        i = (i ^ (i >> 1)) & 0x1;
        return i;
}

int get_raw_timing_bit(void)
{
        int parity = 0;
        int start = get_clock();

        while(start == get_clock()) {
                parity++;
        }
        return parity & 1;
}

int get_whitened_timing_bit(void) {
        int a, b;

        while (1) {
                // ensure we restart without the time offset from the
		// failed tests.
                get_raw_timing_bit();
                a = get_raw_timing_bit();
                b = get_raw_timing_bit();
                if (a > b)
                        return 1;
                if (b > a)
                        return 0;
        }
}

int main(void)
{
        int i;

        while (1) {
                for (i = 0; i < 64; i++) {
                        int j, k;
                        // variable-length eating 2N values per bit, looking
                        // for changing values.
                        do {
                                j = get_whitened_timing_bit();
                                k = get_whitened_timing_bit();
                        } while (j == k);
                        printf("%d", j);
                }

                printf("\n");
        }
}

On my athlon 1.5 GHz with HZ=250, it produces about 40 kb/second. On an
IXP420 at 266 MHz with HZ=100, it produces about 6 kb/s. On a VAX VLC4000
at around 60 MHz under openbsd, it produces about 6 bits/s. In all cases,
the output data looks well distributed :

willy@pcw:~$ for i in entropy.out.*; do echo $i :;z=$(tr -cd '0' <$i|wc -c); o=$(tr -cd '1' <$i|wc -c); echo $z zeroes, $o ones;done
entropy.out.k7 :
159811 zeroes, 166861 ones
entropy.out.nslu2 :
23786 zeroes, 24610 ones
entropy.out.vax :
687 zeroes, 657 ones

And there are very few long runs, the data is not compressible :

willy@pcw:~$ for i in entropy.out.*; do echo -n "$i : ";u=$(tr -d '01' -c <$i|wc -c); c=$(tr -d '01' -c <$i | gzip -c9|wc -c); echo $(echo $u/$c|bc -l) digits/gzip byte;done
entropy.out.k7 : 6.67672246407913830809 digits/gzip byte
entropy.out.nslu2 : 6.27460132244262932711 digits/gzip byte
entropy.out.vax : 4.74911660777385159010 digits/gzip byte

Here are the 4 first output lines of the k7 version :
0100011111001100111011100100100011011101010011110111100011111000
1111101101010110101011101000011010001011010001101101000101011011
1100111100100101000011000011010011101010010101101100011000011000
0100001100101001101000100100101110001001001011000110100111000000

I found no unique line out of 10000. I think the fact that the
clock source used by gettimeofday() is not completely coupled
with the TSC makes this possible. If we had used rdtsc() instead
of gettimeofday(), we might have gotten really strange patterns.
It's possible that peeking around out-of-cache memory data would
add random bus latency to the numbers in such a case, but it's
hard to know what memory size to map to ensure staying out of the
cache.

Regards,
Willy

