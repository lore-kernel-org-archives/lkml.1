Return-Path: <linux-kernel-owner+w=401wt.eu-S1756308AbZJ0RHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbZJ0RHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 13:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756220AbZJ0RHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 13:07:39 -0400
Received: from mail.vyatta.com ([76.74.103.46]:53393 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940AbZJ0RHi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 13:07:38 -0400
Date: Tue, 27 Oct 2009 10:07:36 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Stephen Hemminger <stephen.hemminger@vyatta.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Octavian Purdila <opurdila@ixiacom.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] dcache: better name hash function
Message-ID: <20091027100736.5303f1ab@nehalam>
In-Reply-To: <4AE6A16F.4020002@gmail.com>
References: <19864844.24581256620784317.JavaMail.root@tahiti.vyatta.com>
 <4AE68E23.20205@gmail.com>
 <4AE69829.9070207@gmail.com>
 <4AE6A16F.4020002@gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 08:29:51 +0100
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Eric Dumazet a écrit :
> > 
> > 
> > 511 value on 64bit, and 1023 on 32bit arches are nice because
> > hashsz * sizeof(pointer) <= 4096, wasting space for one pointer only.
> > 
> > Conclusion : jhash and 511/1023 hashsize for netdevices,
> > no divides, only one multiply for the fold.
> 
> Just forget about 511 & 1023, as power of two works too.
> 
> -> 512 & 1024 + jhash
> 
> Guess what, David already said this :)


Rather than wasting space, or doing expensive, modulus; just folding
the higher bits back with XOR redistributes the bits better.


On fast machine (Nehalam):

100000000 Iterations
256 Slots (order 8)
Algorithm             Time       Ratio       Max   StdDev
string10             2.505290       1.00    390628   0.00
xor                  2.521329       1.00    392120   2.14
SuperFastHash        2.781745       1.00    397027   4.43
fnv32                2.847892       1.00    392139   0.98
djb2                 2.886342       1.00    390827   0.12
string_hash31        2.900980       1.00    391001   0.20
string_hash17        2.938708       1.00    391122   0.20
full_name_hash       3.080886       1.00    390860   0.10
jhash_string         3.092161       1.00    392775   1.08
fnv64                5.340740       1.00    392854   0.88
kr_hash              2.395757       7.30   4379091 1568.25

On slow machine (CULV):
100000000 Iterations
256 Slots (order 8)
Algorithm             Time       Ratio       Max   StdDev
string10             10.807174       1.00    390628   0.00
SuperFastHash        11.397303       1.00    397027   4.43
xor                  11.660968       1.00    392120   2.14
djb2                 11.674707       1.00    390827   0.12
jhash_string         11.997104       1.00    392775   1.08
fnv32                12.289086       1.00    392139   0.98
string_hash17        12.863864       1.00    391122   0.20
full_name_hash       13.249483       1.00    390860   0.10
string_hash31        13.668270       1.00    391001   0.20
fnv64                39.808964       1.00    392854   0.88
kr_hash              10.316305       7.30   4379091 1568.25

So Eric's string10 is fastest for special case of fooNNN style names.
But probably isn't best for general strings. Orignal function
is >20% slower, which is surprising probably because of overhead
of 2 shifts and multipy. jenkins and fnv are both 10% slower.

The following seems to give best results (combination of 16bit trick
and string17).


static unsigned int xor17(const unsigned char *key, unsigned int len)
{
    	uint32_t h = 0;
	unsigned int rem;

	rem = len & 1;
	len >>= 1;

	while (len--) {
		h = ((h << 4) + h) ^ get_unaligned16(key);
		key += sizeof(uint16_t);
	}

	if (rem)
		h = ((h << 4) + h) ^ *key;


    	return h;
}


