Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbXKBHuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbXKBHuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 03:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbXKBHuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 03:50:44 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:29090 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbXKBHum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 03:50:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jfERha7tV14itfKm5hMIdFIX2FuNk5RGQKPb0kTmaEnWBPf4GTFznd2UCRIaSf7rcGcfj6cHobftClAjuV2150csYXDyqaSN1ZlFf4Ug2EAWgBRmOQjg6RYPAb+z8AkZ+QpOCxL0TDv/edIHgq95/xPJ8X7nxIJ4ietNnYUi0VQ=
Message-ID: <64bb37e0711020050s55bda596j7adf89c697c5f72f@mail.gmail.com>
Date: Fri, 2 Nov 2007 08:50:41 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Fengguang Wu" <wfg@mail.ustc.edu.cn>
Subject: Re: writeout stalls in current -git
Cc: "Maxim Levitsky" <maximlevitsky@gmail.com>,
       "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Chinner" <dgc@sgi.com>, linux-fsdevel@vger.kernel.org
In-Reply-To: <393970108.15915@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710220822.52370.maximlevitsky@gmail.com>
	 <393056632.00561@ustc.edu.cn>
	 <200710221505.35397.maximlevitsky@gmail.com>
	 <20071022131045.GA5357@mail.ustc.edu.cn> <393060478.03650@ustc.edu.cn>
	 <64bb37e0710310822r5ca6b793p8fd97db2f72a8655@mail.gmail.com>
	 <393903856.06449@ustc.edu.cn>
	 <64bb37e0711011120i63cdfe3ci18995d57b6649a8@mail.gmail.com>
	 <64bb37e0711011200n228e708eg255640388f83da22@mail.gmail.com>
	 <393970108.15915@ustc.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/07, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> On Thu, Nov 01, 2007 at 08:00:10PM +0100, Torsten Kaiser wrote:
> > On 11/1/07, Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> > > On 11/1/07, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> > > > Thank you. Maybe we can start by the applied debug patch :-)
> > >
> > > Will applied it and try to recreate this.
> >
> > Patch applied, used emerge to install a 2.6.24-rc1 kernel.
> >
> > I had no complete stalls, but three times during the move from tmpfs
> > to the main xfs the emerge got noticeable slower. There still was
> > writeout happening, but as emerge prints out every file it has written
> > during the pause not one file was processed.
> >
> > vmstat 10:
> > procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
> >  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
> >  0  1      0 3146424    332 614768    0    0   134  1849  438 2515  3  4 91  2
> >  0  0      0 3146644    332 614784    0    0     2  1628  507  646  0  2 85 13
> >  0  0      0 3146868    332 614868    0    0     5  2359  527 1076  0  3 97  0
> >  1  0      0 3144372    332 616148    0    0    96  2829  607 2666  2  5 92  0
> > -> normal writeout
> >  0  0      0 3140560    332 618144    0    0   152  2764  633 3308  3  6 91  0
> >  0  0      0 3137332    332 619908    0    0   114  1801  588 2858  3  4 93  0
> >  0  0      0 3136912    332 620136    0    0    20   827  393 1605  1  2 98  0
> > -> first stall
>
> 'stall': vmstat's output stalls for some time, or emerge stalls for
> the next several vmstat lines?

emerge stalls. The vmstat did work normally.

> >  0  0      0 3137088    332 620136    0    0     0   557  339 1437  0  1 99  0
> >  0  0      0 3137160    332 620136    0    0     0   642  310 1400  0  1 99  0

So meaning that these last three lines indicated that for ~30 seconds
the writeout was much slower than normal.

> >  0  0      0 3136588    332 620172    0    0     6  2972  527 1195  0  3 80 16
> >  0  0      0 3136276    332 620348    0    0    10  2668  558 1195  0  3 96  0
> >  0  0      0 3135228    332 620424    0    0     8  2712  522 1311  0  4 96  0
> >  0  0      0 3131740    332 621524    0    0    75  2935  559 2457  2  5 93  0
> >  0  0      0 3128348    332 622972    0    0    85  1470  490 2607  3  4 93  0
> >  0  0      0 3129292    332 622972    0    0     0   527  353 1398  0  1 99  0
> > -> second longer stall
> >  0  0      0 3128520    332 623028    0    0     6   488  249 1390  0  1 99  0
> >  0  0      0 3128236    332 623028    0    0     0   482  222 1222  0  1 99  0
> >  0  0      0 3128408    332 623028    0    0     0   585  269 1301  0  0 99  0
> >  0  0      0 3128532    332 623028    0    0     0   610  262 1278  0  0 99  0
> >  0  0      0 3128568    332 623028    0    0     0   636  345 1639  0  1 99  0
> >  0  0      0 3129032    332 623040    0    0     1   664  337 1466  0  1 99  0
> >  0  0      0 3129484    332 623040    0    0     0   658  300 1508  0  0 100  0
> >  0  0      0 3129576    332 623040    0    0     0   562  271 1454  0  1 99  0
> >  0  0      0 3129736    332 623040    0    0     0   627  278 1406  0  1 99  0
> >  0  0      0 3129368    332 623040    0    0     0   507  274 1301  0  1 99  0
> >  0  0      0 3129004    332 623040    0    0     0   444  211 1213  0  0 99  0

The second time the slowdown was much longer.

> >  0  1      0 3127260    332 623040    0    0     0  1036  305 1242  0  1 95  4
> >  0  0      0 3126280    332 623128    0    0     7  4241  555 1575  1  5 84 10
> >  0  0      0 3124948    332 623232    0    0     6  4194  529 1505  1  4 95  0
> >  0  0      0 3125228    332 624168    0    0    58  1966  586 1964  2  4 94  0
> > -> emerge resumed to normal speed, without any intervention from my side
> >  0  0      0 3120932    332 625904    0    0   112  1546  546 2565  3  4 93  0
> >  0  0      0 3118012    332 627568    0    0   128  1542  612 2705  3  4 93  0
>
> Interesting, the 'bo' never falls to zero.

Yes, I was not able to recreate the complete stall from the first
mail, but even this slowdown does not look completly healthy.
I "hope" this is the same bug, as I seem to be able to trigger this
slowdown much easier.

[snip logs]
>
> Interestingly, no background_writeout() appears, but only
> balance_dirty_pages() and wb_kupdate.  Obviously wb_kupdate won't
> block the process.

Yes, I noticed that too.
The only time I have seen background_writeout was during bootup and shutdown.

As for the stalled watch cat /proc/meminfo:
That happend on the third slowdown/stall when emerge was already finished

> > If I see the complete stall again, I will post that too.
>
> Thank you, could you run it with the attached new debug patch?

I will, but it will have to wait until the evening.

Torsten
