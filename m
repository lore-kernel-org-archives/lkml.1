Return-Path: <linux-kernel-owner+w=401wt.eu-S935212AbYCFQ3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935212AbYCFQ3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 11:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763976AbYCFQ1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 11:27:41 -0500
Received: from tur.go2.pl ([193.17.41.50]:42516 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934955AbYCFQ1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 11:27:39 -0500
Message-ID: <47D01868.9060609@o2.pl>
Date: Thu, 06 Mar 2008 17:14:32 +0100
From: Artur Skawina <art_k@o2.pl>
User-Agent: Thunderbird 2.0.0.13pre (X11/20080229)
MIME-Version: 1.0
To: Olivier Galibert <galibert@pobox.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Chris Lattner <clattner@apple.com>, Michael Matz <matz@suse.de>,
       Richard Guenther <richard.guenther@gmail.com>,
       Joe Buck <Joe.Buck@synopsys.com>, Jan Hubicka <hubicka@ucw.cz>,
       Aurelien Jarno <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction
  flag
References: <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de> <20080305212005.GC17267@synopsys.com> <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com> <47CF11D6.7070901@zytor.com> <738B72DB-A1D6-43F8-813A-E49688D05771@apple.com> <Pine.LNX.4.64.0803052258530.20583@wotan.suse.de> <2F47E21A-9055-4EC3-99CF-B666BBC045C3@apple.com> <47CF3F09.4080606@zytor.com> <578FCA7D-D7A6-44F6-9310-4A97C13CDCBE@apple.com> <47CF44E7.3020106@zytor.com> <20080306135139.GA5236@dspnet.fr.eu.org>
In-Reply-To: <20080306135139.GA5236@dspnet.fr.eu.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olivier Galibert wrote:
> On Wed, Mar 05, 2008 at 05:12:07PM -0800, H. Peter Anvin wrote:
>> It's a kernel bug, and it needs to be fixed.
> 
> I'm not convinced.  It's been that way for 15 years, it's that way in
> the BSD kernels, at that point it's a feature.  The bug is in the
> documentation, nowhere else.  And in gcc for blindly trusting the
> documentation.

well, you could see this either way -- either the kernel is buggy and
needs to be fixed or the current behavior is correct and the abi needs
an errata. If there were no performance implications i'd go for the
latter, mostly because of the security aspect.
But this thread made me dig up an old benchmark and apparently omitting
the cld before the string ops makes a significant difference; on P2 it
was ~8%, on P4 it's ~6% for 1480 byte copies; for 32 byte ones the gain
is more like 90% on a P4 [1].

So the impact on small structure memcpy/memset etc is significant, hence
fixing the kernel looks like a better long term plan.

artur

[1]
P4 # ./bcsp m
IACCK 0.9.29  Artur Skawina <...>
[ exec time; lower is better  ] [speed ] [ time ]  [ok?]
TIME-N+S TIME32 TIME33 TIME1480 MBYTES/S TIMEXXXX  CSUM FUNCTION ( rdtsc_overhead=0  null=0 )
       0      0      0        0      inf        0  ffff csum_partial_copy_null
    1885    375    389      156  7589.74    39350     0 generic_memcpy
   10894    532    666     1696   698.11   108557     0 kernel_memcpylib
    1804    325    346      151  7841.06    19614     0 kernel_memcpy686
    1804    325    346      151  7841.06    19693     0 kernel_memcpy686ncld
    1744    323    381      148  8000.00    19687     0 kernel_memcpy686as1
    1332    157    232      139  8517.99    19235     0 kernel_memcpy686as1ncld
    1782    318    339      148  8000.00    19607     0 kernel_memcpy686as2
    1371    168    189      139  8517.99    19221     0 kernel_memcpy686as2ncld

P2 # ./bcsp m
IACKK 0.9.28  Artur Skawina <...>
TIME-N+S   TIME32   TIME33 TIME1480 MBYTES/S TIMEXXXX   CKSUM FUNCTION ( rdtsc_overhead=1  null=0 )
       0        0        0        0      inf        0 :  ffff csum_partial_copy_null
    7121      746     1215      730  1621.92   127418 :     0 generic_memcpy
   43604     2032     1709     6574   180.10   416409 :     0 kernel_memcpylib
    7480      771      726      684  1730.99    96084 :     0 kernel_memcpy686
    7036      735      543      685  1728.47    95508 :     0 kernel_memcpy686ncld
    7498     1015      711      716  1653.63    92200 :     0 kernel_memcpy686as1
    5826      438      489      662  1788.52    91598 :     0 kernel_memcpy686as1ncld
    6667      657      488      708  1672.32    89366 :     0 kernel_memcpy686as2
    6614      456      270      658  1799.39    91203 :     0 kernel_memcpy686as2ncld

